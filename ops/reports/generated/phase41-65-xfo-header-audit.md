# Phase 41 XFO Header Audit — Pre/Post, Duplicate Eliminated

**Report ID:** phase41-65-xfo-header-audit
**Phase:** 41
**Title:** AUD-XFO-41-01 — X-Frame-Options Pre/Post Audit Closed Same-Day: Duplicate Source Identified (Shuffle UI DENY Upstream + TLS-Proxy SAMEORIGIN add_header, Captured In P40-85 F-85-03/R-SEC-40-E), Proxy Line Removed Today, Live Curl Now Shows EXACTLY ONE XFO (DENY, From App) With HSTS And nosniff Retained And UI Loading HTTP 200 — Residual P40 Finding Dispositioned
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:36:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-65-xfo-header-audit.md`

---

## 1. Before-state (historical capture, phase40-85 §3)

```
$ curl -skI https://192.168.222.149:3443/
HTTP/1.1 200 OK
Strict-Transport-Security: max-age=31536000        ← proxy add_header (always)
X-Frame-Options: DENY                              ← upstream Shuffle UI header
X-Frame-Options: SAMEORIGIN                        ← proxy add_header (duplicate — F-85-03)
X-Content-Type-Options: nosniff (×2 layers)
```

Two conflicting XFO values on one response (DENY vs SAMEORIGIN): per RFC behavior
browsers apply the strictest (DENY), but duplicate security headers are drift bait.
Logged as residual R-SEC-40-E "cosmetic-policy overlap; P41 cleanup".

## 2. Fix applied today

Proxy `add_header ... X-Frame-Options SAMEORIGIN` line removed from the Shuffle TLS
proxy config; proxy reloaded. Post-fix config state:

```
config/shuffle-tls/nginx-shuffle-proxy.conf   (mtime Aug 26 04:38)
    line 7: add_header Strict-Transport-Security "max-age=31536000" always;
    line 8: add_header X-Content-Type-Options nosniff always;
    (no X-Frame-Options directive remains in proxy config)
```

Single-source-of-truth principle: the app's DENY is authoritative; the proxy adds
transport-layer headers only.

## 3. After-state (live curl this run, ~05:18Z)

```
$ curl -skI https://192.168.222.149:3443/
HTTP/1.1 200 OK
Server: nginx/1.27.5
...
X-Frame-Options: DENY                    ← exactly ONE occurrence now (from app)
X-Content-Type-Options: nosniff          ← app layer
...
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff          ← proxy layer (retained)
```

Header count check:

```
$ curl -skI … | grep -ci '^x-frame-options:'
1
$ curl -sk -o /dev/null -w '%{http_code}' …
200
```

## 4. Audit verdict

| Check | Result |
|-------|--------|
| Exactly one XFO | **PASS (count=1, value=DENY, source=app)** |
| HSTS retained | PASS (`max-age=31536000`, always) |
| nosniff retained (both layers) | PASS |
| UI regression | PASS (HTTP 200; content served) |
| R-SEC-40-E disposition | CLOSED |

Full fix mechanics + rollback path: phase41-66 (F-XFO-41-01).
