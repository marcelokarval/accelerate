from __future__ import annotations
import json, os, signal, subprocess, hashlib, base64, urllib.request, tarfile, shutil
from pathlib import Path
from core.phase1.contracts import load_strict_json
FROZEN={"package":"@fission-ai/openspec","version":"1.11.0","commit":"a0ddb60d040c61f4907436a9d91310934b1dda63","integrity":"sha512-P9h8H4Snit8I7tHmCopjg3QDwBllIlObxb+/DebvBwhWTj6YEPPYRYkC4n5GqG4PdQnKMA6E1AlEOI9FT4G7FA=="}
FIXTURE_CORE_ARGV={"status":["status","--change","phase1-fixture","--json"],"instructions":["instructions","proposal","--change","phase1-fixture","--json"],"validation":["validate","phase1-fixture","--strict","--json"],"archive":["archive","phase1-fixture","--yes","--json"]}
class AdapterError(RuntimeError): pass
def fixture_environment(root, *, bin_dir=None):
 """The complete child environment; never inherit parent auth/config/cache."""
 root=Path(root)
 path=(str(bin_dir)+":" if bin_dir else "")+str(Path(shutil.which("node") or "/usr/bin/node").parent)+":/usr/bin:/bin"
 return {"HOME":str(root/".home"),"XDG_CONFIG_HOME":str(root/".xdg-config"),"XDG_CACHE_HOME":str(root/".xdg-cache"),"NPM_CONFIG_CACHE":str(root/".npm-cache"),"NPM_CONFIG_USERCONFIG":str(root/".npmrc"),"NPM_CONFIG_GLOBALCONFIG":str(root/".npm-globalrc"),"NPM_CONFIG_PREFIX":str(root/".npm-prefix"),"GIT_CONFIG_NOSYSTEM":"1","GIT_TERMINAL_PROMPT":"0","PATH":path,"LANG":"C.UTF-8","NO_PROXY":"*","OPENSPEC_TELEMETRY":"0","DO_NOT_TRACK":"1"}
def _reject_symlink_ancestry(path):
 """Inspect the lexical path before resolving it; resolution is too late."""
 raw=Path(path).absolute()
 probe=raw
 while not os.path.lexists(probe) and probe!=probe.parent:probe=probe.parent
 for item in (probe,*probe.parents):
  if item.is_symlink():raise AdapterError("WORKSPACE_ESCAPE")
 return raw
def stage_verified_release(fixture_root):
 """Download the one frozen tarball only into the disposable fixture root."""
 raw=_reject_symlink_ancestry(fixture_root)
 root=raw.resolve(); tool=root/".tmp"/"openspec-tool"; tool.mkdir(parents=True,exist_ok=False)
 safe_env=fixture_environment(root)
 tarball=tool/"openspec-1.11.0.tgz"
 with urllib.request.urlopen("https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.11.0.tgz",timeout=30) as r: data=r.read()
 tarball.write_bytes(data); actual="sha512-"+base64.b64encode(hashlib.sha512(data).digest()).decode()
 if actual!=FROZEN["integrity"]: raise AdapterError("PROVENANCE_MISMATCH")
 # package metadata is checked before dependency resolution; npm stays local.
 with tarfile.open(tarball) as tf:
  metadata=json.loads(tf.extractfile("package/package.json").read())
 if metadata.get("name")!=FROZEN["package"] or metadata.get("version")!=FROZEN["version"]: raise AdapterError("PROVENANCE_MISMATCH")
 # The npm tarball does not embed gitHead.  Verify the immutable annotated
 # release reference separately, before any executable is spawned.
 tag=subprocess.run(["git","ls-remote","https://github.com/Fission-AI/OpenSpec.git","refs/tags/v1.11.0"],capture_output=True,text=True,timeout=30,env=safe_env)
 if tag.returncode or tag.stdout.split()[0:1] != [FROZEN["commit"]]: raise AdapterError("PROVENANCE_MISMATCH")
 subprocess.run(["npm","install","--ignore-scripts","--no-audit","--no-fund","--prefix",str(tool),str(tarball)],check=True,capture_output=True,text=True,timeout=120,env=safe_env)
 receipt={**FROZEN,"tarball_sha256":"sha256:"+hashlib.sha256(data).hexdigest(),"package_name":metadata["name"],"package_version":metadata["version"]}
 (tool/"release-receipt.json").write_text(json.dumps(receipt,sort_keys=True),encoding="utf8")
 return tool/"node_modules"/".bin"/"openspec",receipt
def run_core_json(executable, planning_root, argv, timeout=30):
 """Pinned Core call used only by the disposable integration lane."""
 p=subprocess.run([str(executable),*argv,"--json"],cwd=planning_root,text=True,capture_output=True,
                  env=fixture_environment(Path(planning_root),bin_dir=Path(executable).parent),timeout=timeout)
 if len(p.stdout)>1024*1024 or len(p.stderr)>1024*1024: raise AdapterError("JSON_PROTOCOL_INVALID")
 try: value=load_strict_json(p.stdout)
 except Exception as e: raise AdapterError("JSON_PROTOCOL_INVALID") from e
 if not isinstance(value,(dict,list)): raise AdapterError("JSON_PROTOCOL_INVALID")
 return p.returncode,value
