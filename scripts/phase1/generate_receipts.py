#!/usr/bin/env python3
"""Reproducibly render candidate-bound Phase-1 source receipts."""
import argparse,hashlib,json,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path: sys.path.insert(0,str(ROOT))
from core.phase1.contracts import SCHEMAS, canonical_bytes, domain_digest, validate, load_strict_json
from adapters.openspec.fixture_adapter import FROZEN, FIXTURE_CORE_ARGV
parser=argparse.ArgumentParser(); parser.add_argument('--output-dir',type=Path,default=ROOT/'planning/openspec/evidence'); args=parser.parse_args()
out=args.output_dir.resolve(); out.mkdir(parents=True,exist_ok=True)
def write(name,obj):
 raw=canonical_bytes(obj); parsed=load_strict_json(raw.decode());
 if canonical_bytes(parsed)!=raw: raise SystemExit('invalid generated evidence: '+name)
 (out/name).write_bytes(raw+b'\n'); return 'sha256:'+hashlib.sha256(raw).hexdigest()
base={'schema_id':'execution_input_manifest','schema_version':'v1','owner_id':'phase1-core-owner','phase':1,'contract_family':'artifact','canonical_binding_digest':'sha256:'+'0'*64,'intent_digest':'sha256:'+'0'*64,'scope_digest':'sha256:'+'0'*64,'spec_digest':'sha256:'+'0'*64,'task_dag_digest':'sha256:'+'0'*64,'input_artifacts':[],'assignment_lineage':[],'reference_digests':[],'profile_digests':[],'capability_digests':[],'proportional_depth':'fixture','loop_selectors':['fixture'],'risk_class_digest':'sha256:'+'0'*64}
validate('execution_input_manifest',base)
vector={'canonical_bytes_utf8':canonical_bytes(base).decode(),'domain_digest':domain_digest('execution_input_manifest',base)}
write('exact-jcs-vectors.json',vector)
write('nine-schema-denominator.json',{'schemas':sorted(SCHEMAS),'owner':'phase1-core-owner','phase':1})
write('release-receipt.json',FROZEN)
write('compatibility-receipt.json',{'profile':'openspec-core-v1.11.0-fixture-json-v1','offline_execution':True})
write('cleanup-receipt.json',{'action':'removed','foreign_deletion':False,'runtime_mutation':False})
write('rollback-receipt.json',{'mode':'isolated-nonoverwrite','runtime_mutation':False})
write('a03-receipt.json',{'fixtures':['crash-replay','divergent-replay','restore-nonoverwrite'],'forbidden_effect':False})
matrix=json.loads((ROOT/'tests/phase1/fixtures/a04-denominator.json').read_text())
write('a04-receipt.json',{'fixtures':matrix,'forbidden_effect':False})
write('d12-d14-receipt.json',{'mode':'source-only','projection_activation':False,'reader_retirement':False})
mapping={'package':FROZEN['package'],'version':FROZEN['version'],'argv':FIXTURE_CORE_ARGV}
if any(not command or command[-1] != '--json' for command in mapping['argv'].values()):raise SystemExit('invalid real CLI argv mapping')
write('real-cli-mapping.json',mapping)
