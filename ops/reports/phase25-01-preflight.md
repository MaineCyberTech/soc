# Phase 25 Preflight

Date: 2026-08-22 07:03 UTC
Stack root: /opt/mct-security-stack | Releases: v1.0.0/v1.1.0/v1.2.0 (v1.2.0 published P24)

## 1. Health / CI / secret / git / release

- Healthcheck exit 0 (0 FAIL). Local CI PASS. Secret scan PASS.
- Git: HEAD 63c5ed7 (P24). Tags v1.0.0/v1.1.0/v1.2.0.
- **v1.2.0 release confirmed live** (API: release object + asset uploaded).

## 2. Fleet (3/3 active)

- 013 SAMSUNG active (07:04); 014 DESKTOP-MI54LFT active (07:04); 015 Julians-Air active (07:04).
- 015: archives since reconnect (04:22 08-22) = **1** doc in ~2.7h; buffer events 0. Window
  completes 04:22 UTC 08-23 (closeout still accruing).

## 3. Sysmon volumes (quiet cycles)

- 013 EID7 alerts 30m: 25; 014: 12. Both in quiet phases (throttle active on 014; 013 flood
  subsided). Tuning state: 014 policy accepted (rc=0, marker unconfirmed - service restart
  + check pending); 013 not yet re-applied (old policy file still on disk).

## 4. Detection / retention / capacity

- Zeek 24h: 284 (clean). Suricata: 1 doc (quiet). Retention: archives-14d held.
- Disk: root 84% (node fs 84.7% - just below 85% low watermark). Snap fresh (05:17).
- PVE222: FAIL (401). 120537: ~10K/24h.

## 5. Open items (Phase 25 targets)

- DOABLE: DR S3 restore drill (plan/download/checksum/scratch/validate), disk watch +
  retention projection, v1.2.0 verification (already released), audits, billing/scorecard/
  monthly ops, repo commit.
- BLOCKED (replacement/approval/access): 013/014 final tuning confirmation (RMM),
  VT/indexer/PVE rotations, Zeek routing enable, NetFlow scope/arming, Redis/Greenbone/
  canarytokens.

## No secrets