def run_verified_fixture_flow(fixture_root):
 """Exercise the actual 1.11.0 CLI in a disposable root, end to end.

 The fixture is deliberately a docs-only change (`skip_specs`) so validation
 is meaningful without fabricating a product capability.  Archive is confined
 to this run-owned root and its JSON result is retained only in the returned
 deterministic summary.
 """
 root=Path(fixture_root).resolve(); root.mkdir(parents=True,exist_ok=False)
 (root/"planning").mkdir()
 exe,release=stage_verified_release(root)
 env=fixture_environment(root,bin_dir=exe.parent)
 bootstrap_argv=[]
 init_argv=[str(exe),"init",".","--tools","none","--no-animation"];bootstrap_argv.append(init_argv[1:])
 init=subprocess.run(init_argv,cwd=root/"planning",capture_output=True,text=True,timeout=30,env=env)
 if init.returncode: raise AdapterError("INIT_FAILED")
 create_argv=[str(exe),"new","change","phase1-fixture"];bootstrap_argv.append(create_argv[1:])
 create=subprocess.run(create_argv,cwd=root/"planning",capture_output=True,text=True,timeout=30,env=env)
 if create.returncode: raise AdapterError("CHANGE_CREATE_FAILED")
 change=root/"planning"/"openspec"/"changes"/"phase1-fixture"
 (change/".openspec.yaml").write_text("schema: spec-driven\nskip_specs: true\n",encoding="utf8")
 (change/"proposal.md").write_text("## Why\n\nFixture.\n\n## What Changes\n\n- Fixture.\n\n## Capabilities\n\n### New Capabilities\n\n### Modified Capabilities\n\n## Impact\n\nNone.\n",encoding="utf8")
 (change/"design.md").write_text("## Context\n\nFixture.\n",encoding="utf8")
 (change/"tasks.md").write_text("## 1. Fixture\n\n- [x] 1.1 Complete.\n",encoding="utf8")
 status_argv=FIXTURE_CORE_ARGV["status"][:-1];instruction_argv=FIXTURE_CORE_ARGV["instructions"][:-1];validation_argv=FIXTURE_CORE_ARGV["validation"][:-1];archive_argv=FIXTURE_CORE_ARGV["archive"][:-1]
 status_code,status=run_core_json(exe,root/"planning",status_argv)
 instruction_code,instructions=run_core_json(exe,root/"planning",instruction_argv)
 validation_code,validation=run_core_json(exe,root/"planning",validation_argv)
 archive_code,archive=run_core_json(exe,root/"planning",archive_argv)
 if any(code for code in (status_code,instruction_code,validation_code,archive_code)): raise AdapterError("CLI_SEMANTIC_FAILURE")
 if not isinstance(status,dict) or not isinstance(instructions,dict) or not isinstance(validation,dict) or not isinstance(archive,dict): raise AdapterError("JSON_PROTOCOL_INVALID")
 # Persisted command mapping and returned Core evidence use one exact shape.
 # Bootstrap commands are evidence too, but are deliberately distinct from
 # the four-command Core protocol denominator.
 return {"release":release,"status":status,"instructions":instructions,"validation":validation,"archive":archive,"bootstrap_argv":bootstrap_argv,"invoked_argv":FIXTURE_CORE_ARGV}
def invoke(executable, fixture_root, command, timeout=30):
 raw_root=_reject_symlink_ancestry(fixture_root)
 root=raw_root.resolve(); planning=root/"planning"; openspec=planning/"openspec"
 if not openspec.is_dir() or openspec.is_symlink() or any(path.is_symlink() for path in [planning,*planning.parents]) or not planning.is_relative_to(root): raise AdapterError("WORKSPACE_ESCAPE")
 exe=Path(executable).resolve()
 if not exe.is_file() or not exe.is_relative_to(root): raise AdapterError("PROVENANCE_MISMATCH")
 env=fixture_environment(root,bin_dir=exe.parent)
 p=subprocess.Popen([str(exe),command,"--json"],cwd=planning,env=env,text=True,
                    stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
 try: stdout,stderr=p.communicate(timeout=timeout)
 except subprocess.TimeoutExpired as e:
  os.killpg(p.pid, signal.SIGKILL); p.communicate()
  raise AdapterError("TIMEOUT") from e
 if len(stdout)>1024*1024 or len(stderr)>1024*1024: raise AdapterError("JSON_PROTOCOL_INVALID")
 if p.returncode: raise AdapterError("CLI_SEMANTIC_FAILURE")
 try: out=load_strict_json(stdout)
 except Exception as e: raise AdapterError("JSON_PROTOCOL_INVALID") from e
 if not isinstance(out,dict) or set(out)-{"ok","command","result"} or not out.get("ok") or out.get("command")!=command: raise AdapterError("JSON_PROTOCOL_INVALID")
 return out
