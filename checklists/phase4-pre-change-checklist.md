# Phase 4 Pre-Change Checklist

Run before EACH Phase 4 change.

- [ ] Indexer cluster green (`_cluster/health`)
- [ ] Current Docker containers listed (docker ps)
- [ ] Ports captured (phase4-ports-*.txt)
- [ ] Config backup created for the file being changed (ops/backups)
- [ ] Alert before-count captured (alert-volume-by-rule.sh)
- [ ] No secrets in command output
- [ ] Rollback path known (phase4-rollback-index.md)
- [ ] Wazuh master/worker impact understood (analysisd restart needed?)
- [ ] Change documented in ops/reports before execution
- [ ] Class A paths confirmed unaffected (OpenCanary/MISP IOC/unknown exporter/lateral)
