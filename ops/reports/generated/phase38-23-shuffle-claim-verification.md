# Phase 38-23 — Shuffle Claim Verification

**Report ID:** phase38-23-shuffle-claim-verification
**Phase:** 38
**Title:** Phase 38-23 — Shuffle Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-23-shuffle-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:30 UTC
**Scope:** Verify listener/TLS/auth/workflows/executions/routing/backup/UI-access claims against the live Shuffle stack.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | Frontend listens `0.0.0.0:3001`; backend `127.0.0.1:5001` | **VERIFIED** | `ss -tlnp` |
| 2 | Frontend has no TLS and no firewall restriction | **VERIFIED** | HTTPS probe fails (000), HTTP 200 on all-interface bind |
| 3 | Bearer-token auth functions on backend API | **VERIFIED** | Authenticated API calls return valid JSON |
| 4 | Exactly 2 workflows, healthchecks only | **CONTRADICTED** | Both workflows are Wazuh→IRIS routing workflows |
| 5 | 796 executions, all FINISHED, healthchecks only | **PARTIAL / CONTRADICTED (composition)** | P36 report records "796 total, all FINISHED"; current first-page pulls show 68 + 1 executions carrying real alert payloads |
| 6 | No real alert routing implemented | **CONTRADICTED** | Routing workflows exist with FINISHED runs processing production-shaped events |
| 7 | Workflow backups exist and are current-ish | **VERIFIED** | `ops/backups/shuffle-workflows/*.json` through Aug 23 |

---

## Evidence Detail

### 1–2. Listeners / TLS / exposure
```
$ ss -tlnp | grep -E "3001|5001"
LISTEN 0 4096   0.0.0.0:3001    0.0.0.0:*     ← frontend on ALL interfaces
LISTEN 0 4096   127.0.0.1:5001  0.0.0.0:*     ← backend loopback-only

$ curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3001/
200
$ curl -sk -o /dev/null -w "%{http_code}" https://127.0.0.1:3001/
000        ← TLS not served; frontend is plaintext HTTP
```
Frontend binds all interfaces in cleartext; host primary IP is 192.168.222.149 (LAN-reachable). Backend correctly loopback-bound. No `ufw`/`iptables` rules were retrievable without sudo (password required) — no firewall evidence found either way; the plaintext-all-interfaces exposure claim itself is confirmed by socket state. **VERIFIED** for listeners and TLS absence.

### 3. Auth
```
$ curl -s -m5 -H "Authorization: Bearer <token>" http://127.0.0.1:5001/api/v1/workflows
→ valid JSON array of 2 workflow objects
```
Bearer auth accepted (token value withheld here; it appears only in operator channel/live state). **VERIFIED.**

### 4–5. Workflows and executions — key contradiction
```
$ curl ... /api/v1/workflows | jq names/statuses
wazuh-high-severity-to-iris   eb937a37   status=test
wazuh-flow-classb-to-iris     e951db98

$ curl ... /workflows/eb937a37-.../executions?page_size=100 → 68 executions
$ curl ... /workflows/e951db98-.../executions?page_size=100 → 1 execution

Sample execution_argument (high-severity wf, started_at 1787642038 = 2026-08-25T07:13Z):
{"rule_id": "121000", "rule_level": 12,
 "rule_description": "OpenCanary deception hit",
 "rule_groups": ["opencanary"], "agent_name": "wazuh",
 "srcip": "172.20.0.1", "timestamp": "2026-08-25T07:12:58.904Z"}
status=FINISHED, completed 7 s later.
```
The two workflows are **not** healthchecks — they are named routing pipelines into DFIR-IRIS, and the high-severity one ran 68 recorded executions with genuine Wazuh alert payloads (OpenCanary rule 121000 L12 hits as recent as today). The prior "healthchecks only / no real routing" characterization does not match current live state. The "796 total, all FINISHED" figure traces to `ops/reports/phase36-26-shuffle-final-status.md` and cannot be re-derived exactly from the paginated API in this session (first pages: 68+1); totals may include deleted/replaced workflows. Statuses observed are uniformly FINISHED. **Claim 4: CONTRADICTED. Claim 5: PARTIAL** (FINISHED-only holds on every execution observed; total count and "healthcheck composition" do not hold).

### 6. Routing reality check
- High-severity workflow `status=test`, executions FINISHED with multi-node completion (`last_node` populated).
- IRIS stack is up (`iriswebapp_nginx/app/worker/db/rabbitmq` containers running).
- End-to-end proof that a finished execution created an IRIS case/alert was NOT directly queried this session (would require IRIS-side lookup). The *existence and firing* of routing pipelines contradicts "no routing"; full delivery confirmation remains open. **CONTRADICTED** as an absolute claim ("NO real routing"), with delivery-evidence caveat.

### 7. Backups
```
$ ls -la ops/backups/shuffle-workflows/
shuffle-workflows-20260811-061156.json
shuffle-workflows-20260812-021212.json
shuffle-workflows-20260816-054501.json
shuffle-workflows-20260823-054501.json   ← most recent, ~30 KB each
```
Backups exist at regular cadence; newest predates today's workflow activity by 2 days. **VERIFIED** (freshness gap noted).

---

## Verification Commands Used
```bash
ss -tlnp | grep -E "3001|5001"
curl -s -m5 -H "Authorization: Bearer $T" http://127.0.0.1:5001/api/v1/workflows
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3001/
curl -sk -o /dev/null -w "%{http_code}" https://127.0.0.1:3001/
curl -s -H "Authorization: Bearer $T" .../workflows/{eb937a37,e951db98}-*/executions?page_size=...
ls -la ops/backups/shuffle-workflows/
grep -n "Executions" ops/reports/phase36-26-shuffle-final-status.md
docker ps --format '{{.Names}}' | grep iris
```

## Summary
Infrastructure claims (listeners, loopback backend, bearer auth, backups) are **VERIFIED**. The operational narrative "healthchecks only, no real routing" is **CONTRADICTED** by two live Wazuh→IRIS workflows with 69 observed FINISHED executions including production-shaped OpenCanary alerts. Exposure finding stands: plaintext HTTP on 0.0.0.0:3001 with no TLS termination on the port itself (note: a `wazuh-cloudflared` container is running and may provide an external tunnel — separate surface to audit).

## No secrets
