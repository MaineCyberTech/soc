# Phase 56: TLS Path

**Prompt:** 043-classa-tls
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Verified the proxy certificate/listener for the Shuffle TLS intake without executing any hook. The
`shuffle-tls-proxy` presents a valid (self-signed MCT) cert `CN=shuffle.mgmt`, valid
2026-08-26 → 2036-08-23, on `192.168.222.149:3443`. Important: that listener proxies to the
Shuffle **frontend (UI)**, not the `:5001` backend webhook API. The Class-A Wazuh `hook_url` uses
plaintext `http://shuffle-backend:5001` (internal docker), so the Wazuh→Shuffle hop is NOT
TLS-protected on the wire (internal network only).

## Evidence
- EV-TLS-01 (VERIFIED): `openssl s_client -connect 192.168.222.149:3443` → cert `subject=C=US,O=MCT,CN=shuffle.mgmt`, `issuer=C=US,O=MCT,CN=shuffle.mgmt` (self-signed), `notBefore=Aug 26 00:51:52 2026`, `notAfter=Aug 23 00:51:52 2036`. (TLS layer — certificate inspection only, no HTTP GET.)
- EV-TLS-02 (VERIFIED): `shuffle-tls-proxy` nginx `listen 443 ssl; proxy_pass http://shuffle-frontend:80` (read from `/etc/nginx/conf.d/default.conf`). Listener serves UI, HSTS added. (TLS layer / proxy config.)
- EV-TLS-03 (PARTIAL): The `:3443` interface is bound on `192.168.222.149`, NOT `127.0.0.1` — a `127.0.0.1:3443` probe returns nothing (listener not on loopback). This matches AGENTS.md ("host's .149 TLS interface :3443").
- EV-TLS-04 (VERIFIED): Wazuh→Shuffle Class-A hop is plaintext (`http://shuffle-backend:5001`) — TLS not applied on that intra-docker hop (see 041/042). (REST/Wazuh layer — separate from the external TLS intake.)

## Backup-Rollback
Read-only. No change.

## Stop conditions
Changing TLS posture / cert / exposure is approval-gated (AGENTS.md). Inspection only.

## Limitations
- Cert chain not externally CA-trusted (self-signed MCT) — acceptable for internal mgmt interface.
- We inspected the cert via TLS handshake only; did not send an HTTP request (no webhook probe).

## Verdict rationale
TLS certificate and listener verified live and valid; scope clarified (UI proxy, not webhook
API). Wazuh→Shuffle hop is plaintext-internal. Inspection complete → DONE.
