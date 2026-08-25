#!/usr/bin/env python3
import json,sys,os
root=sys.argv[1]; rows=[]
for name in sorted(os.listdir(root)):
 p=os.path.join(root,name)
 if os.path.isfile(p): rows.append({'check':name,'state':open(p,errors='replace').read().strip()})
print(json.dumps({'state_dir':root,'checks':rows,'count':len(rows)},indent=2))
