# Phase 34 Change Register

Date: 2026-08-25

| ID | Change | Risk | Approval | Rollback |
|---|---|---|---|---|
| CR-34-01 | Wire drops/memcap/resource/ruleset-age/config-drift/wazuh-ingest alerts | Low | Pre-approved (P33 design) | Remove cron entries |
| CR-34-02 | Canary SID 2027967 E2E proof (synthetic pcap) | Low | Synthetic only, no real payload | Disable canary route |
| CR-34-03 | Agent 016 eve.json forwarding (if approved) | Medium | Requires approval | Revert ossec.conf |
| CR-34-04 | Python bytecode temp policy (PYTHONDONTWRITEBYTECODE) | Low | MCT scripts only | Revert env |
| CR-34-05 | OpenCode scratch policy (bounded root) | Low | Operator only | Remove config |
| CR-34-06 | /tmp scheduled cleanup observation | Low | Pre-approved | Remove cron |
| CR-34-07 | Endpoint throttle retirement (if cert PASS) | Medium | Requires marker evidence | Re-enable throttle |
| CR-34-08 | Shuffle native controls (if UI available) | Low | Guardrail operational | Disable workflow |
| CR-34-09 | Trend dashboard implementation | Low | Read-only queries | Remove dashboard |

## Out of scope (unchanged)
- PVE access
- RAM expansion
- Production routing approval (deferred)

## No secrets

## Changes applied
- CR-34-03: Agent 016 eve.json forwarding ADDED to ossec.conf (approved)
  - Backup: /var/ossec/etc/ossec.conf.bak-p34
  - Added: `<localfile><log_format>json</log_format><location>/var/log/suricata/eve.json</location></localfile>`
  - Removed duplicate eve.json entry
  - Agent restarted, active, forwarding confirmed
