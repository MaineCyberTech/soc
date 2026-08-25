# Phase 34 OpenCode Scratch Policy

Date: 2026-08-25

## Policy
- Bounded scratch root: /tmp/mct-opencode-scratch/
- Ownership: current user
- Age: files > 60m, not open, not protected
- Quota: < 500MB total
- Active-run marker: .mct-active (excluded from cleanup)
- Cleanup exclusions: protected paths, open files
- Audit log: /opt/mct-security-stack/ops/reports/opencode-scratch-cleanup.log
- Operator runbook: manual override + investigation

## No secrets
