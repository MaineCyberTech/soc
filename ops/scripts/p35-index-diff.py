#!/usr/bin/env python3
import json,sys
def load(p):
 x=json.load(open(p)); return {r['index']:r for r in x if isinstance(r,dict) and r.get('index')}
b=load(sys.argv[1]); a=load(sys.argv[2]);
print(json.dumps({'deleted':sorted(set(b)-set(a)),'created':sorted(set(a)-set(b)),'retained':len(set(a)&set(b))},indent=2))
