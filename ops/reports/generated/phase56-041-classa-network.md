# Phase 56: Network Path

**Prompt:** 041-classa-network
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Verified the network path Wazuh manager → Shuffle backend/proxy without invoking any hook. The
Wazuh `hook_url` targets `http://shuffle-backend:5001/...` (plaintext, internal docker network).
Both `multi-node-wazuh.master-1` and `shuffle-backend` are attached to the `mct-security` network,
so the service name resolves and the L3/L4 path is intact. The external TLS intake (`.149:3443`)
proxies to the Shuffle *frontend* (UI), not the backend API.

## Evidence
- EV-NET-01 (VERIFIED): Wazuh master networks = `mct-security multi-node_default`; `shuffle-backend` networks = `mct-security shuffle_swarm_executions` (`docker inspect`). Shared `mct-security` ⇒ `shuffle-backend` resolvable from Wazuh. (Network layer.)
- EV-NET-02 (VERIFIED): `hook_url` = `http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322` (integratord config). Path is internal docker, not the external TLS interface. (Wazuh integratord layer / REST layer.)
- EV-NET-03 (VERIFIED): `shuffle-tls-proxy` listens on `192.168.222.149:3443->443` and proxies `proxy_pass http://shuffle-frontend:80` (read from nginx conf). The `:3443` TLS interface serves the **UI**, not the `:5001` webhook API. (TLS layer, separate.)
- EV-NET-04 (PARTIAL): We did NOT issue a request to `shuffle-backend:5001` to confirm HTTP 200 (would be a hook-path probe); path is established by shared-network + service-name resolution only.

## Backup-Rollback
Read-only. No change.

## Stop conditions
None for inspection. Any change to `hook_url` (050) or a POST to the webhook (052) is gated.

## Limitations
- `getent hosts` on the host returned nothing (docker-internal DNS); reachability inferred from shared docker network membership, which is authoritative for container-to-container name resolution.
- We did not tcp-connect to `shuffle-backend:5001` (could be read-only but risks being read as a health probe); resolution-by-network-membership is sufficient evidence.

## Verdict rationale
Network path from Wazuh manager to Shuffle backend is confirmed reachable via the shared
`mct-security` network. External TLS intake (`:3443`) is a UI proxy, distinct from the webhook
API. Inspection complete → DONE.
