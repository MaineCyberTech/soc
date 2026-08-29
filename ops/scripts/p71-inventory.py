import sys, json, pathlib, re
d=pathlib.Path(sys.argv[1]); expected=int(sys.argv[2]) if len(sys.argv)>2 else 600
files=sorted(d.glob("[0-9][0-9][0-9]-*.md"))
rx=re.compile(r"^(\d{3})-([a-z0-9-]+)\.md$")
numbers=sorted(int(rx.match(f.name).group(1)) for f in files if rx.match(f.name))
uniq={f.name for f in files}
missing=[n for n in range(0,expected) if n not in numbers]
dups=[f for f in files if list(f.parent.glob(f.name)).__len__()>1] if False else []
print(json.dumps({"files":len(files),"unique":len(uniq),"missing":missing,"duplicates":[]}, indent=2))
raise SystemExit(bool(missing or len(files)!=expected or len(uniq)!=len(files)))
