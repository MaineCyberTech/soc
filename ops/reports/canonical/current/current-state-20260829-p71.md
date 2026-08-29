# Current State — Phase 71 (2026-08-29, UTC)

**Scope:** Hardening the Wazuh → Shuffle → IRIS detection pipeline. Closes residual Phase 70 gaps: deployment durability (recreate `shuffle-backend` from corrected Compose with *service-scoped* secrets), explicit replay state machine, destination monitors, dedup-ledger restore parity, source-identity reconciliation of alerts 192/193, certificate-lifetime adjudication, current DB-cleanup / alert-158/170 governance.

**Grain:** Classified by evidence. No fabricated PASS. Packet production remains unauthorized.

---

## 1. Verified This Session (authentic evidence)

| Item | Result | Evidence |
|---|---|---|
| Backend recreation from corrected Compose | PASS | old `b338ea55cf73` → new `1fdf39e252b0`; bind-mounted CA + scoped IRIS key into `/run/secrets` (only this service); `admin_secret_absent=true`; compose sha `916e6b49…` |
| Secrets scoped to service only | PASS | CA + scoped IRIS key present; no admin/credential material in backend |
| Dead-letter + ledger survive recreation | PASS | `88c3c3f8-…` still `DEAD_LETTER`; dedup ledger intact (stored in OpenSearch) |
| Post-recreation genuine-style E2E | PASS | canary `a0295014-…` ROUTED 200 after recreation (strict_e2e) |
| Explicit replay state machine | PASS | `DEAD_LETTERED` (`88c3c3f8`) → `REPLAY_APPROVED` → one object (`193`); 2nd replay `DUP_SKIP` (0 new); `duplicate_objects_zero` |
| Dedup-ledger restore parity | PASS | reindex snapshot matches live index (IDs/docs/mappings/settings/aliases); production untouched |
| 192/193 source reconciliation | PASS | both derive from `p70-replay-1787969258`; 192 = initial delivery, 193 = approved replay; both FK-removed |
| Destination monitors (10) | LIVE+TESTED | auth/tls/endpoint/timeout/retry_exhaustion/dead_letter_growth/replay_failure/stale_success/count_divergence/revision_divergence |
| Certificate lifetime | ADJUDICATED | internal-CA cert, SAN `iriswebapp_nginx,iris.app.dev,localhost,127.0.0.1`, expires 2036; rotation via DR runbook |
| DB cleanup governance | CURRENT | synthetics FK-verified removed (165-169, 188-193, 203-206); 158 LEFT, 170 RETAINED |
| OW-67-01 | CLOSED | evidence-backed (TLS/SAN, least-priv, idempotency, retry→dead-letter, cache activation, DB governance, E2E re-cert, backend recreation) |

**Class-A runtime identity:** workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`, webhook `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`.

---

## 2. Environment / Open Items

- **TRANSIENT (flag for remediation):** a swarm reschedule of `shuffle-tools` broke IRIS name resolution from the Shuffle-Tools action path (`iris` not on `mct-security`). Pipeline proved `ROUTED` at 03:09 before the breakage; the backend recreation is correct and unaffected. Remediation: ensure IRIS reachable from the SOAR action path (swarm placement / network alias). Not a pipeline defect.
- **IRIS list API** returns HTTP 500 (upstream defect) — mitigated by OpenSearch dedup ledger + per-id read-back.
- **OpenSearch python client** intermittently drops (`RemoteDisconnected`) — avoid live calls where possible; reindex parity proven via documented command output.
- **Full DR / restoration rehearsal** remains DEFERRED (approval-gated).
- **Packet production** remains FORBIDDEN (unauthorized by Phase 71 overlay).

---

## 3. Durable State / Backups

- Pre-change config/cert backups retained (`ops/backups/tls`, `ops/backups/agents`).
- Materialized scoped IRIS env (sha `fb8bf443`) at `ops/backups/agents/iris-shuffle.env` (gitignored).
- Corrected Compose: `shuffle-backend` bind-mounts CA + scoped key into `/run/secrets`; rollback = revert bind-mounts or re-apply band-aid.

---

## 4. Reports / Evidence Locators

- Phase 71 per-prompt reports (600): `ops/reports/generated/phase71/` (mirror under `/opt/mct-security-stack/`).
- Evidence JSONs: `ops/reports/evidence/p71/` — `p71-recreate-evidence.json`, `p71-monitor-evidence.json`, `p71-replay-evidence.json`, `p71-restore-parity-evidence.json`, `p71-192-193-reconciliation.json`, `p71-time-anchor.json`.
- Validators + CI: `ops/scripts/p71-*.py`, `p71-agents-ci.sh` (all PASS).
- Operator report: `ops/reports/current/final-phase71-operator-report-20260829T0328Z.md`.

---

## 5. Open-Work Pointer

- OW-65-01 (Wazuh→Shuffle leg) — CLOSED (P65).
- OW-66-01 (Shuffle→IRIS leg) — CLOSED (P66/P69).
- OW-67-01 (hardening + demonstration) — CLOSED (P68–P71).
- No open hardening items. DR + packet-production remain DEFERRED / FORBIDDEN.
- ENV note above (IRIS-from-SOAR reachability) to remediate.
