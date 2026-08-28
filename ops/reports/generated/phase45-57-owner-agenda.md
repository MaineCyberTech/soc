# Phase 45: Owner Session Agenda

## Session Overview
**Date:** [Date]
**Time:** [Time] EDT
**Duration:** 2 hours
**Participants:** Owner, Platform Engineer, Security
**Location:** [Location/Video]

## Agenda Items (Independent Execution)

### 1. Agent 013 (Disconnected) - 15 min
| Item | Evidence Required | Decision |
|------|-------------------|----------|
| Current Status | Agent dashboard / API | [CONNECTED/DISCONNECTED] |
| Root Cause | Logs / diagnostics | [Identified] |
| Remediation | [Action taken] | [EXECUTED/PENDING] |
| Verification | Agent heartbeat | [CONNECTED] |
| Rollback | Revert config if needed | [VALIDATED] |

### 2. Agent 015 (Power/Sleep) - 15 min
| Item | Evidence Required | Decision |
|------|-------------------|----------|
| Current State | Agent power status | [ONLINE/OFFLINE/SLEEP] |
| Power Config | BIOS/OS power settings | [CONFIGURED] |
| Wake Test | Wake-on-LAN / manual | [WOKE] |
| Verification | Agent heartbeat | [ONLINE] |
| Rollback | Revert power config | [VALIDATED] |

### 3. RTO/RPO Targets - 20 min
| Target | Current | Target | Evidence | Decision |
|--------|---------|--------|----------|----------|
| **RTO (Recovery Time)** | [Current] | [Target] | [Test result] | [APPROVE/ADJUST] |
| **RPO (Recovery Point)** | [Current] | [Target] | [Test result] | [APPROVE/ADJUST] |
| **Restore Test** | [Date] | [Pass/Fail] | [Log] | [APPROVE] |
| **Kill Switch** | Tested | [Y/N] | [Log] | [VALIDATED] |

### 4. Target Approval - 15 min
| Target | Status | Evidence | Decision |
|--------|--------|----------|----------|
| IRIS Production | [READY/NOT READY] | [Phase 45-48] | [APPROVE/DEFER] |
| Wazuh Integration | [READY/NOT READY] | [Phase 45-45] | [APPROVE/DEFER] |
| Dashboard v2 | [READY/NOT READY] | [Phase 45-71-75] | [APPROVE/DEFER] |
| Disk Policy | [READY/NOT READY] | [Phase 45-65] | [APPROVE/DEFER] |

### 5. Host-Side VirusTotal Mode - 15 min
| Item | Current | Target | Evidence | Decision |
|------|---------|--------|----------|----------|
| VT Mode | [CLOUD/HOST] | [HOST] | [Config] | [APPROVE/DEFER] |
| API Key | [Configured] | [VALID] | [Test] | [VALIDATED] |
| Host Binary | [Installed] | [Y/N] | [Check] | [COMPLETE] |
| Fallback | [Configured] | [CLOUD] | [Config] | [VALIDATED] |

### 6. GitHub Publication Auth - 15 min
| Item | Status | Evidence | Decision |
|------|--------|----------|----------|
| GitHub PAT | [Configured] | [Test] | [VALIDATED] |
| Repo Access | [Granted] | [Test push] | [VALIDATED] |
| Release Workflow | [Tested] | [Run] | [VALIDATED] |
| Attestations | [Enabled] | [Config] | [VALIDATED] |

### 7. Dashboard v2 Swap - 15 min
| Item | Status | Evidence | Decision |
|------|--------|----------|----------|
| Dashboard v2 Ready | [Y/N] | [Phase 45-71-75] | [APPROVE/DEFER] |
| Swap Plan | [Documented] | [Plan] | [APPROVED] |
| Rollback | [Tested] | [Test result] | [VALIDATED] |
| Client-Safe | [Verified] | [Test] | [VALIDATED] |

### 8. Disk Policy - 15 min
| Item | Current | Target | Evidence | Decision |
|------|---------|--------|----------|----------|
| Threshold | [Current%] | [Target%] | [Config] | [APPROVE/DEFER] |
| Alerting | [Configured] | [Y/N] | [Alert test] | [VALIDATED] |
| Retention | [Current] | [Target] | [Policy] | [APPROVED] |
| ISM Integration | [Active] | [Y/N] | [Policy] | [VALIDATED] |

## Execution Format
Each item:
1. **Present Evidence** (5 min) - Dashboard, logs, test results
2. **Owner Decision** (5 min) - APPROVE/DEFER/REJECT
3. **Rollback Validation** (5 min) - Confirm rollback works

## Evidence Package
Each item must include:
- [ ] Screenshot/dashboard link
- [ ] Log excerpt / test output
- [ ] Rollback procedure tested
- [ ] Owner signature

## Sign-Off
| Item | Owner Decision | Signature | Date |
|------|----------------|-----------|------|
| Agent 013 | [APPROVE/DEFER/REJECT] | [Sig] | [Date] |
| Agent 015 | [APPROVE/DEFER/REJECT] | [Sig] | [Date] |
| RTO/RPO | [APPROVE/ADJUST] | [Sig] | [Date] |
| Targets | [APPROVE/DEFER] | [Sig] | [Date] |
| VT Host | [APPROVE/DEFER] | [Sig] | [Date] |
| GitHub Auth | [APPROVE/DEFER] | [Sig] | [Date] |
| Dashboard v2 | [APPROVE/DEFER] | [Sig] | [Date] |
| Disk Policy | [APPROVE/DEFER] | [Sig] | [Date] |

## Rollback Validation (All Items)
| Item | Rollback Tested | Rollback Time | Verified By |
|------|-----------------|---------------|-------------|
| Agent 013 | [Y/N] | [Min] | [Name] |
| Agent 015 | [Y/N] | [Min] | [Name] |
| RTO/RPO | [Y/N] | [Min] | [Name] |
| Targets | [Y/N] | [Min] | [Name] |
| VT Host | [Y/N] | [Min] | [Name] |
| GitHub Auth | [Y/N] | [Min] | [Name] |
| Dashboard v2 | [Y/N] | [Min] | [Name] |
| Disk Policy | [Y/N] | [Min] | [Name] |

## Session Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform Engineer | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:30:00Z (UTC) / 2026-08-27T00:30:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after monitor cert (Phase 45-56)*
