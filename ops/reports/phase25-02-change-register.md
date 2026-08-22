# Phase 25 Change Register

Date: 2026-08-22

| # | Change | Owner | Approval | Backup | Rollback | Health gate | Evidence |
|---|---|---|---|---|---|---|---|
| C1 | 013/014 Sysmon tuning confirm (RMM apply + restart + verify) | Operator | APPROVED (P24 applied) | effective-config dumps | rollback-sysmon-tune.ps1 | EID1/10 + buffer clean | marker + volume |
| C2 | 015 closeout + scorecard promotion | SOC | n/a (validate) | - | - | keepalive/volume/queue | 24h metrics |
| C3 | Zeek Class A routing enable | SOC+op | **APPROVED + ENABLED 2026-08-22** | ossec.conf.pre-zeek-classa.bak + workflow export | remove integration block + restart | cases < 5/day | synthetic tests FINISHED; case window open |
| C4 | v1.2.0 release (already published P24) | Operator | DONE (P24) | git tag | tag delete | gates (P19-22 verify) | release object+asset |
| C5 | VT key rotation | Operator | PENDING (key) | conf backup | restore prior | VT fires | record |
| C6 | Indexer rotation | SOC | PENDING | .env backup | restore+recreate | cluster/dashboard | post-rotation validation |
| C7 | PVE222 token | Operator | PENDING (token) | creds backup | remove token | API 200 | healthcheck |
| C8 | DR S3 restore drill (scratch-only) | SOC | APPROVED (non-destructive) | n/a | cleanup scratch | no prod touch | checksum + extract + validate |
| C9 | Windows dashboard/PS logging | SOC | PENDING (post-tuning) | - | - | EID7 clean 24h | enable record |
| C10 | NetFlow alert arming | SOC | PENDING (scope) | - | - | dry-run <5/day | arming record |

## Rules

- No prod-destructive DR test; scratch-only. No broad routing. No EID7 global disable.
- No release without gates. No secret values.

## No secrets