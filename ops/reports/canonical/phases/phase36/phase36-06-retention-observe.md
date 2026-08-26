# Phase 36: Retention Transition Observation

Date: 2026-08-25

## Before observation

| Index | Docs | Size | Status |
|---|---|---|---|
| 08-15 | 3,007,251 | 1.8GB | Present (11 days old) |
| 08-16 | 2,150,542 | 1.2GB | Present (10 days old) |
| 08-17 | 2,633,464 | 2.4GB | Present (9 days old) |
| 08-18 | 2,397,160 | 2.0GB | Present (8 days old) |

## ISM state
- Policy `wazuh-archives-14d`: NOT ATTACHED to any index
- No transitions executing
- No deletions occurring

## Observation
- No ISM transitions observed
- No indices deleted
- Disk remains at 85%
- Expected wave NOT occurring

## Root cause
- Policy exists but was never attached to indices
- Template has no ISM configuration

## No forced deletion
- No manual index deletion performed
- No watermark manipulation

## No secrets
