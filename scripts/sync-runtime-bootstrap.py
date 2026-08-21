#!/usr/bin/env python3
"""Closed, recoverable installer for the Codex bootstrap projection only."""
from __future__ import annotations
import argparse, base64, hashlib, json, os, stat, tempfile
from pathlib import Path

REPO=Path(__file__).resolve().parents[1]; MANIFEST=REPO/"adapters/runtime/cross-runtime-bootstrap-manifest.json"
EXPECTED={"contract_version":2,"semantic_core":"core/delegation/runtime-neutral-delegation.md","runtimes":{
"codex":{"status":"supported","apply_eligible":True,"loader":"AGENTS.md","projection":"adapters/runtime/codex/global-bootstrap-orchestration.fragment.md"},
"openhands":{"status":"export-only","apply_eligible":False,"loader":"binding_unavailable","projection":"adapters/runtime/openhands/accelerate-bootstrap-projection.md"},
"hermes":{"status":"staged-only","apply_eligible":False,"loader":"runtime-truth-required","projection":"adapters/runtime/hermes/hermes-delegate-task-bootstrap.fragment.md"},
"opencode":{"status":"legacy-reference","apply_eligible":False,"loader":"none","projection":"adapters/runtime/opencode/delegation-contract.md"},
"openclaw":{"status":"legacy-reference","apply_eligible":False,"loader":"none","projection":"adapters/runtime/openclaw/delegation-contract.md"},
"claude":{"status":"export-only","apply_eligible":False,"loader":"none","projection":"adapters/runtime/claude/delegation-contract.md"}}}
START=b"<!-- accelerate-delegation-policy:start -->"; END=b"<!-- accelerate-delegation-policy:end -->"
def sha(b): return hashlib.sha256(b).hexdigest()
def die(m): raise ValueError(m)
def fsdir(d):
 f=os.open(d,os.O_RDONLY); os.fsync(f); os.close(f)
def atom(p,b,mode,uid=None,gid=None,xattrs=None):
 f,t=tempfile.mkstemp(prefix=".accelerate-bootstrap-",dir=p.parent)
 try:
  os.write(f,b); os.fsync(f); os.close(f)
  if uid is not None:
   try: os.chown(t,uid,gid)
   except PermissionError: die("cannot preserve target ownership")
  os.chmod(t,mode)
  # Ownership first, then mode bits (including suid/sgid), then ACL/xattrs.
  if xattrs:
   for name,value in xattrs.items(): os.setxattr(t,name,value,follow_symlinks=False)
  os.replace(t,p); fsdir(p.parent)
 finally:
  try: os.close(f)
  except OSError: pass
  if os.path.exists(t): os.unlink(t)
def jwrite(p,x): atom(p,(json.dumps(x,sort_keys=True,indent=2)+"\n").encode(),0o600)
def contract():
 if json.loads(MANIFEST.read_text())!=EXPECTED: die("bootstrap manifest violates approved invariants")
 reg=json.loads((REPO/"adapters/runtime/runtime-consumer-registry.json").read_text()); par=(REPO/"adapters/runtime/model-lanes/cross-runtime-agent-parity.toml").read_text(); oth=json.loads((REPO/"adapters/runtime/other-runtime-adapters.policy.json").read_text())
 rows={row['runtime']:row for row in reg.get('consumers',[])}
 required={'codex':('legacy-reference','none','adapters/runtime/codex/README.md'),'openhands':('export-only','no semantic-core loader is installed','adapters/runtime/model-lanes/cross-runtime-agent-parity.toml'),'hermes':('legacy-reference','none','adapters/runtime/hermes/capabilities.yaml'),'opencode':('legacy-reference','none','adapters/runtime/opencode/capabilities.yaml'),'openclaw':('legacy-reference','none','adapters/runtime/openclaw/capabilities.yaml'),'claude':('export-only','no semantic-core loader is installed','adapters/runtime/claude/capabilities.yaml')}
 for name,(status,loader,path) in required.items():
  row=rows.get(name)
  if not row or row.get('status')!=status or row.get('loader')!=loader or row.get('projection',{}).get('path')!=path: die('runtime consumer registry cross-validation failed')
 if 'child_binding_state = "binding_unavailable"' not in par: die('OpenHands binding cross-validation failed')
 for name,status in (('opencode','legacy-reference'),('openclaw','legacy-reference'),('claude','export-only')):
  if oth.get('runtimes',{}).get(name,{}).get('runtime_status')!=status: die('adapter registry cross-validation failed')
