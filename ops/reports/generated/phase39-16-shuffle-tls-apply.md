# Phase 39 Shuffle TLS Apply Record — TLS-39-01

**Report ID:** phase39-16-shuffle-tls-apply
**Phase:** 39
**Title:** TLS-39-01 — TLS Termination: NOT APPLIED (DEFERRED to P40) With Prepared Design
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:55:00Z
**Classification:** INTERNAL
**Status:** DEFERRED (P40)
**Record ID:** TLS-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-16-shuffle-tls-apply.md`

---

## 1. Current TLS Status

**NOT APPLIED.** The Shuffle frontend serves plaintext HTTP on
`192.168.222.149:3001`. There is no reverse proxy on this LXC guest. A
cloudflared tunnel exists in this stack but terminates Wazuh alerts only — it
was deliberately **not extended** to Shuffle in this phase.

## 2. Why Deferred (explicit list)

1. **No proxy deployed yet**: no nginx/caddy/traefik exists on this LXC; adding
   one is a new service introduction requiring its own review, not a side
   effect of a bind change.
2. **Certificate decision unresolved**: self-signed (browser-warning friction,
   manual trust distribution) vs internal CA (requires CA availability and
   issuance policy). No decision authority consulted within this window.
3. **Operator approval pending**: switching operators to `https://…:3001` with
   possible cert warnings changes daily workflow; sign-off required before
   flipping transport.
4. **Scope discipline**: Phase-39 arc already carried rotation + invalidation +
   exposure restriction; bundling a new daemon into the same window would blur
   rollback boundaries.

## 3. Risk Accepted Short-Term

Admin bearer token and UI password traverse the trusted management LAN
(`192.168.222.0/24`) in plaintext HTTP. Accepted **temporarily** under the
interface-binding control; explicitly tracked as P40 work item. Any use of
Shuffle from outside the trusted LAN segment before P40 lands is prohibited.

## 4. Prepared Design (for P40 execution)

### 4.1 Topology

```
operator browser ──https──> LXC :443 (proxy, TLS termination)
                              └──http──> shuffle-frontend:80 (bind reduced
                                         or kept .149-only during transition)
backend :5001 stays loopback-only — NEVER exposed by the proxy beyond what
frontend itself already reaches internally.
```

Candidate proxies: caddy (simplest auto-cert) or nginx (already-familiar
config surface). One of the two, not both.

### 4.2 Certificate ownership & renewal

- Option A self-signed: 825-day cert, SAN = `192.168.222.149` + hostname;
  renewal = regenerate + reload proxy + redistribute trust anchor; document in
  ops runbook with calendar reminder at T-30d.
- Option B internal CA: short-lived certs (90d); renewal automated via existing
  CA tooling if present, else scripted CSR/renew hook; proxy reload on success
  only (old cert retained until new validates).
- Either way: key file mode 600, gitignored, never printed to reports.

### 4.3 Header baseline (sample)

```nginx
add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
```

HSTS note: only enable once https is stable, since HSTS pins operators to TLS.

### 4.4 Exposure end-state

After proxy stabilizes: frontend publish drops to `127.0.0.1:3001:80` (loopback)
with proxy as sole LAN listener on :443 — completing the O2 option deferred in
DES-39-01. Backend remains unexposed throughout; nothing in this design touches
5001's loopback bind.

### 4.5 Rollback (from future TLS state)

Remove/disable proxy unit → restore `.149` bind (or keep it, since it is the
current proven state) → `up -d shuffle-frontend`. Operators revert to
`http://192.168.222.149:3001/`. Downtime ≈ proxy stop + frontend no-op.

## 5. Acceptance Signature Block

| Field | Value |
|---|---|
| Deferred by | opencode/ox-alpha, Phase-39 arc |
| Tracked as | P40 backlog item (TLS proxy for Shuffle frontend) |
| Interim compensating controls | interface-only bind (FW-39-01), rotated credential (ROT-39-01), trusted-LAN-only reachability |
| Revisit trigger | P40 planning, OR any requirement to access Shuffle beyond 192.168.222.0/24 |
