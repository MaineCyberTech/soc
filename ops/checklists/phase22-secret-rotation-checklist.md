# Phase 22 Secret Rotation Checklist

Owner: SOC operator. Approval-gated. Record evidence in ops/reports per item. No values printed.

## A. Indexer/admin password family (coordinated rotation)

- [ ] Approval for rotation window (change control)
- [ ] New value generated via secure channel (operator)
- [ ] Indexer internal users updated in-cluster (admin user)
- [ ] ops/creds.env updated (WAZUH_ADMIN_PASSWORD, WAZUH_WUI_PASSWORD)
- [ ] wazuh-docker .env updated (INDEXER_PASSWORD, API_PASSWORD, DASHBOARD_PASSWORD,
      EF_OUTPUT_OPENSEARCH_PASSWORD, ES_PASS)
- [ ] Dashboard wazuh.yml updated (WUI password)
- [ ] Restart indexers -> dashboard -> verify green cluster, dashboard login, API token
- [ ] Verify elastiflow + flow-relay outputs fresh (index growth)
- [ ] Verify ops scripts (endpoint-count, alert-volume) RC 0
- [ ] Rollback ready: prior values retained in creds.env backup + .env backup
- [ ] Record evidence report

## B. VirusTotal key

- [ ] Obtain replacement key (VirusTotal account) - BLOCKED until provided
- [ ] Render key into wazuh_manager.conf via script (env-sourced, no tracked literal)
- [ ] Restart analysisd; verify VT integration on test hash
- [ ] Revoke old key after 24h clean

## C. Cloudflare tunnel token

- [ ] New token -> .env.cloudflare (600) -> recreate tunnel container -> verify 1-2 tunnel endpoints

## D. SO / PVE SSH + DO Spaces + registration

- [ ] Per-owner rotation, update ops/creds.env, verify one dependent automation each

## Notes

- After each rotation: secret scan + spot-check reports for value leakage.
- Keep skip-worktree protections on wazuh-docker tracked files; env abstraction (22.16) reduces
  reliance on them.

## No secrets