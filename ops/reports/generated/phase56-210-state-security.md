# Phase 56: Security

**Prompt:** 210-state-security
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only security inspection of input/auth/logs for the packet path: the IRIS token is loaded value-blind from approved runtime files (no secret in code/repo), token files present at both the service-scoped secret mount and the legacy fallback, and the webhook is TLS-terminated at `:3443`. The `suricata-eve-in` trigger `auth` field is empty (no request signature), relying on TLS + network isolation. No mutation performed.

**Layers (kept separate per overlay):**
- REST: Shuffle API (`/api/v1/...`) queried with `Authorization: Bearer` (key read programmatically, never printed). VERIFIED reachable.
- Webhook: `suricata-eve-in` (`736b7410`) `running`, `auth:""`. VERIFIED (no signature verification; defense = TLS :3443 + LAN isolation).
- Wazuh integratord: NOT in scope for this prompt (Class-A `eb937a37` absent from live triggers — see EV-TRIG-1; separate from packet path).
- Sensor-origin: NOT mutated; Suricata EVE forwarder should POST to local `:3443` TLS (per AGENTS.md known-blocker note). Read-only only.

## Evidence
- EV-SEC-1 (VERIFIED): IRIS token file exists at `/run/secrets/iris-shuffle.env` (service-scoped Swarm secret `iris-shuffle-env`, id `4vpfvc92ice01x52qtc69yi2c`) AND legacy `/shuffle-files/iris-shuffle.env`. Value never read/printed. `load_iris_token()` reads value-blind (code lines 8-23).
- EV-DOCKER-1 (VERIFIED): secret `iris-shuffle-env` present, granted to `shuffle-tools` only (Phase 54/55 carryover).
- EV-TRIG-1 (VERIFIED): live triggers show ONLY `suricata-eve-in` (`736b7410`) `running`; Class-A `eb937a37` (`wazuh-high-severity-to-iris`) ABSENT from live trigger list → corroborates Phase 55 Wazuh→IRIS drift (separate from packet path security).
- EV-TRIG-2 (VERIFIED): `suricata-eve-in` trigger `auth:""` — webhook accepts unauthenticated POSTs; protected by TLS :3443 + network controls only.
- EV-WF-2 (VERIFIED): IRIS POST uses `Authorization: Bearer <token>` + `verify=False` (no cert pinning) to `https://iriswebapp_nginx:8443/alerts/add`.

## Backup / Rollback
N/A (read-only). Token rotation is approval-gated (AGENTS.md).

## Stop conditions
No mutation this pack. TLS/exposure changes, token rotation, Wazuh apply are gates (run-context §4). Read-only inspection only.

## Limitations
- `auth:""` on the webhook is a noted exposure (mitigated by TLS + isolation, not by request signing).
- IRIS TLS `verify=False` means no certificate pinning (internal-network trust assumption).
- Wazuh→IRIS path security not assessable live (trigger absent).

## Verdict rationale
Input/auth/log evidence VERIFIED read-only across REST/webhook/token layers; live hardening gated. PARTIAL.
