# Runbook — Restore Wazuh→Shuffle→IRIS Delivery (OW-65-01)

**Status:** OPEN. Remediation defined; requires Shuffle admin (beyond agent RBAC) + owner sign-off.
**Risk:** Low–Medium. All steps are reversible; rollback restores `ossec.conf` to sha
`1893ae0ee4b93e3132f8d9acf2e6fec1101f2f20ff04871cef888c9aab37f2d4` (root:wazuh 640) and disconnects the manager from the Shuffle network.

## Root causes (discovered Phase 65)
1. **Network isolation** — live `ossec.conf` `<integration>` hook_url `http://shuffle-backend:5001/...`
   uses a swarm service name not resolvable from the manager container; every gateway IP returned
   HTTP 000 (port 5001 not exposed to the manager bridge).
2. **Placeholder API key** — live `<api_key>` = `SHUFFLE_API_KEY_PLACEHOLDER`.
3. **Webhook not linked** — `webhook_e3fec000` is not attached to the Class-A workflow
   `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`, so a successful POST creates no IRIS alert.

## Remediation (permanent)
**A. Reachability (choose one):**
- *Preferred (no Shuffle restart):* add the manager container to the `mct-security` network
  persistently in its compose (`networks: [..., mct-security]`), OR
- publish Shuffle `5001` on `0.0.0.0` in `compose/docker-compose.shuffle.yml`
  (`"0.0.0.0:5001:5001"`) and redeploy the Shuffle stack.
- Then set `<hook_url>` to `http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000-...`
  (already the value; only needs name resolution).

**B. API key:** replace `SHUFFLE_API_KEY_PLACEHOLDER` with the real Shuffle API key
(source: gitignored `.env` / `config/shuffle-api-key`), via the staged-deploy contract
(owner=root, group=wazuh, mode=640, xml_valid, backup sha, rollback) — NOT committed.

**C. Link webhook → Class-A workflow:** in Shuffle (UI or admin API), attach
`webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` as a trigger to workflow
`c6b3fcd8-13e5-44a8-a818-024e4ae4422b` (the IRIS-creating lane). Requires Shuffle admin token.

## Verify
1. Restart integratord (watchdog) so it re-reads `ossec.conf`.
2. Generate a genuine Wazuh alert (monitored localfile + rule 100065, or a real high-severity event).
3. Confirm `wazuh-integratord` logs `Response [200]` to the webhook AND a new IRIS alert appears
   (independent `GET /alerts/<id>` read-back with governed token).

## Rollback
- Restore `ossec.conf` from the pre-change backup (root:wazuh 640, sha `1893ae…`) + integratord-only
  restart via watchdog.
- Revert compose network/publish change and redeploy; disconnect `mct-security` if added ad-hoc.
