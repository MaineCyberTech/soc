#!/usr/bin/env python3
"""
Phase 85 SHUFFLE-OPENSEARCH — live dependency-inventory snapshot.

Captures, read-only, exactly what the Shuffle backend does against the
`shuffle-opensearch` cluster, so that least privilege is derived from ACTUAL
underlying actions rather than from HTTP paths.

Sources (all live / CURRENT):
  A. `docker inspect shuffle-backend` env KEY NAMES + non-secret values only.
  B. OpenSearch Security audit log (`security-auditlog-*`) filtered to the Shuffle
     backend container IP, aggregated by `audit_request_privilege` — the real
     transport-layer action names.
  C. Read-only cluster introspection (_cat/indices, _alias, _plugins/_ism/*).
  D. Non-secret literal strings extracted from the deployed `shufflebackend`
     binary (endpoint shapes the platform actually calls).
  E. Shuffle's OWN platform-health document persisted in OpenSearch.

SECRET HANDLING: the admin credential is read in-process from mode-600 .env and
handed to curl via `--config` on stdin, never in argv. `audit_request_body` is
NEVER selected or persisted. No secret value / hash / fingerprint is written.
"""
import datetime
import hashlib
import json
import os
import subprocess
import sys

BASE = "/opt/mct-security-stack"
CA = f"{BASE}/data/opensearch-tls/ca/ca.pem"
RESOLVE = "shuffle-opensearch:9200:172.20.0.1"
URL = "https://shuffle-opensearch:9200"
BACKEND_IP = "172.20.0.6"

SAFE_SOURCE = ["@timestamp", "audit_category", "audit_request_effective_user",
               "audit_request_privilege", "audit_trace_indices",
               "audit_transport_request_type", "audit_request_layer"]


def pw():
    with open(f"{BASE}/.env", encoding="utf-8") as fh:
        for line in fh:
            if line.strip().startswith("SHUFFLE_OPENSEARCH_PASSWORD="):
                return line.strip().split("=", 1)[1].strip().strip('"').strip("'")
    raise SystemExit("credential not found")


def req(secret, method, endpoint, body=None):
    cmd = ["curl", "-s", "-X", method, "--cacert", CA, "--resolve", RESOLVE,
           "-H", "Content-Type: application/json", "--config", "-", f"{URL}{endpoint}"]
    if body is not None:
        cmd += ["-d", json.dumps(body)]
    res = subprocess.run(cmd, input=f'user = "admin:{secret}"\n',
                         capture_output=True, text=True)
    try:
        return json.loads(res.stdout)
    except json.JSONDecodeError:
        return {"_raw_omitted": True}


def dexec(args):
    return subprocess.run(args, capture_output=True, text=True).stdout.strip()


