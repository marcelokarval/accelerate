"""Fixture-only SQLite ledger with a recoverable immutable same-root CAS."""
from __future__ import annotations
import hashlib, os, sqlite3, tempfile
from pathlib import Path
class ReplayConflict(RuntimeError): pass
def _name(v): return len(v)==64 and all(c in "0123456789abcdef" for c in v)
class FixtureGauntletStore:
 def __init__(self,root):
  raw=Path(root).absolute(); probe=raw
  while not probe.exists() and probe!=probe.parent: probe=probe.parent
  if any(p.is_symlink() for p in [probe,*probe.parents]): raise ReplayConflict("SYMLINK_ROOT")
  self.root=raw.resolve();self.root.mkdir(parents=True,exist_ok=True);self.cas=self.root/"cas";self.stage=self.cas/".staging";self.cas.mkdir(exist_ok=True);self.stage.mkdir(exist_ok=True);self.db=self.root/"ledger.sqlite3"
  self.cx=sqlite3.connect(self.db,isolation_level=None);self.cx.execute("PRAGMA journal_mode=WAL");self.cx.execute("PRAGMA synchronous=FULL");self.cx.executescript("CREATE TABLE IF NOT EXISTS operations (k TEXT PRIMARY KEY, request_digest TEXT NOT NULL, result_digest TEXT NOT NULL, revision INTEGER NOT NULL, fence TEXT NOT NULL); CREATE TABLE IF NOT EXISTS events (n INTEGER PRIMARY KEY AUTOINCREMENT,k TEXT UNIQUE NOT NULL,digest TEXT NOT NULL);");self.cleanup_orphans()
 def _sync(self):
  fd=os.open(self.cas,os.O_RDONLY);os.fsync(fd);os.close(fd)
 def _publish(self,data):
  name=hashlib.sha256(data).hexdigest();final=self.cas/name
  if final.exists():
   if final.is_symlink() or not final.is_file() or hashlib.sha256(final.read_bytes()).hexdigest()!=name:raise ReplayConflict("CAS_TAMPER")
   return "sha256:"+name,False
  fd,tmp=tempfile.mkstemp(prefix="blob-",dir=self.stage)
  try:
   with os.fdopen(fd,"wb") as f:f.write(data);f.flush();os.fsync(f.fileno())
   os.chmod(tmp,0o444);os.replace(tmp,final);self._sync()
  except Exception:
   if os.path.exists(tmp):os.unlink(tmp)
   raise
  return "sha256:"+name,True
 def put(self,data):return self._publish(data)[0]
 def cleanup_orphans(self):
  refs={x[0].removeprefix("sha256:") for x in self.cx.execute("SELECT request_digest FROM operations")}|{x[0].removeprefix("sha256:") for x in self.cx.execute("SELECT result_digest FROM operations")}
  for p in self.stage.iterdir():
   if p.is_symlink() or not p.is_file():raise ReplayConflict("STAGING_TAMPER")
   p.unlink()
  for p in self.cas.iterdir():
   if p==self.stage:continue
   if p.is_symlink() or not p.is_file() or not _name(p.name) or hashlib.sha256(p.read_bytes()).hexdigest()!=p.name:raise ReplayConflict("CAS_TAMPER")
   if p.name not in refs:p.unlink()
  self._sync()
 def apply(self,key,request,result,revision=1,fence="fixture",fault=None):
  if not isinstance(key,str) or not key or type(revision) is not int or revision<1 or not isinstance(fence,str) or not fence:raise ReplayConflict("INVALID_OPERATION")
  rq="sha256:"+hashlib.sha256(request).hexdigest();rs="sha256:"+hashlib.sha256(result).hexdigest();prior=self.cx.execute("SELECT request_digest,result_digest,revision,fence FROM operations WHERE k=?",(key,)).fetchone()
  if prior:
   if prior==(rq,rs,revision,fence):return "REPLAYED",rs
   raise ReplayConflict("CONFLICT")
  created=[]
  try:
   _,new=self._publish(request);created+= [rq] if new else []
   if fault=="after_request_publish":raise ReplayConflict("INJECTED_FAILURE")
   _,new=self._publish(result);created+= [rs] if new else []
   if fault=="after_result_publish":raise ReplayConflict("INJECTED_FAILURE")
   self.cx.execute("BEGIN IMMEDIATE");self.cx.execute("INSERT INTO operations VALUES(?,?,?,?,?)",(key,rq,rs,revision,fence))
   if fault=="before_event":raise ReplayConflict("INJECTED_FAILURE")
   self.cx.execute("INSERT INTO events(k,digest) VALUES(?,?)",(key,rs))
   if fault=="before_commit":raise ReplayConflict("INJECTED_FAILURE")
   self.cx.execute("COMMIT")
  except Exception:
   if self.cx.in_transaction:self.cx.execute("ROLLBACK")
   refs={x[0] for x in self.cx.execute("SELECT request_digest FROM operations")}|{x[0] for x in self.cx.execute("SELECT result_digest FROM operations")}
   for digest in created:
    p=self.cas/digest.removeprefix("sha256:")
    if digest not in refs and p.exists():p.unlink()
   self._sync();raise
  return "ACCEPTED",rs
 def verify_cas(self,digest):
  name=digest.removeprefix("sha256:");p=self.cas/name
  if not _name(name) or not p.is_file() or p.is_symlink() or hashlib.sha256(p.read_bytes()).hexdigest()!=name:raise ReplayConflict("CAS_MISSING_OR_TAMPERED")
  return p.read_bytes()
 def event_log_digest(self):return "sha256:"+hashlib.sha256(repr(self.cx.execute("SELECT k,result_digest,revision,fence FROM operations ORDER BY k").fetchall()).encode()).hexdigest()
 def restore_to(self,target):
  target=Path(target).absolute()
  if target.exists() or target.is_symlink():raise ReplayConflict("RESTORE_NON_OVERWRITE")
  rows=self.cx.execute("SELECT k,request_digest,result_digest,revision,fence FROM operations ORDER BY k").fetchall()
  for row in rows:self.verify_cas(row[1]);self.verify_cas(row[2])
  other=FixtureGauntletStore(target)
  for row in rows:
   with other.cx:other.cx.execute("INSERT INTO operations VALUES(?,?,?,?,?)",row);other.cx.execute("INSERT INTO events(k,digest) VALUES(?,?)",(row[0],row[2]))
   other.put(self.verify_cas(row[1]));other.put(self.verify_cas(row[2]))
  if other.event_log_digest()!=self.event_log_digest():raise ReplayConflict("RESTORE_MISMATCH")
  return other
