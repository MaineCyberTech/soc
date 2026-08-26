# Phase 23 Zeek Class A Routing Controlled Enable

Date: 2026-08-22
Status: **APPROVAL PENDING - NOT ENABLED** (approval-gated; no automatic routing without approval).

## Scope (Class A only - approved candidates)

| Rule | Route |
|---|---|
| 122001 SSH (lvl 8) | Wazuh -> Shuffle webhook -> IRIS High |
| 122002 SMB (lvl 8) | same |
| 122003 RDP (lvl 8) | same |

**Excluded**: 122000 (base), 122004 (admin), 122005 (subnet), 122006 (UDP), bulk-flow rules.

## Enable procedure (on approval)

1. Export current Shuffle workflows (rollback baseline).
2. Add webhook filter: `rule.groups contains mct,zeek` AND `rule.level >= 8` AND
   `rule.id in {122001,122002,122003}`.
3. Add **dedup** (rule.id + src + dst + 1h window) and **rate limit** (stop at 5 cases/day;
   notify operator on exceed) - per preflight gap.
4. Test with a synthetic alert (no live traffic).
5. Enable; open 24h case-volume window (Phase 23.13).

## Rollback

- Remove/disable the webhook filter; restore exported workflows if needed.

## Versioning

- Record Shuffle workflow version + filter hash in the enable report.

## No secrets