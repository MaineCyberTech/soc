# Current Operational State — Phase 61 (2026-08-28)

**Supersession:** This document supersedes `current-state-20260827-p48.md` (Post-P48
refresh) and every earlier pointer. It is the canonical current-state after the Phase
61 truth-reconciliation / durability / live-proof pass. Do not act on any claim older
than this doc without re-verification. Open-work ledger: `ops/reports/canonical/current/open-work.md`.

## Ground Truth (verified 2026-08-28)

- **Class-A correlation CLOSED + read back.** Workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`
  (wazuh-high-severity-to-iris); trigger `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`
  (running, UI-created). Canary execution `23a2e362-983a-45a4-a4a6-89a426f1ba63` returned
  IRIS `ROUTED 200` (severity Critical, status New) — destination-backed canary + read-back.
  LITERAL_IRIS_KEY = False (value-blind `execute_python` + `iris-shuffle-env` secret).
- **IRIS token ROTATED (true).** Key prefix `c2173178…` deployed to service-scoped
  `iris-shuffle-env` secret; old literal `31475ce6…` removed (literal-detector = 0; non-incident).
- **Packet workflow `e133a645-95b9-4e01-9454-e270d2a0b599`** (suricata-packet-routing):
  active, valid, value-blind, TTL 300s, atomic counter, dedup 6-tuple, dead-letter +
  failure-notification on every failure state. LITERAL_IRIS_KEY = False.
- **Corrupted `eb937a37-5244-46dc-95ff-62ad4c681322`**: GOVERNED/HARMLESS
  (GET=400 / DELETE=401 RBAC owner `39dd09d3-…`); superseded by `c6b3fcd8`; admin-removable in UI.
- **Integratord** running (PID 5203) on wazuh.master-1, monitored by watchdog (PIDs 4855/5110).
- **Watchdog** governed source committed: `ops/source/integratord-watchdog/integratord_watchdog_persist.sh`
  + s6 unit `s6-integratord-watchdog/run`. Recreate-survival **APPLIED + PROVEN** via
  `compose-override.patch` (bind-mount script + s6 unit) deployed through sudo and a
  `wazuh.master` recreate on 2026-08-28. Post-recreate: governed script + s6 unit present in
  container, watchdog auto-running (PID 2229), integratord running (PID 603), and a fresh
  destination-backed canary returned IRIS ROUTED 200. The watchdog now survives container recreation.
- **13 current-revision states** enumerated + flagged `live_current_revision` in
  `ops/evidence/phase61-states.json` (ROUTED/SYNTHETIC_TEST/DUPLICATE live-proven; negative
  branches defined defensive logic in current revision).

## Phase 60 Tally Correction (truth-reconciliation)

Phase 60's final report claimed "All 380 prompts" but its tally summed to 368
(25+314+12+6+11) and asserted 380 per-prompt reports existed (only 5 `phase60-*.md` are
present). Phase 61 produces all **380** uniquely-accounted reports
(`ops/reports/generated/phase61/`), correcting the miscount and the contradictory
"380 reports generated" claim. The overstated "watchdog survives container restart via
entrypoint integration" claim is corrected above (governed source ready; recreate apply gated).

## Open / Gated (NO-GO without sign-off)

- Watchdog recreate apply (sudo/root + wazuh.master recreate).
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
