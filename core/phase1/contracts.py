"""Closed, typed Phase-1 fixture contracts; they never activate a runtime."""
from __future__ import annotations
import hashlib, json, math, re, subprocess, hmac, os, copy
from types import MappingProxyType
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

OWNER="phase1-core-owner"
DIGEST=re.compile(r"sha256:[0-9a-f]{64}\Z")
IDENTIFIER=re.compile(r"[a-z][a-z0-9_-]{0,63}\Z")
PREFIXES={"execution_input_manifest":"accelerate-execution-input-manifest-v1\n","review_candidate_manifest":"accelerate-review-candidate-manifest-v1\n","root_review_candidate_manifest":"accelerate-root-review-candidate-manifest-v1\n"}
SCHEMAS={
 "execution_input_manifest":("v1","artifact",{"canonical_binding_digest","intent_digest","scope_digest","spec_digest","task_dag_digest","input_artifacts","assignment_lineage","reference_digests","profile_digests","capability_digests","proportional_depth","loop_selectors","risk_class_digest"}),
 "review_candidate_manifest":("v1","artifact",{"execution_input_manifest_digest","output_snapshot","generated_artifact_digests","dependency_digests","lockfile_digests","config_digests","environment_input_digests"}),
 "root_review_candidate_manifest":("v1","artifact",{"root_run_id","execution_input_manifest_id","execution_input_manifest_digest","frozen_dag_digest","children","current_child_set_digest","g4_receipt_set","g5_receipt_set","g6_receipt_set","integration_output_snapshot","global_proof_digest","whole_change_proof_plan_digest","non_goal_digests"}),
 "tasks_ready_receipt":("tasks-ready-v1","dispatch-readiness",{"owner_actor_id","consumer_id","root_run_id","task_dag_denominator_digest","node_bindings","planning_artifact_digests","binding_readback_digest","route_id","capability_digests","risk_quorum_digest","execution_input_manifest_digest","planning_manifest_digest","issued_at","expires_at","freshness_basis","validator_signature"}),
 "builder_ready_receipt":("builder-ready-v1","builder-readiness",{"worker_actor_id","runtime_instance_id","builder_assignment_digest","execution_input_manifest_digest","bootstrap_ack_digest","artifact_loader_confirmation_digest","loader_readback_digest","prompt_load_receipt_digest","capability_digest","fence_token_digest","lease_digest","issued_at","expires_at","freshness_basis","validator_signature"}),
 "reviewer_ready_receipt":("reviewer-ready-v1","review-readiness",{"review_candidate_digest","reviewer_assignment_digest","reviewer_actor_id","reviewer_actor_epoch","runtime_instance_id","context_root_digest","profile_digest","scope_digest","lease_digest","fence_token_digest","bootstrap_ack_digest","bootstrap_ack_actor_id","artifact_loader_confirmation_digest","loader_readback_digest","prompt_load_receipt_digest","proof_digest","independence_digest","quorum_risk_digest","capability_digests","issued_at","expires_at","freshness_basis","validator_signature"}),
 "domain_gauntlet_g4_receipt_set":("v1","domain-gauntlet",{"gate_id","verdict","root_run_id","candidate_digest","child_loop_id","parent_loop_id","denominator_digest","receipt_ids","receipt_digests","prerequisite_receipt_ids","prerequisite_receipt_digests","participant_ids","verifier_actor_id","verifier_actor_epoch","issued_at","expires_at","freshness_basis","validator_signature","allowed_state_advance"}),
 "domain_gauntlet_g5_receipt_set":("v1","domain-gauntlet",{"gate_id","verdict","root_run_id","candidate_digest","child_loop_id","parent_loop_id","seam_id","denominator_digest","receipt_ids","receipt_digests","prerequisite_receipt_ids","prerequisite_receipt_digests","participant_ids","verifier_actor_id","verifier_actor_epoch","issued_at","expires_at","freshness_basis","validator_signature","allowed_state_advance"}),
 "domain_gauntlet_g6_receipt_set":("v1","domain-gauntlet",{"gate_id","verdict","root_run_id","candidate_digest","child_loop_id","parent_loop_id","flow_id","denominator_digest","receipt_ids","receipt_digests","prerequisite_receipt_ids","prerequisite_receipt_digests","participant_ids","verifier_actor_id","verifier_actor_epoch","issued_at","expires_at","freshness_basis","validator_signature","allowed_state_advance"}),}
# Every material receipt binding is compared against verifier-owned current
# context.  The signature is deliberately excluded: it authenticates this
# payload rather than being a payload binding itself.
REQUIRED_CONTEXT_BINDINGS={schema:tuple(sorted(fields-{"validator_signature"})) for schema,(_,_,fields) in SCHEMAS.items() if schema in {"tasks_ready_receipt","builder_ready_receipt","reviewer_ready_receipt"}}
class ContractError(ValueError): pass
def _pairs(pairs):
 out={}
 for k,v in pairs:
  if k in out: raise ContractError("DUPLICATE_KEY:"+k)
  out[k]=v
 return out
def _constant(v): raise ContractError("NON_FINITE_NUMBER:"+v)
def load_strict_json(text):
 try:return json.loads(text,object_pairs_hook=_pairs,parse_constant=_constant)
 except (json.JSONDecodeError,ValueError) as e:raise ContractError(str(e)) from e
def canonical_bytes(value):
 def check(v):
  if isinstance(v,int) and not isinstance(v,bool) and abs(v)>9007199254740991:raise ContractError("I_JSON_INTEGER_RANGE")
  if isinstance(v,float) and not math.isfinite(v):raise ContractError("NON_FINITE_NUMBER")
  if isinstance(v,list):
   for x in v:check(x)
  elif isinstance(v,dict):
   if not all(isinstance(k,str) for k in v):raise ContractError("NON_STRING_MEMBER")
   for x in v.values():check(x)
  elif v is not None and not isinstance(v,(str,bool,int,float)):raise ContractError("NON_I_JSON_TYPE")
 check(value)
 raw=json.dumps(value,ensure_ascii=False,allow_nan=False,separators=(",",":"))
 # Do not materialize a sorted object: ECMAScript reorders integer-like member
 # names on object construction.  Emit sorted key/value fragments directly.
 program="const x=JSON.parse(process.argv[1]);const s=v=>Array.isArray(v)?'['+v.map(s).join(',')+']':v&&typeof v==='object'?'{'+Object.keys(v).sort((a,b)=>a<b?-1:a>b?1:0).map(k=>JSON.stringify(k)+':'+s(v[k])).join(',')+'}':JSON.stringify(v);process.stdout.write(s(x))"
 try:return subprocess.run(["node","-e",program,raw],check=True,capture_output=True,timeout=5).stdout
 except Exception as e:raise ContractError("JCS_RUNTIME_UNAVAILABLE") from e
