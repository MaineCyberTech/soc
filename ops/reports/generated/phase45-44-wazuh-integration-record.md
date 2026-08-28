# Phase 45: Wazuh Integration Configuration of Record

## Configuration of Record
**Version:** 1.0
**Date:** [Date]
**Owner:** [Owner Name]
**Approved By:** [Approver]

## Nodes
| Node | Role | Config File | Version |
|------|------|-------------|---------|
| `wazuh-manager` | Manager (centralized push) | `/var/ossec/etc/ossec.conf` | 1.0 |
| `wazuh-agent-*` | Agents (local forward) | `/var/ossec/etc/ossec.conf` | 1.0 |

## Manager Configuration (`/var/ossec/etc/ossec.conf`)
```xml
<ossec_config>
  <!-- Shuffle Packet Routing Integration -->
  <integration>
    <name>shuffle-packet-routing</name>
    <hook_url>http://shuffle-host:5001/api/v1/hooks/p39-suricata-test</hook_url>
    <format>json</format>
    <rule_id>2027967</rule_id>
    <level>7</level>
    <group>suricata,packet</group>
    <alert_format>json</alert_format>
  </integration>
  
  <!-- Suricata EVE JSON forwarding -->
  <suricata>
    <enabled>yes</enabled>
    <eve_output>yes</eve_output>
    <eve_modules>alert,http,dns,tls,files</eve_modules>
  </suricata>
</ossec_config>
```

## Agent Configuration (`/var/ossec/etc/ossec.conf` on each agent)
```xml
<ossec_config>
  <client>
    <server>
      <address>wazuh-manager</address>
      <port>1514</port>
    </server>
  </client>
  
  <!-- Local Suricata EVE forwarding (optional) -->
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
</ossec_config>
```

## Secret References
| Secret | Location | Reference |
|--------|----------|-----------|
| Shuffle webhook | N/A (public webhook) | None |
| IRIS API token | Shuffle auth object | `{{IRIS_API_TOKEN}}` |

## Reload Procedure
| Step | Command | Verification |
|------|---------|--------------|
| 1. Backup | `cp /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.backup` | File exists |
| 2. Apply config | Edit `/var/ossec/etc/ossec.conf` | Syntax valid |
| 3. Test config | `/var/ossec/bin/ossec-control test` | No errors |
| 4. Reload | `/var/ossec/bin/ossec-control restart` | Service running |
| 5. Verify | `tail -f /var/ossec/logs/ossec.log` | Integration started |

## Test Procedure
| Test | Command | Expected |
|------|---------|----------|
| Trigger alert | Suricata rule 2027967 fires | Event in Shuffle |
| Verify payload | Check Shuffle execution | Fields parsed |
| Verify routing | Check IRIS | Alert created |

## Failure Semantics
| Failure | Behavior | Recovery |
|---------|----------|----------|
| Shuffle unreachable | Wazuh queues locally (buffer) | Auto-retry on restore |
| Hook returns 5xx | Wazuh logs error, continues | Manual review |
| Hook returns 4xx | Wazuh logs error, drops event | Fix payload |
| Network partition | Local buffer (configurable) | Auto-flush on restore |

## Rollback Procedure
```bash
# 1. Restore backup
cp /var/ossec/etc/ossec.conf.backup /var/ossec/etc/ossec.conf

# 2. Test config
/var/ossec/bin/ossec-control test

# 3. Restart
/var/ossec/bin/ossec-control restart

# 4. Verify
tail -f /var/ossec/logs/ossec.log
```

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Author] | Initial packet routing integration |

## Approval
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Wazuh Admin | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:16:00Z (UTC) / 2026-08-27T00:16:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after Wazuh baseline (Phase 45-43)*
