#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r={"MALFORMED","SYNTHETIC_TEST","POLICY_SUPPRESSED","DUPLICATE","ROUTE_BRANCH_SELECTED","ROUTE_ATTEMPTED","ROUTED","TARGET_FAILED","AUTH_FAILED","DATASTORE_READ_FAIL","DATASTORE_WRITE_FAIL","COUNTER_FAIL","UNKNOWN"};t=x.get("tests",[]);g={a.get("state") for a in t if a.get("live_current_revision") and a.get("execution_id") and a.get("observed_state")};m=sorted(r-g);print(json.dumps({"missing":m},indent=2));raise SystemExit(bool(m))