def root_for(test):
 if not test: return Path.home()
 if test.is_symlink(): die('--test-root symlink rejected')
 r=test.resolve(strict=True)
 if r==Path('/') or not (r/'.accelerate-test-root').is_file() or (r/'.accelerate-test-root').read_text()!='accelerate-test-root-v1\n': die("--test-root requires a freshly marked test root")
 return r
def paths(runtime,root):
 if runtime not in EXPECTED['runtimes']: die('unknown runtime')
 if runtime!='codex': die('runtime is '+EXPECTED['runtimes'][runtime]['status']+'; apply is blocked')
 b=root/'.codex'; return b/'AGENTS.md',b/'.accelerate-bootstrap-receipt.json',b/'.accelerate-bootstrap-journal.json'
def safe(p,r,missing=True):
 try: parts=p.relative_to(r).parts
 except ValueError: die('path escapes canonical root')
 cur=r
 for part in parts:
  cur/=part
  if cur.exists() and cur.is_symlink(): die('symlink path component rejected')
 if not p.parent.is_dir() or p.parent.is_symlink(): die('unsafe parent')
 if p.exists():
  s=p.stat()
  if not stat.S_ISREG(s.st_mode) or s.st_nlink!=1: die('single-link regular file required')
 elif not missing: die('required path missing')
 return p.resolve(strict=False)
def state(p):
 if not p.exists(): return {'exists':False,'bytes':b'','mode':0o644,'uid':None,'gid':None,'dev':None,'ino':None,'hash':None,'xattrs':{}}
 s=p.stat(); b=p.read_bytes()
 try: xs={name:os.getxattr(p,name,follow_symlinks=False) for name in os.listxattr(p,follow_symlinks=False)}
 except (AttributeError,OSError) as exc: die('cannot safely read source xattrs: '+str(exc))
 return {'exists':True,'bytes':b,'mode':stat.S_IMODE(s.st_mode),'uid':s.st_uid,'gid':s.st_gid,'dev':s.st_dev,'ino':s.st_ino,'hash':sha(b),'xattrs':xs}
def source():
 p=REPO/EXPECTED['runtimes']['codex']['projection']
 if p.is_symlink() or not p.is_file(): die('unsafe projection source')
 return p.read_bytes()
def render(b,src):
 a,z=b.count(START),b.count(END)
 if a!=z or a>1: die('malformed or duplicate managed block')
 if not a: return b+(b'' if not b or b.endswith(b'\n') else b'\n')+src
 i=b.index(START); q=b.index(END,i)+len(END); return b[:i]+src.rstrip(b'\n')+b[q:]
def pack_xattrs(xs): return {k:base64.b64encode(v).decode() for k,v in xs.items()}
def unpack_xattrs(xs): return {k:base64.b64decode(v) for k,v in xs.items()}
def xhash(xs): return sha(json.dumps(pack_xattrs(xs),sort_keys=True).encode())
def rec(mode,t,b,a,s,j): return {'mode':mode,'target_identity':str(t),'source_sha256':sha(s),'target_before_sha256':b['hash'],'target_after_sha256':sha(a),'target_type':'regular' if b['exists'] else 'missing','target_mode':b['mode'],'target_uid':b['uid'],'target_gid':b['gid'],'target_dev':b['dev'],'target_ino':b['ino'],'target_xattrs':pack_xattrs(b['xattrs']),'target_xattr_sha256':xhash(b['xattrs']),'journal':str(j),'changed':b['bytes']!=a}
def distinct(*ps):
 if len({str(x) for x in ps})!=len(ps): die('canonical paths must be distinct')
