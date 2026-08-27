# Phase 56: Host HTTPS Probe

**Prompt:** 217-os-host-https
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only host HTTPS probe of `127.0.0.1:9200`. Unauthenticated GET returns `401` (TLS terminates, auth enforced); with operator credentials it returns `200` + cluster metadata. The certificate is presented (TLS working). This is the **Wazuh indexer**; the Shuffle backend OpenSearch is not host-published (see 214/218/219).

## Evidence
- EV-OS-2 (VERIFIED): `curl -sk https://127.0.0.1:9200/` → `401` unauth; with `admin:***` → `200`, `cluster_name=wazuh-cluster`, uuid `OQ_G_ZSIRZWFdJNzkoTeLA`, v7.10.2. TLS cert presented (HTTPS succeeded).
- EV-OS-1 (VERIFIED): plaintext counterpart returns empty reply → confirms TLS-only posture.
- EV-DOCKER-1 (VERIFIED): Wazuh indexer cert/TLS is the `wazuh-cluster` transport; host HTTPS is the correct access path.

## Backup / Rollback
N/A (read-only probe). Credential used from `creds.env` (value never printed).

## Stop conditions
No mutation. TLS/cert changes are gates (run-context §4).

## Limitations
- Target is the Wazuh indexer, not the Shuffle backend (host HTTPS to Shuffle backend is N/A — not published).
- Cert chain/expiry not deeply inspected (only that TLS handshake succeeded + 401/200).

## Verdict rationale
Host HTTPS probe VERIFIED (401→200, TLS working) for the Wazuh indexer. PARTIAL because Shuffle backend is not host-reachable over HTTPS.
