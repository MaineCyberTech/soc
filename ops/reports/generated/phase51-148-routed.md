# Phase 51: Routed

**Prompt:** 148-routed
**Generated:** 2026-08-27T16:45:00Z (UTC) / 2026-08-27T12:45:00-04:00 (EDT)
**Timezone:** UTC authoritative; America/New_York (EDT -0400)
**Verdict:** PARTIAL — AUTH_FAILED (IRIS no token; REST HTTP success only, object ID unproven)

## Task
Success+object.

## Evidence (live, this session)
- [rest_exec] POST /api/v1/workflows/{id}/execute with synthetic EVE JSON -> success:true (exec e9eda235-... and dda85ccb-...). execute_python logic runs via native REST. NOT webhook proof.
- [wf_id] e133a645-95b9-4e01-9454-e270d2a0b599
- [hook_wazuh] webhook_eb937a37-5244-46dc-95ff-62ad4c681322 (Wazuh Class-A): GET -> success:true, execution_id 421698e3-... -> LIVE, source=webhook, PERSISTENT, triggers wazuh-high-severity-to-iris. Proven functional.
- [iris_secret] Only DFIR_IRIS_* app secrets in .env; [REDACTED-IRIS-TOKEN] placeholder; no real token (value-blind).
- [hook_packet] 736b7410-ed6a-52af-b369-89dbef6386cb (packet-routing): GET -> 'Hook ID not valid' -> BROKEN, not registered/valid. Matches P50 stopped + 'missing params'.

## Action Performed
Attempted ROUTED proof: REST execution returns success:true but IRIS object ID cannot be proven — no IRIS API token (AUTH_FAILED). HTTP-success + object-ID gate NOT met. ROUTED remains partial until IRIS auth resolved.

## Backup / Rollback
- Workflow/hook/policy state documented; all gated changes reversible and unexecuted.
- No production state mutated for gated items.

## Stop Conditions
- Secret disclosure, unapproved retry, forced ISM deletion, production routing, field-limit increase, weakened TLS/exposure, destructive volume removal, fabricated PASS.

## Impact
- Safe reversible work completed; gated items isolated with exact blocker packages.

---
*Phase 51 — evidence-backed; secrets never exposed; no fabricated PASS.*
