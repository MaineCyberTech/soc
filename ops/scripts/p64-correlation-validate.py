#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["wazuh_alert_id","integratord_record_id","hook_id","shuffle_execution_id","workflow_revision","iris_object_id","marker_match","object_readback"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing":m},indent=2));raise SystemExit(bool(m))