def domain_digest(schema_id,value):
 if schema_id not in PREFIXES:raise ContractError("NO_MANIFEST_DOMAIN")
 return "sha256:"+hashlib.sha256(PREFIXES[schema_id].encode()+canonical_bytes(value)).hexdigest()
def _closed(v,fields,label):
 if not isinstance(v,dict):raise ContractError(label+"_OBJECT_REQUIRED")
 unknown,missing=set(v)-fields,fields-set(v)
 if unknown:raise ContractError(label+"_UNKNOWN_FIELD:"+sorted(unknown)[0])
 if missing:raise ContractError(label+"_MISSING_FIELD:"+sorted(missing)[0])
 return v
def _id(v,label):
 if not isinstance(v,str) or not IDENTIFIER.fullmatch(v):raise ContractError("INVALID_ID:"+label)
 return v
def _digest(v,label):
 if not isinstance(v,str) or not DIGEST.fullmatch(v):raise ContractError("BAD_DIGEST:"+label)
 return v
def _unique(values,label,ordered=False):
 if len(values)!=len(set(values)):raise ContractError("DUPLICATE_SEMANTIC_REFERENCE:"+label)
 if ordered and values!=sorted(values):raise ContractError("NONDETERMINISTIC_ORDER:"+label)
def _id_array(v,label,ordered=True):
 if not isinstance(v,list):raise ContractError("ARRAY_REQUIRED:"+label)
 out=[_id(x,label) for x in v];_unique(out,label,ordered);return out
def _digest_array(v,label):
 if not isinstance(v,list):raise ContractError("ARRAY_REQUIRED:"+label)
 out=[_digest(x,label) for x in v];_unique(out,label,True);return out
def _digest_map(v,label):
 """An ordered, closed identifier-to-digest denominator.

 Receipt lists are intentionally not accepted here: positional parallel arrays
 lose the ID/digest binding that a gate lineage consumes.
 """
 if not isinstance(v,dict):raise ContractError("DIGEST_MAP_REQUIRED:"+label)
 keys=list(v)
 for key in keys:
  if not isinstance(key,str) or not re.fullmatch(r"[A-Za-z0-9:_-]{1,128}",key):raise ContractError("INVALID_EVIDENCE_KEY:"+label)
  _digest(v[key],label)
 if keys!=sorted(keys):raise ContractError("NONDETERMINISTIC_ORDER:"+label)
 return v
def _link_array(v,label):
 if not isinstance(v,list):raise ContractError("ARRAY_REQUIRED:"+label)
 seen=[]
 for x in v:
  _closed(x,{"id","digest"},label+"_ENTRY");seen.append(_id(x["id"],label));_digest(x["digest"],label)
 _unique(seen,label,True)
def _gate_ref(v,label):
 _closed(v,{"id","digest"},label);_id(v["id"],label);_digest(v["digest"],label)
def _base(schema_id,v):
 if schema_id not in SCHEMAS:raise ContractError("UNKNOWN_SCHEMA")
 version,family,fields=SCHEMAS[schema_id]
 if schema_id.endswith("receipt") or schema_id.endswith("receipt_set"):
  _closed(v,{"schema_version","receipt_family"}|fields,"SCHEMA")
  if v["schema_version"]!=version or v["receipt_family"]!=family:raise ContractError("OWNER_VERSION_FAMILY_MISMATCH")
 else:
  _closed(v,{"schema_id","schema_version","owner_id","phase","contract_family"}|fields,"SCHEMA")
  if v["schema_id"]!=schema_id or v["schema_version"]!=version or v["owner_id"]!=OWNER or type(v["phase"]) is not int or v["phase"]!=1 or v["contract_family"]!=family:raise ContractError("OWNER_VERSION_FAMILY_MISMATCH")
def _snapshot(v):
 fields={"mode","root_identity","allowed_paths","tracked_policy","entries","generated_artifact_digests","dependency_digests","lockfile_digests","config_digests","environment_input_digests"};_closed(v,fields,"OUTPUT_SNAPSHOT")
 if v["mode"] not in {"commit","no_commit"}:raise ContractError("OUTPUT_MODE")
 if not isinstance(v["root_identity"],str) or not v["root_identity"]:raise ContractError("OUTPUT_ROOT")
 if v["tracked_policy"] not in {"clean_commit","materialized","declared_ignored"}:raise ContractError("OUTPUT_TRACKED_POLICY")
 paths=[]
 for x in v["entries"]:
  typ=x.get("type") if isinstance(x,dict) else None;own={"regular":"content_digest","symlink":"target_digest","submodule":"submodule_commit_digest"}.get(typ)
  _closed(x,{"path","type","mode","size",own} if own else set(),"OUTPUT_ENTRY")
  if not isinstance(x["path"],str) or not x["path"] or x["path"].startswith("/") or ".." in x["path"].split("/"):raise ContractError("OUTPUT_ENTRY_PATH")
  if type(x["mode"]) is not int or x["mode"]<0 or type(x["size"]) is not int or x["size"]<0:raise ContractError("OUTPUT_ENTRY_METADATA")
  _digest(x[own],own);paths.append(x["path"])
 _unique(paths,"output_entries",True)
 if not isinstance(v["allowed_paths"],list) or paths!=v["allowed_paths"]:raise ContractError("OUTPUT_DENOMINATOR_MISMATCH")
 if v["mode"]=="commit" and v["tracked_policy"]!="clean_commit":raise ContractError("COMMIT_POLICY")
 for k in fields-{"mode","root_identity","allowed_paths","tracked_policy","entries"}:_digest_array(v[k],k)
 return "sha256:"+hashlib.sha256(canonical_bytes(v)).hexdigest()
