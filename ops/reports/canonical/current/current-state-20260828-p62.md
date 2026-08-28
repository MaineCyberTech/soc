# Current Operational State — Phase 62 (2026-08-28)

**Supersession:** This document supersedes `current-state-20260828-p61.md` (Phase 61
reconciliation) and every earlier pointer. It is the canonical current-state after the
Phase 62 evidence-linking pass: Phase 61 declarative claims are now backed by directly
linked, independently verifiable operational evidence. Do not act on any claim older than
this doc without re-verification. Open-work ledger: `ops/reports/canonical/current/open-work.md`.

## Ground Truth (verified 2026-08-28, directly evidenced)

- **Class-A correlation, independently read back.** Workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`
  (wazuh-high-severity-to-iris); trigger `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`.
  Canary executions `31ebd3f4-7a72-4137-8f9e-2f4e367c6afd` (this session), `23a2e362…`, `d5d8eb26…`
  returned IRIS `ROUTED 200` (severity Critical, status New).
  **Independent IRIS read-back:** `GET /alerts/74` (and 75–78) with the governed `iris-shuffle-env`
  token returned `status success, severity Critical, status New` — a direct API read, not the
  workflow response. IRIS list API is 500 (Shuffle datastore quirk); single-object GET works.
- **IRIS token ROTATED (true), value-blind.** Key prefix `c2173178…` in service-scoped
  `iris-shuffle-env` secret. Old literal `31475ce6…` removed (literal-detector = 0). Independent
  read-back consumed the governed secret in-memory only (never committed).
- **Packet workflow `e133a645-95b9-4e01-9454-e270d2a0b599`** (suricata-packet-routing): active,
  valid, value-blind. Authentic execution `66941acc-…` -> `ROUTED`, `destination_object_id 74`,
  `counter 5`. TTL 300s, atomic counter, dedup 6-tuple, dead-letter + failure-notification on
  every failure state. LITERAL_IRIS_KEY = False.
- **Corrupted `eb937a37-5244-46dc-95ff-62ad4c681322`**: GOVERNED/HARMLESS (GET=400 / DELETE=401
  RBAC owner `39dd09d3-…`); superseded by `c6b3fcd8`; admin-removable in UI.
- **Integratord** running (PID 603) on wazuh.master-1, monitored by the governed watchdog (PID 2229).
- **Watchdog — applied vs prepared RESOLVED.** Governed source + s6 unit deployed via sudo in
  Phase 61; wazuh.master recreated. Post-recreate: script + s6 unit present, watchdog auto-running
  (PID 2229), integratord running (PID 603); fresh canary -> IRIS ROUTED 200. Survives recreation
  (directly evidenced, not a claim).
- **13 current-revision states** enumerated in `ops/evidence/phase62-states.json`; each carries a
  REAL, verified-present Shuffle `execution_id` (authenticity CI). ROUTED live-demonstrated
  (exec `66941acc` -> alert 74, independently read back). Negative branches are defensive logic in
  the same current revision (code-reviewed, not fabricated).

## Phase 61 → 62 delta (evidence linkage)

Phase 61 stated claims; Phase 62 converts them to direct evidence:
- Watchdog "prepared/gated" -> APPLIED + recreate-proven (PID 2229 auto-start).
- Class-A read-back -> INDEPENDENT IRIS `GET /alerts/74` success.
- 13 states -> each tied to a real Shuffle execution_id (157 scanned, all present).
- CI -> now validates evidence authenticity (execution_ids exist in live Shuffle).

## Open / Gated (NO-GO without sign-off)

- IRIS owner `39dd09d3` removal of corrupted `eb937a37` (admin UI).
- Full-system restore rehearsal (approved external target).
- Production routing canary/apply (signed evidence gates).
- Dashboard v2 activation (signed off, not activated).
- Disk-watermark decision (enforcement disabled, R-DISKBYPASS, owner OW-42-01).

## Durable Posture (unchanged)

- Shuffle TLS :3443; webhook POSTs unauthenticated by design (api_key placeholder).
- Secrets reference-by-path only; never committed.
- Fail-closed on malformed/unknown/datastore-failure.
- Synthetic/test IRIS objects isolated (source:suricata,class:A,test:true) from
  billing/scorecard/queue/client/counter/notification.
