#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["wazuh","integratord","hook","backend","action_worker","iris_dns","iris_tls","iris_auth","destination_fresh","monitors_fresh","divergence_clear"];m=[k for k in r if x.get(k)!="HEALTHY"];print(json.dumps({"not_healthy":m},indent=2));raise SystemExit(bool(m))
