# Phase 40-31: TLS Risk Acceptance — NOT REQUIRED (Template Record)

**Report ID:** phase40-31-tls-risk-acceptance
**Phase:** 40
**Title:** Phase 40-31: Signed Risk Acceptance Status NOT REQUIRED — Outcome #1 Achieved; TOFU Residual + Pinning Control
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:01:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-31-tls-risk-acceptance.md`

---

## 1. Status: NOT REQUIRED

A signed risk acceptance for plaintext exposure is **NOT REQUIRED**: outcome #1
(TLS reverse proxy) was implemented and verified (phase40-27/-28/-29), so the
condition that would require a signed acceptance — unprotected transport of
credentials on the management plane — no longer exists. This record is retained as a
**template-only section** documenting why the acceptance lane stays empty, so future
arcs do not re-litigate it silently.

## 2. Residual Risk (honest register)

| Residual | Description | Compensating control |
|----------|-------------|---------------------|
| Self-signed cert → Trust-On-First-Use | First browser visit shows a certificate warning; an operator accepting blindly could be MITM'd on first use | Fingerprint pinning procedure below (§3); manual cert import for workstations |
| Scope honesty | LAN-scope only; no public-internet claims made (phase40-29 §3) | Router/firewall posture remains owner-side responsibility |
| Host-reboot persistence unproven | Tracked, not accepted | Deferred explicitly to prompt 69 approved window (phase40-30 §3) |

## 3. Fingerprint Pinning Instructions (compensating control)

Live-captured SHA-256 fingerprint of the deployed certificate:

```
$ openssl x509 -in config/shuffle-tls/shuffle-mgmt.crt -noout -fingerprint -sha256
sha256 Fingerprint=33:BB:52:10:81:25:7E:4E:43:43:97:CB:7E:4E:9B:9A:CA:E7:E4:04:BC:64:E0:90:26:09:81:D1:78:DB:E2:F5
```

To pin from a workstation before trusting the endpoint:

```
openssl s_client -connect 192.168.222.149:3443 </dev/null 2>/dev/null \
  | openssl x509 -noout -fingerprint -sha256
```

Compare against the value above (or its post-renewal successor); accept/trust only on
exact match. After any renewal (phase40-27 §5), capture the new fingerprint and
re-issue this comparison to all operators.

## 4. If Acceptance Ever Becomes Required

Should outcome #1 ever regress (proxy removed, binding reverted), the empty template
activates: draft acceptance must name residual plaintext risk, compensating monitoring,
expiry of the acceptance, and MCT SOC signature — per AGENTS.md approval gates.

Cross-refs: options decision phase40-26 · certification phase40-32.
