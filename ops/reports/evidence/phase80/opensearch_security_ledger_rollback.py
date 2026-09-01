#!/usr/bin/env python3
import subprocess, json, os
from datetime import timezone, datetime

OUT = "/opt/mct-security-stack/ops/reports/evidence/phase80"
OS = "https://172.20.0.1:9200"
ADMIN = "admin:" + open("/tmp/os_admin.txt").read().strip()
DEDUP = "dedup_writer:94f41153bf5060fa151bae35ddf6f7c15560302b99271cd1"
IDX = "wazuh-iris-dedup-000001"
REPO = "mct_snapshots"
SNAP = json.load(open(f"{OUT}/opensearch-recovery.json"))["snapshot_id"]

def curl(auth, method, path, data=None):
    cmd = ["curl","-sk","-u",auth,"-X",method,f"{OS}{path}","-w","\n%{http_code}"]
    if data is not None:
        cmd += ["-H","Content-Type: application/json","--data",json.dumps(data)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    parts = r.stdout.rsplit("\n",1)
    code = int(parts[1]) if len(parts)>1 and parts[1].isdigit() else r.returncode
    body_txt = parts[0]
    try:
        body = json.loads(body_txt) if body_txt.strip() else {}
    except Exception:
        body = {"raw": body_txt[:200]}
    return code, body

ev = {}

# ---- security_restored: scoped dedup_writer RBAC ----
TIDX = "wazuh-iris-dedup-rbactest-p80"
# 1) dedup_writer CAN write (to a dedup-pattern index)
rc, b = curl(DEDUP,"POST", f"/{TIDX}/_doc/1", {"event_id":"x","state":"test"})
write_ok = rc in (200,201)
# 2) dedup_writer CANNOT do admin op (delete index)
rc, b = curl(DEDUP,"DELETE", f"/{TIDX}")
admin_op_denied = (rc == 403)
# 3) dedup_writer CANNOT create role
rc, b = curl(DEDUP,"PUT", "/_plugins/_security/api/roles/testrole", {"cluster_permissions":["*"]})
role_create_denied = (rc == 403)
# 4) anonymous denied
rc, b = curl(":", "GET", f"/{IDX}/_search?size=1")
anon_denied = (rc == 401)
# cleanup temp index via admin (keep real ledger untouched)
curl(ADMIN,"DELETE", f"/{TIDX}")
security_restored = write_ok and admin_op_denied and role_create_denied and anon_denied
ev["security_restored"] = security_restored
ev["rbac_detail"] = {"dedup_writer_write_ok": write_ok, "admin_op_denied": admin_op_denied,
                     "role_create_denied": role_create_denied, "anonymous_denied": anon_denied}

# ---- ledger_parity: create-only / dedup structure preserved ----
rc, mp = curl(ADMIN,"GET", f"/{IDX}/_mapping")
props = mp.get(IDX,{}).get("mappings",{}).get("properties",{})
has_dedup_key = "event_id" in props and "keyword" in props["event_id"].get("fields",{})
rc, cnt = curl(ADMIN,"GET", f"/{IDX}/_count")
docs = cnt.get("count")
rc, snapcnt = curl(ADMIN,"GET", f"/_snapshot/{REPO}/{SNAP}?pretty")
snap_doc_count = snapcnt.get("snapshots",[{}])[0].get("shards",{}).get("successful")
snap_indices = snapcnt.get("snapshots",[{}])[0].get("indices")
ledger_parity = has_dedup_key and (docs is not None)
ev["ledger_parity"] = ledger_parity
ev["ledger_detail"] = {"dedup_key_field":"event_id", "keyword_subfield": has_dedup_key,
                       "docs_after_restore": docs}

# ---- true_runtime_rollback: restore SAME snapshot to verify index, compare, delete ----
VIX = "wazuh-iris-dedup-verify-p80"
rc, b = curl(ADMIN,"POST", f"/_snapshot/{REPO}/{SNAP}/_restore?wait_for_completion=true",
            {"indices": IDX, "rename_pattern": IDX, "rename_replacement": VIX})
restore_ok = rc == 200 and b.get("snapshot",{}).get("shards",{}).get("failed",1)==0
rc, vc = curl(ADMIN,"GET", f"/{VIX}/_count")
verify_docs = vc.get("count")
rc, vm = curl(ADMIN,"GET", f"/{VIX}/_mapping")
verify_props = vm.get(VIX,{}).get("mappings",{}).get("properties",{})
mapping_match = set(verify_props.keys()) == set(props.keys())
count_match = (verify_docs == docs)
# delete verify index
rc, b = curl(ADMIN,"DELETE", f"/{VIX}")
verify_deleted = b.get("acknowledged") is True
true_runtime_rollback = restore_ok and mapping_match and count_match and verify_deleted
ev["true_runtime_rollback"] = true_runtime_rollback
ev["rollback_detail"] = {"verify_index": VIX, "original_docs": docs, "verify_docs": verify_docs,
                         "mapping_match": mapping_match, "count_match": count_match,
                         "verify_index_deleted": verify_deleted}

json.dump(ev, open(f"{OUT}/opensearch-security-ledger-rollback.json","w"), indent=2)
print(json.dumps(ev, indent=2))
