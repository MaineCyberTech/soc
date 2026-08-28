#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));o=x.get("open",[]);r=x.get("resolved",[]);bad=[i for i in o if i.get("status")=="CLOSED"];ids=[i.get("id") for i in r];print(json.dumps({"closed_in_open":bad,"ow65_01_resolved":"OW-65-01" in ids},indent=2));raise SystemExit(bool(bad or "OW-65-01" not in ids))
