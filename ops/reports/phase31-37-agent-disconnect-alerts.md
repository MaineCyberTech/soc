# Phase 31 Agent Disconnect Alerts

Date: 2026-08-24
Status: **DESIGNED - WIRING PENDING**.

- Detect active critical agents (014, 015, 012, 006/007/011) disconnected for N minutes
  (e.g., 15m) via wazuh API/agent_control; retired agents (008) must NOT alert.
- Implementation: cron check + alert + runbook link (44). Exact blocker: none (wiring
  change on live manager scheduled); design complete.

## No secrets
