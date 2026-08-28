# Phase 45: Change Register

## Change Categories & Gates

### 1. Reports (Phase 44 Corrective Addenda)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Phase 44 claim audit | Owner | Preserve originals | Revert addenda | Timestamped addenda | Any future-dated evidence |
| Phase 44 corrective addenda | Owner | Original reports | Delete addenda | UTC+EDT timestamps | No rewrites of history |
| Phase 44 supersession note | Owner | Original reports | Remove note | Version reference | No deletion of v1.3.1 artifacts |

### 2. Packet Workflow (suricata-packet-routing)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Export workflow JSON | Owner | Current workflow | Re-import | Exported file hash | Workflow ID mismatch |
| Convert to durable artifact | Owner + Security | Current workflow | Restore test status | Canonical layout + secret refs | Placeholder credentials remain |
| Replace IRIS placeholder | Security | Current workflow | Restore placeholder | Auth object reference | `[REDACTED-*]` in live path |
| Split action types | Owner | Current workflow | Re-consolidate | Action per state | Single execute_python remains |

### 3. Trigger & Webhook
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Start trigger via UI | Owner | Current state (stopped) | Stop trigger | UI screenshot + status | Trigger remains stopped |
| Validate hook path | Owner | Current state | N/A | Live probe response | Hook returns "Hook ID not valid" |
| Bind Wazuh Suricata | Owner + Wazuh admin | Current config | Remove binding | Wazuh config + Shuffle logs | Wazuh not sending to hook |

### 4. Authentication (IRIS)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Create IRIS auth object | Security | N/A | Delete object | Object ID + reference | Placeholder in Authorization |
| Update workflow auth ref | Security | Current workflow | Restore placeholder | Workflow JSON | HTTP 401 on IRIS POST |
| Prove IRIS HTTP 200 | Security | N/A | N/A | IRIS alert object ID | HTTP != 200/201 |

### 5. Wazuh Integration
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Configure Suricata → Shuffle | Wazuh admin | Current Wazuh config | Remove rule | Wazuh config + Shuffle receipt | Events not reaching hook |
| Verify field mapping | Owner | N/A | N/A | Field extraction logs | Mismatched field names |

### 6. Field Cycle (C1-C5)
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Certify on new-cycle index | Owner | Current index | Revert index | C1-C5 evidence per field | Index mismatch / future-dated |

### 7. Delivery Monitor
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Full-day window evidence | Owner | Current monitor | N/A | Elapsed timestamps | < 24h elapsed |

### 8. Owner-Gated Actions
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Agent 013 repair | Owner | Current state | N/A | Agent connected | Agent remains disconnected |
| Agent 015 power/sleep | Owner | Current state | N/A | Agent awake | Agent asleep |
| RTO/RPO targets | Owner | Current targets | Revert | Signed targets | No owner sign-off |
| Target approval | Owner | Pending | Reject | Approval record | Unapproved target in prod |
| VT host mode | Owner | Current mode | Revert | Host scan result | Cloud-only mode |
| GitHub auth | Owner | Current auth | Revert | Publication success | Auth failure |
| Dashboard v2 | Owner | Current dashboard | Revert | v2 accessible | v1 only |
| Disk policy | Owner | Current policy | Revert | Policy applied | No decision recorded |

### 9. Disk Policy
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Implement threshold | Owner | Current config | Revert | Config + alerts | No decision / NO-GO |

### 10. v1.3.1 Publication
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Tag release | Owner | Pre-tag state | Delete tag | Git tag + hash | Unsigned / failed checks |
| Publish artifacts | Owner | N/A | Remove | Published artifacts | Missing attestations |

### 11. Dashboard v2
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Activate v2 | Owner | v1 config | Revert to v1 | v2 URL + visual proof | v2 not accessible |

### 12. ISM Wave
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Observe first wave | Owner | Pre-wave state | N/A | Wave logs + timestamps | Forced deletion / manipulated watermarks |

### 13. Restore Readiness
| Change | Approval | Backup | Rollback | Evidence | Stop Gate |
|--------|----------|--------|----------|----------|-----------|
| Validate restore | Owner | Current backups | N/A | Restore test logs | Any gate NO-GO |
| Go/No-Go decision | Owner | N/A | N/A | Signed decision | Premature GO |

### 14. AGENTS & Git
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

---
*Generated: 2026-08-27T03:30:15Z (UTC) / 2026-08-26T23:30:15-04:00 (EDT)*
