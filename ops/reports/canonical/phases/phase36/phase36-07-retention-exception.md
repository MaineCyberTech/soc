# Phase 36: Late Retention Exception Handling

Date: 2026-08-25

## Exception
- 08-15 archives should have been deleted on day 14 (2026-08-29)
- Currently day 11 and deletion has NOT started
- Root cause: ISM policy not attached

## Diagnosis

| Check | Finding |
|---|---|
| Age basis | min_index_age counts from index creation time — correct |
| Policy attachment | NOT ATTACHED — root cause |
| Template matching | wazuh-archives-p19-retention template exists but has no ISM settings |
| Action errors | N/A (no transitions executing) |
| Retries | N/A |
| Aliases | No aliases interfering |
| Protected indices | None |
| Cluster state | GREEN |

## Escalation
- **ISM policy attachment must be fixed** before wave can occur
- Prompts 06-08 will attach policy and observe
- No manual deletion without approval

## No secrets
