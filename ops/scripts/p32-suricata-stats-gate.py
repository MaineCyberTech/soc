#!/usr/bin/env python3
import json,sys
p=sys.argv[1]; last=None
for line in open(p,errors='replace'):
 try:
  x=json.loads(line)
  if x.get('event_type')=='stats': last=x
 except Exception: pass
if not last: raise SystemExit('No stats event found')
st=last.get('stats',{}); cap=st.get('capture',{}); print(json.dumps({'kernel_packets':cap.get('kernel_packets'),'kernel_drops':cap.get('kernel_drops'),'detect_alert':st.get('detect',{}).get('alert'),'flow_memuse':st.get('flow',{}).get('memuse')},indent=2))
