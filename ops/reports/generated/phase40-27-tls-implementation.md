# Phase 40-27: TLS Implementation Record (TLS-40-01)

**Report ID:** phase40-27-tls-implementation
**Phase:** 40
**Title:** Phase 40-27: Shuffle TLS Closure Implementation — Proxy, Certificate, Backend Restriction
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-27-tls-implementation.md`

---

Implementation window: **2026-08-26T00:51Z–00:58Z**. All steps executed live.

## 1. Step Log

1. **Certificate generated** (~00:51Z): RSA-2048 self-signed cert written to
   `config/shuffle-tls/shuffle-mgmt.{crt,key}`; key set mode `600` (verified:
   `600 user:user`).
2. **nginx reverse proxy added** as compose service `shuffle-tls-proxy`
   (`compose/docker-compose.shuffle.yml:120-131`, image `nginx:1.27-alpine`,
   `restart: unless-stopped`) publishing **192.168.222.149:3443→443**, mounting conf +
   certs read-only, attached to network `mct-security`.
3. **Plaintext closed from LAN**: frontend publish edited in compose from
   `192.168.222.149:3001:80` → `127.0.0.1:3001:80`; frontend recreated from pinned
   digest `ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f…82836`.
4. **Compose-profile gotcha — encountered and fixed**: stack services carry
   `profiles: ["shuffle"]`; a bare `docker compose config -q` failed on `depends_on`
   references to unselected-profile services during validation. Fix: removed the
   stale `depends_on` block; final compose validates clean.
5. Post-change verification session (headers, blocked tests, restart cycle) run at
   01:59Z — outputs embedded in phase40-28/-29/-30.

## 2. Certificate Details

| Field | Value |
|-------|-------|
| Subject / Issuer | `C=US, O=MCT, CN=shuffle.mgmt` (self-signed) |
| Key | RSA 2048-bit, mode 600 |
| SAN | `DNS:shuffle.mgmt, IP Address:192.168.222.149` |
| Validity | notBefore 2026-08-26T00:51:52Z → **notAfter 2036-08-23T00:51:52Z** |
| SHA-256 fingerprint | `33:BB:52:10:81:25:7E:4E:43:43:97:CB:7E:4E:9B:9A:CA:E7:E4:04:BC:64:E0:90:26:09:81:D1:78:DB:E2:F5` |
| Files | `config/shuffle-tls/shuffle-mgmt.crt` (664), `config/shuffle-tls/shuffle-mgmt.key` (600) |

## 3. Secure Headers / TLS Settings

From `config/shuffle-tls/nginx-shuffle-proxy.conf`: `ssl_protocols TLSv1.2 TLSv1.3`;
`Strict-Transport-Security "max-age=31536000" always`; `X-Frame-Options SAMEORIGIN
always`; `X-Content-Type-Options nosniff always`; `X-Forwarded-Proto https`;
`proxy_read_timeout 300s`; upstream `http://shuffle-frontend:80`.

Observed live response headers (curl -skI https://192.168.222.149:3443/, 01:59Z):
`HTTP/1.1 200 OK`, `X-Frame-Options: DENY` + `X-Content-Type-Options: nosniff`
(upstream app), plus proxy-added `X-Frame-Options: SAMEORIGIN`,
`X-Content-Type-Options: nosniff`, `Strict-Transport-Security: max-age=31536000`.
Note (honest observation): duplicate XFO/nosniff headers result from app+proxy both
setting them; harmless, recorded for the next review.

Negotiated live: `TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384` (openssl s_client).

## 4. Backend Restriction

- shuffle-backend: `127.0.0.1:5001` — unchanged, loopback only.
- shuffle-frontend: now `127.0.0.1:3001` — loopback-only for HTTP; the ONLY LAN-facing
  listener on the management plane is the TLS proxy on 192.168.222.149:3443.

Healthcheck method used throughout: `curl -sk -o /dev/null -w '%{http_code}'
https://192.168.222.149:3443/` → `200` (7 ms class).

## 5. Renewal Ownership and Procedure

**Owner: MCT SOC.** Review cadence annual; cert horizon ends 2036-08-23.
Regeneration (single command, then restart proxy):

```
openssl req -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes \
  -keyout config/shuffle-tls/shuffle-mgmt.key \
  -out config/shuffle-tls/shuffle-mgmt.crt \
  -subj "/C=US/O=MCT/CN=shuffle.mgmt" \
  -addext "subjectAltName=DNS:shuffle.mgmt,IP:192.168.222.149"
docker restart shuffle-tls-proxy && chmod 600 config/shuffle-tls/shuffle-mgmt.key
```

After renewal, capture the new SHA-256 fingerprint (see phase40-31 pinning procedure).

## 6. Rollback Steps

1. Restore prior binding: revert frontend publish to `192.168.222.149:3001:80` or
   restore `ops/backups/docker-compose.shuffle.yml.pre-p39-hardening` era binding.
2. Remove the `shuffle-tls-proxy` service block from compose and
   `docker compose up -d --remove-orphans` (scoped).
3. Certs under `config/shuffle-tls/` may remain; they are inert without the proxy.
