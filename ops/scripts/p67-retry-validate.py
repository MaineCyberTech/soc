#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["max_attempts","timeout_seconds","backoff","idempotency_key","dead_letter","replay_guard","alerting"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing":m},indent=2));raise SystemExit(bool(m))
