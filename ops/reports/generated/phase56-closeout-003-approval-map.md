# Phase 56 Closeout: Approval Map

- UTC: 2026-08-28T00:25:31Z
- America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
Classify actions as MAY_AUTO, EXISTING_APPROVAL, NEW_APPROVAL_REQUIRED, and PROHIBITED.

## Task
Map each closeout action to an authorization class so execution stops at the right gate.

## Evidence
EB §9 (covered vs not covered by owner "fix it all", 2026-08-27); README §19 gates; AGENTS overlay (no GET webhook probe; literal credential prohibited; production/full restore NO-GO).

## Method
READ-ONLY-INSPECTION.

## Backup / Rollback
none — read-only.

## Stop conditions
PROHIBITED class must never run: webhook GET health probe, secret exposure, host reboot, service deletion, destructive/full restore, unapproved production routing.

## Classification
- MAY_AUTO: read-only inspection, hash verification of existing artifacts, read-only secret scan, chronology audit, catalog/parity read.
- EXISTING_APPROVAL (owner "fix it all"): hook_url correction, IRIS auth header, Wazuh restart, packet-workflow dedup/TTL/counter fixes, synthetic labeling.
- NEW_APPROVAL_REQUIRED: Wazuh `<group>` filter change, Shuffle trigger UI-start (separate UI action), production canary, full restore, dashboard, disk-policy change, TLS/exposure change.
- PROHIBITED: webhook GET health probe, secret value exposure, host reboot, service deletion, destructive restore.

## Limitations
Trigger UI-start is allowed by UI path only; REST start is 404/405 (EB §2) and thus outside auto-approval.

## Verdict
ACCEPT — four-class map derived from bundle; gates align with README §19.
