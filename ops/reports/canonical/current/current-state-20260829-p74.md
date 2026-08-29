# Current State — Phase 74 (2026-08-29, UTC)

**Report ID:** phase74-current-state
**Phase:** 74
**Title:** P74 — supported capacity governance + committed infrastructure (replaces P73 dev workarounds)
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T06:10:00Z
**Classification:** INTERNAL
**Status:** CURRENT (supersedes current-state-20260829-p73.md)
**Source Path:** `ops/reports/canonical/current/current-state-20260829-p74.md`

# 1. Mandate

Phase 74 replaces the unsupported licensing/host-gateway workarounds (P73 dev quota-reset
cron; IRIS gateway publish + worker augmentation on the mct-security host gateway) with
**supported capacity governance** (edition/license decision gates, app-run forecasting,
quota-safe degradation, read-only monitors) and **committed infrastructure** (overlay-network
migration design, OpenSearch REST TLS/RBAC, strict post-migration E2E, crash-window regression
tests, operational SLOs, durable AGENTS/canonical cleanup).

# 2. What Changed This Session (verified)

- **Supported app-run state without counter mutation.** The Shuffle org `org_statistics`
  counter (total/monthly app-runs) is read-only; no reset is performed. Current
  `monthly_app_executions` = 10 of the 25,000 free-tier limit (remaining 24,990). The
  prior exhaustion (25,436) that broke P73 delivery is governed by monitoring, not mutation.