def validate_output_snapshot(snapshot):return _snapshot(snapshot)
def regenerate_output_snapshot(root,mode="no_commit",context=None):
 """Regenerate a deterministic candidate snapshot from a disposable root."""
 root=Path(root).resolve(); entries=[]
 if mode=="commit":
  def git(*args):
   p=subprocess.run(["git",*args],cwd=root,capture_output=True,timeout=10)
   if p.returncode:raise ContractError("GIT_SNAPSHOT_REQUIRED")
   return p.stdout
  head=git("rev-parse","HEAD").decode().strip()
  # Both ordinary changes and untracked/ignored residue are material facts for
  # a commit snapshot; no caller-selected path list can hide them.
  status=git("status","--porcelain=v1","-z","--ignored")
  if status:raise ContractError("COMMIT_SNAPSHOT_DIRTY")
  for record in git("ls-files","-s","-z").split(b"\0"):
   if not record:continue
   meta,path=record.split(b"\t",1); filemode,object_id,_stage=meta.decode().split()
   rel=path.decode(); p=root/rel; st=p.lstat(); common={"path":rel,"mode":int(filemode,8),"size":st.st_size}
   if filemode=="160000": entries.append({**common,"type":"submodule","submodule_commit_digest":"sha256:"+hashlib.sha256(object_id.encode()).hexdigest()})
   elif filemode=="120000": entries.append({**common,"type":"symlink","target_digest":"sha256:"+hashlib.sha256(p.readlink().as_posix().encode()).hexdigest()})
   else: entries.append({**common,"type":"regular","content_digest":"sha256:"+hashlib.sha256(p.read_bytes()).hexdigest()})
  entries.sort(key=lambda x:x["path"])
  context=context or {}
  return {"mode":"commit","root_identity":"sha256:"+hashlib.sha256((str(root)+"\n"+head).encode()).hexdigest(),"allowed_paths":[x["path"] for x in entries],"tracked_policy":"clean_commit","entries":entries,"generated_artifact_digests":context.get("generated_artifact_digests",[]),"dependency_digests":context.get("dependency_digests",[]),"lockfile_digests":context.get("lockfile_digests",[]),"config_digests":context.get("config_digests",[]),"environment_input_digests":context.get("environment_input_digests",[])}
 for path in sorted(root.rglob("*"),key=lambda p:p.as_posix()):
  if path.is_dir() or ".git" in path.relative_to(root).parts:continue
  rel=path.relative_to(root).as_posix(); st=path.lstat(); common={"path":rel,"mode":st.st_mode & 0o777,"size":st.st_size}
  if path.is_symlink(): entries.append({**common,"type":"symlink","target_digest":"sha256:"+hashlib.sha256(path.readlink().as_posix().encode()).hexdigest()})
  else: entries.append({**common,"type":"regular","content_digest":"sha256:"+hashlib.sha256(path.read_bytes()).hexdigest()})
 context=context or {}
 return {"mode":mode,"root_identity":"sha256:"+hashlib.sha256(str(root).encode()).hexdigest(),"allowed_paths":[x["path"] for x in entries],"tracked_policy":"materialized" if mode=="no_commit" else "clean_commit","entries":entries,"generated_artifact_digests":context.get("generated_artifact_digests",[]),"dependency_digests":context.get("dependency_digests",[]),"lockfile_digests":context.get("lockfile_digests",[]),"config_digests":context.get("config_digests",[]),"environment_input_digests":context.get("environment_input_digests",[])}
def compare_output_snapshot(root,supplied_snapshot,*,actual_context=None):
 """Compare a supplied snapshot with the current tree and bound inputs.

 ``supplied_snapshot`` is the candidate declaration.  The caller must pass the
 current binding context when those inputs are independently materialized; it
 is intentionally not copied from the candidate before regeneration.
 """
 validate_output_snapshot(supplied_snapshot)
 context=actual_context if actual_context is not None else {key:supplied_snapshot[key] for key in ("generated_artifact_digests","dependency_digests","lockfile_digests","config_digests","environment_input_digests")}
 try: actual=regenerate_output_snapshot(root,supplied_snapshot["mode"],context)
 except ContractError as error:
  # A commit candidate is only comparable to a clean index/worktree.  At the
  # candidate boundary its dirty-state rejection is the declared snapshot
  # mismatch, rather than an implementation-detail Git error.
  if str(error)=="COMMIT_SNAPSHOT_DIRTY":raise ContractError("OUTPUT_SNAPSHOT_MISMATCH") from error
  raise
 if canonical_bytes(actual)!=canonical_bytes(supplied_snapshot):raise ContractError("OUTPUT_SNAPSHOT_MISMATCH")
 return actual
OUTCOME_CODES={"ACCEPTED","REJECTED"}
OUTCOME_STATE=re.compile(r"[A-Z][A-Z0-9_]*(?::[a-z0-9_-]+)?\Z")
OUTCOME_EFFECTS={"changed","unchanged"}
OUTCOME_FORBIDDEN={"no_forbidden_effect","no_spawn_or_write","no_assignment_or_review_effect","no_root_review_advance","no_reviewer_lease_or_gate_evidence","no_write_before_g3","no_write_or_active","no_review_before_g3","no_review_active"}
# The proposal is an exact five-field contract, not a map of low-level Python
# exceptions.  Keep it closed: a fixture can only select one of these rows.
A04_POLICY={
 "execution-input-manifest-v1":("ACCEPTED","MANIFEST_MATCH","unchanged","no_forbidden_effect","execution-input-manifest"),"review-candidate-manifest-v1":("ACCEPTED","MANIFEST_MATCH","unchanged","no_forbidden_effect","candidate"),"root-manifest-accept":("ACCEPTED","MANIFEST_MATCH","unchanged","no_forbidden_effect","root-manifest+execution-input-manifest+acceptance+quorum+domain-gauntlet:G4-set+domain-gauntlet:G5-set+domain-gauntlet:G6-set"),
 "included-input-mutation":("ACCEPTED","SUCCESSOR_CREATED","changed","no_forbidden_effect","predecessor+successor"),"proof-before-review-candidate-freeze-reject":("REJECTED","NO_GATE_EVIDENCE","unchanged","no_reviewer_lease_or_gate_evidence","candidate"),
 "output-tree-mismatch-reject":("REJECTED","OUTPUT_SNAPSHOT_MISMATCH","unchanged","no_assignment_or_review_effect","supplied+regenerated-tree"),
 "tasks-ready-valid":("ACCEPTED","READY","changed","no_spawn_or_write","tasks-ready"),"builder-ready-valid":("ACCEPTED","READY","changed","no_write_before_g3","builder-ready"),"reviewer-ready-valid":("ACCEPTED","READY","changed","no_review_before_g3","reviewer-ready")}
for _name in ("commit-extra-file","no-commit-extra-file","missing-file","symlink-target","executable-bit","submodule","ignored-untracked","generated-output","dependency-lock-config-env-input"):
 A04_POLICY[_name]=("REJECTED","OUTPUT_SNAPSHOT_MISMATCH","unchanged","no_assignment_or_review_effect","supplied+regenerated-tree")
