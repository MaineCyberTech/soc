# Phase 19 Wazuh Index / Noise / Storage After Zeek

Date: 2026-08-18

## 1. Storage before vs after Zeek rules (P18 enabled rules on 08-16/17)

| Day | Alerts docs | Alerts size | Archives docs | Archives size |
|---|---|---|---|---|
| 08-14 | 163,824 | 141 MB | n/a (older indices not shown) | - |
| 08-15 | 140,354 | 135 MB | 3,007,251 | 1.8 GB |
| 08-16 (P18 rules live) | 43,881 | 61 MB | 2,150,542 | 1.2 GB |
| 08-17 | 359,124 | 322 MB | 2,633,464 | 2.4 GB |
| 08-18 | 425,389 | 401 MB | 2,060,766 | 1.5 GB |

Notes:
- Alert volume ramped up after P18 Zeek rules went live (08-17/18), driven by
  **122000/122005/122006 (mDNS + UDP broadcast) = ~417K/24h**, not by real detections.
- Archives remain the dominant store (1.2-2.4 GB/day) due to macOS 015 flood (~1.4M/day
  until disconnect) + Zeek base events.
- Whole cluster ~11 GB today (alerts+archives+elastiflow ~1.9GB + states).

## 2. macOS flood impact after remediation

- NOT remediated yet (fix pending Mac-side apply). 08-18 archives dropped to 308K after the
  09:04 disconnect - a drop in volume caused by the agent being offline, not a fix.
- After the operator applies the Phase 19 macOS config change, expect archives for 015 to
  fall >=95% (save ~1.3M docs/day = ~1GB/day).

## 3. Zeek noise impact (post-v2 projection)

- v2 tuning (approval-gated) should cut Zeek alerts from ~417K/24h to < 2K/24h, reducing
  alert index daily growth by ~90%+ (several hundred MB/day).

## 4. ILM / retention status

- No ILM policies exist on this cluster (query returns none); wazuh-alerts/archives have no
  ILM attached. P18 ILM action plan remains **un-applied** (approval-gated).
- With 11 GB total today and ~2-3 GB/day combined growth, retention control is now
  operationally required: raw growth projects to ~100+ GB/month if unmanaged.

## 5. Recommendation

1. Deploy Zeek v2 (approval) -> drop alert/archive load.
2. Apply macOS fix (operator) -> drop archives load.
3. Apply ILM per P18 plan (approval): alerts 30d hot, archives 14d hot then delete/archive;
   elastiflow 14d. See `phase19-index-retention-followup.md`.

## No secrets