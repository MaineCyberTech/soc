#!/usr/bin/env python3
import subprocess, json, os, hashlib, datetime, time
from datetime import timezone

OUT = "/opt/mct-security-stack/ops/reports/evidence/phase80"
OS = "https://172.20.0.1:9200"
ADMIN = "admin:" + open("/tmp/os_admin.txt").read().strip()
DEDUP = "dedup_writer:94f41153bf5060fa151bae35ddf6f7c15560302b99271cd1"
IDX = "wazuh-iris-dedup-000001"
REPO = "mct_snapshots"

def curl(auth, method, path, data=None):
    cmd = ["curl","-sk","-u",auth,"-X",method,f"{OS}{path}"]
    if data is not None:
        cmd += ["-H","Content-Type: application/json","--data",json.dumps(data)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode, r.stdout

# Record old id
rc, out = curl(ADMIN,"GET", f"/_cat/indices/{IDX}?h=uuid,docs.count,status&format=json")
old = json.loads(out)[0]
opensearch_old_id = old["uuid"]
print("OLD_ID", opensearch_old_id, "docs", old.get("docs.count"))

ts = datetime.datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ").lower()
snap = f"p80_snap_{ts}"
print("SNAPSHOT", snap)

# Take snapshot (record window)
t0 = datetime.datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.%fZ")
rc, out = curl(ADMIN,"PUT", f"/_snapshot/{REPO}/{snap}?wait_for_completion=true",
               {"indices": IDX, "include_global_state": False})
t1 = datetime.datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.%fZ")
print("SNAP_RC", rc, out[:300])
snap_state = json.loads(out).get("snapshot",{}).get("state") if out.strip() else None
print("SNAP_STATE", snap_state)

# Delete the index (true runtime reconstruction target)
rc, out = curl(ADMIN,"DELETE", f"/{IDX}")
print("DELETE_RC", rc, out[:120])
# confirm gone
rc, out = curl(ADMIN,"GET", f"/_cat/indices/{IDX}?h=uuid&format=json")
print("AFTER_DELETE_EXISTS", bool(out.strip() and out.strip()!='[]'))

# Restore from snapshot (runtime type = snapshot, NOT reindex)
rc, out = curl(ADMIN,"POST", f"/_snapshot/{REPO}/{snap}/_restore?wait_for_completion=true",
               {"indices": IDX})
print("RESTORE_RC", rc, out[:200])
# new id
rc, out = curl(ADMIN,"GET", f"/_cat/indices/{IDX}?h=uuid,docs.count,status&format=json")
new = json.loads(out)[0]
opensearch_new_id = new["uuid"]
print("NEW_ID", opensearch_new_id, "docs", new.get("docs.count"))

ev = {
  "opensearch_old_id": opensearch_old_id,
  "opensearch_new_id": opensearch_new_id,
  "opensearch_runtime_type": "snapshot",
  "snapshot_id": snap,
  "snapshot_window_start": t0,
  "snapshot_window_end": t1,
  "snapshot_state": snap_state,
  "docs_after_restore": new.get("docs.count"),
}
json.dump(ev, open(f"{OUT}/opensearch-recovery.json","w"), indent=2)
print(json.dumps(ev, indent=2))
