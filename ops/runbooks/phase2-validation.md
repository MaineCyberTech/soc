# Stack Validation Runbook

Purpose: verify nothing broke during stack build-out and that new services behave as intended.

## When to run

- After any phase deployment.
- After rollback.
- Weekly (cron) for drift detection.

## 1. Existing stack health

```bash
/opt/mct-security-stack/ops/scripts/phase2-healthcheck.sh --verbose
```

Checks: Wazuh containers, indexer cluster green/yellow, Wazuh API + indexer localhost-only, Elastiflow indexing, flow-relay, cloudflared, Security Onion reachability, stack services, recent backups.

## 2. Port audit

```bash
/opt/mct-security-stack/ops/scripts/phase2-port-audit.sh
```

Verifies: no unexpected public ports, planned ports documented in `ops/reports/ports.md`, Wazuh API/indexer not publicly bound.

## 3. Integration smoke test

```bash
/opt/mct-security-stack/ops/scripts/phase2-integration-smoke-test.sh
```

Verifies each deployed route responds; skips non-deployed services. Full route payload tests: `integrations/test-events.md`.

## 4. Acceptance criteria

- [ ] Existing Wazuh data flows not broken (cluster health, alerts still indexing, flow relay still sending)
- [ ] New services reachable only as intended (loopback / Cloudflare Access)
- [ ] Test alerts flow through planned routes (verified 2026-08-10: flow Class A/B → Shuffle → IRIS, canary → monitor → IRIS, Greenbone alert → webhook)
- [ ] Rollback steps verified (see `phase2-rollback.md`)
- [ ] Backups still running (config + snapshot cron)

## 5. Recording

Record results in `ops/reports/validation-<timestamp>.md` using `ops/reports/acceptance-test-template.md`. Attach pass/fail per check; include evidence (HTTP codes, counts).

## 6. Weekly cron suggestion

```bash
30 06 * * 1 /opt/mct-security-stack/ops/scripts/phase2-healthcheck.sh >> /opt/mct-security-stack/ops/reports/healthcheck-weekly.log 2>&1
```

Review the log weekly in the internal security review.
