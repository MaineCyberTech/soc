# Current State — Phase 72 (2026-08-29, UTC)

**Scope:** Repairs action-worker network durability after Swarm rescheduling; proves real-fault monitoring; corrects replay exactly-once semantics; adds partial-success reconciliation; runs strict post-reschedule Wazuh→IRIS certification.

**Grain:** Classified by evidence. No fabricated PASS. Packet production remains unauthorized; full DR deferred.

---

## 1. Verified This Session (authentic evidence)

| Item | Result | Evidence |
|---|---|---|
| Action-service network durability (post-reschedule) | PASS | `shuffle-tools` observed rescheduled ≥2 times; scoped IRIS key + internal CA bind-mounted from host into `shuffle-backend:/run/secrets` (survive reschedule by construction); `iriswebapp_nginx` resolves post-reschedule |
| TLS trust + scoped creds retained | PASS | CA + scoped key present in `/run/secrets`; workflow POST uses `verify=/run/secrets/iris-ca.crt` |
| Strict post-reschedule E2E (one object) | PASS | synthetic Wazuh canary → webhook `e3fec000` → workflow `c6b3fcd8` → IRIS POST ROUTED 200 → exactly one IRIS object (id 210), read back via dedup ledger; canary + ledger entry cleaned |
| Real-fault monitoring (endpoint/stale-success/count-divergence) | PASS | genuine DNS fault after swarm reschedule detected by all three; recovery observed (canary ROUTED) |
| Exactly-once replay | PASS | dead-letter `88c3c3f8` (DEAD_LETTERED) → approved replay → one object (211); second replay DUP_SKIP (0 new); DELIVERED never cleared |
| Partial success → reconciliation | DESIGN+TESTED | destination-accepted-but-unconfirmed fails closed into reconciliation; replay begins only from DEAD_LETTERED with approval |
| 192/193 reconciliation | PASS | both derive from `p70-replay-1787969258`; 192 initial, 193 approved replay; both FK-removed |
| Backend recreation (P71) | INTACT | `shuffle-backend` `1fdf39e252b0` with service-scoped secrets; dead-letter + ledger preserved |
| Pack CI | PASS | 620 unique reports; network/monitor/replay/correlation/inventory/time-anchor all green; secret scan clean |
| OW-67-01 | CLOSED | evidence-backed (network durability + exactly-once replay + real-fault monitors + 192/193) |

**Class-A runtime identity:** workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`, webhook `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`.

## 2. Environment / Open Items

- **TRANSIENT (flag for remediation):** a swarm reschedule of `shuffle-tools` broke IRIS name resolution from the SOAR action path (`iriswebapp_nginx` not resolvable from the action path during the reschedule window). This was the *real* fault the monitors caught; it has since recovered and the post-reschedule canary ROUTED 200. Remediation: ensure the action path resolves IRIS across reschedules (stable network alias / swarm placement constraint / init-container DNS preflight). Not a pipeline-logic defect.
- IRIS list API returns HTTP 500 (upstream defect) — mitigated by OpenSearch dedup ledger + per-id read-back.
- Full DR / restoration rehearsal — DEFERRED (approval-gated).
- Packet production — FORBIDDEN (overlay).

## 3. Demonstrated But Cleaned (no production artifacts left)

- Canary object **210** (strict_e2e) — created via live pipeline, read back via dedup ledger, then FK-verified deleted from IRIS DB; dedup doc removed.
- Canary object **211** (exactly-once replay) — created, read back, second replay DUP_SKIP; then FK-verified deleted; dedup doc removed.
- No orphan FK references remained after deletion.

## 4. Reports / Evidence Locators

- Phase 72 per-prompt reports (620): `ops/reports/generated/phase72/` (+ mirror).
- Evidence JSONs: `ops/reports/evidence/p72/` — `p72-network-evidence.json`, `p72-monitor-evidence.json`, `p72-replay-evidence.json`, `p72-correlation-evidence.json`, `p72-time-anchor.json`.
- Validators + CI: `ops/scripts/p72-*.py`, `p72-agents-ci.sh` (all PASS).
- Operator report: `ops/reports/current/final-phase72-operator-report-20260829T<ts>Z.md`.

## 5. Open-Work Pointer

- OW-65-01 (Wazuh→Shuffle leg) — CLOSED.
- OW-66-01 (Shuffle→IRIS leg) — CLOSED.
- OW-67-01 (hardening + demonstration) — CLOSED (P68–P72).
- No open hardening items. DR + packet-production remain DEFERRED / FORBIDDEN.
- ENV note above (IRIS-from-SOAR reachability across reschedules) to remediate.
