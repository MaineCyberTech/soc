#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["endpoint_real_fault","stale_success_real_fault","count_divergence_real_fault","alert_routed","recovery_observed"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing_or_false":m},indent=2));raise SystemExit(bool(m))
