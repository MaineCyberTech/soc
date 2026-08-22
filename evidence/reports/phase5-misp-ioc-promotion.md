> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 5 MISP IOC Promotion

Date: 2026-08-11
Status: **PASS - first controlled IOC promoted through the full lifecycle**

## Lifecycle executed

| Step | Status | Evidence |
|---|---|---|
| candidate | PASS | MISP event 2109 created via API (controlled test IOC 203.0.113.77, RFC5737) |
| analyst-reviewed | PASS | tags attached: action:block + confidence:high + tlp:green |
| active-block (exported-to-CDB) | PASS | misp-to-wazuh-cdb.py wrote `203.0.113.77:` to ops/cdb/misp-iocs |
| CDB push + reload | PASS | file copied to master+worker; analysisd restart; .cdb recompiled (2084 bytes) |
| Wazuh match | PASS | logtest: rule 121100 matched, level 12 (Class A) |
| reviewed/expired | PASS | action:block tag removed; next export drops the IOC |

## Key findings

1. **Export script is slow (~12 min for 2,107 events)**: it does one detail API
   call per event (0.34s each). Any cron invocation must allow >= 15 min
   (the Phase 4 cron log showed earlier runs completing - now that MISP has
   more events, the window must be sized accordingly).
2. CDB reload still requires analysisd restart (documented pattern).
3. No benign traffic affected: test IOC is an RFC5737 documentation address.

## Files

- ops/reports/phase5-misp-ioc-promotion.md (this file)
- integrations/misp/real-ioc-promotion-procedure.md
- integrations/misp/cdb-reload-and-analysisd-restart.md

## Cleanup note

- Event 2109 retained in MISP (audit trail) with confidence:high + tlp:green,
  minus action:block.
- CDB currently holds 203.0.113.77: until next export; next run (cron or
  manual) removes it since action:block is gone.
