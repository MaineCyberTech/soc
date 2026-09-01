#!/usr/bin/env python3
"""
Phase 85 SHUFFLE-OPENSEARCH workstream - value-blind security/config backup capture.

Reads the LIVE OpenSearch Security configuration of the `shuffle-opensearch`
cluster (read-only GETs only) and writes a REDACTED backup usable for audit and
as the reference state for the rollback plan.

SECRET HANDLING (mandatory):
  * The admin credential is consumed in-process from the mode-600 gitignored
    /opt/mct-security-stack/.env (never echoed, never placed in argv).
  * Every key whose name matches the secret-ish denylist is dropped and the key
    NAME ONLY is recorded under `_redacted_keys`.
  * No secret value, no password hash, no secret-derived fingerprint is written.
"""
import hashlib
import json
import os
import subprocess
import sys
import datetime

BASE = "/opt/mct-security-stack"
CA = f"{BASE}/data/opensearch-tls/ca/ca.pem"
HOST = "shuffle-opensearch"
RESOLVE = f"{HOST}:9200:172.20.0.1"
URL = f"https://{HOST}:9200"

DENY = (
    "password", "hash", "secret", "token", "apikey", "api_key",
    "private_key", "pemkey", "keystore", "credential", "passwd", "pwd",
)

redacted_keys = set()


def load_pw():
    """Read SHUFFLE_OPENSEARCH_PASSWORD from .env without echoing it."""
    with open(f"{BASE}/.env", "r", encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line.startswith("SHUFFLE_OPENSEARCH_PASSWORD="):
                return line.split("=", 1)[1].strip().strip('"').strip("'")
    raise SystemExit("SHUFFLE_OPENSEARCH_PASSWORD not present in .env")


def redact(obj, path=""):
    if isinstance(obj, dict):
        out = {}
        for k, v in obj.items():
            if any(d in k.lower() for d in DENY):
                redacted_keys.add(f"{path}/{k}".lstrip("/"))
                continue
            out[k] = redact(v, f"{path}/{k}")
        return out
    if isinstance(obj, list):
        return [redact(v, path) for v in obj]
    return obj


def get(pw, endpoint):
    cmd = [
        "curl", "-s", "-o", "-", "-w", "\n@@HTTP:%{http_code}",
        "--cacert", CA, "--resolve", RESOLVE,
        "--config", "-", f"{URL}{endpoint}",
    ]
    # credential passed on stdin via curl --config so it never appears in argv
    cfg = f'user = "admin:{pw}"\n'
    res = subprocess.run(cmd, input=cfg, capture_output=True, text=True)
    raw = res.stdout
    code = 0
    if "@@HTTP:" in raw:
        raw, tail = raw.rsplit("\n@@HTTP:", 1)
        code = int(tail.strip() or 0)
    try:
        body = json.loads(raw) if raw.strip() else None
    except json.JSONDecodeError:
        body = {"_non_json_body_omitted": True}
    return code, body


def main():
    outdir = sys.argv[1]
    os.makedirs(outdir, exist_ok=True)
    pw = load_pw()

    endpoints = {
        "internalusers": "/_plugins/_security/api/internalusers",
        "roles": "/_plugins/_security/api/roles",
        "rolesmapping": "/_plugins/_security/api/rolesmapping",
        "actiongroups": "/_plugins/_security/api/actiongroups",
        "tenants": "/_plugins/_security/api/tenants",
        "securityconfig": "/_plugins/_security/api/securityconfig",
        "audit_config": "/_plugins/_security/api/audit",
        "permissionsinfo": "/_plugins/_security/api/permissionsinfo",
        "authinfo": "/_plugins/_security/authinfo",
        "ism_policies": "/_plugins/_ism/policies",
        "aliases": "/_alias",
        "index_templates": "/_index_template",
        "legacy_templates": "/_template",
        "cluster_health": "/_cluster/health",
    }

    backup = {
        "artifact": "phase85 shuffle-opensearch security + datastore config backup (REDACTED, value-blind)",
        "phase": 85,
        "workstream": "SHUFFLE-OPENSEARCH",
        "cluster": "shuffle-opensearch (opensearchproject/opensearch:3.2.0, cluster.name=shuffle-cluster)",
        "endpoint": f"{URL} (published 172.20.0.1:9200)",
        "captured_utc": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "method": "read-only HTTPS GET, internal CA CN=mct-opensearch-ca validated, hostname verified, "
                  "identity admin (all_access) supplied via curl --config on stdin (never in argv)",
        "secret_handling": "password hashes and every secret-ish key dropped before write; key NAMES ONLY listed "
                           "in _redacted_keys; no secret value or secret-derived fingerprint persisted",
        "http_status": {},
        "config": {},
    }

    for name, ep in endpoints.items():
        code, body = get(pw, ep)
        backup["http_status"][ep] = code
        backup["config"][name] = redact(body, name) if body is not None else None

    backup["_redacted_keys"] = sorted(redacted_keys)

    path = os.path.join(outdir, "security-config-redacted.json")
    blob = json.dumps(backup, indent=1, sort_keys=True)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(blob)
    os.chmod(path, 0o640)
    print(path)
    print("sha256", hashlib.sha256(blob.encode()).hexdigest())
    print("http", json.dumps(backup["http_status"]))
    print("redacted_key_names", len(backup["_redacted_keys"]))


if __name__ == "__main__":
    main()