for _name in ("root-manifest-unknown-field-reject","root-manifest-duplicate-semantic-child-reject","root-manifest-non-denominator-child-reject","root-manifest-current-child-set-mismatch-reject","root-manifest-nonaccepted-child-reject","root-manifest-failed-child-reject","root-manifest-blocked-child-reject","root-manifest-unknown-active-child-reject","root-manifest-invalid-omission-or-replacement-reject"):
 _artifact="root-manifest+operator-disposition" if _name.endswith("omission-or-replacement-reject") else ("root-manifest+acceptance" if any(x in _name for x in ("nonaccepted","failed","blocked","unknown-active")) else "root-manifest")
 A04_POLICY[_name]=("REJECTED", "DENOMINATOR_MISMATCH" if _name.endswith("omission-or-replacement-reject") or _name.endswith("non-denominator-child-reject") else ("CHILD_SET_MISMATCH" if _name.endswith("current-child-set-mismatch-reject") else ("FAN_IN_INCOMPLETE" if any(x in _name for x in ("nonaccepted","failed","blocked","unknown-active","omitted","stale","missing-gates")) else ("UNKNOWN_FIELD" if "unknown-field" in _name else ("DUPLICATE_SEMANTIC_REFERENCE" if "duplicate" in _name else "CONFLICT")))),"unchanged","no_root_review_advance",_artifact)
for _name in ("tasks-ready-missing-required-skill-plan-reject","tasks-ready-unresolvable-loader-capability-reject","tasks-ready-duplicate-node-reject","tasks-ready-bound-input-change-reject","tasks-ready-bare-family-reject","tasks-ready-stale-binding-reject"):
 A04_POLICY[_name]=("REJECTED","NO_GO","unchanged","no_spawn_or_write","tasks-ready")
for _name in ("builder-ready-missing-worker-reject","builder-ready-wrong-worker-reject","builder-ready-missing-ack-reject","builder-ready-lease-fence-reject","builder-ready-prompt-load-reject","builder-ready-capability-reject"):
 A04_POLICY[_name]=("REJECTED","NO_GO","unchanged","no_write_or_active","builder-ready")
for _name in ("reviewer-ready-missing-candidate-reject","reviewer-ready-wrong-assignment-reject","reviewer-ready-actor-runtime-reject","reviewer-ready-ack-lease-fence-reject","reviewer-ready-prompt-load-reject","reviewer-ready-proof-independence-reject","reviewer-ready-capability-reject"):
 A04_POLICY[_name]=("REJECTED","NO_GO","unchanged","no_review_active","reviewer-ready")
for _name,_artifact in (("g4-set-multi-child-omission-reject","domain-gauntlet:G4-set"),("g5-set-multi-seam-omission-reject","domain-gauntlet:G5-set"),("g6-set-wrong-participant-reject","domain-gauntlet:G6-set")):
 A04_POLICY[_name]=("REJECTED","DENOMINATOR_MISMATCH","unchanged","no_root_review_advance",_artifact)
# Private semantic predicates are deliberately stricter than the public A04
# vocabulary.  A fixture may normalize only the exact failure it was named to
# demonstrate; an arbitrary malformed input cannot borrow another row's NO_GO.
A04_PRIVATE_REASON={
 "commit-extra-file":"OUTPUT_SNAPSHOT_MISMATCH","no-commit-extra-file":"OUTPUT_SNAPSHOT_MISMATCH","missing-file":"OUTPUT_SNAPSHOT_MISMATCH","symlink-target":"OUTPUT_SNAPSHOT_MISMATCH","executable-bit":"OUTPUT_SNAPSHOT_MISMATCH","submodule":"OUTPUT_SNAPSHOT_MISMATCH","ignored-untracked":"OUTPUT_SNAPSHOT_MISMATCH","generated-output":"OUTPUT_SNAPSHOT_MISMATCH","dependency-lock-config-env-input":"OUTPUT_SNAPSHOT_MISMATCH","output-tree-mismatch-reject":"OUTPUT_SNAPSHOT_MISMATCH",
 "root-manifest-unknown-field-reject":"SCHEMA_UNKNOWN_FIELD:unrecognized","root-manifest-duplicate-semantic-child-reject":"DUPLICATE_SEMANTIC_REFERENCE:children","root-manifest-non-denominator-child-reject":"FROZEN_DAG_DENOMINATOR_MISMATCH","root-manifest-current-child-set-mismatch-reject":"CURRENT_CHILD_SET_MISMATCH","root-manifest-nonaccepted-child-reject":"FAN_IN_INCOMPLETE","root-manifest-failed-child-reject":"FAN_IN_INCOMPLETE","root-manifest-blocked-child-reject":"FAN_IN_INCOMPLETE","root-manifest-unknown-active-child-reject":"FAN_IN_INCOMPLETE","root-manifest-invalid-omission-or-replacement-reject":"OPERATOR_DISPOSITION_INVALID",
 "tasks-ready-bare-family-reject":"OWNER_VERSION_FAMILY_MISMATCH","tasks-ready-stale-binding-reject":"STALE_RECEIPT","tasks-ready-bound-input-change-reject":"BOUND_INPUT_MISMATCH:binding_readback_digest","tasks-ready-unresolvable-loader-capability-reject":"BOUND_INPUT_MISMATCH:node_bindings","tasks-ready-duplicate-node-reject":"DUPLICATE_SEMANTIC_REFERENCE:node_bindings","tasks-ready-missing-required-skill-plan-reject":"NODE_BINDING_MISSING_FIELD:required_skill_ids",
 "builder-ready-missing-worker-reject":"SCHEMA_MISSING_FIELD:worker_actor_id","builder-ready-wrong-worker-reject":"BOUND_INPUT_MISMATCH:worker_actor_id","builder-ready-missing-ack-reject":"SCHEMA_MISSING_FIELD:bootstrap_ack_digest","builder-ready-lease-fence-reject":"BAD_DIGEST:lease_digest","builder-ready-prompt-load-reject":"BAD_DIGEST:prompt_load_receipt_digest","builder-ready-capability-reject":"BAD_DIGEST:capability_digest",
 "reviewer-ready-missing-candidate-reject":"SCHEMA_MISSING_FIELD:review_candidate_digest","reviewer-ready-wrong-assignment-reject":"BOUND_INPUT_MISMATCH:reviewer_assignment_digest","reviewer-ready-actor-runtime-reject":"BOUND_INPUT_MISMATCH:runtime_instance_id","reviewer-ready-ack-lease-fence-reject":"BAD_DIGEST:fence_token_digest","reviewer-ready-prompt-load-reject":"BAD_DIGEST:prompt_load_receipt_digest","reviewer-ready-proof-independence-reject":"BAD_DIGEST:independence_digest","reviewer-ready-capability-reject":"BAD_DIGEST:capability_digests",
 "g4-set-multi-child-omission-reject":"DENOMINATOR_MISMATCH","g5-set-multi-seam-omission-reject":"DENOMINATOR_MISMATCH","g6-set-wrong-participant-reject":"DENOMINATOR_MISMATCH","proof-before-review-candidate-freeze-reject":"NO_FROZEN_CANDIDATE_OR_GATE"}
