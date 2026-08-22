# Phase 24 Agent 015 Upgrade Predicate Control

Date: 2026-08-22

## Change applied

- `integrations/macos/remediation-bundle/verify-agent015.sh` now includes a **post-upgrade
  predicate control**: checks for the `MCT-PHASE22-BOUNDED-MACOS` marker in ossec.conf and
  prints OK (preserved) or WARN (agent upgrade rewrote config -> re-run repair --apply).
- Syntax verified (`bash -n`).

## Procedure (after ANY macOS agent upgrade)

1. Run `sudo ./verify-agent015.sh` on the Mac.
2. WARN -> `sudo ./repair-agent015-unified-log.sh --apply` (idempotent; backup + rollback intact).
3. Confirm archive volume stays <= 50K/24h + bounded events flow.

## Governance note

- This closes the P23 "upgrade-preservation risk" follow-up with an executable check.

## No secrets