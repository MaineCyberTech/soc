# Phase 46: Change Register

## Change Categories & Gates

### 1. Phase 45 Corrective Addenda (Immutable History)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Phase 45 corrective addenda | Owner | Preserve originals | Delete addenda | Timestamped addenda | Any future-dated evidence |
| Phase 45 time correction addendum | Owner | Original final | Revert timestamp | Corrected UTC timestamp | No rewrites of history |
| Phase 45 supersession note | Owner | Original reports | Remove note | Version reference | No deletion of v1.3.1 artifacts |

### 2. Webhook Trigger & Hook
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Start trigger via UI | Owner | Current state (stopped) | Stop trigger | UI screenshot + status | Trigger remains stopped |
| Validate hook path | Owner | Current state | N/A | Live probe response | Hook returns "Hook ID not valid" |
| Hook registration fix | Platform | Current config | N/A | Hook responds 200/202 | Hook returns 404/invalid |

### 3. Packet Workflow (suricata-packet-routing)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Export workflow JSON | Owner | Current workflow | Re-import | Exported file hash | Workflow ID mismatch |
| Convert to multi-action | Owner + Security | Current workflow | Restore test status | Canonical layout + secret refs | Placeholder credentials remain |
| Replace IRIS placeholder | Security | Current workflow | Restore placeholder | Auth object reference | `[REDACTED-*]` in live path |
| Split action types | Owner | Current workflow | Re-consolidate | Action per state | Single execute_python remains |

### 4. Trigger & Webhook
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Start trigger via UI | Owner | Current state (stopped) | Stop trigger | UI screenshot + status | Trigger remains stopped |
| Validate hook path | Owner | Current state | N/A | Live probe response | Hook returns "Hook ID not valid" |

### 4. IRIS Authentication
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Create IRIS auth object | Security | N/A | Delete object | Object ID + reference | Placeholder in Authorization |
| Update workflow auth ref | Security | Current workflow | Restore placeholder | Workflow JSON | HTTP 401 on IRIS POST |
| Prove IRIS HTTP 200 | Security | N/A | N/A | IRIS alert object ID | HTTP != 200/201 |

### 5. Wazuh Binding
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Configure Suricata → Shuffle | Wazuh admin | Current Wazuh config | Remove binding | Wazuh config + Shuffle receipt | Wazuh not sending to hook |
| Verify field mapping | Owner | N/A | N/A | Field extraction logs | Mismatched field names |

### 5. Field Cycle (C1-C5)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Certify on new-cycle index | Owner | Current index | Revert index | C1-C5 evidence per field | Index mismatch / future-dated |

### 6. Delivery Monitor
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Full-day window evidence | Owner | Current monitor | N/A | Elapsed timestamps | < 24h elapsed |

### 6. Owner-Gated Actions (8 Independent Decisions)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Agent 013 repair | Owner | Current state | Revert config | Agent heartbeat | [CONNECTED] |
| Agent 015 power/sleep | Owner | Current state | Revert power config | Agent awake | [ONLINE] |
| RTO/RPO targets | Owner | Current targets | Revert | Signed targets | [APPROVE/ADJUST] |
| Target approval (4) | Owner | Pending | Reject | Approval record | [APPROVE/DEFER] |
| VT Host Mode | Owner | Current mode | Revert | Host scan result | [APPROVE/DEFER] |
| GitHub Auth | Owner | Current auth | Revert | Publication success | [VALIDATED] |
| Dashboard v2 swap | Owner | Current dashboard | Revert | v2 accessible | [VALIDATED] |
| Disk policy | Owner | Current policy | Revert | Policy applied | [APPROVE/DEFER] |

### 7. Disk Policy
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Implement thresholds | Owner | Current config | Revert | Config + alerts | No decision / NO-GO |
| Accept risk (if thresholds not enabled) | Owner | N/A | N/A | Risk doc signed | No decision / NO-GO |

### 6. v1.3.1 Publication
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Tag release | Owner | Pre-tag state | Delete tag | Git tag + hash | Unsigned / failed checks |
| Publish artifacts | Owner | N/A | Remove | Published artifacts | Missing attestations |

### 7. Dashboard v2
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Activate v2 | Owner | v1 config | Revert to v1 | v2 URL + visual proof | v2 not accessible |

### 8. ISM Wave
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Observe first wave | Owner | Pre-wave state | N/A | Wave logs + timestamps | Forced deletion / manipulated watermarks |

### 9. Restore Readiness
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Validate restore | Owner | Current backups | N/A | Restore test logs | Any gate NO-GO |
| Go/No-Go decision | Owner | N/A | N/A | Signed decision | Premature GO |

### 10. AGENTS & Git
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Update AGENTS.md | Owner | Current AGENTS.md | Restore | Diff + hash | Drift from durable guidance |
| Audit + repo closeout | Owner | Pre-audit state | N/A | Audit reports | Unresolved HIGH/CRITICAL |

## Universal Gates
- **NO PVE access** (out of scope)
- **NO RAM expansion** (out of scope)
- **NO `docker compose down -v`** (data destruction)
- **NO forced ISM deletion**
- **NO future-dated evidence**
- **NO simulated PASS**
- **NO credentials in logs/debug**

## Evidence Paths
| Artifact | Path | Retention |
|----------|------|-----------|
| Phase 45 Reports | `/opt/mct-security-stack/ops/reports/generated/phase45-*.md` | 90 days |
| Phase 46 Reports | `/opt/mct-security-stack/ops/reports/generated/phase46-*.md` | 90 days |
| Workflow Exports | `/opt/mct-security-stack/ops/exports/` | 1 year |
| Shuffle Workflow Executions | API query | 90 days |
| OpenSearch Snapshots | `/opt/opensearch/snapshots/` | Per ISM policy |
| Shuffle Config | `/opt/mct-security-stack/.env` | Permanent |

## Stop Conditions (Universal)
- Any future-dated evidence detected → **STOP**
- Any credential printed in logs → **STOP**
- Any simulated PASS claimed → **STOP**
- Any forced ISM action → **STOP**
- Any `docker compose down -v` attempted → **STOP**
- PVE/RAM expansion work detected → **STOP**

---
*Generated: 2026-08-27T05:32:00Z (UTC) / 2026-08-27T01:32:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
