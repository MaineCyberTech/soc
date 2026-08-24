#!/usr/bin/env python3
import json,sys,collections
p=sys.argv[1] if len(sys.argv)>1 else '/var/log/suricata/eve.json'; c=collections.Counter(); bad=0
with open(p,errors='replace') as f:
 for line in f:
  try:c[json.loads(line).get('event_type','unknown')]+=1
  except Exception:bad+=1
print(json.dumps({'events':dict(c),'invalid_json':bad},indent=2))
