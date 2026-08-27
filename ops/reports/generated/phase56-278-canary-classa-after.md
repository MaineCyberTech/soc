# Phase 56: Class-A Regression

**Prompt:** 278-canary-classa-after
**Generated (UTC):** 2026-08-27T23:29:49Z
**Operator (EDT):** 2026-08-27T19:29:49-0400
**Verdict:** BLOCKED

## Summary
Read-only "after" regression inspection for the Class-A Wazuh→IRIS lane. A regression test requires a canary run (gated); additionally the Class-A path is currently MIS-WIRED, so even post-canary regression cannot be assessed now.

## Evidence
### Wazuh integratord (read-only)
- EV-INT-20 (VERIFIED): integratord posts suricata-group alerts to `webhook_eb937a37` (271); this hook is NOT a live Shuffle trigger (live Class-A trigger id `24636c49…`, 272). Class-A path broken pre-canary.
- EV-INT-21 (VERIFIED): integratord daemon running on manager+worker (265) — daemon itself healthy; defect is trigger-id wiring, not daemon.

### REST / Webhook (read-only — NO GET on webhook URL)
- EV-WBH-18 (VERIFIED): `wazuh-high-severity-to-iris` (`eb937a37…`) workflow status `test`, embedded trigger `24636c49…` running — but no receiving webhook `webhook_eb937a37`. Regression baseline cannot be established.

### Sensor-origin (read-only)
- EV-SNR-17 (VERIFIED): Class-A lane input = sensor agent 016 suricata alert (270).

## Backup-Rollback
No mutation (read-only). N/A. Class-A repair/reload/recreate/rollback (047-048, 057-061) is owner/Class-A-certified gated — read-only certification only.

## Stop conditions
Canary EXECUTION (266-288) requires signed Class-A approval + Class-A directly certified. Class-A repair (047-048/057-061) beyond read-only certification is owner-gated. The trigger-id mismatch must be reconciled before any regression test. Marked BLOCKED — legitimate gate + pre-condition defect.

## Limitations
No regression run; Class-A path mis-wire observed read-only. "After" state not measurable without signed execution + reconciliation.

## Verdict rationale
Class-A regression test is canary-execution, gated; path also mis-wired. Read-only inspection only. Verdict BLOCKED.
