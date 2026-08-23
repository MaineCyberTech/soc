# Phase 26 Full System Regression Audit

Date: 2026-08-23

## Post-change state (vs P25)

| Area | P25 | P26 | Regression |
|---|---|---|---|
| Healthcheck | 0 FAIL | 0 FAIL | NO |
| Cluster | green | green (256 shards) | NO |
| Fleet | 3/3 (013 lagging) | **3/3 active (013 reconnected)** | NO (improved) |
| 015 | closeout pending | **CLOSED OUT (PASS)** | NO (improved) |
| Zeek routing | enabled | enabled + **guardrailed** (kill switch proven) | NO (hardened) |
| Disk | 84.7% node | **79.5% node** (below watermark) | NO (improved) |
| Retention | aligned | **deletes observed** (08-07/08/09 gone) | NO (working) |
| DR | config-bundle drill PASS | **snapshot restore drill PASS** (p26-restore) | NO (proof extended) |
| Sysmon | 014 accepted rc=0 | EID7 0/30m both; marker confirm pending | NO (quiet) |
| CI/secret | PASS | PASS | NO |
| Config | canonical + live aligned | integration live; guardrail script added | NO |

## Risk register (updated)

- 013/014 marker confirmation pending (operator check) - EID7 already quiet.
- Dedup idempotency gap (datastore node = UI step; guardrail backstop in place).
- Blocked: VT/indexer/PVE rotations, NetFlow scope, Redis, Greenbone, canarytokens.
- Release: v1.3.0 staged (approval).

## Verdict

- **No regressions**; new capabilities (guardrail, snapshot restore proof) validated.

## No secrets