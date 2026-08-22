> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 mct-canary01 Alert Validation - PASS

Date: 2026-08-15
Status: **PASS - alert path verified end-to-end**

## Path verified

```text
mct-canary01 OpenCanary event -> syslog 514/udp (192.168.222.149)
  -> Wazuh master -> rule 121014 (level 12, Class A)
  -> alerts index (10 alerts in 15m)
  -> Shuffle/IRIS route (same as local canary - webhook ready)
```

## Evidence

- Canary01 events in Wazuh archive (startup + events)
- Rule 121014 level 12 FIRED (alerts index, 05:58:30)
- sshd rules 5710/5762 from canary host
- Syslog path confirmed (node_id opencanary-mct-canary01 distinct from local opencanary-mct-01)

## Notes

- IRIS case path: same webhook trigger (wazuh-high-severity) as local canary -
  verified in Phase 3/4 (rule 121012 drill).
- Deception now has TWO sensors: local (opencanary-mct-01) + VM (opencanary-mct-canary01).
