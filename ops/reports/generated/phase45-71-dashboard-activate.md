# Phase 45: Dashboard v2 Activation

## Pre-conditions
- [ ] Phase 45-64 Signoff = APPROVE
- [ ] Phase 45-64 Rollback tested
- [ ] Phase 45-64 Client-safe = Verified

## Activation Procedure

### 1. Backup Current v1 Dashboard
```bash
# Backup v1 dashboard
curl -X GET "https://grafana/api/dashboards/uid/<v1-uid>" \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  -o /opt/mct-security-stack/ops/backups/dashboard-v1-backup-$(date +%Y%m%d).json
```

### 2. Import v2 Dashboard
```bash
# Import v2 dashboard
curl -X POST "https://grafana/api/dashboards/db" \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  -H "Content-Type: application/json" \
  -d @dashboard-v2.json

# Capture v2 UID
V2_UID=$(jq -r '.uid' dashboard-v2.json)
```

### 3. Update Links/References
```bash
# Update any hardcoded dashboard references
# Update documentation
# Update bookmarks if applicable
```

## Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| v2 Dashboard Active | Yes | [Y/N] | [PASS/FAIL] |
| v1 Dashboard Archived | Yes (not deleted) | [Y/N] | [PASS/FAIL] |
| Data Sources Connected | All | [Count] | [PASS/FAIL] |
| Panels Render | All | [Count] | [PASS/FAIL] |
| Queries Execute | No errors | [Count] | [PASS/FAIL] |

## Originals Retention
| Artifact | Location | Retention |
|----------|----------|-----------|
| v1 Dashboard JSON | `/opt/mct-security-stack/ops/backups/dashboard-v1-backup-<date>.json` | 1 year |
| v1 Grafana UID | [v1-uid] | Permanent |
| v1 Screenshots | `/opt/mct-security-stack/ops/backups/screenshots/` | 90 days |

## Rollback Procedure
```bash
# 1. Re-import v1
curl -X POST "https://grafana/api/dashboards/db" \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  -H "Content-Type: application/json" \
  -d @/opt/mct-security-stack/ops/backups/dashboard-v1-backup-<date>.json

# 2. Verify v1 active
curl -X GET "https://grafana/api/dashboards/uid/<v1-uid>" \
  -H "Authorization: Bearer $GRAFANA_TOKEN"
```

## Rollback Verification
| Test | Target | Actual | Pass/Fail |
|------|--------|--------|-----------|
| Rollback Time | < 2 min | [Min] | [PASS/FAIL] |
| v1 Data Intact | Yes | [Y/N] | [PASS/FAIL] |
| Queries Work | Yes | [Y/N] | [PASS/FAIL] |
| No Data Loss | Yes | [Y/N] | [PASS/FAIL] |

## Client Impact
| Check | Method | Pass/Fail |
|-------|--------|-----------|
| Embedded Panels | Iframe test | [PASS/FAIL] |
| API Tokens | Existing tokens work | [PASS/FAIL] |
| Bookmarks | Old URLs work/redirect | [PASS/FAIL] |
| Embedded Panels | Iframe embed | [PASS/FAIL] |

## Verification
| Check | Pass/Fail |
|-------|-----------|
| v2 Activated | [PASS/FAIL] |
| v1 Archived (not deleted) | [PASS/FAIL] |
| All panels render | [PASS/FAIL] |
| All data sources connected | [PASS/FAIL] |
| Rollback tested | [PASS/FAIL] |
| Client-safe verified | [PASS/FAIL] |

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:44:00Z (UTC) / 2026-08-27T00:44:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after dashboard signoff (Phase 45-64)*
