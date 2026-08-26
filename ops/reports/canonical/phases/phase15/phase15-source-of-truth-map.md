# Phase 15 Source-of-Truth Map

Date: 2026-08-16

| Topic | Source of truth | Notes |
|---|---|---|
| Architecture | ARCHITECTURE.md | current (08-16) |
| Ports | PORTS.md | current |
| Repo layout | REPO-MAP.md | current |
| Security rules | SECURITY.md | current |
| Portability | PORTABILITY.md | current |
| Wazuh ops | /opt/wazuh-docker/multi-node/ops/STACK-OVERVIEW.md | live host |
| Syslog model | ARCHITECTURE.md (15140, 514 retired) | verified by CI |
| SO model | agent 008 packet ingestion (zeek-forward) | verified 08-16 |
| Velociraptor | NATIVE binary on host (runbook annotated) | NOT compose |
| Greenbone | VM103 containers; schedule MCT-lab-weekly-sun-0600 | proven |
| DR | ops/runbooks (S3 data tier healthy) | config bundle local-only |
| Client ops | client-onboarding/ + reporting/output/client/ | cycle started |
| Releases | RELEASE-NOTES.md + GitHub v1.0.0 | current |

## Rule

- Live operational state -> verify against host (scripts/verify) + ARCHITECTURE.
- Historical evidence -> evidence/ (never rewritten).
- No hidden phase-pack dependencies.

## No secrets
