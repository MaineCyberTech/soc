#!/usr/bin/env python3
import json,sys,collections
p=sys.argv[1]; sids=collections.Counter(); cats=collections.Counter(); src=collections.Counter(); dst=collections.Counter(); total=bad=0
for line in open(p,errors='replace'):
 try:
  x=json.loads(line)
  if x.get('event_type')!='alert': continue
  total+=1; a=x.get('alert',{}); sids[str(a.get('signature_id','unknown'))]+=1; cats[a.get('category','unknown')]+=1; src[x.get('src_ip','unknown')]+=1; dst[x.get('dest_ip','unknown')]+=1
 except Exception: bad+=1
print(json.dumps({'total_alerts':total,'by_sid':dict(sids.most_common()),'by_category':dict(cats.most_common()),'top_sources':dict(src.most_common(20)),'top_destinations':dict(dst.most_common(20)),'invalid_json':bad},indent=2))
