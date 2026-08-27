# Phase 55: Integration Schema

**Prompt:** 177-integration-schema
**Generated (UTC):** 2026-08-27T23:08:14Z
**Operator (EDT):** 2026-08-27T19:08:14-0400
**Verdict:** DONE

## Summary
Confirm the Wazuh->Shuffle integration uses native integration fields (no custom/invalid
schema). Inspected the `shuffle` integration block in `/var/ossec/etc/ossec.conf` (read-only;
secret-bearing lines redacted).

## Evidence
- E1 (VERIFIED) — native Wazuh integration block present: `<integration>` ... `<name>shuffle</name>` ... `<hook_url>` (present, not printed) ... `<group>suricata,</group>` ... `<alert_format>json</alert_format>` ... `</integration>`. These are standard native Wazuh integration fields (`name`, `hook_url`, `group`, `alert_format`).
- E2 (VERIFIED) — `<api_key>` is present but REDACTED (referenced by path `/var/ossec/etc/ossec.conf` only); no custom/non-native field names appear in the schema.
- E3 (VERIFIED) — a separate native `virustotal` integration block (`name=virustotal`, `group=syscheck`, `alert_format=json`) also uses only native fields, confirming the schema is stock Wazuh.

## Backup / Rollback
Read-only; N/A.

## Stop conditions
None for inspection.

## Limitations
`hook_url` value not printed (contains the webhook routing endpoint which may embed an API key query param); presence asserted only. No secret values exposed.

## Verdict rationale
Integration schema is native Wazuh (no custom/invalid fields); secret field redacted. Verdict DONE.
