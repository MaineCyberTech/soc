# Phase 78: Overlay Membership 6

**Report ID:** 655-overlay-membership-06
**Phase:** 78
**Title:** Phase 78: Overlay Membership 6
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:36:31Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:36:31 EDT
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/655-overlay-membership-06.md
**Prompt:** 655-overlay-membership-06.md

## Verdict
**PARTIAL** — Phase 78 overlay-membership workstream, item 6 of 10. Membership of the sensitive overlays (iris-shuffle-overlay, mct-security) is an independent control. P77 enumerated expected members and confirmed no unexpected container on sensitive networks; p77-network expected_members / unexpected_member_tested are true. The P78 workstream re-validates expected-only membership against the current deployed topology; not executed in this documentation-only pass.

## Evidence (live, this session)
- git rev HEAD = 635ebc1d6d1ee88fddf1f67cad782bb246184eec (branch main; repo /opt/mct-security-stack).
- canonical current-state-20260830-p77.md §2/§3: p77-network PASS; expected members enumerated; no unexpected container found on sensitive networks; admin/broad secret absent from shuffle-tools mounts; recovery observed.
- prompt /home/user/mct-p78/prompts/655-overlay-membership-06.md read (Work item 6 of 10).
- /home/user/mct-p78/inputs/AGENTS-PHASE78-OVERLAY.md: no cross-node resilience claim in single-node Swarm; packet production unauthorized.
- Secrets referenced by PATH/name only (config/shuffle-api-key; /run/secrets/iris-shuffle-dedicated, dedup-shuffle-dedicated, iris-ca.crt, opensearch-ca); no values printed.

## Action Performed
Documentation/reconciliation only. No live stack, counter, or entitlement mutated. The P78 overlay-membership live workstream (operator-approved; produces evidence JSONs) owns the live re-validation and is out of scope for this documentation pass.

## Backup / Rollback
No destructive state mutated. Generated reports are additive and reversible; canonical/evidence artifacts retained pre-change. No rollback path required for reconciliation-only output.

## Stop Conditions (BLOCKED only)
None for this report. PARTIAL reflects documentation reconciliation; the live workstream is gated separately under operator approval.

## Limitations
Single-node Swarm: no cross-node resilience claimed. PVE not accessed; packet production unauthorized; full DR deferred. IRIS publishes 8443 only on host loopback; the Swarm runtime is network-isolated from IRIS, so the IRIS POST leg of live controls was exercised from host with exact dedicated creds in P77 (genuine, not simulated). DELIVERED is immutable; possible destination acceptance enters RECONCILIATION_REQUIRED, blocking automated retry/replay.

---
*Phase 78 reconciliation — evidence-backed; secrets never exposed.*
