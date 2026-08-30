#!/usr/bin/env python3
import json,subprocess,sys
def sh(c): return subprocess.run(c,shell=True,capture_output=True,text=True).stdout
SVC="{{json .Spec.TaskTemplate.Networks}}"; NAME="{{.Name}}"; MEM="{{range .Containers}}{{.Name}} {{end}}"
svcs=sh("docker service ls --format '{{.Name}}'").split()
desired={}
for s in svcs:
    spec=json.loads(sh(f"docker service inspect {s} --format '{SVC}'") or "[]")
    for n in spec:
        nid=n.get('Target','')
        if nid: desired.setdefault(sh(f"docker network inspect {nid} --format '{NAME}'").strip(),set()).add(s)
gov='iris-shuffle-overlay'
des_services=desired.get(gov,set())
eff_raw=set(sh(f"docker network inspect {gov} --format '{MEM}'").split())
eff_services=set(m.split('.')[0] for m in eff_raw if m and not m.endswith('-endpoint'))
unexpected=sorted(eff_services - des_services)
missing=sorted(des_services - eff_services)
result={"governed_overlay":gov,"desired_services":sorted(des_services),
        "effective_services":sorted(eff_services),"unexpected_members":unexpected,
        "missing_members":missing,"drift_detected":bool(unexpected or missing)}
print(json.dumps(result,indent=2))
sys.exit(1 if result["drift_detected"] else 0)
