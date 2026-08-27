# Phase 56: Host Access Decision

**Prompt:** 233-os-host-access-decision
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Decided whether the host requires direct access to the Shuffle OpenSearch datastore, or whether it is intentionally closed.

## Evidence
- EV-OS-NET-1 (VERIFIED): The datastore is **intentionally not host-published** (PortBindings all null) — host access is closed by design; only the `mct-security` overlay reaches it.
- EV-OS-NET-2 (VERIFIED): Host *can* reach `172.20.0.8:9200` incidentally via Docker bridge routing, but this is a dynamic container IP, not a sanctioned published endpoint.
- EV-OS-AUTH-1 (VERIFIED): The cluster runs with security disabled (anonymous) — so any host/network path to it would be unauthenticated; keeping it off published host ports is the correct isolation posture.

## Backup/Rollback
Read-only decision; no changes.

## Stop conditions
Decision only. Actually opening host access (publish port / firewall / auth enable) is an approval-gated exposure change and was NOT taken.

## Limitations
This report records the decision (intentionally closed / overlay-only). Implementation of any monitor that needs host access should use the supported network path (234), not a new published port.

## Verdict rationale
Host access is intentionally closed (not published, anonymous-auth cluster kept internal). Decision recorded. DONE.
