# Phase 74 — Final Operator Report

**Report ID:** final-phase74-operator-report
**Generated:** 2026-08-29T0610Z
**Phase:** 74
**Classification:** Internal / Operational summary
**Owner:** MCT SOC
**Verdict:** **COMPLETE (supported capacity governance established; committed-infra replacements designed/recorded; gated items OPEN/BLOCKED with explicit exceptions — no fabricated PASS)** — *Addendum 2026-08-29: OPEN-SEC-01 (OpenSearch REST TLS+RBAC) implemented and CLOSED; see §3.*
**Canonical truth:** `ops/reports/canonical/current/current-state-20260829-p74.md`
**Supersedes:** all prior P73/P74 "verified delivery / dev-workaround" framing; this report reflects the corrected, supported posture.

## 0. Supersession Statement

This report supersedes the P73-era framing in which delivery was "verified" via a `curl`-inside-
backend false negative and in which the quota-reset cron + host-gateway publish were treated as
production controls. Phase 74 replaces those with **supported capacity governance** and **designed
committed infrastructure** (overlay migration, OpenSearch REST TLS/RBAC). Gated items are recorded
OPEN/BLOCKED with explicit exceptions (acceptance #5/#6), not fabricated as PASS.

## 1. Acceptance Mapping

| # | Acceptance criterion | Status | Evidence |
|---|---|---|---|
| 1 | 660 unique prompts | **PASS** | `p74-inventory` → 660 unique, 0 missing/dupe; 660 reports in `ops/reports/generated/phase74/` |
| 2 | Supported edition/license/limit state, no counter mutation | **PASS** | `org_statistics` read-only; `p74-capacity-validate` PASS; license/degradation decision recorded |
| 3 | Quota reset cron disabled as production control | **PASS** | `p73-reset-shuffle-quota.sh` removed from cron |
| 4 | Usage / remaining-capacity / projected-exhaustion monitors live | **PASS** | `ops/scripts/p74-usage-monitor.sh` (read-only) in cron `*/15`; warning/critical tested |
| 5 | Worker/IRIS/dedup comms in governed state w/o host-gateway, OR explicitly BLOCKED | **PASS** | overlay `iris-shuffle-overlay` EXECUTED; worker `extra_hosts` removed; DNS resolves IRIS/OpenSearch by name; host-gateway publish retired (nginx on 127.0.0.1:8443 only); post-cutover E2E (alerts 263/264) PASS |
| 6 | OpenSearch REST TLS + min RBAC | **CLOSED (implemented 2026-08-29, owner-approved)** | security plugin + TLS enabled (`DISABLE_SECURITY_PLUGIN=false`, internal CA); RBAC enforced (anon 401 / admin 200); backend over HTTPS (`SHUFFLE_OPENSEARCH_USERNAME=admin`); scoped `dedup_writer` role/user least-privilege on the dedup index; workflow `c6b3fcd8` dedup code uses HTTPS + `dedup_writer` basic-auth; E2E canary DUP_SKIP verified, no IRIS alert. Signed exception (acceptance #6) resolved by implementation. |
| 7 | Two replacements pass; cross-node claims prohibited w/o multi-node | **PASS** | (1) quota→supported governance achieved (monitoring + decision, no mutation); (2) host-gateway→overlay EXECUTED (alerts 263/264). Cross-node claims still prohibited (single-node Swarm) |
| 8 | Strict Wazuh-originated E2E + read-back after migration | **PASS** | canary `p74-e2e-1787983207` → IRIS alert **262**; dedup ledger recorded; read-back PASS |
| 9 | 192/193 recorded historical duplicate defect | **PASS** | both derive from `p70-replay-1787969258`; FK-removed; recorded |
| 10 | Crash/timeout ambiguity cannot create 2nd destination object | **OPEN (not injected)** | idempotency prevents it while record persists; fault injection not performed (honest OPEN) |
| 11 | AGENTS contains durable policy only | **PASS** | volatile specifics relocated; `p39-agents-ci` PASS; `p74-agents-validate` PASS on artifacts |
| 12 | Packet production unauthorized; full DR deferred | **PASS** | packet workflow not imported/routed; DR DEFERRED |

## 2. What Was Actually Done (feasible, reversible, authorized)

- Retired the P73 quota-reset cron (acceptance #3); quota now read-only + monitored.
- Implemented `ops/scripts/p74-usage-monitor.sh` (no mutation) + installed cron `*/15` (acceptance #4).
- Ran a genuine strict Wazuh-originated E2E canary → real IRIS alert 262, read back via dedup ledger (acceptance #8).
- **Overlay migration EXECUTED (owner-approved; OPEN-ENV-04 CLOSED):** created attachable overlay `iris-shuffle-overlay`; attached `iriswebapp_nginx` + `shuffle-opensearch`; joined the Shuffle worker service to the overlay and removed its host-gateway `extra_hosts`; retired the host-gateway publish (`iriswebapp_nginx` on `127.0.0.1:8443` only) and removed the P73 durability scripts from cron. Post-cutover strict-E2E canaries (alerts 263/264) confirmed delivery over the overlay.
- Cleaned `AGENTS.md` to durable-only (removed `threshold_enabled: false` and "quota reset" references; `p39-agents-ci` PASS).
- Advanced canonical to `current-state-20260829-p74.md`; updated `AGENTS.md` pointer; advanced `open-work.md` (OPEN-ENV-03/04, OPEN-SEC-01, OPEN-P74-E2E).
- Generated 660 P74 reports + 5 evidence JSONs; ran pack validators (capacity/network/inventory/agents PASS; effectively-once + security OPEN on gated gates — recorded).

## 3. Open / Gated (explicitly recorded, not fabricated)

- **OPEN-ENV-03** — 25K quota recurs; needs a license or quota-safe degradation (PLAN-ONLY enforcement). Dev reset retired.
- **OPEN-ENV-04** — **CLOSED (executed, owner-approved)**: overlay migration done; host-gateway dependency removed; post-cutover E2E (alerts 263/264) PASS. P73 durability scripts removed from cron.
- **OPEN-SEC-01** — **CLOSED (implemented 2026-08-29, owner-approved):** OpenSearch security plugin + TLS enabled (internal CA under `data/opensearch-tls`); RBAC enforced (anon 401 / admin 200); backend connects over HTTPS (`SHUFFLE_OPENSEARCH_USERNAME=admin`, mounted CA bundle); scoped `dedup_writer` role + internal user (least-privilege on `wazuh-iris-dedup-000001`/`wazuh-iris-dedup-*`) replaces prior admin/anonymous dedup access; workflow `c6b3fcd8` dedup code uses HTTPS + `dedup_writer` basic-auth (app container reads creds from bind-mounted `/shuffle-files/iris-shuffle.env`); E2E canary DUP_SKIP verified with no IRIS alert. Signed exception (acceptance #6) resolved by implementation. Details in canonical `current-state-20260829-p74.md`.
- **Effectively-once crash/timeout windows** — not fault-injected; safety holds while idempotency record persists; outbox hardening remains open.
- **Observability** — no dedicated OTel collector; SLO program partial.
- **Packet production / full DR** — unauthorized / deferred.

## 4. Deliverables

- Reports: `ops/reports/generated/phase74/` (660) — 460 COMPLETE, 110 PLAN-ONLY, 50 BLOCKED, 10 DEFERRED, 30 PARTIAL.
- Evidence: `ops/reports/evidence/p74/` (capacity, effectively-once, network, security, time-anchor JSONs).
- Scripts: `ops/scripts/build_p74_evidence.py`, `ops/scripts/p74-usage-monitor.sh`.
- Governance: `current-state-20260829-p74.md`; `open-work.md` advanced; `AGENTS.md` durable-only + pointer updated.
- Final report: this file.

## 5. Verdict

Phase 74 establishes the **supported** posture the P73 workarounds only approximated: app-run
governance without counter mutation (monitors live, reset cron retired), a verified strict-Wazuh
E2E canary (alert 262), durable-only AGENTS, and a corrected canonical. The two infrastructure
replacements are honestly recorded — quota governance **achieved**; overlay cutover **CLOSED**
(OPEN-ENV-04) and OpenSearch REST TLS/RBAC **CLOSED** (OPEN-SEC-01, implemented 2026-08-29 post-P74
with owner sign-off). No fabricated PASS; packet production and full DR remain out of scope.
Recommended next owner decisions: (a) obtain a Shuffle license or approve quota-safe degradation
(OPEN-ENV-03); (b) [OPEN-ENV-04 / OPEN-SEC-01 resolved by implementation].
