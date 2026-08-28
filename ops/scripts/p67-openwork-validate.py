#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));o=x.get("open",[]);r=x.get("resolved",[]);bad=[i for i in o if i.get("status")=="CLOSED"];print(json.dumps({"closed_in_open":bad,"ow66_01_open":any(i.get("id")=="OW-66-01" for i in o)},indent=2));raise SystemExit(bool(bad))
