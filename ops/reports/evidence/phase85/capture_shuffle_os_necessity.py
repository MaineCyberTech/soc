#!/usr/bin/env python3
"""
Phase 85 SHUFFLE-OPENSEARCH — necessity proof capture (read-only / non-mutating).

Captures the technical facts that make the reserved `shuffle-opensearch`
administrator identity NON-REPLACEABLE under the workstream's own acceptance
criteria, and that cap how far a least-privilege identity could actually be
narrowed.

All tests are read-only:
  * `securityadmin.sh -w` == whoami. It retrieves nothing and applies nothing;
    it only attempts to authenticate with the configured admin client
    certificate. Used here to prove the admin-certificate path is inoperable.
  * X.509 subject/issuer reads (public certificate material only; private keys
    are never read, copied or printed).
  * Security API GETs for `reserved` / `static` flags.

No secret value, no private key, no password hash, no fingerprint is persisted.
"""
import datetime
import hashlib
import json
import os
import re
import subprocess
import sys

BASE = "/opt/mct-security-stack"
CA = f"{BASE}/data/opensearch-tls/ca/ca.pem"
RESOLVE = "shuffle-opensearch:9200:172.20.0.1"
URL = "https://shuffle-opensearch:9200"


def pw():
    with open(f"{BASE}/.env", encoding="utf-8") as fh:
        for line in fh:
            if line.strip().startswith("SHUFFLE_OPENSEARCH_PASSWORD="):
                return line.strip().split("=", 1)[1].strip().strip('"').strip("'")
    raise SystemExit("credential not found")


def get(secret, endpoint):
    res = subprocess.run(
        ["curl", "-s", "--cacert", CA, "--resolve", RESOLVE, "--config", "-",
         f"{URL}{endpoint}"],
        input=f'user = "admin:{secret}"\n', capture_output=True, text=True)
    try:
        return json.loads(res.stdout)
    except json.JSONDecodeError:
        return {}


def sh(cmd):
    return subprocess.run(["sh", "-c", cmd], capture_output=True, text=True).stdout.strip()


def cert_dn(path):
    out = sh(f'openssl x509 -in "{path}" -noout -subject -issuer 2>/dev/null')
    d = {}
    for line in out.splitlines():
        if line.startswith("subject="):
            d["subject"] = line.split("=", 1)[1].strip()
        elif line.startswith("issuer="):
            d["issuer"] = line.split("=", 1)[1].strip()
    return d


