# Phase 53: Wazuh Integration Schema

**Prompt:** 153-wazuh-schema
**Generated (UTC):** 2026-08-27T20:08:49Z
**Operator (EDT):** 2026-08-27T16:08:49-0400
**Verdict:** DONE

## Summary
Deployed Wazuh version is 4.14.7 (manager/indexer/dashboard images). The official Shuffle integration is configured in `ossec.conf` with the canonical fields: `<name>shuffle</name>`, `<api_key>` (placeholder, not the real key), `<hook_url>` (internal `http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-...`), `<group>suricata,</group>`, `<alert_format>json</alert_format>`. Schema matches the Wazuh Shuffle integration contract.

## Evidence
- E1: `docker images` — wazuh/wazuh-manager:4.14.7, wazuh/wazuh-indexer:4.14.7, wazuh/wazuh-dashboard:4.14.7.
- E2: `multi-node-wazuh.master-1:/var/ossec/etc/ossec.conf` — integration block `name=shuffle`, hook_url `...webhook_eb937a37-5244-46dc-95ff-62ad4c681322`, group `suricata,`, alert_format json. api_key shows `SHUFFLE_API_KEY_PLACEHOLDER` (real secret not in file).
- E3: also present: virustotal integration (group syscheck) — unrelated to Class-A.

## Backup / Rollback
Config also present in `ops/shuffle-opensearch-backup-20260827-190604Z` (backup, read-only reference).

## Stop conditions (BLOCKED only)
None.

## Limitations
api_key is a placeholder in ossec.conf; live auth uses the webhook ID in the URL (no secret needed in config). Wazuh-side field schema verified; IRIS-side alert schema is per workflow (see 150).

## Verdict rationale
Version and official shuffle-integration schema fields confirmed present and well-formed. DONE.
