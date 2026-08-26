# Phase 42 Nosniff Pre-Fix Baseline

**Report ID:** phase42-49-nosniff-baseline
**Phase:** 42
**Title:** NOSNIFF-BASE-42-01 — Duplicate X-Content-Type-Options Documented Value-Blind-Safe (App Header + Proxy Header = 2× nosniff on :3443); Ownership Split Defined (App: Standard Security Headers / Proxy: TLS-Specific HSTS); Dedup Decision Rationale Recorded
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (baseline pre-fix)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-49-nosniff-baseline.md`

---

## 1. Baseline condition (observed this morning, pre-fix)

Curl capture against the exposed management endpoint showed **two**
`X-Content-Type-Options` response headers on every reply:

```
$ curl -skI https://<mgmt-ip>:3443/
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff        ← source 1: proxy add_header
X-Content-Type-Options: nosniff        ← source 2: shuffle-frontend app server
Strict-Transport-Security: max-age=31536000
```

Duplicate response headers are RFC-ambiguous consumer behavior (some clients
take first, some last, some reject) and pollute header-diff baselines. Not
exploitable by itself — but free to fix and worth certifying clean.

## 2. Header sources — which component owns which

| Source | Evidence | Emitted headers |
|---|---|---|
| `shuffle-frontend` (app) | direct curl `127.0.0.1:3001` → `X-Content-Type-Options: nosniff`; present in its `/etc/nginx/nginx.conf(.tmpl)` | nosniff (standard security header set) |
| `shuffle-tls-proxy` (TLS terminator) | host conf `config/shuffle-tls/nginx-shuffle-proxy.conf` carried `add_header X-Content-Type-Options nosniff always;` alongside the HSTS line | nosniff (duplicate) + HSTS |

## 3. Dedup decision rationale

The proxy terminates TLS for an internal-only management UI; its distinct job
is TLS posture (protocols, cert, **HSTS**). Standard security headers are the
application's responsibility and already ship with the Shuffle frontend image
— they survive proxy rebuilds and apply to any future direct exposure path.
Keeping the app copy and removing the proxy copy yields exactly one header,
preserves semantics (`nosniff` is a flag; duplication adds nothing), and keeps
the proxy config minimal to its TLS mandate.

## 4. Risk of removal

None: the header remains present exactly once end-to-end via the app layer;
HSTS stays at the proxy. Regression gate for the fix (report phase42-50):
exactly 1× XCTO + HSTS present + HTTP 200.

Rollback of the baseline state (re-adding the duplicate) documented in
phase42-50 §5 but not desired.
