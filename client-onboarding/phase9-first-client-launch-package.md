# Phase 9 First Client Launch Package

Client-safe. Updates Phase 8 package with Phase 9 validated capabilities.

## Service package

- **Managed Security Monitoring - Standard** (Linux endpoints first)
- Optional add-ons (with signed authorization): Vulnerability Management
  (Greenbone), Canary/Deception (post T1 validation)

## Scope and exclusions

| In scope | Excluded |
|---|---|
| Linux endpoints (Wazuh agent: FIM, syscollector, logs, auth events) | Windows endpoints (Windows pilot tuning in progress - not client-ready) |
| Alert monitoring + escalation (24x7 SOC, lvl 9+ triage) | Automated blocking (manual approval only) |
| Monthly scorecard (client-safe) | Broad agent rollout beyond approved endpoints |
| Vulnerability scanning (Discovery config, authorized targets only) | Invasive scans without signed authorization |
| Incident response (manual containment per runbook) | Public dashboard exposure |

## Capability status (Phase 9 validated)

| Capability | Status |
|---|---|
| Wazuh stack (master/worker/indexer/dashboard) | OPERATIONAL (0 FAIL health) |
| Linux endpoint pilot (agent 011 lab + docker-host + portal) | VALIDATED |
| Alert path: canary -> rule 121014 -> Shuffle -> IRIS | VALIDATED (Phase 9 re-verified after fix) |
| Greenbone recurring schedule + report | OPERATIONAL (weekly lab schedule created) |
| Backup/DR (snapshots local+S3) | OPERATIONAL (34 S3 snapshots) |
| Velociraptor hunt capability | VALIDATED (Windows client enrolled + hunt) |
| Canarytokens hosted T1 | PENDING (account) - not client-facing yet |

## Endpoint deployment plan (Linux)

1. level.io group `client-<slug>` created first.
2. Deploy via install-wazuh-linux.sh (WAZUH_MANAGER=142.105.190.25,
   WAZUH_REG_PASSWORD encrypted var, agent group).
3. Verify with verify-endpoint-linux-macos.sh (root) -> alert on non-zero.
4. Confirm agent Active in Wazuh dashboard.
5. Set group-based rules/tuning per client profile.

## Scan scope (if authorized)

- Greenbone Discovery scan of client internet-facing IPs (signed authorization).
- Cadence: weekly (mirrors lab schedule MCT-lab-weekly-sun-0600 pattern).
- Reports: client-safe vulnerability review (see phase9-first-vulnerability-review.md).

## Escalation

- See phase9-first-client-escalation-matrix.md.

## First 30 days

- See phase9-first-client-launch-package (this) + fulfillment runbook (P9.11).

## Preconditions (Phase 9 status)

- [ ] Capacity: disk 63%, swap high - RAM expansion RECOMMENDED before launch
- [ ] DR S3 bundle 403 - config DR local-only until keys fixed (accepted risk
      short-term; snapshots still S3-backed)
- [ ] Canarytoken T1 - deferred to post-launch (not a launch blocker)

## No secrets

No secret values printed.