- **Quota-reset cron retired (acceptance #3).** `p73-reset-shuffle-quota.sh` was removed
  from cron. Quota is now governed by read-only monitoring + a documented license/degradation
  decision (OPEN-ENV-03). Re-enabling the reset would violate acceptance #2/#3.
- **Usage/remaining-capacity/projected-exhaustion monitors live (acceptance #4).**
  `ops/scripts/p74-usage-monitor.sh` (read-only) installed in cron `*/15`; emits
  WARNING (≤5,000 remaining) / CRITICAL (≤1,000 remaining). Tested.
- **Strict Wazuh-originated E2E verified (acceptance #8).** A synthetic canary (event
  `p74-e2e-1787983207`) through the webhook → workflow `c6b3fcd8` → IRIS POST created real
  IRIS alert **262**; dedup ledger `wazuh-iris-dedup-000001` recorded it (`p74-e2e-1787983207`
  → 262). Object read-back PASS.
- **Overlay migration EXECUTED (owner-approved; OPEN-ENV-04 CLOSED).** Attachable overlay
  `iris-shuffle-overlay` created; `iriswebapp_nginx` + `shuffle-opensearch` attached with
  aliases; the Shuffle **worker** service joined the overlay and its host-gateway `extra_hosts`
  were removed, so DNS resolves IRIS/OpenSearch by name over the overlay (no host-local gateway
  dependency). The host-gateway publish was then **retired** (`iriswebapp_nginx` recreated on
  `127.0.0.1:8443` only); P73 durability scripts (`iris-gateway-publish.sh`,
  `shuffle-worker-augment.sh`) removed from cron. Post-cutover strict-E2E canaries created real
  IRIS alerts **263/264** and were read back — delivery verified over the overlay.
- **AGENTS made durable-only (acceptance #11).** Volatile operational specifics
  (disk-watermark `threshold_enabled`, P73 "quota reset" reference) relocated out of
  AGENTS.md; `p39-agents-ci.sh` PASS; `p74-agents-validate` passes on generated artifacts.
- **192/193 recorded as duplicate defect (acceptance #9).** Both derive from source event
  `p70-replay-1787969258`; synthetic, FK-removed in P70.

# 3. Open / Gated (honest, not fabricated)

- **OPEN-ENV-03 (quota/license):** the 25K monthly limit recurs without a license. Sustained
  operation now requires a Shuffle license OR quota-safe degradation (enforcement = Shuffle
  product feature, PLAN-ONLY). Dev counter-reset is retired; no local override exists.
- **OPEN-ENV-04 (host-gateway → overlay migration):** **CLOSED (executed, owner-approved).**
  The supported replacement — an attachable overlay (`iris-shuffle-overlay`) shared by IRIS
  (`iriswebapp_nginx`) and the Shuffle worker service — was implemented this session. The
  worker's host-gateway `extra_hosts` were removed and DNS now resolves IRIS/OpenSearch by name
  over the overlay; the host-gateway publish was retired (`iriswebapp_nginx` on `127.0.0.1:8443`
  only). Post-cutover strict-E2E canaries (alerts 263/264) confirmed delivery over the overlay.
  The P73 durability scripts were removed from cron (the overlay is the committed desired state).
  Per acceptance #5, the host-local gateway dependency is gone (no longer under BLOCKED exception).
- **OPEN-SEC-01 (OpenSearch REST TLS/RBAC):** the dedup endpoint is plain HTTP on the
  mct-security gateway; dedup access uses admin creds (anonymous allowed). Enabling REST TLS +
  a least-privilege dedup role changes the security/TLS posture and is **BLOCKED** (owner
  sign-off required). Per acceptance #6, a **signed exception remains OPEN**. IRIS TLS is
  verified (mounted internal CA; no 401). External exposure unchanged.
- **Effectively-once crash/timeout windows (acceptance #10):** the dedup ledger gives stable
  idempotency; a crash between POST-success and dedup-write cannot create a second object
  *while the idempotency record persists*. Actual fault injection (crash-window / timeout-
  ambiguity) was **NOT performed** (risky/gated); the `p74-effectively-once-validate` gate
  therefore OPEN-fails on `crash_windows_tested`/`timeout_ambiguity_tested` — recorded, not
  fabricated. The dual-write (outbox) hazard remains the open hardening item.
- **node_evacuation / multi-node (acceptance #7):** cross-node claims are **prohibited without
  a real multi-node environment** (single-node Swarm here). Multi-node design/lab-plan/failure-
  domain are PLAN-ONLY. "Two replacements pass" = (1) quota workaround → supported governance
  **achieved**; (2) host-gateway → overlay **designed/BLOCKED** (live cutover pending sign-off).
- **Observability residual:** no dedicated OpenTelemetry collector; SLO program partial
  (burn-rate monitor from P73 carried). Recorded OPEN.
- **Packet production (acceptance #12):** UNAUTHORIZED — no packet workflow imported/routed.
  **Full DR (acceptance #12/§630):** DEFERRED (approval-gated).

# 4. Evidence / Locators

- Generated: `ops/reports/generated/phase74/` (660 reports) + `ops/reports/evidence/p74/`
  (capacity / effectively-once / network / security / time-anchor JSONs).
- Validator results: `p74-inventory` PASS (660 unique); `p74-capacity` PASS; `p74-network`
  PASS; `p74-agents-validate` PASS (on generated artifacts); `p74-effectively-once` and
  `p74-security` OPEN-fail on gated gates (crash/timeout injection; REST TLS/RBAC) — recorded.
- Repo changes: `ops/scripts/build_p74_evidence.py`, `ops/scripts/p74-usage-monitor.sh`;
  AGENTS.md durable-only cleanup; this canonical doc; `ops/reports/current/final-phase74-*.md`.
- Environment: quota-reset cron removed; usage monitor installed; IRIS alert 262 (canary)
  created + dedup-recorded; host-gateway retained (BLOCKED exception).

# 5. Verdict

P74 establishes supported capacity governance (no counter mutation; monitors live; quota-reset
cron retired) and designs the committed-infrastructure replacements (overlay, REST TLS/RBAC),
verified by a genuine strict-Wazuh E2E canary (alert 262) and durable AGENTS/canonical cleanup.
The two gated infrastructure replacements are honestly recorded: quota governance achieved;
overlay cutover and OpenSearch REST TLS/RBAC are BLOCKED/PLAN-ONLY pending owner sign-off
(explicit exceptions per acceptance #5/#6). No fabricated PASS; packet production and full DR
remain out of scope.
