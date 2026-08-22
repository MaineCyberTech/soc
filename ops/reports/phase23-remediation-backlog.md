# Phase 23 Remediation Backlog

Date: 2026-08-22

## Endpoint (operator)
1. 014 Sysmon include-oriented tuning apply + throttle retirement.
2. 013 power confirmation (client).
3. 015 post-upgrade predicate re-check (repair --check after any agent upgrade).

## Capacity
4. PVE222 token refresh + capacity reconciliation.
5. Swapfile resize (8GB -> 4GB) only if disk > 85% (deferred, service-affecting).
6. Monitor disk trend + 14d archive deletes from ~09-05.

## Credentials
7. VirusTotal key rotation (replacement key).
8. Indexer password rotation (approval) with post-rotation validation.

## Governance
9. Brand template neutralization (12 templates + render script endpoint hardcodes).
10. STACK-OVERVIEW agent inventory full refresh.
11. Evidence banner at creation for all new reports.

## Detection
12. Zeek Class A routing enable (approval) + case-volume window.
13. Suricata severity rules when natural volume exists.
14. NetFlow scope classification -> arm new-subnet alerts.

## Infra
15. Redis 120537 VPS fix -> restore level 5.
16. Duplicate backup crons de-duplication.

## No secrets