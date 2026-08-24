# Phase 28 Golden-Path Runbook (Empty Host -> Handoff)

Date: 2026-08-24
Status: **RUNBOOK** (execution requires approved fresh target; dry-run in 47).

## 1. Prerequisites (supported host)

- Debian/Ubuntu (or equivalent), root, Docker + compose + swarm init, git.
- Populate /opt/mct-cache from cache manifest (42) incl. Wazuh agents, velociraptor; Sysmon
  via Sysinternals (EULA cache-only). Verify sha256 checksums.

## 2. Secrets bootstrap

- Create wazuh-docker `.env` + ops/creds.env from profile templates (35), 0600 perms.
- Populate profile (production): WAZUH_*, SHUFFLE_*, DO_*, GH_PAT, PVE_*, VT_*.
- Fail-closed: missing required var aborts.

## 3. Install (stages per service-graph 39)

1. infra/docker/swarm init.
2. wazuh-indexer (compose multi-node) -> wait cluster green.
3. wazuh-manager, dashboard, elastiflow.
4. iris (compose iris-web) + shuffle (swarm) - rabbitmq first.
5. wazuh-integration (custom-json-output) + opencanary + syslog bridge + tenzir.
6. crons (guardrail, backup-bundle 04:00) + endpoint agents (install-wazuh-*.sh / .ps1).

## 4. Health + smoke

- Healthcheck 0 FAIL; CI PASS; secret PASS; cluster green; disk < 85%.
- Smoke: synthetic marked event -> intake + guardrail count (44).

## 5. Backup + handoff

- Backup bundle build + S3 mirror (nyc3); snapshot repo verifying; scorecard run; docs
  handoff (README + runbooks).

## 6. Rollback

- Full rollback path per 45 (no `down -v`).

## No secrets