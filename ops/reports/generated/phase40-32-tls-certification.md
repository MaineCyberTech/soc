# Phase 40-32: TLS Arc Certification (TLS-CERT-40-01)

**Report ID:** phase40-32-tls-certification
**Phase:** 40
**Title:** Phase 40-32: Shuffle Management-Plane TLS Closure — Certification PASS (Outcome #1)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:02:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-32-tls-certification.md`

---

## 1. Certification Verdict

**PASS** under outcome #1: protected transport (TLSv1.2/1.3 reverse proxy) is
implemented, verified live, and plaintext is closed from LAN interfaces.

## 2. Evidence Register

| Dimension | Verdict | Evidence |
|-----------|---------|----------|
| Protected transport implemented | **VERIFIED** | phase40-27; `https://192.168.222.149:3443` → 200 in ~6–7 ms; negotiated TLSv1.3 / TLS_AES_256_GCM_SHA384 |
| Authorized path | **VERIFIED** | AUTHZ-40-02 (phase40-28): UI 200; authenticated API `GET /api/v1/workflows` = 200 listing 2 workflows (`wazuh-high-severity-to-iris`, `wazuh-flow-classb-to-iris`); HSTS + XFO + nosniff headers present |
| Blocked paths | **VERIFIED (scoped)** | DENY-40-02 (phase40-29): LAN plaintext :3001 refused (curl exit 7); bridge-source 3443 refused; public-internet reachability expressly not claimed from inside LXC |
| Persistence | **VERIFIED** (reboot deferred) | PERS-40-02 (phase40-30): compose-defined; frontend recreate survived mid-op; live proxy restart cycle at 01:59:31Z → 200; host reboot → prompt 69 window |
| Risk acceptance | **NOT REQUIRED** | Outcome #1 achieved; TOFU residual with fingerprint-pinning control (phase40-31) |

## 3. Logging

nginx access logs are captured in container logs. Sample line:

```
192.168.222.149 - - [26/Aug/2026:00:55:29 +0000] "GET / HTTP/1.1" 200 577 "-" "curl/8.14.1" "-"
```

## 4. Final Listener-State Proof Block (live, 2026-08-26T01:59Z)

```
$ ss -tlnp | grep -E ':(3443|3001|5001)\b'
LISTEN 0 4096  127.0.0.1:5001          0.0.0.0:*     # shuffle-backend (unchanged)
LISTEN 0 4096  192.168.222.149:3443    0.0.0.0:*     # shuffle-tls-proxy (only LAN face)
LISTEN 0 4096  127.0.0.1:3001          0.0.0.0:*     # shuffle-frontend (loopback recovery)
```

## 5. Ownership and Cadence

- **Ownership:** MCT SOC (SOAR ops).
- **Next review:** Phase 41; certificate review cadence annual (horizon 2036-08-23;
  renewal procedure inline in phase40-27 §5).

## 6. Rollback Proven-Documented

Rollback steps recorded in phase40-27 §6 (restore pre-P39-era binding backup or revert
publish; remove proxy service; certs inert). No rollback exercised — none required.

## 7. Open Items Carried Forward

1. Host-reboot persistence test → prompt 69 approved restart window.
2. Duplicate XFO/nosniff headers (app+proxy) → cosmetic cleanup candidate, Phase 41.
3. Workstation cert import / pinning rollout per phase40-31 §3.

## 8. Supersession Statement

This report supersedes the open blocker note "Shuffle LAN exposure without TLS"
(phase39-14 design reference) for the management plane. It stands until a newer final
supersedes it; historical reports are never rewritten in place.
