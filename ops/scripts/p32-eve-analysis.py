#!/usr/bin/env python3
import json,sys,collections,datetime
p=sys.argv[1] if len(sys.argv)>1 else '/var/log/suricata/eve.json'; types=collections.Counter(); sids=collections.Counter(); src=collections.Counter(); bad=0
with open(p,errors='replace') as f:
 for line in f:
  try:
   x=json.loads(line); types[x.get('event_type','unknown')]+=1
   if x.get('event_type')=='alert':
    a=x.get('alert',{}); sids[str(a.get('signature_id','unknown'))]+=1; src[x.get('src_ip','unknown')]+=1
  except Exception: bad+=1
print(json.dumps({'event_types':dict(types),'alert_sids':dict(sids.most_common()),'alert_sources':dict(src.most_common(25)),'invalid_json':bad},indent=2))