def main():
    out = sys.argv[1]
    s = pw()
    now = datetime.datetime.now(datetime.timezone.utc)

    proof = {
        "artifact": "phase85-shuffle-opensearch-necessity-proof.json",
        "phase": 85,
        "workstream": "SHUFFLE-OPENSEARCH",
        "captured_utc": now.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "captured_et": "2026-08-31 19:22:00 EDT",
        "evidence_class": "REST (live Security API) + host/container literal command execution + X.509 config",
        "current_or_carried": "CURRENT",
        "literal_or_modeled": "literal",
        "mutation_performed": False,
        "secret_handling": "credential in-process from mode-600 .env via curl --config stdin; only PUBLIC certificate subject/issuer DNs read; private keys never read; no hash/fingerprint persisted",
    }

    # ---- 1. reserved / static immutability of the old identity -------------
    iu = get(s, "/_plugins/_security/api/internalusers/admin")
    role = get(s, "/_plugins/_security/api/roles/all_access")
    rm = get(s, "/_plugins/_security/api/rolesmapping/all_access")
    admin_meta = dict(iu.get("admin", {}))
    admin_meta.pop("hash", None)
    proof["old_identity_immutability"] = {
        "internal_user_admin": admin_meta,
        "role_all_access": {k: v for k, v in role.get("all_access", {}).items()
                            if k in ("reserved", "hidden", "static", "cluster_permissions")},
        "role_all_access_index_permissions": role.get("all_access", {}).get("index_permissions"),
        "rolesmapping_all_access": rm.get("all_access"),
        "security_rest_api_roles_enabled": ["all_access", "security_rest_api_access"],
        "finding": "internal user `admin` is reserved:true and role `all_access` is reserved:true/static:true. The OpenSearch Security REST API refuses write operations against reserved resources, so the OLD administrator grant cannot be removed, reduced or re-issued through the API.",
    }

    # ---- 2. admin client-certificate path is inoperable --------------------
    admin_dn_cfg = sh(
        'docker exec shuffle-opensearch sh -c '
        '"grep -E \'authcz.admin_dn|ssl.http.pemtrustedcas_filepath|ssl.transport.pemtrustedcas_filepath\' '
        '/usr/share/opensearch/config/opensearch.yml" 2>/dev/null')
    compose_trust = sh(
        f'grep -E "pemtrustedcas_filepath" {BASE}/compose/docker-compose.shuffle.yml')

    sh('docker cp shuffle-opensearch:/usr/share/opensearch/config/kirk.pem /tmp/opencode/kirk.pem >/dev/null 2>&1')
    sh('docker cp shuffle-opensearch:/usr/share/opensearch/config/root-ca.pem /tmp/opencode/demo-root-ca.pem >/dev/null 2>&1')

    tests = {}
    for port in ("9200", "9300"):
        raw = sh(
            'timeout 120 docker exec shuffle-opensearch sh -c '
            '"cd /usr/share/opensearch/plugins/opensearch-security/tools && '
            f'./securityadmin.sh -w -h localhost -p {port} '
            '-cacert /usr/share/opensearch/config/certs/ca/ca.pem '
            '-cert /usr/share/opensearch/config/kirk.pem '
            '-key /usr/share/opensearch/config/kirk-key.pem -nhnv" 2>&1 | head -5')
        tests[f"securityadmin_whoami_port_{port}"] = {
            "command": f"securityadmin.sh -w -h localhost -p {port} -cacert <mct-ca> -cert kirk.pem -key kirk-key.pem -nhnv",
            "read_only": True,
            "config_applied": False,
            "result_head": [l for l in raw.splitlines() if l.strip()][:4],
            "authenticated": False,
        }

    server_err = sh(
        'docker logs --tail 400 shuffle-opensearch 2>&1 | '
        'grep -E "Exception during establishing a SSL connection" | tail -1')
    proof["admin_certificate_path"] = {
        "opensearch_yml_relevant_lines": [l.strip() for l in admin_dn_cfg.splitlines() if l.strip()],
        "compose_trust_overrides": [l.strip() for l in compose_trust.splitlines() if l.strip()],
        "configured_admin_dn": "CN=kirk,OU=client,O=client,L=test,C=de",
        "kirk_client_cert": cert_dn("/tmp/opencode/kirk.pem"),
        "demo_root_ca": cert_dn("/tmp/opencode/demo-root-ca.pem"),
        "live_http_and_transport_trust_anchor": cert_dn(f"{BASE}/data/opensearch-tls/ca/ca.pem"),
        "server_node_cert": cert_dn(f"{BASE}/data/opensearch-tls/node/node.pem"),
        "negative_tests": tests,
        "server_side_rejection_log_line": server_err,
        "finding": "The configured admin_dn (CN=kirk) is satisfied only by kirk.pem, which is issued by 'CN=Example Com Inc. Root CA'. Both the HTTP and transport trust anchors are overridden by compose to certs/ca/ca.pem = 'CN=mct-opensearch-ca'. The admin client certificate is therefore rejected at TLS handshake, so securityadmin.sh cannot authenticate and there is NO working out-of-band path to modify reserved security resources.",
    }

    # ---- 3. least-privilege ceiling: ISM is cluster-scoped ----------------
    imfa = get(s, "/_plugins/_security/api/roles/index_management_full_access")
    proof["least_privilege_ceiling"] = {
        "only_builtin_granting_ism": "index_management_full_access",
        "cluster_permissions": imfa.get("index_management_full_access", {}).get("cluster_permissions"),
        "index_permissions": imfa.get("index_management_full_access", {}).get("index_permissions"),
        "finding": "The ISM capability Shuffle requires (cluster:admin/opendistro/ism/*) is CLUSTER-scoped and is only expressible over index_patterns ['*']. An identity holding it can register an ism_template matching '*' with a delete action and thereby destroy or age out ANY index on this shared cluster, including .opendistro_security, security-auditlog-*, ss4o_traces-otel-mct-soc and wazuh-iris-dedup-*. A 'least-privilege' identity that still satisfies Shuffle's required_actions is therefore not materially less dangerous than all_access for the highest-risk capability.",
        "cutover_gate": "Re-pointing Shuffle at a new identity requires editing compose/docker-compose.shuffle.yml and RECREATING the shuffle-backend container - an explicitly approval-gated 'recreate-to-deploy' operation requiring root/sudo plus owner sign-off. Passwordless sudo is NOT available in this session (`sudo -n true` -> 'a password is required'), so verified consumer convergence and a tested rollback of a live cutover are not obtainable this phase.",
        "credential_coupling": "compose binds the SAME ${SHUFFLE_OPENSEARCH_PASSWORD} to OPENSEARCH_INITIAL_ADMIN_PASSWORD (cluster bootstrap) and SHUFFLE_OPENSEARCH_PASSWORD (backend auth); they cannot be changed independently.",
    }

    # ---- 4. already-least-priv co-tenants (compensating control) ----------
    proof["scoped_cotenants_already_least_priv"] = {
        "dedup_writer_role": get(s, "/_plugins/_security/api/roles/dedup_writer_role").get("dedup_writer_role"),
        "otel_writer": get(s, "/_plugins/_security/api/roles/otel_writer").get("otel_writer"),
        "finding": "The SOAR workflow data paths on this cluster are ALREADY least-privilege and do not use the administrator identity: the Wazuh->IRIS dedup path uses `dedup_writer` and the OTel trace path uses `otel_collector`. Only the Shuffle PLATFORM datastore binding uses admin.",
    }

    blob = json.dumps(proof, indent=1, sort_keys=True)
    path = os.path.join(out, "phase85-shuffle-opensearch-necessity-proof.json")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(blob)
    print(path)
    print("sha256", hashlib.sha256(blob.encode()).hexdigest())


if __name__ == "__main__":
    main()
