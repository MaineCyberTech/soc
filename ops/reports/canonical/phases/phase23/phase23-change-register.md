# Phase 23 Change Register

Date: 2026-08-22
One register for all Phase 23 remediation changes. Every item: approval state, owner, backup, rollback, health gate, evidence.

| # | Change | Owner | Approval | Backup | Rollback | Health gate | Evidence req |
|---|---|---|---|---|---|---|---|
| C1 | 014 Sysmon tuning apply (include-oriented) | Operator (endpoint access) | PENDING (approval-gated) | Sysmon config export + hash | reload prior config / `sysmon -u` | agent 014 keepalive + EID1/10 continuity | pre/post EID7 counts + config hash |
| C2 | 015 macOS repair (apply if not already done; validate) | Operator (Mac) - appears APPLIED externally | APPLIED (external) / validate | mct-backups timestamped (bundle) | rollback-agent015.sh | reconnect + bounded volume | reconnect ts + 24h volume |
| C3 | Zeek Class A routing enable (SSH/SMB/RDP only) | SOC + operator | PENDING (approval-gated) | Shuffle workflow export | disable webhook filter | IRIS case volume < 5/day | case volume window + rollback evidence |
| C4 | Disk relief (approved cleanup only) | SOC | APPROVED items only (register per item) | no deletion of evidence/snapshots outside policy | n/a (non-destructive first) | disk < 85%, cluster green, no write blocks | bytes reclaimed per item |
| C5 | PVE222 token refresh | Operator (new token) | PENDING (replacement token) | old token ref removed | n/a | API auth 200 | healthcheck PASS |
| C6 | VirusTotal key rotation | Operator (replacement key) | PENDING (replacement key) | wazuh_manager.conf backup | restore prior key + analysisd restart | VT integration fires | rotation record |
| C7 | Indexer password rotation | SOC | PENDING (approval-gated) | .env/creds.env backup | restore prior values + recreate | cluster green + dashboard/API/scripts | post-rotation validation |
| C8 | Docs governance (architecture, client-dir, banners, branding) | SOC | APPROVED (doc-only) | git history | git revert | CI PASS | commit + review |
| C9 | 013 coverage confirmation | Client | n/a (info) | - | - | - | client confirmation |

## Rules

- No change applied without its approval marker; destructive/service-affecting steps require
  dry-run, backup, approval, rollback, validation.
- Disk relief: never delete evidence/snapshots/backups merely to reach a target.

## Files
- `ops/reports/phase23-change-register.md` (this), `ops/checklists/phase23-approval-gates.md`

## No secrets