A04_PRIVATE_PREDICATE={name:"exact:"+reason for name,reason in A04_PRIVATE_REASON.items()}
_A04_POLICY_ROWS=tuple(A04_POLICY.items())
# Inspection projection only: execute_a04 captures the tuple, not this name.
A04_POLICY=MappingProxyType(dict(_A04_POLICY_ROWS))
def candidate_outcome(code,result_state,revision_effect,forbidden_effect,receipt_digests):
 """Closed production result returned by Phase-1 validators/actions."""
 value={"code":code,"result_state":result_state,"revision_effect":revision_effect,"forbidden_effect":forbidden_effect,"receipt_digests":receipt_digests}
 _closed(value,{"code","result_state","revision_effect","forbidden_effect","receipt_digests"},"CANDIDATE_OUTCOME")
 if code not in OUTCOME_CODES or not isinstance(result_state,str) or not OUTCOME_STATE.fullmatch(result_state) or revision_effect not in OUTCOME_EFFECTS or forbidden_effect not in OUTCOME_FORBIDDEN:raise ContractError("CANDIDATE_OUTCOME_FIELDS")
 _digest_map(receipt_digests,"receipt_digests");return value
def a04_outcome_digest(fixture_id,code,result_state,revision_effect,forbidden_effect,artifacts=None):
 """Deterministic observed-outcome receipt digest for A04 verification."""
 artifact_digests={}
 for name,value in (artifacts or {}).items():
  if not isinstance(name,str) or not name:raise ContractError("A04_ARTIFACT")
  artifact_digests[name]=value if isinstance(value,str) and DIGEST.fullmatch(value) else "sha256:"+hashlib.sha256(value).hexdigest() if isinstance(value,bytes) else (_ for _ in ()).throw(ContractError("A04_ARTIFACT"))
 payload={"fixture_id":fixture_id,"code":code,"result_state":result_state,"revision_effect":revision_effect,"forbidden_effect":forbidden_effect,"artifact_digests":artifact_digests}
 return "sha256:"+hashlib.sha256(b"accelerate-a04-outcome-v1\n"+canonical_bytes(payload)).hexdigest()
def _normalize_operator_disposition(value):
 """Classify the closed disposition shape before its A04 rejection outcome."""
 if not isinstance(value,dict) or set(value)!={"action","reason"}:return "INVALID"
 if value["action"] not in {"omit","replace"} or not isinstance(value["reason"],str) or not value["reason"]:return "INVALID"
 return "VALID_BUT_INSUFFICIENT"
def _execute_a04(name,fixture_input,root,_rows):
 """Closed A04 dispatcher.  It accepts data and a candidate root, never code."""
 policy=dict(_rows)
 if name not in policy or not isinstance(fixture_input,dict):raise ContractError("A04_FIXTURE_INPUT_REQUIRED")
 if any(callable(x) for x in fixture_input.values()):raise ContractError("A04_CALLBACK_FORBIDDEN")
 code,state,effect,forbidden,artifact=policy[name]; before={"revision":0,"artifact":artifact}; receipt_values=None
 try:
  value=fixture_input.get("value")
  context=fixture_input.get("expected_context")
  if name in {"execution-input-manifest-v1","review-candidate-manifest-v1"}: validate({"execution-input-manifest-v1":"execution_input_manifest","review-candidate-manifest-v1":"review_candidate_manifest"}[name],value)
  elif name.startswith("tasks-ready") or name.startswith("builder-ready") or name.startswith("reviewer-ready"):
   schema="tasks_ready_receipt" if name.startswith("tasks-ready") else ("builder_ready_receipt" if name.startswith("builder-ready") else "reviewer_ready_receipt"); validate(schema,value,expected_context=context)
  elif name.startswith(("g4-","g5-","g6-")): validate_gate_set(fixture_input["schema_id"],value,fixture_input["expected_participants"],fixture_input["candidate_digest"],fixture_input.get("parent"),fixture_input.get("expected_receipts"),expected_context=context)
  elif name=="included-input-mutation":
   predecessor=fixture_input.get("predecessor"); mutated=fixture_input.get("mutated_execution_input_manifest")
   if "successor" in fixture_input:raise ContractError("A04_SUCCESSOR_CALLER_SUPPLIED")
   if not isinstance(predecessor,dict):raise ContractError("A04_PREDECESSOR_REQUIRED")
   predecessor_bytes=canonical_bytes(predecessor); validate("execution_input_manifest",mutated)
   validate_root_manifest_context(predecessor,**fixture_input["root_context"])
   predecessor_digest=domain_digest("root_review_candidate_manifest",predecessor)
   if fixture_input.get("predecessor_candidate_digest")!=predecessor_digest:raise ContractError("A04_PREDECESSOR_DIGEST")
   new_digest=domain_digest("execution_input_manifest",mutated)
   successor=copy.deepcopy(predecessor); successor["execution_input_manifest_digest"]=new_digest
   validate_root_manifest_context(successor,**fixture_input["root_context"])
   if canonical_bytes(predecessor)!=predecessor_bytes:raise ContractError("A04_PREDECESSOR_MUTATED")
   successor_digest=domain_digest("root_review_candidate_manifest",successor)
   if successor_digest==predecessor_digest:raise ContractError("A04_SUCCESSOR_NOT_DISTINCT")
   receipt_values={"predecessor":predecessor_digest,"successor":successor_digest}
   value=successor
  elif name=="proof-before-review-candidate-freeze-reject":
   validate_root_manifest_context(value,**fixture_input["root_context"])
   if fixture_input.get("frozen_candidate") is not False or fixture_input.get("gate_evidence") is not False:raise ContractError("A04_GATE_PREDICATE_REQUIRED")
   raise ContractError("NO_FROZEN_CANDIDATE_OR_GATE")
  elif name=="root-manifest-invalid-omission-or-replacement-reject":
   validate_root_manifest_context(value,**fixture_input["root_context"])
   if _normalize_operator_disposition(fixture_input.get("operator_disposition"))=="INVALID":raise ContractError("OPERATOR_DISPOSITION_INVALID")
   state="OPERATOR_DISPOSITION_INSUFFICIENT"
   raise ContractError("OPERATOR_DISPOSITION_VALID_BUT_INSUFFICIENT")
  elif name.startswith("root-"): validate_root_manifest_context(value,**fixture_input["root_context"])
  elif root is not None: compare_output_snapshot(root,value,actual_context=fixture_input.get("actual_context"))
  else: raise ContractError("A04_ROOT_REQUIRED")
 except ContractError as error:
  acceptable={A04_PRIVATE_REASON.get(name)}
  if name=="root-manifest-invalid-omission-or-replacement-reject":acceptable.add("OPERATOR_DISPOSITION_VALID_BUT_INSUFFICIENT")
  if code!="REJECTED" or str(error) not in acceptable:raise ContractError("A04_SEMANTIC_MISMATCH") from error
  after=before
 else:
  if code!="ACCEPTED":raise ContractError("A04_UNEXPECTED_ACCEPT")
  after={"revision":1,"artifact":artifact} if effect=="changed" else before
 if (after!=before)!=(effect=="changed"):raise ContractError("A04_REVISION_EFFECT")
 tokens=tuple(sorted(set(artifact.split("+"))))
 receipt=receipt_values or {token:a04_outcome_digest(name,code,state,effect,forbidden,{token:hashlib.sha256(token.encode()).digest()}) for token in tokens}
 return candidate_outcome(code,state,effect,forbidden,receipt)
