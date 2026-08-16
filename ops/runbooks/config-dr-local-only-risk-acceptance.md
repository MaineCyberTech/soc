# Config DR - Local-Only Risk Acceptance (Pilot)

Date: 2026-08-16

## Accepted risk

- Wazuh/stack configuration DR is LOCAL-ONLY for the first-client pilot term.
- S3 upload of the config bundle (s3://wazuh/dr/) is blocked by stale DO Spaces
  CLI keys (403).
- Data tier (OpenSearch snapshots) is NOT affected - fully S3-backed.

## Risk statement

If the production host (192.168.222.149) is lost, configs can be restored from:
1. /opt/wazuh-backups/dr-stage/ (daily config bundles, 0600)
2. Git history (compose/config/runbooks)
3. ops/backups/phase2-config bundles

This is acceptable for the pilot because:
- No client configs exist yet (no client engaged).
- Configs change slowly; local bundles are fresh daily.
- The critical data tier (snapshots) is offsite.

## Conditions that trigger re-evaluation

- First client onboarding (client configs become part of the bundle).
- DO Spaces keys refreshed (re-test upload).
- More than 1 host in the stack.

## Owner

- MCT SOC - monitor dr-s3-cron.log; re-test on key refresh.

## No secrets

No secret values printed.
