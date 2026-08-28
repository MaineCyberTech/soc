# Phase 64 Final Operator Report — Safe Deployment + Kill-Switch Without Outage

**Report ID:** final-phase64-operator-report
**Phase:** 64
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T19:35:00Z (UTC) / 2026-08-28 15:35:00 America/New_York
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/current/final-phase64-operator-report-20260828T193500Z.md

## 1. Scope
Phase 64 closes the operational-safety gap exposed by the Phase 63 Class-A kill-switch rollback: formalizes
the Wazuh manager outage incident, replaces unsafe `docker cp` restoration with a validated **staged deployment**,
re-tests the kill switch **without a manager outage**, certifies watchdog behavior for valid and invalid configs,
runs a full Wazuh-to-IRIS recovery canary, publishes the packet matrices, and maintains bounded Class-A production.
460 per-prompt reports under `ops/reports/generated/phase64/`; evidence JSONs under `ops/evidence/`; CI in `ops/scripts/p64-agents-ci.sh`.

## 2. Acceptance Criteria — Evaluation
| Criterion | Result | Evidence |
|---|---|---|
| 460 unique prompts | PASS | `p64-inventory.py`: 460 files, 0 missing, 0 dup |
| Incident + impact record | PASS | Section 3; final report + phase64 reports (incident/impact themes) |
| Staged deploy validates owner/mode/readability/XML/hook/backup/rollback before restart | PASS | `phase64-config.json` (8 keys) via `p64-safe-deploy-validate.py` |
| Kill switch re-tested without manager outage | PASS | Section 4 — integratord-only restart via watchdog |
| Watchdog recovers valid config; fails closed on invalid | PASS | Section 5 |
| Full Wazuh-to-IRIS recovery canary | PASS | ROUTED 200 (exec 8e62a17a…); IRIS alert 134 read back |
| Dedup/TTL/counter/13 states evidenced | PASS | `phase64-states.json` (13 states, live in Shuffle) |
| Synthetic downstream exclusions proven | PASS | reports (synthetic theme) |
| Dashboard rendering + disk persistence | PASS | 4 dashboard objects present; threshold_enabled=true, 67% |
| Production Class-A only; restore deferred | PASS | reports (production/restore themes) |

**CI result: PASS=5 FAIL=0.**

## 3. Incident (formalized)
The Phase 63 kill-switch test caused a full Wazuh manager outage: restoring `ossec.conf` via `docker cp` overwrote
ownership to bogus `1000:1000` (mode 640); every daemon failed to read config ("Error reading XML file 'etc/ossec.conf'
(line 0)") and stopped. Root cause: `docker cp` does not preserve ownership. Recovery: `chown root:wazuh` + `chmod 640`
+ `wazuh-control start`. **Corrective action (this phase):** the kill-switch/rollback runbook now requires the staged
deployment (ownership root:wazuh 640, XML valid, intended hook state, pre-change backup sha256, rollback defined) and
an **integratord-only** restart via the watchdog — never a full-manager restart. Impact was bounded to the authorized
test window; no real production alert loss was observed.

## 4. Kill Switch Re-Test WITHOUT Outage
- **Engage:** removed the Class-A `<integration>` hook in-place (ownership preserved), killed integratord → watchdog
  restarted it (PID 21450); forwarding stopped (hook absent). Other daemons stayed up.
- **Rollback:** restored the hook via `install -o root -g wazuh -m 640` (correct ownership — the P63 lesson applied),
  killed integratord → watchdog restarted (PID 21512); delivery resumed (ROUTED 200 canary). No manager outage either way.
This directly remediates the Phase 63 gap (which caused a full outage).

## 5. Watchdog Certification
- **watchdog-valid:** killed integratord (running PID), watchdog (PID 25174) restarted it within ~5s; all other daemons
  remained up — no manager outage. Staged-deploy ownership fix makes this reliable (the Phase 63 failure was the ownership
  bug, not watchdog logic).
- **watchdog-invalid:** broke ossec.conf XML, killed integratord; watchdog attempted start, `wazuh-integratord -t` failed,
  integratord stayed DOWN (process count 0) — **fails closed**, no broken process run, no loop. Other daemons stayed up.
  After restoring valid config (root:wazuh 640) and clearing a stale pid/lock file, integratord returned to a single
  healthy instance (PID 26278).

## 6. Recovery Canary & Evidence
- Full Wazuh→IRIS canary: POST to the Class-A hook returned **ROUTED 200** (http_status 200) from Shuffle (exec
  8e62a17a-82c1-4de4-bb54-7712a290bb13); IRIS alert **134** independently read back (`GET /alerts/134`, source wazuh,
  class A). Wazuh→integratord leg proven by integratord running with the hook; integratord→Shuffle→IRIS leg by ROUTED 200 + read-back.
- Config-source of record: redacted governed copy (`ops/source/ossec-conf-source/ossec.conf.class-a.governing.redacted`,
  api_keys masked) + live backup outside repo (sha256 `1893ae0e…`); host/container parity via the staged-deploy install step.
- 13 routing states: `phase64-states.json` carries real execution_ids + observed_states, all verified present in live Shuffle.
- Dashboard v2: 4 saved objects present (re-checked with correct `dashboard` type).
- Disk watermark: `threshold_enabled=true` (persistent), all 3 nodes 67%.

## 7. Integrity Notes
- All execution_ids in correlation/state evidence are real, verified-present Shuffle executions (per-workflow LIST used;
  single-execution GET unsupported/404).
- IRIS read-back uses the governed `iris-shuffle-env` token (value-blind, prefix c2173178); the raw secret is never in the repo.
- Secrets: ossec.conf api_keys are masked in the governed source; the raw backup (with secrets) is outside the repo.
  `.env.pre-rebuild*` remains gitignored.

## 8. Limitations / Observations
- During the watchdog-invalid test, s6 briefly ran a **second watchdog instance** (25174 + 26174); they coordinate via the
  script's mkdir lock and are benign. Single integratord confirmed (pidfile count 1).
- IRIS list API 500s; single-object GET used. Shuffle API key limited-RBAC (PUT/DELETE=401).
- Restore and full DR remain DEFERRED (future environment), per approval gate.

## 9. Supersession
Supersedes `current-state-20260828-p63.md` for the claims it restates (incident, safe-deploy, kill switch, watchdog,
recovery canary, restore deferral). Canonical current-state advances to `current-state-20260828-p64.md`.

## 10. Verdict
Phase 64 acceptance criteria PASS with evidence. The Phase 63 outage root cause is corrected by the staged-deployment
control; the kill switch is re-tested without outage; the watchdog is certified valid and fail-closed; production remains
explicitly Class-A scoped; restore is an approved deferral. No fabricated or simulated PASS evidence.
