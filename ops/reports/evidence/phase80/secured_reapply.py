#!/usr/bin/env python3
import subprocess, json, os
from datetime import timezone, datetime

OUT = "/opt/mct-security-stack/ops/reports/evidence/phase80"
OS = "https://172.20.0.1:9200"
ADMIN = "admin:" + open("/tmp/os_admin.txt").read().strip()
DEDUP = "dedup_writer:94f41153bf5060fa151bae35ddf6f7c15560302b99271cd1"
IDX = "wazuh-iris-dedup-000001"

def curl(auth, method, path, data=None):
    cmd = ["curl","-sk","-u",auth,"-X",method,f"{OS}{path}","-w","\n%{http_code}"]
    if data is not None:
        cmd += ["-H","Content-Type: application/json","--data",json.dumps(data)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    parts = r.stdout.rsplit("\n",1)
    code = int(parts[1]) if len(parts)>1 and parts[1].isdigit() else r.returncode
    return code

# Re-verify RBAC after recovery (write allowed, admin op denied) via temp index
TIDX = "wazuh-iris-dedup-reapply-p80"
curl(ADMIN,"DELETE", f"/{TIDX}")  # ensure clean start
uid = datetime.now(timezone.utc).strftime("%H%M%S%f")
rc_w = curl(DEDUP,"POST", f"/{TIDX}/_doc/{uid}", {"event_id":uid,"state":"reapply"})
rc_d = curl(DEDUP,"DELETE", f"/{TIDX}")
curl(ADMIN,"DELETE", f"/{TIDX}")
rbac_ok = (rc_w in (200,201)) and (rc_d == 403)

# Re-verify dedicated secrets still present in docker + granted to services
def sh(cmd):
    return subprocess.run(cmd, shell=True, capture_output=True, text=True).stdout
secrets_present = [s for s in ["iris-shuffle-dedicated","dedup-shuffle-dedicated","iris-ca.crt","opensearch-ca"]
                   if s in sh("docker secret ls")]
sb = json.loads(sh("docker inspect shuffle-backend"))[0]
sb_mounts = [m.get("Destination","") for m in sb["Mounts"]]
# dedicated secret files expected under /run/secrets
dedicated_mounted_backend = [s for s in secrets_present if any(s in d for d in sb_mounts)]
sw = json.loads(sh("docker service inspect shuffle-workers"))[0]
sw_secrets = [s["SecretName"] for s in sw["Spec"].get("TaskTemplate",{}).get("ContainerSpec",{}).get("Secrets",[])]
secrets_granted = bool(dedicated_mounted_backend) and ("dedup-shuffle-dedicated" in sw_secrets)

secured_reapply = rbac_ok and bool(secrets_present) and secrets_granted
ev = {"secured_reapply": secured_reapply,
      "reapply_rbac_write_rc": rc_w, "reapply_rbac_delete_rc": rc_d,
      "dedicated_secrets_present": secrets_present,
      "backend_dedicated_secret_mounts": dedicated_mounted_backend,
      "workers_swarm_secrets": sw_secrets}
json.dump(ev, open(f"{OUT}/secured-reapply.json","w"), indent=2)
print(json.dumps(ev, indent=2))
