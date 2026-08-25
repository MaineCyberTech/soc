# Phase 36: ISM Explain and Error Review

Date: 2026-08-25

## ISM Policies

| Policy | Description | States | Transition |
|---|---|---|---|
| wazuh-archives-14d | Archives 14d hot→delete | hot→delete | min_index_age 14d |
| wazuh-retention | 30d retention | hot→delete | min_index_age 30d |
| wazuh-states-retention | State indices retention | - | - |
| elastiflow | ElastiFlow retention | - | - |

## Policy attachment status

**CRITICAL FINDING**: `wazuh-archives-14d` policy EXISTS but is NOT attached to ANY archive index.

Evidence:
- `wazuh-archives-4.x-2026.08.15/_settings/index.plugins.ism`: `{}` (empty)
- `_index_template/wazuh-archives-p19-retention`: template exists but has no ISM settings
- `_plugins/_ism/explain`: Policy not found for indices

## Why deletion never happened
1. Policy created with correct 14d transition
2. But `ism_template` field in policy is `null` — no auto-attachment via template
3. Archive indices were created without explicit ISM policy attachment
4. No ISM policy state on any index → no transitions executed

## Error notifications
- None configured (error_notification: null in policy)

## Resolution required
- Attach `wazuh-archives-14d` to all `wazuh-archives-*` indices
- Or create ISM template to auto-attach to new indices
- Then observe transitions

## No secrets
