#!/usr/bin/env python3
import json,os,re,sys
from pathlib import Path
root=Path(sys.argv[1] if len(sys.argv)>1 else '/opt/mct-security-stack')
schema=json.loads((root/'config/schema.json').read_text())
profiles=list((root/'config/profiles').glob('*.env.example'))
req=set(schema.get('required',[]))
for p in profiles:
 keys={m.group(1) for m in re.finditer(r'^([A-Z][A-Z0-9_]*)=',p.read_text(),re.M)}
 print(p.name,'missing',sorted(req-keys),'extra',sorted(keys-req))
