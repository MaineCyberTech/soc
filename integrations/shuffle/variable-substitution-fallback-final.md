# Variable Substitution Fallback (Final)

## Problem

Shuffle variable substitution is unreliable in this build (observed Phase 3-5):
`$exec.json` style references can come back empty in action titles/fields.

## Final fallback pattern (mandatory)

1. **Static alert title** - no variables:
   `MCT alert - possible incident (templating degraded)`
2. **Raw JSON payload in body/description** - the original webhook payload
   preserved verbatim (or wrapped: `{"raw_payload": "<escaped>"}`).
3. **IRIS analyst parses the payload** fields from the case note.
4. **Store original payload in case note** (truncate > 64 KB if needed).
5. **Tag the case** `shuffle-templating-degraded` for reporting.

## Rule

- NEVER drop an event because templating broke.
- If a workflow fails, the alert must still reach IRIS (manual or degraded path).

## Verification

- After any Shuffle restart: test one payload per webhook; confirm the fallback
  path works (static title + raw body).
- Track failures in SOC validation matrix as degraded-but-acceptable.

## Webhook smoke test

```bash
/opt/mct-security-stack/ops/scripts/shuffle-webhook-smoke-test.sh --dry-run
# or with a real webhook URL:
SHUFFLE_WEBHOOK_URL=http://127.0.0.1:3001/api/v1/hooks/webhook_<id> \
  /opt/mct-security-stack/ops/scripts/shuffle-webhook-smoke-test.sh
```
