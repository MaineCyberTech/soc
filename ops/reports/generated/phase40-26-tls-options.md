# Phase 40-26: TLS Options Matrix and Decision

**Report ID:** phase40-26-tls-options
**Phase:** 40
**Title:** Phase 40-26: Shuffle TLS Closure — Options Evaluated, Outcome #1 Selected and IMPLEMENTED
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-26-tls-options.md`

---

## 1. Options Matrix

| Option | Description | Feasibility here | Verdict |
|--------|-------------|------------------|---------|
| **A. TLS reverse proxy + self-signed cert** | nginx terminates TLSv1.2/1.3 on mgmt IP :3443, proxies to frontend; plaintext publish pulled back to loopback | Fully feasible inside LXC constraints (no NET_ADMIN needed); uses existing docker/compose primitives | **CHOSEN — IMPLEMENTED ✓** |
| B. Enterprise proxy / existing cloudflared | Route management UI through an enterprise proxy or the existing `wazuh-cloudflared` tunnel | No enterprise proxy exists in this stack; cloudflared is chartered to Wazuh dashboard egress only | N/A — none exists |
| C. VPN-only path | Restrict access behind a VPN concentrator; no LAN listener at all | Requires VPN infrastructure outside this LXC/environment | Out of scope — infra absent |
| D. Signed risk acceptance of plaintext | Keep cleartext, document formal acceptance | Only legitimate if A–C all impossible | **NOT REQUIRED** — A achieved, so there is nothing residual to accept at transport level |

## 2. Decision Statement

**Outcome #1 selected** per the TLS decision policy governing this arc (Phase 40 pack):
protected transport via Option A, implemented and verified in the same session
(2026-08-26T00:51Z–00:58Z). The pack permits exactly two closures; outcome #1 was
executed, so outcome #2 (signed acceptance of residual plaintext) is moot.

**No silent deferral occurred:** the decision was made, applied, and evidenced within
this phase rather than parked. Residual items that genuinely remain (self-signed trust,
host-reboot test scope) are tracked explicitly in phase40-31 and phase40-30/prompt-69.

## 3. Why A Satisfies the Policy

- Closes plaintext from LAN interfaces (only `127.0.0.1:3001` remains, for emergency
  SSH-tunnel recovery).
- Provides TLSv1.2/1.3 termination with HSTS on the management path.
- Requires no capabilities this LXC lacks and no new third-party systems.
- Carries named ownership (MCT SOC), a 10-year expiry horizon, and an inline renewal
  procedure (phase40-27 §5).

## 4. Cross-References

Baseline: phase40-25 · Implementation record: phase40-27 · Authorized/blocked tests:
phase40-28, phase40-29 · Certification: phase40-32.
