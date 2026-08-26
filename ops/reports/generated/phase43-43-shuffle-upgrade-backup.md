# Phase 43: Shuffle Upgrade Backup

**Report ID:** phase43-43-shuffle-upgrade-backup.md
**Phase:** 43
**Title:** Phase 43 Shuffle Upgrade Backup & Rollback Plan
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T18:30:00Z
**Classification:** INTERNAL
**Status:** PREPARED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-43-shuffle-upgrade-backup.md`

---

## 1. Backup Inventory (Pre-Upgrade)

| Component | Backup Method | Location |
|-----------|---------------|----------|
| Workflows | API export → `ops/evidence/p42-workflow-export/` | Git-tracked |
| Hook docs | OpenSearch `hooks` index dump | `ops/evidence/p42-workflow-export/` |
| Shuffle OpenSearch | Snapshot `snap-20260826-pre-upgrade` | `wazuh-backup` repo |
| Shuffle config | `compose/docker-compose.shuffle.yml` | Git-tracked |
| Shuffle TLS certs | `config/shuffle-tls/` | Git-ignored, backed up |
| Shuffle OpenSearch data | `shuffle-database` volume snapshot | Docker volume backup |

---

## 2. Backup Commands (Ready to Execute)

```bash
# Workflow exports
for wf in $(curl -s -H "Authorization: Bearer $NT" http://127.0.0.1:5001/api/v1/workflows | python3 -c "import json,sys; [print(w['id']) for w in json.load(sys.stdin)]"); do
  curl -s -H "Authorization: Bearer $NT" "http://127.0.0.1:5001/api/v1/workflows/$wf" > "ops/evidence/pre-upgrade-workflows/$wf.json"
done

# Hook docs backup
docker exec shuffle-opensearch curl -s "http://localhost:9200/hooks/_search?size=100" > ops/evidence/pre-upgrade-hooks.json

# OpenSearch snapshot
curl -sk -u admin:[REDACTED-PW] -X PUT "https://127.0.0.1:9200/_snapshot/wazuh-backup/snap-20260826-pre-upgrade" -H 'Content-Type: application/json' -d '{"indices":"shuffle-*","ignore_unavailable":true,"include_global_state":false}'

# Config backup
cp -r /opt/mct-security-stack/compose/docker-compose.shuffle.yml /opt/mct-security-stack/ops/backups/pre-upgrade-shuffle-compose.yml
cp -r /opt/mct-security-stack/config/shuffle-tls /opt/mct-security-stack/ops/backups/pre-upgrade-shuffle-tls/
```

---

## 3. Rollback Procedure

| Step | Command |
|------|---------|
| 1. Stop new version | `docker compose -f compose/docker-compose.shuffle.yml down` |
| 2. Restore config | `git checkout HEAD -- compose/docker-compose.shuffle.yml config/shuffle-tls/` |
| 3. Restore OpenSearch | `curl -X POST "https://127.0.0.1:9200/_snapshot/wazuh-backup/snap-20260826-pre-upgrade/_restore"` |
| 4. Restore workflows | Re-import from `ops/evidence/pre-upgrade-workflows/` |
| 5. Start old version | `docker compose -f compose/docker-compose.shuffle.yml up -d` |
| 6. Verify | Check workflows + hooks + IRIS delivery |

---

## 3. Status

**PREPARED** — Backup plan documented; commands ready; not yet executed (upgrade deferred).