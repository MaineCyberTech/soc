#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["owner","group","mode","readable_by_service_user","xml_valid","intended_hook_state","backup_sha256","rollback_defined"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing":m},indent=2));raise SystemExit(bool(m))
