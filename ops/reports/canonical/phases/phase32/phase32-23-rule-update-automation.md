# Phase 32 Rule Update Automation

Date: 2026-08-25
- suricata-update update (manual/scheduled) with: config gate (suricata -T), drift check
  (sha256), resource gate (memory/drops), observe window, rollback (prior rules backup).
- CI-adjacent: document in runbook; no unattended wholesale activation.

## No secrets
