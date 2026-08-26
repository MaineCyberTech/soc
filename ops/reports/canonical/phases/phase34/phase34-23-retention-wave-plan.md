# Phase 34 Retention Wave Verification Plan

Date: 2026-08-25

## Expected deletions (ISM 14d policy)
| Index | Birthday | Expected Delete | Status |
|---|---|---|---|
| wazuh-archives-4.x-2026.08.15 | 2026-08-11 | ~2026-08-25 | PRESENT (1.8GB, hot) |
| wazuh-archives-4.x-2026.08.16 | 2026-08-12 | ~2026-08-26 | PRESENT (1.2GB) |
| wazuh-archives-4.x-2026.08.17 | 2026-08-13 | ~2026-08-27 | PRESENT (2.4GB) |
| wazuh-archives-4.x-2026.08.18 | 2026-08-14 | ~2026-08-28 | PRESENT (2GB) |

## Disk baseline
- Current: 84% (119G / 148G)
- Expected relief: ~7.4GB (08-15..18)
- Expected post-wave: ~76-78%

## Escalation
- If 08-15 not deleted by 2026-08-26: investigate ISM policy
- If disk > 85% before wave: capacity alert fires

## No secrets
