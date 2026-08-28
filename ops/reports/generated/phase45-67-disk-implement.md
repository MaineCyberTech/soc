# Phase 45: Disk Policy Implementation

## Pre-conditions
- [ ] Phase 45-65 Decision = ENABLE THRESHOLDS or ACCEPTED RISK
- [ ] Owner sign-off obtained

## Implementation: Enable Thresholds

### 1. Configure Thresholds
```bash
# Set warning threshold
curl -X PUT "https://monitoring/api/v1/thresholds/disk_warning" \
  -H "Authorization: Bearer $MON_TOKEN" \
  -d '{"value": 80, "unit": "percent"}'

# Set critical threshold
curl -X PUT "https://monitoring/api/v1/thresholds/disk_critical" \
  -H "Authorization: Bearer $MON_TOKEN" \
  -d '{"value": 90, "unit": "percent"}'
```

### 2. Configure Alerts
```bash
# Warning alert
curl -X POST "https://alerting/api/v1/alerts" \
  -H "Authorization: Bearer $ALERT_TOKEN" \
  -d '{"name": "disk_warning", "condition": "disk_usage > 80%", "severity": "warning", "channel": "slack"}'

# Critical alert
curl -X POST "https://alerting/api/v1/alerts" \
  -H "Authorization: Bearer $ALERT_TOKEN" \
  -d '{"name": "disk_critical", "condition": "disk_usage > 90%", "severity": "critical", "channel": "pagerduty"}'
```

### 3. Enable Auto-Cleanup
```bash
# Configure ISM policy for auto-delete
curl -X PUT "https://opensearch:9200/_plugins/_ism/policies/disk-cleanup" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN" \
  -d '{
    "policy": {
      "description": "Disk cleanup policy",
      "default_state": "hot",
      "states": [
        {
          "name": "hot",
          "actions": [
            {"rollover": {"min_size": "50gb"}}
          ],
          "transitions": [{"state_name": "warm", "conditions": {"min_index_age": "7d"}}]
        },
        {
          "name": "warm",
          "actions": [
            {"readonly": {}}
          ],
          "transitions": [{"state_name": "cold", "conditions": {"min_index_age": "30d"}}]
        },
        {
          "name": "cold",
          "actions": [
            {"delete": {}}
          ],
          "transitions": [{"state_name": "delete", "conditions": {"min_index_age": "90d"}}]
        },
        {
          "name": "delete",
          "actions": []
        }
      ]
    }
  }'
```

## Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Warning threshold set | 80% | [Value] | [PASS/FAIL] |
| Critical threshold set | 90% | [Value] | [PASS/FAIL] |
| Warning alert fires | At 81% | [Test] | [PASS/FAIL] |
| Critical alert fires | At 91% | [Test] | [PASS/FAIL] |
| Auto-cleanup active | Yes | [Status] | [PASS/FAIL] |
| ISM policy active | Yes | [Status] | [PASS/FAIL] |
| Allocation writes | Normal | [Check] | [PASS/FAIL] |
| Alerts route correctly | Slack/PagerDuty | [Test] | [PASS/FAIL] |

## Owner & Expiry
| Field | Value |
|-------|-------|
| **Owner** | [Name] |
| **Expiry** | [Date + 1 year] |
| **Review Date** | [Date + 6 months] |

## Rollback
```bash
# Disable thresholds
curl -X DELETE "https://monitoring/api/v1/thresholds/disk_warning"
curl -X DELETE "https://monitoring/api/v1/thresholds/disk_critical"

# Disable alerts
curl -X DELETE "https://alerting/api/v1/alerts/disk_warning"
curl -X DELETE "https://alerting/api/v1/alerts/disk_critical"

# Disable ISM policy
curl -X DELETE "https://opensearch:9200/_plugins/_ism/policies/disk-cleanup"
```

## Rollback Test
| Test | Target | Actual | Pass/Fail |
|------|--------|--------|-----------|
| Disable thresholds | < 1 min | [Min] | [PASS/FAIL] |
| Disable alerts | < 1 min | [Min] | [PASS/FAIL] |
| No false alerts | 0 | [Count] | [PASS/FAIL] |

## Verification
| Check | Verified |
|-------|----------|
| Thresholds applied | [Y/N] |
| Alerts firing correctly | [Y/N] |
| Auto-cleanup active | [Y/N] |
| ISM policy attached | [Y/N] |
| Allocation writes normal | [Y/N] |
| Alerts routing correct | [Y/N] |
| Rollback tested | [Y/N] |

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:40:00Z (UTC) / 2026-08-27T00:40:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after disk decision (Phase 45-65)*
