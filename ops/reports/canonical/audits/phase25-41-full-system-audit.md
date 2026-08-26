# Phase 25 Full System Regression Audit

Date: 2026-08-22

## Post-change state (vs P24)

| Area | P24 | P25 | Regression |
|---|---|---|---|
| Healthcheck | 0 FAIL | 0 FAIL | NO |
| Cluster | green | green | NO |
| Fleet | 3/3 active | 3/3 active pre-restart; **013 lagging reconnect post-restart** (lastKeepalive 07:07; 014/015 active) | WATCH (013 reconnect) |
| Zeek | 284/24h clean | 284/24h clean; **Class A routing ENABLED** (approved) | NO (new capability) |
| Suricata | staged | staged (1 doc) | NO |
| Retention | archives-14d on 08-19+ | **archives-14d on ALL archives indices** (08-07..18 re-attached) | NO (relief) |
| Disk | 84% (node 84.7) | 84% (node 84.7) - relief ~14.4GB projected | NO (watch) |
| DR | S3 uploading | **S3 restore drill PASSED** (checksum-verified) | NO (proof gained) |
| Release | v1.2.0 published | re-verified; P25 bundle staged | NO |
| Sysmon tuning | scripts ready | 014 policy accepted (rc=0); marker/load confirm pending; 013 re-apply pending | NO (in progress) |
| CI/secret | PASS | PASS | NO |
| Config drift | canonical 9 IPs | canonical + integration block synced; running live | NO |

## Risk register (updated)

- 013 reconnect lag post-restart (WATCH - operator check if persistent).
- EID7 cyclic floods (tuning confirmation pending on 013/014).
- Disk at low watermark (relief in motion).
- Blocked: VT/indexer/PVE rotations, NetFlow scope, Redis, Greenbone, canarytokens.

## Verdict

- **No regressions**; routing enabled per approval; DR proof gained; retention relief started.

## No secrets