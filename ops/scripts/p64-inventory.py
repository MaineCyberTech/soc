#!/usr/bin/env python3
import pathlib,re,json,sys
p=pathlib.Path(sys.argv[1]);ids=[int(m.group(1)) for f in p.glob("*.md") if (m:=re.match(r"(\d{3})-",f.name))];e=set(range(460));g=set(ids);print(json.dumps({"files":len(ids),"unique":len(g),"missing":sorted(e-g),"duplicates":sorted(x for x in g if ids.count(x)>1)},indent=2));raise SystemExit(bool(e-g or len(ids)!=len(g)))
