# Phase 40-25: TLS Decision Arc — Pre-Decision Baseline

**Report ID:** phase40-25-tls-decision-baseline
**Phase:** 40
**Title:** Phase 40-25: Shuffle Management-Plane TLS Baseline Before Closure Decision
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-25-tls-decision-baseline.md`

---

## 1. Binding History

| Era | shuffle-frontend publish | Posture |
|-----|--------------------------|---------|
| Pre-P39 | `0.0.0.0:3001:80` | Plaintext HTTP on all host interfaces — full LAN exposure [VERIFIED per phase39-13] |
| P39 hardening era | `192.168.222.149:3001:80` | Plaintext narrowed to the management IP only (phase39-14 design) — exposure reduced, but transport still cleartext |
| This phase (pre-change) | `192.168.222.149:3001:80` | Same as P39; TLS closure outstanding |

Backend API has been loopback-only (`127.0.0.1:5001`) throughout and is unchanged by this arc.

## 2. Plaintext Path Status at Baseline

At baseline the UI/API path from a LAN operator workstation to Shuffle was:
`http://192.168.222.149:3001` → shuffle-frontend:80 in cleartext. No TLS termination
existed anywhere on that path. The management plane carried both session traffic and
API bearer credentials.

## 3. Firewall / Network-Control Context

The stack runs inside an LXC container with **no NET_ADMIN capability**: no nftables,
no iptables, no host firewall tooling available. Interface-scope binding (publishing to
specific IPs) is therefore the ONLY network-restriction primitive usable at this layer.
Any option requiring firewall enforcement or VPN concentrator infrastructure is out of
scope for this environment.

## 4. Authentication Behavior Over Plaintext (Risk)

Shuffle authenticates with password login plus `Authorization: Bearer <api-key>` calls.
Over the pre-change plaintext path, both the session password and long-lived bearer
tokens traversed the LAN unencrypted, exposing them to passive capture on the management
segment. This is the primary risk driving the arc.

## 5. Existing Proxy / Certificate Options Surveyed

- **cloudflared**: present (`wazuh-cloudflared` container) but scoped exclusively to
  Wazuh dashboard egress; not reusable for an internal LAN management endpoint without
  changing its charter. Rejected for this arc.
- **Internal CA**: none documented in the repo; no issuing infrastructure exists to
  sign a server cert.
- **Enterprise/reverse proxy appliance**: none exists in this stack.
- Conclusion: self-signed certificate + local nginx reverse proxy is the only
  implementable closure without new infrastructure.

## 6. Ownership, Expiry Requirement, Rollback State

- **Owner:** MCT SOC (per AGENTS.md escalation table).
- **Expiry requirement:** the governing TLS decision policy (Phase 40 pack) requires
  any chosen closure to carry a documented certificate expiry horizon with renewal
  ownership named before certification; a 10-year self-signed horizon with an annual
  review cadence satisfies it.
- **Rollback state at baseline:** compose file under git; prior binding preserved as
  backup at `ops/backups/docker-compose.shuffle.yml.pre-p39-hardening`; no TLS
  artifacts existed yet, so rollback = restore publish binding and remove whatever
  proxy service this phase adds.

## 7. Cross-References

Exposure baseline: phase39-13 · Hardening design: phase39-14 · Decision matrix:
phase40-26 · Implementation: phase40-27.
