#!/usr/bin/env python3
import json,sys
allowed={'HEALTHY','DEGRADED','BLOCKED','RETIRED','MAINTENANCE','FAILED','UNKNOWN'}
p=json.load(open(sys.argv[1]))
bad=[x for x in p.get('components',[]) if x.get('state') not in allowed or not x.get('owner') or not x.get('next_action')]
print(json.dumps({'checked':len(p.get('components',[])),'invalid':bad},indent=2))
raise SystemExit(bool(bad))
