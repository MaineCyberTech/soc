#!/usr/bin/env python3
import json, subprocess, hashlib, os

NET = "shuffle_swarm_executions"
OUT = "/opt/mct-security-stack/ops/reports/evidence/phase80"

def sh(cmd):
    r = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"{cmd} failed rc={r.returncode}: {r.stderr[:200]}")
    return r.stdout

def docker_net(name):
    return json.loads(sh(f"docker network inspect {name}"))[0]

net = docker_net(NET)

defining_keys = ["Name","Scope","Driver","EnableIPv4","EnableIPv6","IPAM",
                 "Internal","Attachable","Ingress","ConfigFrom","ConfigOnly","Options","Labels"]
desired = {k: net.get(k) for k in defining_keys}
desired_json = json.dumps(desired, sort_keys=True, indent=2)
desired_hash = hashlib.sha256(desired_json.encode()).hexdigest()

effective = dict(net)
svc = json.loads(sh("docker service inspect shuffle-workers"))[0]
effective["_service_inspect_shuffle-workers"] = svc
sb = json.loads(sh("docker inspect shuffle-backend"))
effective["_container_inspect_shuffle-backend_networks"] = {
    n: sb[0]["NetworkSettings"]["Networks"].get(n, {}).get("NetworkID")
    for n in sb[0]["NetworkSettings"]["Networks"]
}
effective_json = json.dumps(effective, sort_keys=True, indent=2, default=str)
effective_hash = hashlib.sha256(effective_json.encode()).hexdigest()

with open(f"{OUT}/backend-overlay-desired.json","w") as f:
    f.write(desired_json)
with open(f"{OUT}/backend-overlay-effective.json","w") as f:
    f.write(effective_json)

print("SOURCE_HASH", desired_hash)
print("EFFECTIVE_HASH", effective_hash)
print("DESIRED", desired.get("Attachable"), desired.get("Driver"), desired.get("Scope"))
members = [v["Name"] for v in net.get("Containers",{}).values()]
print("EFFECTIVE_MEMBERS", members)
print("BACKEND_ON_OVERLAY", any(m=="shuffle-backend" for m in members))
print("BACKEND_PROXY_ON_OVERLAY", any(m=="shuffle-backend-proxy" for m in members))
print("WORKERS_ON_OVERLAY", any("shuffle-workers" in m for m in members))
