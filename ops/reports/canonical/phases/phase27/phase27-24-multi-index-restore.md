# Phase 27 Multi-Index Scratch Restore

Date: 2026-08-24
Status: **RESTORED (PASS)**

## Restore

- POST `/_snapshot/wazuh-backup/snap-20260824-0517/_restore?wait_for_completion=true`
- indices: ports, protocols, groups (explicit); include_global_state=false,
  include_aliases=false; rename -> p27-restore-*.
- Result: 3 indices restored; shards total 3, failed 0, successful 3.

## Guardrails honored

- Explicit non-security indices; aliases/global state disabled; wait_for_completion;
  no live-source change (sources remained open/green throughout).

## No secrets