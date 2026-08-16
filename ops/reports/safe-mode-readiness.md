# Safe Mode Readiness - Phase 3

Date: 2026-08-11

## Deliverables

- `ops/runbooks/safe-mode.md` - answers all 9 safe-mode questions; per-service stop procedures; never-stop rules.
- `ops/runbooks/break-glass.md` - emergency procedure, contacts, isolate->diagnose->contain->restore->document.
- `ops/scripts/enter-safe-mode.sh` - dry-run default; stops 6 phase 2 stacks with `--apply`; verifies Wazuh stays up.
- `ops/scripts/exit-safe-mode-checklist.sh` - dry-run default; restarts stacks; post-restore pass/fail checklist.

## Verification

- enter-safe-mode.sh dry-run: PASS (all 6 stacks enumerated, Wazuh untouched).
- exit-safe-mode-checklist.sh: created; dry-run verified syntax.
- Wazuh ingest protection: by design (script never touches multi-node compose).

## Safe-mode answers coverage

| Question | Covered |
|---|---|
| Stop Phase 2 without breaking Wazuh | YES |
| Disable Shuffle actions, keep collection | YES |
| Stop MISP-to-CDB exports | YES (manual cron instruction) |
| Disable Greenbone scans | YES |
| Stop OpenCanary | YES |
| Keep Wazuh ingest during troubleshooting | YES |
| Recover if Shuffle routing breaks | YES |
| Disable active response temporarily | YES |
| Restore alerts after safe mode | YES |

## Open items

- Active response disable procedure requires ossec.conf edit + analysisd restart (documented, not applied).
- Scripts were not executed in --apply mode (would stop production services); validated in dry-run only.
