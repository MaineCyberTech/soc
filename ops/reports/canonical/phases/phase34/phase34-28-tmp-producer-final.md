# Phase 34 /tmp Producer Final Analysis

Date: 2026-08-25

## Producers
| Producer | Evidence | Recurrence |
|---|---|---|
| Python bytecode (__pycache__) | pyc trees from p30-pyc, mct-p28-pyc | yes (CI runs) |
| OpenCode scratch | opencode temp files | yes (active sessions) |
| JVM temp | java temp trees | yes (services) |
| Docker/container | overlay2 temp | yes (containers) |

## Attribution
- Bulk: small files (pyc caches, JVM temp) spread across many PIDs
- Not a single-producer problem
- Control: bounded paths + scheduled cleanup

## No secrets