def _closed_a04_dispatch(rows):
 def execute_a04(name,fixture_input,root=None):return _execute_a04(name,fixture_input,root,rows)
 return execute_a04
execute_a04=_closed_a04_dispatch(_A04_POLICY_ROWS)
def validate(schema_id,v,*,evaluation_time=None,expected_context=None):
 _base(schema_id,v)
 if schema_id=="execution_input_manifest":
  for k in ("canonical_binding_digest","intent_digest","scope_digest","spec_digest","task_dag_digest","risk_class_digest"):_digest(v[k],k)
  _link_array(v["input_artifacts"],"input_artifacts");_link_array(v["assignment_lineage"],"assignment_lineage")
  for k in ("reference_digests","profile_digests","capability_digests"):_digest_array(v[k],k)
  if v["proportional_depth"] not in {"fixture","minimal","standard","deep"}:raise ContractError("PROPORTIONAL_DEPTH")
  _id_array(v["loop_selectors"],"loop_selectors")
 elif schema_id=="review_candidate_manifest":
  _digest(v["execution_input_manifest_digest"],"execution_input_manifest_digest");_snapshot(v["output_snapshot"])
  for k in ("generated_artifact_digests","dependency_digests","lockfile_digests","config_digests","environment_input_digests"):_digest_array(v[k],k)
 elif schema_id=="root_review_candidate_manifest":
  for k in ("root_run_id","execution_input_manifest_id"):_id(v[k],k)
  for k in ("execution_input_manifest_digest","frozen_dag_digest","current_child_set_digest","global_proof_digest","whole_change_proof_plan_digest"):_digest(v[k],k)
  ids=[]
  for x in v["children"]:
   _closed(x,{"node_id","state","candidate_id","candidate_digest","acceptance_receipt_id","acceptance_receipt_digest","quorum_receipt_id","quorum_receipt_digest"},"CHILD")
   ids.append(_id(x["node_id"],"child"));_id(x["candidate_id"],"candidate")
   if x["state"]!="ACCEPTED":raise ContractError("FAN_IN_INCOMPLETE")
   for k in ("candidate_digest","acceptance_receipt_digest","quorum_receipt_digest"):_digest(x[k],k)
   for k in ("acceptance_receipt_id","quorum_receipt_id"):_id(x[k],k)
  if not ids:raise ContractError("FAN_IN_INCOMPLETE")
  _unique(ids,"children",True)
  for k in ("g4_receipt_set","g5_receipt_set","g6_receipt_set"):_gate_ref(v[k],k)
  _snapshot(v["integration_output_snapshot"]);_digest_array(v["non_goal_digests"],"non_goal_digests")
 elif schema_id.endswith("receipt_set"):
  gate={"domain_gauntlet_g4_receipt_set":"domain-gauntlet:G4","domain_gauntlet_g5_receipt_set":"domain-gauntlet:G5","domain_gauntlet_g6_receipt_set":"domain-gauntlet:G6"}[schema_id]
  if v["gate_id"]!=gate or v["verdict"] not in {"GO","NO_GO"}:raise ContractError("GATE_ENUM")
  for k in ("root_run_id","child_loop_id","parent_loop_id","verifier_actor_id","verifier_actor_epoch","allowed_state_advance"):_id(v[k],k)
  _digest(v["candidate_digest"],"candidate_digest")
  if schema_id.endswith("g5_receipt_set"):_id(v["seam_id"],"seam_id")
  if schema_id.endswith("g6_receipt_set"):_id(v["flow_id"],"flow_id")
  for k in ("denominator_digest",):_digest(v[k],k)
  participants=_id_array(v["participant_ids"],"participant_ids"); ids=_id_array(v["receipt_ids"],"receipt_ids"); digests=_digest_map(v["receipt_digests"],"receipt_digests"); prerequisite_ids=_id_array(v["prerequisite_receipt_ids"],"prerequisite_receipt_ids"); prerequisite_digests=_digest_map(v["prerequisite_receipt_digests"],"prerequisite_receipt_digests")
  if ids!=list(digests) or prerequisite_ids!=list(prerequisite_digests) or len(ids)!=len(participants):raise ContractError("DENOMINATOR_MISMATCH")
  _validate_gate_authority(schema_id,v,expected_context)
 else:
  _validate_readiness(schema_id,v,expected_context)
 return v
def _fresh(v,evaluation_time=None):
 for k in ("issued_at","expires_at"):
  if not isinstance(v[k],str) or not v[k].endswith("Z"):raise ContractError("RFC3339_TIMESTAMP")
 try: issued=datetime.fromisoformat(v["issued_at"].replace("Z","+00:00")); expires=datetime.fromisoformat(v["expires_at"].replace("Z","+00:00"))
 except ValueError as e:raise ContractError("RFC3339_TIMESTAMP") from e
 if issued>=expires:raise ContractError("INVALID_FRESHNESS_WINDOW")
 if evaluation_time is not None and not(issued<=evaluation_time<expires):raise ContractError("STALE_RECEIPT")
 if not isinstance(v["freshness_basis"],str) or not v["freshness_basis"] or not isinstance(v["validator_signature"],str) or not v["validator_signature"]:raise ContractError("AUTHORITY_OR_SIGNATURE")
def readiness_signature(receipt,key,*,schema_id,validator_id,trust_root):
 value=dict(receipt);value["validator_signature"]=""
 prefix=f"accelerate-readiness-v2\n{schema_id}\n{validator_id}\n{trust_root}\n".encode()
 return hmac.new(key,prefix+canonical_bytes(value),hashlib.sha256).hexdigest()
class ReadinessAuthorityVerifier:
 __slots__=("_registry",)
 def __init__(self,registry):object.__setattr__(self,"_registry",tuple((v,r,k) for v,roots in registry.items() for r,k in roots.items()))
 def __setattr__(self,*_):raise AttributeError("immutable verifier")
 def key_for(self,validator_id,trust_root):
  for validator,root,key in self._registry:
   if (validator,root)==(validator_id,trust_root):return key
  raise ContractError("UNAUTHORIZED_SIGNER")
