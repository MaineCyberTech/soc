#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["trace_context","delivery_spans","retry_spans","replay_spans","reconciliation_spans","metrics_bounded","slo_defined","burn_rate_fast_tested","burn_rate_slow_tested","no_sensitive_payloads"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing_or_false":m},indent=2));raise SystemExit(bool(m))
