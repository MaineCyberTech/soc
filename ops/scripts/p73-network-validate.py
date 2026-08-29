#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["desired_state_hash","action_service","overlay_network","stable_dns","reschedule_one","reschedule_two","node_evacuation","healthcheck_noninvasive","strict_e2e_after_each","rollback_tested"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing_or_false":m},indent=2));raise SystemExit(bool(m))