_FIXTURE_GATE_TRUST=ReadinessAuthorityVerifier({"fixture-validator":{"fixture-root":b"phase1-test-authority-key"}})
# Compatibility export only. Validation closes over _FIXTURE_GATE_TRUST below;
# rebinding this public name is deliberately ineffective.
FIXTURE_READINESS_VERIFIER=_FIXTURE_GATE_TRUST
def _validate_readiness(schema_id,v,expected_context=None,_trust=_FIXTURE_GATE_TRUST):
 if expected_context is None:raise ContractError("AUTHORITY_CONTEXT_REQUIRED")
 required={"evaluation_time"}|set(REQUIRED_CONTEXT_BINDINGS[schema_id])
 if not required <= set(expected_context):raise ContractError("AUTHORITY_CONTEXT_REQUIRED")
 evaluation_time=expected_context["evaluation_time"]
 validator="fixture-validator";trust_root="fixture-root";key=_trust.key_for(validator,trust_root)
 for binding in REQUIRED_CONTEXT_BINDINGS[schema_id]:
  if v.get(binding)!=expected_context[binding]:raise ContractError("BOUND_INPUT_MISMATCH:"+binding)
 expected_signature=readiness_signature(v,key,schema_id=schema_id,validator_id=validator,trust_root=trust_root)
 if not hmac.compare_digest(v.get("validator_signature",""),expected_signature):raise ContractError("AUTHORITY_OR_SIGNATURE")
 if schema_id=="tasks_ready_receipt":
  for k in ("owner_actor_id","consumer_id","root_run_id","route_id"):_id(v[k],k)
  for k in ("task_dag_denominator_digest","binding_readback_digest","risk_quorum_digest","execution_input_manifest_digest","planning_manifest_digest"):_digest(v[k],k)
  _digest_array(v["planning_artifact_digests"],"planning_artifact_digests");_digest_array(v["capability_digests"],"capability_digests")
  nodes=[]
  for n in v["node_bindings"]:
   _closed(n,{"node_id","owner_id","profile_digest","assignment_digest","scope_digest","dependency_digests","acceptance_digest","proof_digest","required_skill_ids","required_skill_digests","artifact_digest","projection_digest","loader_digest"},"NODE_BINDING")
   nodes.append(_id(n["node_id"],"node_id"));_id(n["owner_id"],"owner_id")
   for k in set(n)-{"node_id","owner_id","required_skill_ids","dependency_digests","required_skill_digests"}:_digest(n[k],k)
   _id_array(n["required_skill_ids"],"required_skill_ids");_digest_array(n["dependency_digests"],"dependency_digests");_digest_array(n["required_skill_digests"],"required_skill_digests")
  _unique(nodes,"node_bindings",True)
 else:
  for k in v:
   if k.endswith("_digest"):_digest(v[k],k)
  for k in ("worker_actor_id","runtime_instance_id","reviewer_actor_id","reviewer_actor_epoch","bootstrap_ack_actor_id"):
   if k in v:_id(v[k],k)
  if "capability_digests" in v:_digest_array(v["capability_digests"],"capability_digests")
 _fresh(v,evaluation_time)
 for key,expected in expected_context.items():
  if key not in required and key not in {"evaluation_time"} and v.get(key)!=expected:raise ContractError("BOUND_INPUT_MISMATCH:"+key)
def _validate_gate_authority(schema_id,v,expected_context=None,_trust=_FIXTURE_GATE_TRUST):
 if expected_context is None:raise ContractError("AUTHORITY_CONTEXT_REQUIRED")
 required={"evaluation_time"}|{k for k in SCHEMAS[schema_id][2] if k!="validator_signature"}
 if not required <= set(expected_context):raise ContractError("AUTHORITY_CONTEXT_REQUIRED")
 validator=expected_context["verifier_actor_id"]; trust_root=expected_context.get("trust_root","fixture-root")
 key=_trust.key_for(validator,trust_root)
 for binding in required-{"evaluation_time"}:
  if v.get(binding)!=expected_context[binding]:raise ContractError("BOUND_INPUT_MISMATCH:"+binding)
 expected_signature=readiness_signature(v,key,schema_id=schema_id,validator_id=validator,trust_root=trust_root)
 if not hmac.compare_digest(v.get("validator_signature",""),expected_signature):raise ContractError("AUTHORITY_OR_SIGNATURE")
 _fresh(v,expected_context["evaluation_time"])
def validate_gate_set(schema_id,value,expected_participants,candidate_digest,parent=None,expected_receipts=None,*,expected_context=None):
 validate(schema_id,value,expected_context=expected_context)
 if value["candidate_digest"]!=candidate_digest or value["participant_ids"]!=sorted(expected_participants):raise ContractError("DENOMINATOR_MISMATCH")
 if parent is not None and value.get("parent_loop_id")!=parent:raise ContractError("CROSS_PARENT")
 if expected_receipts is not None and (expected_receipts!=value["receipt_digests"] or list(expected_receipts)!=value["receipt_ids"]):raise ContractError("RECEIPT_LINEAGE_MISMATCH")
def validate_root_manifest_context(value,*,frozen_node_ids,current_child_set_digest,candidate_digest=None):
 """Validate the external frozen-DAG denominator without making it writable.

 The DAG is intentionally not embedded in the manifest: its digest is the
 binding, while this verifier receives the frozen authoritative node set.
 """
 validate("root_review_candidate_manifest",value)
 ids=[child["node_id"] for child in value["children"]]
 if ids!=sorted(frozen_node_ids):raise ContractError("FROZEN_DAG_DENOMINATOR_MISMATCH")
 if value["current_child_set_digest"]!=current_child_set_digest:raise ContractError("CURRENT_CHILD_SET_MISMATCH")
 if candidate_digest is not None and any(child["candidate_digest"]!=candidate_digest for child in value["children"]):raise ContractError("CHILD_CANDIDATE_MISMATCH")
def validate_gate_lineage(g4,g5,g6,*,candidate_digest,parent_loop_id,seam_id,flow_id,participants,expected_contexts):
 validate_gate_set("domain_gauntlet_g4_receipt_set",g4,participants["g4"],candidate_digest,parent_loop_id,expected_context=expected_contexts["g4"]);validate_gate_set("domain_gauntlet_g5_receipt_set",g5,participants["g5"],candidate_digest,expected_context=expected_contexts["g5"]);validate_gate_set("domain_gauntlet_g6_receipt_set",g6,participants["g6"],candidate_digest,expected_context=expected_contexts["g6"])
 if g5["seam_id"]!=seam_id or g6["flow_id"]!=flow_id:raise ContractError("SEAM_FLOW_MISMATCH")
 if g5["prerequisite_receipt_ids"]!=g4["receipt_ids"] or g5["prerequisite_receipt_digests"]!=g4["receipt_digests"]:raise ContractError("G4_LINEAGE_MISMATCH")
 if g6["prerequisite_receipt_ids"]!=g5["receipt_ids"] or g6["prerequisite_receipt_digests"]!=g5["receipt_digests"]:raise ContractError("G5_LINEAGE_MISMATCH")
