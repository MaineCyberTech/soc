# Phase 56: Integratord Invocation

**Prompt:** 271-canary-integratord
**Generated (UTC):** 2026-08-27T23:29:49Z
**Operator (EDT):** 2026-08-27T19:29:49-0400
**Verdict:** BLOCKED

## Summary
Read-only inspection of the integratord invocation (script/hook) that would fire for the canary. No live invocation performed.

## Evidence
### Wazuh integratord (read-only)
- EV-INT-11 (VERIFIED): integratord config block (ossec.conf lines ~343-350): `<name>shuffle</name>`, `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url>`, `<group>suricata,</group>`, `<alert_format>json</alert_format>`. api_key entry present as placeholder (value not printed).
- EV-INT-12 (VERIFIED): integratord daemon running on manager + worker (265) — invocation daemon healthy.
- EV-INT-13 (PARTIAL): hook target `webhook_eb937a37` is NOT a live Shuffle trigger (live Class-A trigger id is `24636c49…`, 265). The hook would POST to a non-existent trigger → invocation would not deliver. This is the pre-existing mis-wire, not a daemon-health failure.

### REST / Webhook (read-only — NO GET on webhook URL)
- EV-WBH-08 (VERIFIED): only `suricata-eve-in` (`736b7410…`) live; `webhook_eb937a37` absent.

### Sensor-origin (read-only)
- EV-SNR-10 (VERIFIED): invocation triggered by suricata-group alert from agent 016 (269/270).

## Backup-Rollback
No mutation (read-only). N/A. If integratord config later edited: gate rule §4 (apply owner-gated) + workflow-edit gate.

## Stop conditions
Canary EXECUTION (266-288) requires signed Class-A approval + Class-A certified; integratord invocation is canary work → BLOCKED. Trigger-id mismatch must be reconciled first. Marked BLOCKED — legitimate gate.

## Limitations
No invocation executed; hook config + daemon state verified read-only. Mis-wire observed, not remediated.

## Verdict rationale
Integratord invocation is canary-execution, gated by unsigned Class-A + broken wiring; read-only inspection only. Verdict BLOCKED.
