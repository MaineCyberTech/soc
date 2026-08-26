# MCT Security Stack - Final Phase 11 Operator Report

Date: 2026-08-16
Pack: /home/user/mct-security-9 (Phase 11 First Client Launch, Repo Hardening, Code Review, Portable Stack Cleanup)
Wazuh root: /opt/wazuh-docker/multi-node
Stack root: /opt/mct-security-stack

## Executive summary

Phase 11 executed all 16 prompts, transforming the stack from phase-specific
build artifacts into a **portable, maintainable repo** ready for first-client
launch and future operators/AI agents. **Code review** found and FIXED 5 issues
(3 hardcoded secrets -> creds.env, backup script failure-swallowing, expiring
date check). **Documentation normalization** removed stale "Phase 2" stack
language from ~30 current docs; 122 historical reports archived to evidence/
with banners. **Portable repo** created: REPO-MAP, ARCHITECTURE, PORTABILITY,
SECURITY, .env.example, 7 bootstrap/verify scripts (all PASS), packaging script.
**Secret hygiene**: no live secrets in repo; scanner created. **Greenbone weekly
proof**: manual validation run done (report 00aa2e0b, 16 info findings);
scheduled run due 06:00 UTC today. **DR S3**: formally closed as accepted
local-only risk (data tier healthy: 36 snapshots). **Monthly MSP ops dry run**
executed end-to-end (10 steps, all validated). **First client**: launch-ready
package complete; still blocked on client engagement. **Client communications**:
7 templates QA'd PASS + playbook created.

## Starting state

- Phase 10: RAM fixed, DR restore proven, client staged, Windows telemetry mature.

## First client intake/authorization status

- **LAUNCH-READY, no client engaged** (precise blocker: intake + signed auth).
- Intake complete doc, signed-authorization checklist, approved-endpoint-list,
  launch-readiness all staged.

## Repo inventory summary

- Stack root: 12 top-level areas, ~700 files (ops/reports 313, runbooks 91,
  integrations 194, scripts 12+7 new, etc.).
- ops/backups (2.6G) = operational data; data/ = vendored; both excluded from portable.
- Wazuh ops: STACK-OVERVIEW + runbooks/scripts normalized.

## Code review findings

- 55 .sh files: all pass bash -n. No 514 refs.
- **FIXED (5)**: capacity-threshold (PVE pw hardcoded), disk-growth (indexer pw),
  endpoint-count (API pw), backup-wazuh-config (failure swallowing + broken
  INCLUDE_VOLUMES), phase2-healthcheck (expiring date).
- Tracked (MED/LOW): snapshot rc checks, cron duplicates, shuffle-healthcheck
  hardcoded name, misp report empty, port-audit 514, endpoint-count /tmp dep,
  install-windows doc stale, uninstall-windows exit code.
- Full report: ops/reports/phase11-code-review.md.

## Documentation normalization summary

- "Phase 2 stack" canonical name removed from current docs -> "MCT Security Stack".
- ~30 current files normalized (README, STACK-OVERVIEW, 18+ runbooks,
  integrations, ports.md, client-onboarding README).
- Zero pack-language hits. Historical evidence preserved + archived.
- Report: phase11-doc-normalization.md + phase11-stale-reference-scan.md.

## Architecture source-of-truth status

- ARCHITECTURE.md + PORTS.md + REPO-MAP.md created (current model: syslog 15140,
  SO packet-ingestion via agent 008, Wazuh/ElastiFlow/OpenCanary/Shuffle/IRIS/
  Velociraptor/MISP/Greenbone, lab VMs 201-205, DR posture, endpoint kit, Level.io).
- Old SO/Wazuh forwarding NOT presented as current.

## Portable repo status

- README/REPO-MAP/ARCHITECTURE/PORTABILITY/SECURITY + .env.example + .gitignore.example.
- config/examples/, scripts/bootstrap/ (3), scripts/verify/ (4) - all PASS.
- package-portable-repo.sh (dry-run/--apply).
- verify-portable-repo.sh: PASS.

## Secret hygiene status

- No live secrets in repo (scan verified; hits = references/placeholders).
- 3 hardcoded secrets removed in code review.
- secret-pattern-scan.sh created (file/line/category only).
- SECURITY.md rules + .gitignore recommendations.

## Bootstrap/verify scripts status

- 3 bootstrap + 4 verify scripts created, all tested PASS.
- verify-current-architecture: 15140 mapped, 514 retired, agents active, indexer green.
- verify-no-stale-phase-refs: clean.
- Report: phase11-bootstrap-verify-status.md.

## Historical evidence archive policy

- 122 historical reports copied to evidence/reports/.
- HISTORICAL-REPORTS-README.md (policy) + historical-banner-template.md.
- Banners applied to 4 key final-phase reports.
- Originals preserved (copies only).

## Greenbone weekly proof/client scan plan

