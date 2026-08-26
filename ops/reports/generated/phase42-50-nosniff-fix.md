# Phase 42 Nosniff Fix Record

**Report ID:** phase42-50-nosniff-fix
**Phase:** 42
**Title:** HDR-42-01 — Proxy XCTO Line Removed (sed, Line 8) And Proxy Reloaded; Post-Fix Curl Proves Exactly ONE X-Content-Type-Options + HSTS Retained + HTTP 200; Rollback Procedure Recorded
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:01:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (fixed, verified live)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-50-nosniff-fix.md`

---

## 1. Change applied — HDR-42-01

File: `/opt/mct-security-stack/config/shuffle-tls/nginx-shuffle-proxy.conf`
(bind-mounted into `shuffle-tls-proxy:/etc/nginx/conf.d/default.conf`).

Removed line (sed one-liner this morning):

```diff
     add_header Strict-Transport-Security "max-age=31536000" always;
-    add_header X-Content-Type-Options nosniff always;
     location / {
```

Corroborated by the repo working tree (uncommitted by design, reversible):

```
$ git -C /opt/mct-security-stack diff HEAD -- config/shuffle-tls/nginx-shuffle-proxy.conf
@@ -5,7 +5,6 @@
-    add_header X-Content-Type-Options nosniff always;
```

Proxy reloaded/restarted after edit (container `Up About an hour`, nginx
worker processes respawned 07:51:20Z per container log).

## 2. Post-fix verification [VERIFIED live]

```
$ curl -skI https://<mgmt-ip>:3443/
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff          ← grep -c '^x-content-type-options' = 1
Strict-Transport-Security: max-age=31536000
```

- Exactly **one** XCTO header (counted = 1).
- HSTS retained at proxy.
- HTTP 200 regression check passed (UI reachable through TLS path).
- Inside the proxy container `grep -rn "X-Content" /etc/nginx/` → empty;
  frontend still emits its own header (verified directly on :3001).

## 3. Residual state

Header ownership now matches phase42-49 §3 split: app = standard security
headers, proxy = TLS/HSTS only. No functional or security regression observed;
delivery lane unaffected (monitor cycles green post-change).

## 4. Config backup note

No separate file backup taken — change is a single-line deletion tracked by
the stack git repo working tree (see §1 diff), which IS the restore artifact.

## 5. Rollback procedure

1. Re-add the line after the HSTS `add_header` in
   `config/shuffle-tls/nginx-shuffle-proxy.conf`:
   `add_header X-Content-Type-Options nosniff always;`
   (or `git checkout -- config/shuffle-tls/nginx-shuffle-proxy.conf`).
2. Restart proxy: `docker restart shuffle-tls-proxy`.
3. Re-verify: curl returns 2× XCTO (baseline state of phase42-49).
