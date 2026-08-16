# Shuffle Workflow Fallback Pattern (Static Titles + Raw Payload Body)

## Problem

Shuffle variable substitution is unreliable in this build: `$exec.json` style
references in action titles/fields may come back empty, causing alerts to land
with missing context or, worse, workflows to fail before routing.

## Rule

**Never drop an event because templating is broken.** If the workflow cannot
produce a fully substituted title, it must still fire with a static title and
the raw payload preserved.

## Fallback pattern

1. **Static alert title** - no variables:
   ```
   Title: "MCT Wazuh alert - possible incident (templating degraded)"
   ```
2. **Raw JSON payload in alert description/body**:
   - Use the webhook body field of the action; put the original JSON event
     payload there (raw, unparsed).
   - If the platform mangles it, use a wrapper field
     `{"raw_payload": "<original event as string>"}`.
3. **IRIS analyst parses payload fields** - the case note will contain the raw
   JSON; the analyst extracts `rule.id`, `agent.name`, `data`, `location`, etc.
4. **Store original payload in the case note**:
   - IRIS case description or note = the raw payload string (truncate to a safe
     size, e.g. 64 KB, but keep enough for triage).
5. **Tag the case** with `shuffle-templating-degraded` so reporting can track
   templating failures separately from real alerts.

## Example (Shuffle -> IRIS webhook)

```json
{
  "case_name": "MCT alert (raw mode)",
  "case_description": "{\"rule.id\":\"121000\",\"agent.name\":\"canary01\",\"raw\":\"<escaped event JSON>\"}",
  "case_severity_id": 3,
  "tags": ["shuffle-templating-degraded", "wazuh"]
}
```

## Verification

- After every Shuffle/backend restart, run a test workflow once with a known
  payload and confirm the fallback title/body path works even when variables
  fail.
- Track templating failures in the SOC validation matrix as a degraded-but-acceptable path.
