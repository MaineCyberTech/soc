# Greenbone Target Groups (Phase 4)

Finalized groups for scheduled scanning. Source: mct-soc-scan VM (192.168.222.154).

| Group | Members | Profile | Window | Frequency |
|---|---|---|---|---|
| core-infrastructure | Wazuh host 192.168.222.149, SO 192.168.222.116, PVE 192.168.222.187 | safe discovery -> authenticated (later) | 02:00-04:00 UTC | monthly (1st week) |
| cloud | mct-portal droplet 138.197.105.82 | external exposed services check | 02:00-05:00 UTC client-agreed | monthly |
| network-appliances | Zen 192.168.222.1, SKK 23.150.201.36, LBM-Dock 23.150.201.165 | safe discovery only | 02:00-04:00 UTC | quarterly |
| client-like-test | future test/client endpoints | safe discovery | after provisioning | on-boarding |

## Rules

- Scanner host (192.168.222.154) excluded from all groups.
- Gateways: non-invasive only; never authenticated.
- Internet-facing: client authorization on record + off-peak.
- OpenCanary ports on Wazuh host (21/23/3306/1433/9100/8008) will appear as
  findings - mark as FP in review (canary ports, not real services).

## Files

- integrations/greenbone/target-groups-phase4.md (this file)
- integrations/greenbone/scan-schedule-phase4.md
- integrations/greenbone/remediation-verification-workflow.md
