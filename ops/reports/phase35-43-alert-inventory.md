# Phase 35: Canonical Alert Inventory

Date: 2026-08-25

## Total alerts today (all agents): 41,775

## Agent 016 (mct-packet-sensor): 1,062

| Rule | Count | Description | Level |
|---|---|---|---|
| 120518 | varies | Syscollector packages | 5 |
| 120537 | varies | Syscollector hotfixes | 3 |
| 120527 | varies | Syscollector ports | 4 |
| 80710 | varies | Wazuh vulnerability | 10 |
| 5710 | 1,046 | Syscollector | 5 |
| 651 | 285 | Agent started | 3 |
| 652 | 229 | Agent stopped | 3 |
| 86003 | 211 | Agent reconnected | 3 |
| 2904 | 199 | Syscheck attribute changed | 7 |
| 554 | 185 | Agent related | 5 |
| 2902 | 179 | Syscheck file modified | 7 |
| 2901 | 153 | Syscheck file added | 3 |
| 594 | 147 | Agent | 5 |
| 5502 | 145 | PAM login closed | 3 |
| 5501 | 139 | PAM login opened | 3 |
| 5715 | 107 | Syscollector | 3 |
| 550 | 23 | Syslog errors | 7 |
| 86601 | 2 | **Suricata Alert** | 3 |
| Others | varies | Various | varies |

## Suricata alerts (rule 86601)
1. SID 2027967 — ET MALWARE LiLocked [MCT-CANARY-P35-TEST-002] (synthetic, 18:14:27Z)
2. SID 2210038 — SURICATA STREAM FIN out of window (real SPAN, 17:53:54Z)

## Agent distribution
- 016 dominates alert volume (syscollector + syscheck + PAM)
- Other agents contribute via syscheck and syscollector

## No secrets