def backup_fingerprint(bak,r,t,rc,j):
 if bak.parent.resolve()!=t.parent.resolve() or not bak.name.startswith('.accelerate-bootstrap-backup-'): die('unsafe backup path')
 safe(bak,r,False); distinct(t,rc,j,bak)
 q=state(bak)
 return {'path':str(bak),'sha256':q['hash'],'size':len(q['bytes']),'type':'regular','xattr_sha256':xhash(q['xattrs'])}
def validate_backup(bak,final,r,t,rc,j):
 got=backup_fingerprint(bak,r,t,rc,j)
 for key in ('path','sha256','size','type','xattr_sha256'):
  expected=final.get('backup_path' if key=='path' else 'backup_'+key)
  if got[key]!=expected: die('backup fingerprint mismatch')
 return got
def fault(phase,test_root):
 value=os.getenv('ACCELERATE_BOOTSTRAP_TEST_FAULT')
 if value and not test_root: die('fault injection is test-root only')
 if value==phase: die('forced '+phase+' failure')
def main():
 p=argparse.ArgumentParser(); p.add_argument('--runtime',required=True); p.add_argument('--test-root',type=Path); p.add_argument('--receipt',type=Path); p.add_argument('--recover',action='store_true'); p.add_argument('--rollback-preflight',action='store_true'); p.add_argument('--rollback',action='store_true'); p.add_argument('--stage',action='store_true'); m=p.add_mutually_exclusive_group(); m.add_argument('--dry-run',action='store_true'); m.add_argument('--apply',action='store_true'); a=p.parse_args()
 try:
  contract()
  if a.runtime not in EXPECTED['runtimes']: die('unknown runtime')
  if a.stage: print((REPO/EXPECTED['runtimes'][a.runtime]['projection']).read_text(),end=''); return
  r=root_for(a.test_root); t,rc,j=paths(a.runtime,r); safe(t,r); safe(rc,r); safe(j,r); distinct(t,rc,j)
  if a.receipt and a.receipt.resolve(strict=False)!=rc.resolve(strict=False): die('receipt must be canonical')
  if a.dry_run and a.receipt is None: die('dry-run requires the explicit canonical receipt path')
  s=source(); b=state(t); out=render(b['bytes'],s); dry=rec('dry-run',t,b,out,s,j)
  if a.recover:
   q=json.loads(j.read_text());
   if q.get('target')!=str(t): die('unrecoverable journal')
   if q.get('status') in ('intent','backup_ready'):
    # Intent never owns a backup. A supplied path is hostile input, not cleanup.
    if q.get('status')=='intent':
     if any(q.get(key) is not None for key in ('backup_path','backup_sha256','backup_size','backup_type','backup_xattr_sha256')): die('invalid intent journal backup schema')
    if t.exists() and sha(t.read_bytes())!=q.get('before_sha256'): die('unrecoverable old-target journal')
    if q.get('status')=='backup_ready':
     validate_backup(Path(q['backup_path']),q['final'],r,t,rc,j)
     Path(q['backup_path']).unlink()
    jwrite(j,{'status':'aborted','target':str(t)}); print('aborted'); return
   if q.get('status')!='target_replaced' or not t.exists() or sha(t.read_bytes())!=q.get('after_sha256'): die('unrecoverable journal')
   jwrite(rc,q['final']); q['status']='committed'; jwrite(j,q); print('recovered'); return
  if a.dry_run:
   # Preserve a committed no-op lineage; a dry-run must not orphan its rollback receipt.
   if not dry['changed'] and rc.exists():
    old=json.loads(rc.read_text())
    if old.get('mode')=='apply' and old.get('target_after_sha256')==sha(b['bytes']): print(json.dumps(dict(old,changed=False))); return
   jwrite(rc,dry); print(json.dumps(dry)); return
  if a.apply:
   if b['bytes']==out:
    old=json.loads(rc.read_text())
    if old.get('mode')=='apply' and old.get('target_after_sha256')==sha(b['bytes']): print(json.dumps(dict(old,changed=False))); return
   if json.loads(rc.read_text())!=dry: die('stale or tampered dry-run receipt')
   if b['bytes']==out:
    adopted=rec('apply',t,b,out,s,j); adopted.update({'changed':False,'adopted':True,'backup_path':None})
    jwrite(rc,adopted); print(json.dumps(adopted)); return
   intent={'status':'intent','target':str(t),'before_sha256':b['hash'],'after_sha256':sha(out),'backup_path':None,'backup_sha256':None,'backup_size':None,'backup_type':None,'backup_xattr_sha256':None}; jwrite(j,intent); fault('intent',a.test_root)
   fd,bak=tempfile.mkstemp(prefix='.accelerate-bootstrap-backup-',dir=t.parent); os.close(fd); safe(Path(bak),r,False); distinct(t,rc,j,Path(bak)); atom(Path(bak),b['bytes'],b['mode'],b['uid'],b['gid'],b['xattrs'])
   final=rec('apply',t,b,out,s,j); final.update({'backup_path':bak})
   fp=backup_fingerprint(Path(bak),r,t,rc,j); final.update({'backup_sha256':fp['sha256'],'backup_size':fp['size'],'backup_type':fp['type'],'backup_xattr_sha256':fp['xattr_sha256']})
   q={'status':'backup_ready','target':str(t),'before_sha256':b['hash'],'after_sha256':sha(out),'backup_path':bak,'final':final}; jwrite(j,q); fault('backup_ready',a.test_root); atom(t,out,b['mode'],b['uid'],b['gid'],b['xattrs']); q['status']='target_replaced'; jwrite(j,q); fault('target_replaced',a.test_root)
   if os.getenv('ACCELERATE_BOOTSTRAP_TEST_FAIL_FINALIZE')=='1':
    if not a.test_root: die('fault injection is test-root only')
    die('forced receipt finalization failure')
   fault('receipt_finalize',a.test_root)
   jwrite(rc,final); q['status']='committed'; jwrite(j,q); print(json.dumps(final)); return
  final=json.loads(rc.read_text())
  if a.rollback_preflight:
   if final.get('mode')!='apply' or final.get('target_identity')!=str(t) or sha(t.read_bytes())!=final.get('target_after_sha256'): die('rollback receipt mismatch')
   bak=Path(final['backup_path']); fp=validate_backup(bak,final,r,t,rc,j); pre={'mode':'rollback-preflight','receipt_sha256':sha(rc.read_bytes()),'target_identity':str(t),'backup_fingerprint':fp}; jwrite(j,pre); print(json.dumps(pre)); return
  if a.rollback:
   pre=json.loads(j.read_text()); bak=Path(final['backup_path'])
   if pre.get('mode')!='rollback-preflight' or pre.get('receipt_sha256')!=sha(rc.read_bytes()) or pre.get('backup_fingerprint')!=validate_backup(bak,final,r,t,rc,j): die('rollback preflight mismatch')
   if final['target_type']=='missing':
    t.unlink();
    if t.exists(): die('rollback absence verification failed')
   else:
    atom(t,bak.read_bytes(),final['target_mode'],final['target_uid'],final['target_gid'],unpack_xattrs(final['target_xattrs']))
    readback=state(t)
    if sha(t.read_bytes())!=final['target_before_sha256'] or readback['mode']!=final['target_mode'] or readback['uid']!=final['target_uid'] or readback['gid']!=final['target_gid'] or xhash(readback['xattrs'])!=final['target_xattr_sha256']: die('rollback metadata verification failed')
   bak.unlink(); jwrite(rc,{'mode':'rollback','target_identity':str(t)}); print('rolled back'); return
  die('select an operation')
 except (OSError,ValueError,KeyError,json.JSONDecodeError) as e: p.error(str(e))
if __name__=='__main__': main()
