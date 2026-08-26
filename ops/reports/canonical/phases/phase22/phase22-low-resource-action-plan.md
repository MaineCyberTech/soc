# Phase 22 Low-Resource Action Plan

Date: 2026-08-22

## Priority actions

1. **Root disk 86% (HIGH)** - review space:
   - Verify 14d archives ISM deletes fire from ~09-05 (first 14d-old index).
   - Remove stale backups > 30d in /opt/wazuh-backups (snap rotation already 7d/30d - verify).
   - Review docker image/prune space (docker system prune -f --filter until=168h, dry-run first).
   - Target: < 80% within 30 days.
2. **Swap 64% (MED)** - reduce pressure:
   - Lower shuffle-opensearch heap (1.33GB of 1.5GB cap) if stable after 7d monitoring.
   - Verify indexer heap tuning (P17) intact; consider per-node -Xms/-Xmx cap.
3. **014 Sysmon tuning** (HIGH) - stops agent-side flood + throttle churn (the biggest single lever).
4. **macOS 015 repair** (HIGH) - prevents flood return on reconnect.
5. **pve222 API token** (MED) - restore capacity visibility.
6. **De-duplicate backup crons** (LOW) - remove duplicate snapshot/config-backup entries.

## Watch items

- Disk daily delta after noise fixes (expect < 500MB/day).
- Swap trend after any heap change (re-measure 48h).
- ElastiFlow rollover behavior at 20GB (currently 2.4GB, fine).

## No secrets