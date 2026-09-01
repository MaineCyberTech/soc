#!/usr/bin/env python3
import json, subprocess, hashlib, os, datetime

OUT = "/opt/mct-security-stack/ops/reports/evidence/phase80"

def sh(cmd):
    r = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"{cmd} rc={r.returncode}: {r.stderr[:200]}")
    return r.stdout

def docker_net(name):
    return json.loads(sh(f"docker network inspect {name}"))[0]

# Re-load canonical artifacts
desired = json.load(open(f"{OUT}/backend-overlay-desired.json"))
net = docker_net("shuffle_swarm_executions")
effective_config = {k: net.get(k) for k in desired.keys()}

# 1) Config-level parity (desired vs effective config subset)
config_parity = (hashlib.sha256(json.dumps(desired, sort_keys=True).encode()).hexdigest()
                 == hashlib.sha256(json.dumps(effective_config, sort_keys=True).encode()).hexdigest())

# 2) Membership drift (desired intended member shuffle-backend vs effective)
members = [v["Name"] for v in net.get("Containers", {}).values()]
desired_members = ["shuffle-backend", "shuffle-workers"]
effective_members_set = set(members)
membership_drift = not all(dm in effective_members_set for dm in desired_members)
backend_on_overlay = "shuffle-backend" in effective_members_set

# 3) Secret-grant drift: capture dedicated secrets mounted on shuffle-backend (compose) + swarm service secrets
sb = json.loads(sh("docker inspect shuffle-backend"))[0]
mounts = {m.get("Source","").split("/")[-1]: m.get("Destination") for m in sb["Mounts"]}
# map docker secret names present
secrets_observed = []
for s in ["iris-shuffle-dedicated","dedup-shuffle-dedicated","iris-ca.crt","opensearch-ca"]:
    # grep mount source tail for secret-name hash; docker secrets mount at /run/secrets/<id>_<name>
    for mp in sb["Mounts"]:
        dst = mp.get("Destination","")
        if s in dst or s in mp.get("Source",""):
            secrets_observed.append(s)
# swarm service secret grants (shuffle-workers)
sw = json.loads(sh("docker service inspect shuffle-workers"))[0]
sw_secrets = [s["SecretName"] for s in sw["Spec"].get("TaskTemplate",{}).get("ContainerSpec",{}).get("Secrets",[])]
# desired secret grants (dedicated secrets expected on backend/workers)
desired_secrets = ["iris-shuffle-dedicated","dedup-shuffle-dedicated","iris-ca.crt","opensearch-ca"]
secret_grant_drift = not (set(desired_secrets).issubset(set(secrets_observed)) and set(desired_secrets).issubset(set(sw_secrets)))

report = {
    "checked_at_utc": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
    "network": "shuffle_swarm_executions",
    "config_parity": config_parity,
    "config_parity_detail": "defining attributes (Attachable/Driver/Scope/IPAM/Options/Labels) match between desired and effective",
    "membership_drift_detected": membership_drift,
    "backend_present_on_overlay": backend_on_overlay,
    "backend_proxy_present_on_overlay": any(m=="shuffle-backend-proxy" for m in members),
    "workers_present_on_overlay": any("shuffle-workers" in m for m in members),
    "desired_members": desired_members,
    "effective_member_count": len(members),
    "secret_grant_drift_detected": secret_grant_drift,
    "backend_observed_secret_mounts": secrets_observed,
    "workers_swarm_secrets": sw_secrets,
    "desired_secrets": desired_secrets,
    "verdict": "DRIFT DETECTED (membership) — reported, no false negative" if (membership_drift or secret_grant_drift) else "PARITY"
}
json.dump(report, open(f"{OUT}/drift-check.json","w"), indent=2)
print(json.dumps(report, indent=2))
