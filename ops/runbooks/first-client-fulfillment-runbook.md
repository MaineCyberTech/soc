# First Client Fulfillment Runbook (Phase 9)

Internal delivery runbook for the first external client pilot.

## 1. Intake workflow

1. Receive signed authorization bundle + client intake form.
2. Create client slug: `client-<short-name>`.
3. Register client contacts in escalation matrix.
4. Create level.io client group + Wazuh agent group `client-<slug>`.
5. Record scope (endpoint list, scan targets) in client-zero-asset-scope.

## 2. Endpoint onboarding (Linux)

1. Deploy agent: `install-wazuh-linux.sh` with:
   - WAZUH_MANAGER=142.105.190.25
   - WAZUH_AGENT_GROUP=client-<slug>
   - WAZUH_REG_PASSWORD (encrypted level.io var, from ops/creds.env)
2. Verify: `verify-endpoint-linux-macos.sh` (root) -> expect PASS; alert on fail.
3. Confirm agent Active in Wazuh dashboard (agents page, group filter).
4. Optional: Velociraptor client enroll (per velociraptor-client-rollout).

## 3. Verification steps

- [ ] Agent Active (agent_control -l)
- [ ] FIM scan started (first baseline)
- [ ] Syscollector inventory present
- [ ] Auth events flowing (indexer query agent.id)
- [ ] No registration failures (master authd log)

## 4. Scan scheduling (if authorized)

1. Create Greenbone target for client IPs (GMP pattern in
   integrations/greenbone/phase9-scheduled-scan-config.md).
2. Create task + schedule (weekly, mirror MCT-lab-weekly-sun-0600).
3. Export report; generate client-safe vulnerability review.

## 5. Report generation

1. Monthly: run generate-monthly-scorecard.py (client-safe output).
2. Attach vulnerability section (if scanned).
3. Store in reporting/output/client/phase9-<client>-scorecard-<month>.md.

## 6. Escalation and issue handling

1. Alerts lvl 9+ -> IRIS case (auto via Shuffle where configured).
2. Follow escalation matrix; log all actions in IRIS.
3. L3/L4 -> post-incident summary within 48h.

## 7. Offboarding fallback

1. Remove agent: uninstall-endpoint-linux-macos.sh (root).
2. Remove client group + level.io group.
3. Delete scan target/task in Greenbone (or disable).
4. Revoke any client-specific tokens/webhooks.
5. Archive final scorecard + evidence (client data retention policy).

## 8. Readiness

- See phase9-first-client-fulfillment-readiness.md for the current readiness gate.

## No secrets

No secret values printed.
