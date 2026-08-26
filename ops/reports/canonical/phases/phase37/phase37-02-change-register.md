# Phase 37 — Change Register

**Date:** 2026-08-25T19:28Z

---

## Change Gates

| Gate | Area | Status | Detail |
|------|------|--------|--------|
| Password rotation | Shuffle admin | ✅ PASS | Old credential rejected, new credential applied |
| Exposure changes | Shuffle listener | ⏸ PENDING | Plan documented (phase37-06), approval required |
| Workflow edits | Shuffle workflows | ⏸ PENDING | Inventory complete, edits deferred to Phase 38 |
| Field settings | analysisd decoder_order_size | ✅ APPLIED | Set to 512 in local_internal_options.conf |
| Routing | Wazuh → Shuffle webhook | ⏸ DEFERRED | Not configured; requires Phase 38 |
| Retention | ISM lifecycle | ⏸ PENDING | Archive lifecycle transitions deferred |
| Endpoint changes | Agent configuration | ✅ NONE | No agent changes this phase |
| /tmp policy | Disk cleanup | ✅ APPLIED | Cron at 03:00 UTC daily; 1.6G/7.6G (21%) |
| Dashboards | Visualization | ✅ NONE | No dashboard changes |
| Repo | Git | ⏸ PENDING | HEAD b7c2f18, clean tree; commit pending |

---

## Detailed Gate Records

### 1. Shuffle Password Rotation — PASS

- **Old credential:** Rejected on login attempt (confirmed removed)
- **New credential:** Applied and verified via API login
- **Operator:** Operator rotation pending (secure channel delivery required)
- **Evidence:** phase37-03

### 2. Shuffle Exposure Changes — PENDING

- **Current state:** Frontend on 0.0.0.0:3001, no firewall, no TLS
- **Plan:** Restrict to 127.0.0.1 via iptables; operator uses SSH tunnel
- **Approval:** Required before execution
- **Evidence:** phase37-06, phase37-07

### 3. Workflow Edits — PENDING

- **Current state:** 2 workflows inventoried, both have structural gaps
- **Finding:** No normalization, no dedup, no severity mapping, no error handling
- **Action:** Defer to Phase 38 after Wazuh webhook integration
- **Evidence:** phase37-11, phase37-12

### 4. Field Settings — APPLIED

- **Setting:** decoder_order_size=512 in local_internal_options.conf
- **Result:** Errors STILL accumulating (18,849 total; 1,830 post-restart)
- **Assessment:** 512 is insufficient; must increase in Phase 38
- **Evidence:** phase37-01

### 5. Routing (Wazuh → Shuffle) — DEFERRED

- **Current state:** No webhook configured in Wazuh rules
- **Impact:** Shuffle workflows have no real alert input
- **Action:** Configure webhook integration in Phase 38

### 6. Retention — PENDING

- **Alert retention:** wazuh-retention (30d) — applied
- **Archive retention:** wazuh-archives-14d on 11 indices, hot state, condition_not_met
- **Oldest archive:** 10.8 days (approaching 14d target)
- **Action:** Review lifecycle transitions in Phase 38

### 7. Endpoint Changes — NONE

- **Action:** No agent configuration changes this phase

### 8. /tmp Policy — APPLIED

- **Current usage:** 1.6G / 7.6G (21%)
- **Cleanup:** Cron at 03:00 UTC daily
- **Status:** Healthy

### 9. Dashboards — NONE

- **Action:** No dashboard changes this phase

### 10. Repo — PENDING

- **Current HEAD:** b7c2f18
- **Working tree:** Clean
- **Status:** Commit pending after all reports written

---

## No secrets
