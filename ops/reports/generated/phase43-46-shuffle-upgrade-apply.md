# Phase 43: Shuffle Upgrade Apply

**Report ID:** phase43-46-shuffle-upgrade-apply.md
**Phase:** 43
**Title:** Phase 43 Shuffle Upgrade Apply (If Chosen)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T19:15:00Z
**Classification:** INTERNAL
**Status:** DEFERRED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-46-shuffle-upgrade-apply.md`

---

## 1. Upgrade Execution Plan (If Option B Chosen)

### Prerequisites
- [ ] Backup completed (phase43-43)
- [ ] Lab validation passed (phase43-45)
- [ ] Maintenance window scheduled
- [ ] Rollback plan reviewed
- [ ] Owner approval obtained

### Upgrade Steps

```bash
# 1. Pull new images
docker compose -f compose/docker-compose.shuffle.yml pull

# 2. Stop services
docker compose -f compose/docker-compose.shuffle.yml down

# 3. Update images in compose (or pull latest tags)
# Edit compose/docker-compose.shuffle.yml with new image tags/digests

# 3. Start new version
docker compose -f compose/docker-compose.shuffle.yml up -d

# 4. Verify health
curl -s http://127.0.0.1:5001/api/v1/health
curl -s http://127.0.0.1:3443/

# 5. Run falsification tests (phase43-44)
# 5. Verify workflows
curl -H "Authorization: Bearer $NT" http://127.0.0.1:5001/api/v1/workflows
```

---

## 2. Rollback Triggers

| Trigger | Action |
|---------|--------|
| Health check fails > 5 min | Immediate rollback |
| Workflow execution fails | Rollback |
| IRIS delivery fails | Rollback |
| Packet lane still broken | Rollback |

---

## 3. Status

**DEFERRED** — Upgrade not chosen (Option A preferred). Plan documented for future use.