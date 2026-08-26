# Phase 39 Shuffle Security Certification — SHUFFLE-SEC-39-01

**Report ID:** phase39-20-shuffle-security-report
**Phase:** 39
**Title:** SHUFFLE-SEC-39-01 — Shuffle Exposure Hardening Certification (Arc Summary)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:59:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Record ID:** SHUFFLE-SEC-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-20-shuffle-security-report.md`

---

## 1. Certification Statement

Shuffle exposure hardening (Phase 39 arc) certifies as **PARTIAL-PASS**:
exposure restriction and credential hygiene objectives fully met with live
evidence; transport encryption objective consciously deferred to P40 with
design prepared and risk accepted.

## 2. Control Scorecard

| Control | Objective | Result | Evidence record |
|---|---|---|---|
| Exposure restriction | :3001 reachable only via approved mgmt interface | **MET** — single LISTEN on `192.168.222.149:3001`; loopback & docker0 refuse (rc=7) | FW-39-01, DENY-39-01 |
| Credential rotation | old admin bearer dead, new stored hardened | **MET** — old→401 / new→200 post-restart proof; key file 600 + gitignored | ROT-39-01, INV-39-01 (phase39-07) |
| Authorized functionality | UI + API + workflows work post-change | **MET** — UI 200; API 200 rotated token; 2 workflows; 3 FINISHED real deliveries | AUTHZ-39-01 |
| Persistence | binding survives lifecycle events | **MET (exercised events)** — recreate proven; reboot test follow-up | PERS-39-01 |
| TLS transport | credentials encrypted in transit | **ABSENT** — plaintext HTTP on trusted LAN; deferred P40 w/ prepared design | TLS-39-01 |
| Firewall-based segmentation | n/a on this platform | **IMPOSSIBLE** — no tooling/capability on unprivileged LXC; honestly reframed | FW-39-01 §1 |

## 3. Credential Assurance Summary

- Rotation performed via datastore update + mandatory backend restart (cache
  flush = revocation moment); invalidation empirically proven both directions.
- New key lives only in: `config/shuffle-api-key` (600, gitignored) and `.env`
  consumer line (gitignored). Zero secret values in any report corpus
  (recursion scan phase39-10).
- Old value preserved nowhere under phase control → forward-only posture.

## 4. Logging & Alerting Position

| Capability | State |
|---|---|
| Service logs | available — `docker logs shuffle-backend` / `shuffle-frontend` on demand |
| Auth-failure alerting | **NOT YET** — no watcher/pipeline on Shuffle auth failures; logged as backlog item |
| Access evidence | curl triads + ss snapshots embedded in this arc's records serve as point-in-time audit trail |

## 5. Residual Risks (owned list)

1. **TLS absent** (MED): bearer/password cross LAN in plaintext; accepted
   short-term within trusted mgmt VLAN only; P40 proxy work designed and ready
   (TLS-39-01 §4). Revisit trigger defined.
2. **VLAN-wide reachability** (LOW-MED): anything within `192.168.222.0/24`
   can attempt :3001; accepted as trusted management segment; finer granularity
   requires router ACLs or the future loopback+proxy end-state.
3. **DHCP bind dependency** (LOW-MED): lease change of `.149` breaks the bind
   target; P40 candidate: reservation/static lease + health-script check.
4. **Host reboot unproven** (LOW): recreate persistence proven; reboot
   verification procedure documented in PERS-39-01 §4.
5. **No auth-failure alerting** (LOW): detection gap noted for backlog.
6. **Public-internet claim out of scope** (informational): DENY-39-01 §4
   scopes all blocking claims to host-interface level.

## 6. Ownership & Rollback

| Field | Value |
|---|---|
| Control owner | MCT SOC |
| Technical rollback | restore `ops/backups/docker-compose.shuffle.yml.pre-p39-hardening` → `up -d shuffle-frontend` (~6s downtime envelope); procedure phase39-14 §8 |
| Forward plan | P40: TLS proxy deployment → optional loopback-only final state; reboot drill; auth-alerting hook |
| Baseline reference | phase39-13 (EXP-39-01) before/after table |

## 7. Verdict

**PARTIAL-PASS** — certified deliberately: everything achievable on this
platform was achieved and evidenced; what remains open (TLS) is documented,
designed, risk-accepted, and tracked, not overlooked.
