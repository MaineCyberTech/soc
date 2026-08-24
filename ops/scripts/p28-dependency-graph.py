#!/usr/bin/env python3
import json,sys
from pathlib import Path
root=Path(sys.argv[1] if len(sys.argv)>1 else '/opt/mct-security-stack')
nodes=[]
for p in root.rglob('*'):
 if p.is_file() and p.name in ('docker-compose.yml','docker-compose.yaml','compose.yml','compose.yaml'):
  nodes.append({'type':'compose','path':str(p.relative_to(root))})
for p in root.rglob('*.service'):
 nodes.append({'type':'systemd','path':str(p.relative_to(root))})
for p in root.rglob('*.sh'):
 if 'install' in p.name or 'deploy' in p.name or 'bootstrap' in p.name:
  nodes.append({'type':'installer','path':str(p.relative_to(root))})
print(json.dumps({'root':str(root),'nodes':nodes},indent=2))
