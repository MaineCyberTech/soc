#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["lane","approval_id","effective_at","kill_switch_tested","rollback_tested","monitoring_active","canary_passed"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing":m},indent=2));raise SystemExit(bool(m))
