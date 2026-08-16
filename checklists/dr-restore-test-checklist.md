# DR Restore Test Checklist

- [ ] Scratch disk/tmp allocated (/tmp/opencode/dr-scratch)
- [ ] Snapshot repo copy staged (latest snap-*.dat + meta)
- [ ] Wazuh config tar extracted
- [ ] Phase2 config tar extracted
- [ ] Scratch OpenSearch up (port 19200)
- [ ] Snapshot restore: indices count matches source
- [ ] Snapshot restore: sample doc timestamps match
- [ ] Wazuh config: key files present + diff reviewed
- [ ] Compose parse: docker compose config -q exit 0
- [ ] IRIS restore: pg_restore exit 0 + cases > 0
- [ ] MISP restore: import exit 0 + events > 0
- [ ] Greenbone restore: import exit 0 (or subset documented)
- [ ] Scratch containers removed
- [ ] Production volumes untouched (docker volume ls unchanged)
- [ ] Results recorded in phase5-dr-restore-test-plan.md
