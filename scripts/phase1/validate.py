#!/usr/bin/env python3
import argparse, json
from core.phase1.contracts import load_strict_json, validate, canonical_bytes, domain_digest
p=argparse.ArgumentParser(); p.add_argument('schema'); p.add_argument('input'); a=p.parse_args()
v=validate(a.schema,load_strict_json(open(a.input,encoding='utf8').read())); print(canonical_bytes(v).decode());
if a.schema in ('execution_input_manifest','review_candidate_manifest','root_review_candidate_manifest'): print(domain_digest(a.schema,v))
