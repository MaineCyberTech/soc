# Phase 45: Bind Wazuh to Valid Packet Hook

## Approval
| Field | Value |
|-------|-------|
| **Approved By** | [Owner/Wazuh Admin] |
| **Approval Date** | [Date] |
| **Change Register Ref** | phase45-03-change-register.md |
| **Depends On** | Phase 45-42 (certification), Phase 45-44 (config of record) |

## Pre-Bind State
| Property | Value |
|----------|-------|
| Wazuh → Shuffle | Not configured |
| Suricata EVE | Not forwarded |
| Class-A Lane | Protected |
| Packet Workflow | `test` status |

## Bind Procedure

### 1. Backup Configs
```bash
# Manager
cp /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.pre-packet-backup

# Agents (if agent push)
# for agent in wazuh-agent-*; do
#   cp /var/ossec/etc/ossec.conf ${agent}/ossec.conf.pre-packet-backup
# done
```

### 2. Apply Manager Config
```bash
# Edit /var/ossec/etc/ossec.conf
# Add integration block (see Phase 45-44 config of record)

# Test config
/var/ossec/bin/ossec-control test
# Expected: No errors

# Reload
/var/ossec/bin/ossec-control restart
```

### 3. Verify Manager Reload
```bash
tail -f /var/ossec/logs/ossec.log | grep -E "integration|shuffle"
# Expected: "Integration 'shuffle-packet-routing' started"
```

### 4. Verify Agent Config (if agent push)
```bash
# On each agent
/var/ossec/bin/ossec-control restart
tail -f /var/ossec/logs/ossec.log | grep -E "localfile|suricata"
```

### 4. Minimal Reload Verification
| Check | Command | Expected |
|-------|---------|----------|
| Config syntax | `/var/ossec/bin/ossec-control test` | OK |
| Service status | `/var/ossec/bin/ossec-control status` | Running |
| Integration loaded | `grep shuffle /var/ossec/logs/ossec.log` | Started |
| No errors | `grep -i error /var/ossec/logs/ossec.log` | None |

## Class-A Lane Protection Verification
| Check | Method | Expected |
|-------|--------|----------|
| Workflow status | Shuffle UI | `test` (not production) |
| Suricata rule filter | Wazuh config | `rule_id 2027967` only |
| IRIS auth | Shuffle workflow | `{{IRIS_API_TOKEN}}` (test) |
| No production routing | Shuffle workflow | `test` status |

## Post-Bind Verification

### 1. Trigger Test Alert
```bash
# On Suricata sensor, trigger rule 2027967
# Or inject test event via Wazuh
```

### 2. Verify End-to-End
```bash
# 1. Check Wazuh logs
grep "shuffle-packet-routing" /var/ossec/logs/ossec.log

# 2. Check Shuffle execution
EXEC_ID=<from_hook>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"

# 3. Check IRIS
curl -X GET "https://iriswebapp_nginx:8443/alerts/<ALERT_ID>" \
  -H "Authorization: Bearer <IRIS_ADMIN_TOKEN>"
```

### 3. Verify Class-A Unaffected
| Check | Method | Expected |
|-------|--------|----------|
| Production workflows | Shuffle UI | Unchanged |
| Other integrations | Shuffle UI | Unchanged |
| Wazuh other rules | Wazuh UI | Unchanged |
| Class-A alerts | IRIS | Unchanged |

## Rollback Plan
```bash
# 1. Restore manager config
cp /var/ossec/etc/ossec.conf.pre-packet-backup /var/ossec/etc/ossec.conf

# 2. Test & reload
/var/ossec/bin/ossec-control test && /var/ossec/bin/ossec-control restart

# 3. Verify
/var/ossec/bin/ossec-control status
```

## Verification Checklist
- [ ] Manager config applied & reloaded
- [ ] Integration started in logs
- [ ] No errors in ossec.log
- [ ] Class-A lane unchanged
- [ ] Test event → Shuffle → IRIS
- [ ] Workflow status remains `test`
- [ ] Screenshots captured

## Rollback Trigger Conditions
- Wazuh errors in logs
- Class-A lane affected
- Workflow status changed
- IRIS production alerts affected

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Wazuh Admin | [Name] | [Sig] | [Date] |
| Owner | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:17:00Z (UTC) / 2026-08-27T00:17:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING APPROVAL - Execute after config of record (Phase 45-44)*
