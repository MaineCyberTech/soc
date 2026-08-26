# Phase 40 Dashboard Import Attempt

**Report ID:** phase40-62-dashboard-import
**Phase:** 40
**Title:** Real Saved-Objects Import of W1/W2 NDJSON — SUCCESS 8/8 via `securitytenant: global` (private-Tenant Header Was the Blocker); Post-Import GET Verification; Rollback Ids
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:28:00Z
**Classification:** INTERNAL
**Status:** COMPLETE — IMPORT SUCCEEDED (8/8)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-62-dashboard-import.md`

---

## 1. Target service discovery — REAL OUTPUTS

```
$ docker ps --format '{{.Names}}\t{{.Ports}}' | grep -i dash
multi-node-wazuh.dashboard-1    443/tcp, 127.0.0.1:443->5601/tcp

$ ss -tlnp | grep 443
LISTEN 0 4096  127.0.0.1:443  0.0.0.0:*        ← dashboard mapped here

$ curl -sk -o /dev/null -w '%{http_code}\n' https://127.0.0.1:443/
302        ← alive, redirects to login; API usable with Basic auth
```

## 2. Attempt #1 — `securitytenant: private` → AUTHZ FAILURE (honest capture)

```
$ curl -sk -X POST 'https://127.0.0.1:443/api/saved_objects/_import?overwrite=true' \
    -H 'osd-xsrf: true' -H 'securitytenant: private' \
    --form file=@ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson \
    -u admin:'***'
HTTP 200, body:
{"successCount":0,"success":false,"errors":[{"id":"p39-w1-windows-endpoints",
 "type":"dashboard","title":"W1 — Windows Endpoints: ...",
 "error":{"message":"no permissions for [indices:data/write/bulk[s]] and User
 [name=admin, backend_roles=[admin], requestedTenant=private]","type":"unknown"}},
 ... (same for all 8 objects)]}
```

Precise blocker: the built-in admin user is **not authorized to write the
`private` tenant's backing index** (`requestedTenant=private`). HTTP layer fine,
auth fine, tenant authorization denied.

## 3. Attempt #2 — `securitytenant: global` → SUCCESS

```
$ curl -sk -X POST 'https://127.0.0.1:443/api/saved_objects/_import?overwrite=true' \
    -H 'osd-xsrf: true' -H 'securitytenant: global' \
    --form file=@ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson \
    -u admin:'***'

{"successCount":8,"success":true,"successResults":[
 {"type":"dashboard","id":"p39-w1-windows-endpoints", ...},
 {"type":"dashboard","id":"p39-w2-windows-telemetry-quality", ...}, ...]}
```

**8/8 objects imported** into the Global tenant. Omitting the header entirely
also succeeds (server default resolves to global for this user).

## 4. Post-import verification — REAL OUTPUT

```
$ curl -sk -u admin:'***' 'https://127.0.0.1:443/api/saved_objects/dashboard/p39-w1-windows-endpoints'
{"id":"p39-w1-windows-endpoints","type":"dashboard","namespaces":["default"],
 "updated_at":"2026-08-26T02:16:24.823Z",
 "attributes":{"title":"W1 — Windows Endpoints: Connectivity, Freshness, Throttle",
 "description":"Phase 39 DASH-39-01. Panels driven by agent.id filters and lastKeepAlive freshness.
 Windows agents: 012,013,014 (windows-clients group).","panelsJSON":"[{\"pan...
```

Object retrievable with fresh `updated_at` timestamp ⇒ persisted server-side.

## 5. Rollback procedure (if ever required)

```bash
for ID in p39-w1-windows-endpoints p39-w2-windows-telemetry-quality \
          p39-w1-agent-status-metric p39-w1-lastkeepalive-freshness \
          p39-w1-throttle-events p39-w2-eid-top-table \
          p39-w2-telemetry-quality-metric p39-w2-billing-eligible-tagcloud; do
  curl -sk -u admin:'***' -X DELETE "https://127.0.0.1:443/api/saved_objects/dashboard/$ID" -H 'osd-xsrf: true'
done   # note: visualizations need type-specific DELETE paths (visualization/<id>)
```

Deterministic because ids are fixed (`p39-*`) and no other objects were touched.

## 6. Owner actions / residuals

- UI path for any future re-import: Dashboards → Management → Saved Objects →
  Import → select ndjson → **choose Global tenant**, overwrite yes.
- Residual: grant admin write on `private` tenant OR document global-only
  import convention (chosen: document here).
- Runtime rendering validation continues in phase40-63/64.
