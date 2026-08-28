# Phase 56 Closeout: Filter Repair Plan

**UTC:** 2026-08-28T00:25:31Z
**America/New_York:** 2026-08-27 20:25:31 EDT

## Prompt
Define the minimal Wazuh filter correction, the exact expected groups, and rollback for Class-A.

## Task
Produce a plan (only) for correcting `<group>` so Class-A high-severity Wazuh alerts reach the Shuffle webhook, with rollback.

## Evidence
- EB §3: current `<group>suricata,</group>` retained. Correcting it to match Class-A high-severity Wazuh alerts is a production behavior change NOT covered by the owner "fix it all" authorization (EB §9).
- EB §10: filter reconciliation is a remaining OPEN gate for Class-A certification.

## Method
READ-ONLY-INSPECTION — plan authored from EB; no config change made.

## Backup
Existing durable host bind source + in-volume config (EB §3) serve as rollback baseline.

## Rollback
Revert `<group>` to prior value and re-apply to both running volume and durable host bind source; chown wazuh:wazuh + chmod 640 (per EB §8 preventive).

## Stop conditions
Application of the filter change is GATED — requires explicit owner approval beyond the verbal "fix it all" scope (EB §9). This report plans only; it does NOT apply.

## Limitations
Exact target group expression for Class-A high-severity not validated against live alert taxonomy in closeout; plan documents the gate and rollback, not an applied change.

## Verdict
DONE — filter repair plan and rollback documented; application explicitly BLOCKED pending owner authorization (see 046).
