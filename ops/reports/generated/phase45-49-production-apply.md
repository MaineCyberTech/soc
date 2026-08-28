# Phase 45: Production Packet Apply

## Pre-conditions
- [ ] Phase 45-48 Decision = APPROVE
- [ ] All proofs complete (Phases 45-29 through 45-47)
- [ ] Owner sign-off documented
- [ ] Kill switch tested
- [ ] Rollback validated

## Apply Procedure

### 1. Create Production Workflow (or Update)
```bash
# Option A: New production workflow
# - Copy test workflow
# - Update status: production
# - Update auth: {{IRIS_API_TOKEN_PROD}}
# - Update allowlist: [2027967]
# - Import via Shuffle API

# Option B: Update existing workflow
# - Change status: production
# - Update auth reference
# - Verify allowlist
```

### 2. Update Trigger
```bash
# Ensure trigger running
# Verify hook endpoint active
# Test with probe
```

### 3. Verify Production Config
| Check | Expected | Actual |
|-------|----------|--------|
| Workflow status | `production` | [Status] |
| Auth reference | `{{IRIS_API_TOKEN_PROD}}` | [Ref] |
| Allowlist | `[2027967]` | [List] |
| Trigger status | `running` | [Status] |
| Hook endpoint | Valid | [Valid] |
| IRIS auth | Production token | [Valid] |

### 3. Enable Production Routing
```bash
# If new workflow: start trigger
# If updated: verify trigger running

# Verify no test markers in production path
```

## Verification
| Check | Expected | Actual |
|-------|----------|--------|
| Workflow status | `production` | [Status] |
| Trigger running | Yes | [Y/N] |
| Hook valid | Yes | [Y/N] |
| Auth object | `IRIS_API_TOKEN_PROD` | [Ref] |
| Allowlist | `[2027967]` | [List] |
| Test markers removed | Yes | [Y/N] |

## Production Probe
```bash
# Send test event to production workflow
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"prod-probe"}'

# Verify ROUTED, IRIS 200/201, alert created
```

## Monitoring Activation
```bash
# Enable production monitoring
# - packet.routed.count alert > 1000/hr
# - packet.target_fail.count alert > 10/hr
# - packet.routed.latency alert > 2s
```

## Kill Switch Verification
```bash
# Test kill switch
# 1. Shuffle UI → Workflow → Status → "test"
# 2. Verify no new routing
# 3. Restore → "production"
```

## Rollback Validation
```bash
# 1. Shuffle UI → Workflow → Status → "test"
# 2. Verify no new routing
# 3. Monitor IRIS 1 hour
# 5. Restore → "production"
```

## Class-A Impact
- [ ] No existing production workflows affected
- [ ] Other integrations unchanged
- [ ] Wazuh other rules unaffected
- [ ] IRIS production alerts unchanged

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

## Post-Apply Monitoring (First 24h)
| Metric | Check Interval | Threshold |
|--------|----------------|-----------|
| `packet.routed.count` | 5 min | > 0 |
| `packet.target_fail.count` | 5 min | = 0 |
| `packet.routed.latency.avg` | 5 min | < 500ms |
| IRIS alert quality | 1 hour | > 95% |

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

## If Decision = DEFER/REJECT
**Keep test lane isolated:**
- Workflow status: `test`
- Trigger: `running` (for testing)
- Production route: **DISABLED**
- No production allowlist
- Continue test-lane improvements

---
*Generated: 2026-08-27T04:22:00Z (UTC) / 2026-08-27T00:22:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after SID decision (Phase 45-48)*
