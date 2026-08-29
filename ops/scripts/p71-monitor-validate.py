#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["auth","tls","endpoint","timeout","retry_exhaustion","dead_letter_growth","replay_failure","stale_success","count_divergence","revision_divergence"];m=[k for k in r if not x.get(k,{}).get("tested")];print(json.dumps({"untested":m},indent=2));raise SystemExit(bool(m))