- Manual proof run 2026-08-16 00:58 UTC (report 00aa2e0b): Done, 16 findings all Info.
- Scheduled run due 06:00 UTC today (verify after).
- Client scan plan authorization-gated (Discovery first, MCT-Critical-to-Shuffle attached).

## DR S3 resolution/risk acceptance

- **CLOSED as ACCEPTED**: local-only config DR for pilot.
- Data tier healthy: 36 S3 snapshots (latest 00:47) + 42 local.
- Refresh procedure documented (do-spaces-key-refresh-procedure.md).

## Monthly MSP ops dry run

- Executed all 10 steps end-to-end (health, capacity, backups, counts, alerts,
  vuln, scorecard, billing, comms, retrospective).
- Issues: thin pool 91.6% (rising - action) -> **RESOLVED 2026-08-16 (cleanup: 87.8%)**; agent 009 disposition; IRIS check
  transient, config backup weekly cron verify.
- Reports: phase11-monthly-ops-dry-run.md, endpoint-billing-count, alert-quality,
  internal-retrospective, sample scorecard.

## Endpoint counts/billing/scorecard status

- 7 Wazuh agents (6 active, 1 pending 009); 5 Velociraptor clients.
- Billable: 0 (no client). Internal 4, lab/pilot 2.
- Billing review + client scorecard template finalized (client-safe).

## Client communications status

- 7 templates QA'd PASS (no internal details, placeholders complete).
- Communication playbook created.
- Report: phase11-client-communications-qa.md.

## Remaining risks

1. **Thin pool .222 (was 91.6%, now 87.8% after cleanup)** - 6 unused disks freed
   (2026-08-16: vm-201-disk-8, vm-202/203/204/205-disk-0 + stale ref). Still above
   the 85% WARN - **CHECK LATER: monitor whether pool stays stable post-cleanup;
   extend if > 90%**.
2. **No external client engaged** - launch-ready, needs intake + signed auth.
3. **DR S3 config bundle 403** - accepted local-only; needs keys.
4. **Agent 009 never-connected** - disposition (re-enroll or remove).
5. **Greenbone scheduled run proof** - verify after 06:00 UTC today.
6. **Config backup weekly cron** - verify today's Sunday run.
7. **Windows detection rules** - backlog (measurement-first).
8. **Canarytoken T1** - blocked (no hosted account).
9. **P1 rotation** - deferred (no new values).

## Recommended Phase 12 roadmap

1. **Capacity**: **CHECK LATER** - confirm pool remains ~87-88% after unused-disk
   cleanup (2026-08-16); monitor vm-202 disk growth; extend pool if > 90% or
   migrate VM 202; resolve agent 009.
2. **First client**: engage -> intake -> signed authorization -> deploy ->
   baseline -> 30-day cycle (all artifacts ready).
3. **Greenbone**: verify scheduled run proof; production scan authorization.
4. **DR S3**: obtain keys -> bundle SUCCESS -> full DR validation.
5. **Windows telemetry**: enable PS logging; deploy detection rules to pilot;
   build W1/W2 dashboards.
6. **Repo ops**: establish git remote + CI (verify scripts on commit);
   scheduled portable bundle exports.
7. **Monthly ops**: first real monthly cycle with a client.
8. **MSP growth**: billing automation (endpoint-count -> invoice).

## Files added (summary)

- Top-level: README (normalized), REPO-MAP.md, ARCHITECTURE.md, PORTABILITY.md,
  SECURITY.md, PORTS.md, .env.example, .gitignore.example
- config/examples/secrets.example.env
- scripts/bootstrap/ (3), scripts/verify/ (4), scripts/README.md
- ops/scripts/secret-pattern-scan.sh, package-portable-repo.sh
- ops/reports/: phase11-preflight, phase11-phase10-status-review,
  phase11-repo-inventory, phase11-current-state-map, phase11-code-review,
  phase11-doc-normalization, phase11-stale-reference-scan, phase11-architecture-update,
  phase11-secret-hygiene-scan, phase11-bootstrap-verify-status,
  phase11-evidence-archive-index, phase11-greenbone-weekly-proof,
  phase11-dr-s3-resolution, phase11-monthly-ops-dry-run, phase11-endpoint-billing-count,
  phase11-internal-retrospective, phase11-endpoint-counts, phase11-client-communications-qa,
  final-phase11-operator-report (this file)
- ops/runbooks/: phase11-change-control, config-dr-local-only-risk-acceptance,
  do-spaces-key-refresh-procedure
- client-onboarding/: phase11-client-intake-complete, phase11-signed-authorization-checklist,
  phase11-approved-endpoint-list, phase11-client-greenbone-scan-plan,
  phase11-client-communication-playbook
- reporting/output/: phase11-sample-monthly-scorecard, phase11-lab-vulnerability-review,
  phase11-alert-quality-review, phase11-client-scorecard-template
- service-packaging/phase11-billing-review
- evidence/: HISTORICAL-REPORTS-README.md, historical-banner-template.md, reports/ (122)
- docs/repo-layout-proposed.md

## No secrets

All reports cite paths/variable names only; no secret values printed.
