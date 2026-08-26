# Phase 26 OpenSearch Test Index Restore

Date: 2026-08-23
Status: **RESTORED (PASS)**

## Restore call

- POST `/_snapshot/wazuh-backup/snap-20260823-0017/_restore?wait_for_completion=true`
- Body: indices=[wazuh-states-inventory-protocols-wazuh], include_global_state=false,
  include_aliases=false, rename_pattern=(.+), rename_replacement=p26-restore-$1,
  ignore_unavailable=true.

## Result

- Accepted; restored index `p26-restore-wazuh-states-inventory-protocols-wazuh`
  (114 docs, 36.6KB - identical to source).

## Guardrails honored

- No live/alias/security index touched; source index NOT closed/deleted; wait_for_completion
  used; explicit indices only.

## No secrets