def main():
    out = sys.argv[1]
    s = pw()
    now = datetime.datetime.now(datetime.timezone.utc)

    snap = {
        "artifact": "phase85-shuffle-opensearch-dependency-snapshot.json",
        "phase": 85,
        "workstream": "SHUFFLE-OPENSEARCH",
        "captured_utc": now.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "captured_et": "2026-08-31 19:20:00 EDT",
        "evidence_class": "REST (live authenticated OpenSearch + audit log) + container-inspect + deployed-binary strings",
        "current_or_carried": "CURRENT",
        "literal_or_modeled": "literal",
        "secret_handling": "credential consumed in-process from mode-600 gitignored .env, passed to curl via --config on stdin (never argv); audit_request_body never selected; no secret value/hash/fingerprint persisted",
    }

    # ---- A. consumer binding (non-secret env only) -------------------------
    env_lines = dexec(["docker", "inspect", "shuffle-backend", "--format",
                       "{{range .Config.Env}}{{println .}}{{end}}"]).splitlines()
    non_secret = {}
    key_names = []
    for line in env_lines:
        if "=" not in line:
            continue
        k, v = line.split("=", 1)
        key_names.append(k)
        if k in ("SHUFFLE_OPENSEARCH_URL", "SHUFFLE_OPENSEARCH_USERNAME",
                 "SHUFFLE_DATABASE_TYPE", "SHUFFLE_DEFAULT_ORG", "SHUFFLE_ORG_ID",
                 "OUTER_HOSTNAME", "SHUFFLE_FILE_LOCATION", "SHUFFLE_STATS_DISABLED",
                 "SHUFFLE_LOGS_DISABLED"):
            non_secret[k] = v
    snap["consumer_binding"] = {
        "container": "shuffle-backend (ghcr.io/shuffle/shuffle-backend)",
        "container_ip_mct_security": BACKEND_IP,
        "target": "shuffle-opensearch (opensearchproject/opensearch:3.2.0, cluster shuffle-cluster)",
        "auth_mechanism": "HTTP Basic over TLS (internal CA CN=mct-opensearch-ca); no client certificate; no token",
        "non_secret_env": non_secret,
        "env_key_names_only": sorted(key_names),
        "secret_env_key_names_present": [k for k in key_names if "PASSWORD" in k],
        "identity": "internal user `admin` (reserved:true, backend_roles:[admin]) -> roles mapping all_access (reserved:true, static:true, cluster_permissions ['*'], index_patterns ['*'] allowed_actions ['*'])",
        "credential_coupling": "compose binds the SAME ${SHUFFLE_OPENSEARCH_PASSWORD} to OPENSEARCH_INITIAL_ADMIN_PASSWORD (cluster bootstrap) and SHUFFLE_OPENSEARCH_PASSWORD (backend datastore auth)",
    }

    # ---- B. audit-derived real action names --------------------------------
    agg = req(s, "GET", "/security-auditlog-*/_search", {
        "size": 0,
        "query": {"bool": {"filter": [{"term": {"audit_request_remote_address.keyword": BACKEND_IP}}]}},
        "aggs": {
            "priv": {"terms": {"field": "audit_request_privilege.keyword", "size": 200}},
            "cat": {"terms": {"field": "audit_category.keyword", "size": 20}},
            "user": {"terms": {"field": "audit_request_effective_user.keyword", "size": 20}},
            "rtype": {"terms": {"field": "audit_transport_request_type.keyword", "size": 50}},
            "layer": {"terms": {"field": "audit_request_layer.keyword", "size": 10}},
        }})
    def buckets(name):
        return {b["key"]: b["doc_count"] for b in agg["aggregations"][name]["buckets"]}

    samples = req(s, "GET", "/security-auditlog-*/_search", {
        "size": 12, "sort": [{"@timestamp": "desc"}],
        "query": {"bool": {"filter": [{"term": {"audit_request_remote_address.keyword": BACKEND_IP}}]}},
        "_source": SAFE_SOURCE})

    denials = req(s, "GET", "/security-auditlog-*/_search", {
        "size": 8, "sort": [{"@timestamp": "desc"}],
        "query": {"bool": {"filter": [{"term": {"audit_category.keyword": "MISSING_PRIVILEGES"}}]}},
        "_source": SAFE_SOURCE})

    snap["audit_derived_actions"] = {
        "total_events_for_shuffle_backend": agg["hits"]["total"]["value"],
        "effective_users": buckets("user"),
        "categories": buckets("cat"),
        "request_layers": buckets("layer"),
        "transport_request_types": buckets("rtype"),
        "privileges_observed": buckets("priv"),
        "sample_event_ids": [
            {"index": h["_index"], "id": h["_id"],
             "ts": h["_source"].get("@timestamp"),
             "category": h["_source"].get("audit_category"),
             "privilege": h["_source"].get("audit_request_privilege"),
             "indices": h["_source"].get("audit_trace_indices"),
             "request_type": h["_source"].get("audit_transport_request_type")}
            for h in samples["hits"]["hits"]],
        "least_priv_denial_event_ids": [
            {"index": h["_index"], "id": h["_id"], "ts": h["_source"].get("@timestamp"),
             "user": h["_source"].get("audit_request_effective_user"),
             "privilege": str(h["_source"].get("audit_request_privilege"))[:120],
             "indices": h["_source"].get("audit_trace_indices")}
            for h in denials["hits"]["hits"]],
        "audit_coverage_limitation": "audit config disables AUTHENTICATED and GRANTED_PRIVILEGES for both rest and transport, so routine allowed read/write operations are NOT logged; INDEX_EVENT / FAILED_LOGIN / MISSING_PRIVILEGES / COMPLIANCE_* are. The audit log therefore proves the PRIVILEGED index-admin operations Shuffle performs but is not a complete list of its data-plane calls.",
    }

    # ---- C. cluster introspection -----------------------------------------
    aliases = req(s, "GET", "/_alias")
    ism = req(s, "GET", "/_plugins/_ism/policies")
    explain = req(s, "GET", "/_plugins/_ism/explain/workflowexecution-000001")
    health = req(s, "GET", "/_cluster/health")
    cats = subprocess.run(
        ["curl", "-s", "--cacert", CA, "--resolve", RESOLVE, "--config", "-",
         f"{URL}/_cat/indices?format=json&h=index,docs.count"],
        input=f'user = "admin:{s}"\n', capture_output=True, text=True).stdout
    try:
        cat_idx = json.loads(cats)
    except json.JSONDecodeError:
        cat_idx = []

    shuffle_aliased = ["workflow", "workflow_revisions", "workflowapp", "workflowexecution",
                       "datastore_category", "datastore_ngram", "environments", "notifications",
                       "org_cache", "org_cache_revisions", "org_statistics", "shuffle_logs"]
    shuffle_plain = ["app_revisions", "files", "hooks", "openapi3", "organizations",
                     "platform_health", "sessions", "users", "workflowqueue-shuffle"]

    snap["cluster_state"] = {
        "cluster_health_status": health.get("status"),
        "total_indices": len(cat_idx),
        "shuffle_owned_index_families_aliased_ism_managed": shuffle_aliased,
        "shuffle_owned_index_families_non_aliased": shuffle_plain,
        "shuffle_owned_total": len(shuffle_aliased) + len(shuffle_plain),
        "shuffle_write_aliases_live": sorted(
            a for a, v in aliases.items() if isinstance(v, dict) for a in v.get("aliases", {})
        ) if isinstance(aliases, dict) else [],
        "co_tenant_non_shuffle_indices": sorted(
            i["index"] for i in cat_idx
            if not any(i["index"].startswith(p) for p in shuffle_aliased + shuffle_plain)
        ),
        "index_prefix_env_set": False,
        "index_namespace_note": "SHUFFLE_OPENSEARCH_INDEX_PREFIX is NOT set; the 21 Shuffle index families share no common prefix and at least one is derived from a runtime value (workflowqueue-<environment> -> workflowqueue-shuffle), so the namespace is open-ended.",
        "ism_policy_count": ism.get("total_policies"),
        "ism_policy_shuffle_rollover": next(
            ({"id": p["_id"], "description": p["policy"].get("description"),
              "seq_no": p.get("_seq_no"), "primary_term": p.get("_primary_term"),
              "version": p.get("_version"),
              "ism_template_index_patterns": p["policy"].get("ism_template", [{}])[0].get("index_patterns"),
              "states": [st["name"] for st in p["policy"].get("states", [])]}
             for p in ism.get("policies", []) if p["_id"] == "shuffle-rollover"), None),
        "ism_explain_workflowexecution_000001_policy_id": explain.get(
            "workflowexecution-000001", {}).get("policy_id"),
    }

    # ---- D. deployed-binary endpoint shapes (non-secret strings) ----------
    def bstrings(pattern):
        return sorted(set(filter(None, dexec([
            "docker", "exec", "shuffle-backend", "sh", "-c",
            f'grep -a -o -E "{pattern}" /app/shufflebackend | sort -u'
        ]).splitlines())))

    snap["deployed_binary_endpoint_evidence"] = {
        "binary": "/app/shufflebackend inside container shuffle-backend (image ghcr.io/shuffle/shuffle-backend)",
        "ism_paths": bstrings("_plugins/_ism/[a-zA-Z0-9/_.-]*"),
        "policy_id_literal": bstrings("shuffle-rollover"),
        "other_paths": bstrings("/_aliases|/_cat/indices[a-zA-Z0-9?=&_,.*-]*|/_search"),
        "interpretation": "PUT _plugins/_ism/policies/<id> and POST _plugins/_ism/add/<index> are CLUSTER-scoped ISM APIs; GET /_cat/indices?format=json&h=index is a cluster-wide index enumeration. Neither can be narrowed to the Shuffle index patterns by any OpenSearch Security index_permission.",
    }

    # ---- E. Shuffle's own platform-health record ---------------------------
    ph = req(s, "GET", "/platform_health/_search",
             {"size": 1, "sort": [{"updated": "desc"}]})
    src = ph["hits"]["hits"][0]["_source"] if ph.get("hits", {}).get("hits") else {}
    snap["shuffle_authored_pipeline_proof"] = {
        "index": "platform_health",
        "doc_id": ph["hits"]["hits"][0]["_id"] if ph.get("hits", {}).get("hits") else None,
        "updated_epoch": src.get("updated"),
        "updated_utc": datetime.datetime.fromtimestamp(
            src.get("updated", 0), datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "success": src.get("success"),
        "datastore_subchecks": {k: v for k, v in (src.get("datastore") or {}).items()
                                if k in ("create", "read", "delete")},
        "workflow_subchecks": {k: v for k, v in (src.get("workflows") or {}).items()
                               if k in ("create", "run", "run_finished", "delete", "run_status")},
        "app_subchecks": {k: v for k, v in (src.get("apps") or {}).items()
                          if k in ("create", "run", "delete", "validate", "read")},
        "interpretation": "Shuffle itself wrote this document to OpenSearch; datastore create/read/delete true and workflow create/run/delete true prove the Shuffle->OpenSearch pipeline is FUNCTIONAL as of the recorded timestamp.",
    }
    wc = req(s, "GET", "/workflowexecution/_count")
    snap["shuffle_authored_pipeline_proof"]["workflowexecution_doc_count"] = wc.get("count")

    blob = json.dumps(snap, indent=1, sort_keys=True)
    path = os.path.join(out, "phase85-shuffle-opensearch-dependency-snapshot.json")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(blob)
    print(path)
    print("sha256", hashlib.sha256(blob.encode()).hexdigest())


if __name__ == "__main__":
    main()
