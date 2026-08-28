#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["supervisor_count","critical_section_count","restart_attempt_count","alert_count","stale_lock_safe","single_integratord"];m=[k for k in r if k not in x];bad=x.get("supervisor_count")!=1 or x.get("critical_section_count",0)>1;print(json.dumps({"missing":m,"invalid_singleton":bad},indent=2));raise SystemExit(bool(m or bad))
