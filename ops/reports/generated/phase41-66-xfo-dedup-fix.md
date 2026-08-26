# Phase 41 XFO Dedup Fix Record — F-XFO-41-01

**Report ID:** phase41-66-xfo-dedup-fix
**Phase:** 41
**Title:** FIX-XFO-41-01 — Change Record For Today's Header Dedup On The Shuffle TLS Proxy: sed Removal Of The Duplicate `add_header X-Frame-Options SAMEORIGIN` Line From config/shuffle-tls/nginx-shuffle-proxy.conf, Proxy Restart, Verified Before(Dual)/After(Single-DENY) Header Captures, Rollback Procedure Documented (Re-Add Line + Restart)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:37:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-66-xfo-dedup-fix.md`

---

## 1. Change identification

| Field | Value |
|-------|-------|
| Change ID | F-XFO-41-01 |
| Target | Shuffle TLS proxy (container `shuffle-tls-proxy`, :3443→UI) |
| File | `/opt/mct-security-stack/config/shuffle-tls/nginx-shuffle-proxy.conf` |
| Class | Header hygiene — removes duplicate `X-Frame-Options` (closes R-SEC-40-E / F-85-03) |
| Date applied | 2026-08-26 ~04:38Z (file mtime evidence) |

## 2. The edit

Duplicate directive removed (conceptual diff):

```diff
     add_header Strict-Transport-Security "max-age=31536000" always;
     add_header X-Content-Type-Options nosniff always;
-    add_header X-Frame-Options SAMEORIGIN always;
```

Mechanics: targeted `sed` line-delete on the conf, then container restart of the
proxy to load the cleaned config. No other directive touched — verified by reading
the file post-edit (lines 7–8 intact as shown in phase41-65 §2).

## 3. Verification captures (before → after)

Before (P40-85 historical): two XFO headers —

```
X-Frame-Options: DENY         (upstream app)
X-Frame-Options: SAMEORIGIN   (proxy add_header — removed by this fix)
```

After (live this run):

```
$ curl -skI https://192.168.222.149:3443/ | grep -i x-frame
X-Frame-Options: DENY                       ← single header, app-sourced
$ curl -skI … | grep -ci '^x-frame-options:' → 1
HSTS present; nosniff present (×2 layers); HTTP 200
```

## 4. Rollback procedure

If the app ever stops sending its own XFO and frame-protection must come from the
proxy again:

1. Re-insert into the server block of
   `config/shuffle-tls/nginx-shuffle-proxy.conf`:
   `add_header X-Frame-Options SAMEORIGIN always;`
2. Restart the proxy container (same restart used for the fix).
3. Verify with `curl -skI https://192.168.222.149:3443/ | grep -ci '^x-frame-options:'`
   — expect 1 while app omits it, 2 if app also sends (re-creating the original
   condition; prefer fixing at the app layer first).

Rollback is a two-line, sub-minute operation with no data-plane impact.

## 5. Scope note

This fix concerns the Shuffle management UI surface only. The Wazuh dashboard
(:443 loopback) was never part of the duplicate-header finding and is untouched by
this change.