def _identity(v,label):
 _closed(v,{"kind","namespace","name","version"},label);return tuple(_id(v[k],k) for k in ("kind","namespace","name","version"))
def catalog_source_digest(source):
 """Domain-separated digest of every governed catalog source field."""
 if not isinstance(source,dict):raise ContractError("CATALOG_OBJECT_REQUIRED")
 payload=dict(source);payload.pop("source_digest",None)
 return "sha256:"+hashlib.sha256(b"accelerate-catalog-source-v1\n"+canonical_bytes(payload)).hexdigest()
def validate_source_catalog(source,projection=None):
 _closed(source,{"source_id","source_digest","entries","reader_denominator","reader_bindings","rollback","mode"},"CATALOG");_id(source["source_id"],"source_id");_digest(source["source_digest"],"source_digest")
 if source["source_digest"]!=catalog_source_digest(source):raise ContractError("STALE_CATALOG_SOURCE_DIGEST")
 if source["mode"]!="source-only":raise ContractError("CATALOG_NOT_SOURCE_ONLY")
 readers=_id_array(source["reader_denominator"],"reader_denominator");_closed(source["rollback"],{"route","candidate_digest"},"ROLLBACK");_id(source["rollback"]["route"],"rollback_route");_digest(source["rollback"]["candidate_digest"],"rollback_digest")
 canonical={}; aliases={}; namespace_names={}; lifecycle={}
 for e in source["entries"]:
  _closed(e,{"identity","digest","owner_id","source","lifecycle","aliases"},"CATALOG_ENTRY");ident=_identity(e["identity"],"IDENTITY")
  # Names are a cross-kind namespace.  A skill and profile cannot quietly
  # reuse one namespace/name/version tuple and rely on kind at lookup time.
  name_key=ident[1:]
  if ident in canonical or name_key in namespace_names:raise ContractError("DUPLICATE_CANONICAL_IDENTIFIER")
  canonical[ident]=e;namespace_names[name_key]=ident;_digest(e["digest"],"entry_digest");_id(e["owner_id"],"owner_id");_closed(e["source"],{"locator","revision","digest"},"ENTRY_SOURCE")
  if not all(isinstance(e["source"][k],str) and e["source"][k] for k in ("locator","revision")):raise ContractError("SOURCE_BINDING")
  _digest(e["source"]["digest"],"source_digest");life=e["lifecycle"];_closed(life,{"state","replacement","reader_rationale","history"},"LIFECYCLE")
  if life["state"] not in {"active","deprecated","retired"}:raise ContractError("LIFECYCLE_STATE")
  if not isinstance(life["history"],list) or not life["history"] or any(x not in {"active","deprecated","retired"} for x in life["history"]):raise ContractError("LIFECYCLE_HISTORY")
  order={"active":0,"deprecated":1,"retired":2}
  if life["history"][-1]!=life["state"] or any(order[a]>order[b] for a,b in zip(life["history"],life["history"][1:])):raise ContractError("LIFECYCLE_ORDER")
  if life["state"]=="deprecated" and not(life["replacement"] or life["reader_rationale"]):raise ContractError("DEPRECATION_RATIONALE")
  lifecycle[ident]=life
  for a in e["aliases"]:
   _closed(a,{"identity","target","owner_id","source_digest","expires","state","replacement_rationale"},"ALIAS");ai=_identity(a["identity"],"ALIAS_ID");target=_identity(a["target"],"ALIAS_TARGET")
   alias_name=ai[1:]
   if ai in canonical or ai in aliases or alias_name in namespace_names:raise ContractError("ALIAS_AMBIGUITY_OR_TARGET")
   namespace_names[alias_name]=ai
   if a["state"] not in {"active","deprecated","retired"}:raise ContractError("ALIAS_STATE")
   _id(a["owner_id"],"alias_owner");_digest(a["source_digest"],"alias_source_digest")
   if not isinstance(a["expires"],str) or not a["expires"] or not isinstance(a["replacement_rationale"],str):raise ContractError("ALIAS_METADATA")
   aliases[ai]=target
 # Alias targets may be canonical or aliases, which makes cycles
 # representable; resolve them afterwards and reject every cycle/dangling edge.
 for alias,target in aliases.items():
  if target not in canonical and target not in aliases:raise ContractError("ALIAS_AMBIGUITY_OR_TARGET")
  trail=set();cursor=alias
  while cursor in aliases:
   if cursor in trail:raise ContractError("ALIAS_CYCLE")
   trail.add(cursor);cursor=aliases[cursor]
  if lifecycle[cursor]["state"]=="retired":raise ContractError("RETIRED_ALIAS_TARGET")
 bindings={}
 for binding in source["reader_bindings"]:
  _closed(binding,{"reader_id","identities"},"READER_BINDING");reader=_id(binding["reader_id"],"reader_id")
  if reader not in readers or reader in bindings:raise ContractError("READER_DENOMINATOR_MISMATCH")
  identities=[]
  for item in binding["identities"]:
   identity=_identity(item,"READER_IDENTITY")
   if identity not in canonical:raise ContractError("READER_IDENTITY_UNKNOWN")
   identities.append(identity)
  _unique(identities,"reader_identities",True);bindings[reader]=identities
 if set(bindings)!=set(readers):raise ContractError("READER_DENOMINATOR_MISMATCH")
 for ident,life in lifecycle.items():
  if life["state"]=="retired" and any(ident in deps for deps in bindings.values()):raise ContractError("RETIRED_ACTIVE_READER")
 if projection is not None:
  _closed(projection,{"source_digest","target_harness","target_locator","mode","reader_id","lifecycle","rollback_route"},"PROJECTION")
  if projection["source_digest"]!=source["source_digest"]:raise ContractError("STALE_OR_DIVERGENT_PROJECTION")
  if projection["mode"]!="source-only" or projection["lifecycle"]!="unactivated":raise ContractError("PROJECTION_EFFECT_FORBIDDEN")
  for k in ("target_harness","reader_id","rollback_route"):_id(projection[k],k)
  if projection["reader_id"] not in readers or not isinstance(projection["target_locator"],str) or not projection["target_locator"]:raise ContractError("READER_DENOMINATOR_MISMATCH")
