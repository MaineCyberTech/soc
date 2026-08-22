# Phase 24 Zeek Class A Enable

Date: 2026-08-22
Status: **NOT ENABLED - APPROVAL PENDING** (C3).

## Enable procedure (on approval)

1. Export current Shuffle workflows (rollback baseline).
2. Add webhook filter: `rule.groups contains mct,zeek` AND level >= 8 AND rule.id in
   {122001,122002,122003}.
3. Add dedup (rule.id+src+dst+1h) + rate limit (stop 5/day, notify on exceed).
4. Test with synthetic alert (no live traffic).
5. Enable; open 24h case-volume window (phase24-12).
6. Record workflow version + filter hash.

## Rollback

- Disable filter; restore exported workflows.

## Scope guard

- **Class A only** - never base/UDP/subnet/bulk-flow rules.

## No secrets