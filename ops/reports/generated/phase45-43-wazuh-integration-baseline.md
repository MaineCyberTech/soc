# Phase 45: Wazuh-to-Packet Hook Baseline

## Current State
| Property | Value |
|----------|-------|
| **Wazuh Manager** | Operational |
| **Suricata Integration** | Running on agents |
| **Shuffle Hook** | Not configured |
| **Class-A Lane** | Protected (no Wazuh → Shuffle path) |

## Wazuh Manager Configuration
| Component | Status |
|-----------|--------|
| **Manager Version** | [Version] |
| **Suricata Module** | Enabled |
| **EVE JSON Output** | Enabled |
| **Output Format** | JSON |

## Suricata EVE JSON Events
| Field | Example |
|-------|---------|
| `timestamp` | "2026-08-27T04:14:00Z" |
| `event_type` | "alert" |
| `alert.signature_id` | 2027967 |
| `alert.src_ip` | "10.0.0.1" |
| `alert.dest_ip` | "192.168.1.10" |
| `alert.dest_port` | 443 |
| `alert.proto` | "TCP" |

## Current Integration Gaps
| Gap | Status |
|-----|--------|
| Wazuh → Shuffle webhook | **Not configured** |
| Suricata EVE → Hook URL | **Not configured** |
| Secret management for hook | **Not configured** |
| Node-local vs manager | **Not decided** |
| Rule/group filters | **Not configured** |
| Class-A lane protection | **Active** (no path exists) |

## Hook URL
| Property | Value |
|----------|-------|
| **Target URL** | `http://shuffle-host:5001/api/v1/hooks/p39-suricata-test` |
| **Protocol** | HTTP (internal) / HTTPS (external) |
| **Auth** | None (webhook public) |
| **Content-Type** | application/json |

## Wazuh Integration Options
| Option | Pros | Cons |
|--------|------|------|
| **Manager pushes EVE** | Centralized, single config | Single point of failure |
| **Agent pushes EVE** | Distributed, resilient | Config on each agent |
| **Logstash/Forwarder** | Flexible, buffered | Extra component |

## Current Class-A Lane Protections
| Protection | Status |
|------------|--------|
| No Wazuh → Shuffle config | ✅ Active |
| No Suricata → Hook config | ✅ Active |
| No secret in Wazuh for hook | ✅ Active |
| Production routing disabled | ✅ Workflow `test` status |

## Required Configuration (Future)
| Config | Location | Value |
|--------|----------|-------|
| Hook URL | Wazuh manager `ossec.conf` | `<hook_url>http://shuffle:5001/api/v1/hooks/p39-suricata-test</hook_url>` |
| Event filter | Wazuh manager `ossec.conf` | `<rule_id>2027967</rule_id>` |
| Format | Wazuh manager `ossec.conf` | `<format>json</format>` |
| Secret | Wazuh manager `ossec.conf` | None (webhook public) |

## Backup & Rollback
| Artifact | Backup Location |
|----------|-----------------|
| `ossec.conf` (pre-integration) | `/opt/wazuh-docker/backup/ossec.conf.pre-packet` |
| Suricata rules | `/opt/wazuh-docker/backup/rules/` |

## Node-Local Behavior
| Node | Behavior |
|------|----------|
| Manager | Centralized push (if chosen) |
| Agents | Local Suricata → local forward (if agent push) |

## Decision Required
- [ ] Push from Manager vs Agent
- [ ] Filter rules (SID 2027967 only? All?)
- [ ] Buffer/queue configuration
- [ ] Retry/backoff policy

## Decision Authority
Owner approval required per Phase 45 change register.

---
*Generated: 2026-08-27T04:15:00Z (UTC) / 2026-08-27T00:15:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after packet certification (Phase 45-42)*
