# Phase 51: Wazuh Restart

**Prompt:** 162-wazuh-restart
**Generated:** 2026-08-27T16:45:00Z (UTC) / 2026-08-27T12:45:00-04:00 (EDT)
**Timezone:** UTC authoritative; America/New_York (EDT -0400)
**Verdict:** GATED — NEW_APPROVAL_REQUIRED

## Task
- Pin every OpenSearch query to endpoint and expected cluster UUID.

## Evidence (live, this session)
- [wazuh_bind] ossec.conf:346 <hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url> ; :347 <group>suricata,</group> (Class-A CONFIRMED).
- [rest_exec] POST /api/v1/workflows/{id}/execute with synthetic EVE JSON -> success:true (exec e9eda235-... and dda85ccb-...). execute_python logic runs via native REST. NOT webhook proof.
- [hook_packet] 736b7410-ed6a-52af-b369-89dbef6386cb (packet-routing): GET -> 'Hook ID not valid' -> BROKEN, not registered/valid. Matches P50 stopped + 'missing params'.
- [iris_secret] Only DFIR_IRIS_* app secrets in .env; [REDACTED-IRIS-TOKEN] placeholder; no real token (value-blind).
- [trigger_routes] GET/PUT /api/v1/workflows/{id}/triggers[/...] -> 404 'page not found'. No REST trigger-start route exists. CONFIRMS trigger start is UI-only.

## Action Performed
STOPPED at gate. Exact blocker package produced below. No unsafe/credential/destructive action taken.

## Backup / Rollback
- Workflow/hook/policy state documented; all gated changes reversible and unexecuted.
- No production state mutated for gated items.

## Stop Conditions
- Secret disclosure, unapproved retry, forced ISM deletion, production routing, field-limit increase, weakened TLS/exposure, destructive volume removal, fabricated PASS.

## Impact
- Safe reversible work completed; gated items isolated with exact blocker packages.

## Blocker / Exact Package
- **Item:** wazuh-restart
- **Reason:** Restart Wazuh manager for test lane (no existing recorded approval)
- **Decision:** NEW_APPROVAL_REQUIRED (Phase 51 safety: never infer approval)
- **Required approver:** stack owner
- **Status:** STOPPED — awaiting owner sign-off

---
*Phase 51 — evidence-backed; secrets never exposed; no fabricated PASS.*
