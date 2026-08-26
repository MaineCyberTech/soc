# Phase 35: External Guardrail Failover

Date: 2026-08-25

## Current state
- `p33-core-alert.sh` cron: runs every 15min via crontab
- Last execution confirmed: core alert state files present
- Checks: agent016 (HEALTHY), backup-fresh (HEALTHY), disk-wm (FAILED), release-provenance (HEALTHY), tmp-health (HEALTHY)

## Executable mode
- Script is executable, uses `set -euo pipefail`
- State dir: `/var/lib/mct-alert-state/` on mct-soc-scan

## Cron schedule
- `*/15 * * * * bash /opt/mct-security-stack/ops/scripts/p33-core-alert.sh`
- Independent of Shuffle state — runs even if Shuffle is down

## Five-per-day threshold
- 96 executions/day (every 15min)
- No threshold violation — this is monitoring, not alerting

## Kill switch
- Disable: Remove or comment cron line in crontab
- Current state: ACTIVE

## Analysisd independence
- `p33-core-alert.sh` uses `systemctl is-active` and file age checks — no dependency on analysisd
- Shuffle-native controls (dedup/counter) would depend on analysisd for event feed
- External guardrail remains independent backup

## No secrets
