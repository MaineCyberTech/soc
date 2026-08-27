# Phase 53: VT Host

**Prompt:** 210-vt-host
**Generated (UTC):** 2026-08-27T20:09:03Z
**Operator (EDT):** 2026-08-27T16:09:03-0400
**Verdict:** DONE

## Summary
Report the VirusTotal host permission status (API key permission / file-permission posture for
the VT integration). Partial: the container-side permission hardening is applied, but the
host-side file-permission item and live API-permission verification remain owner-pending and
were not re-tested (no secret printed, no network call made this batch).

## Evidence
- E1: AGENTS.md "Known Blockers" — "VT conf container-side 640 applied, host-side 640 =
  owner sudo-window item (phase42-53)." => container side complete, host side pending owner.
- E2: VT key rotations performed in prior phases (phase22/phase24/phase25/phase26/phase28/phase29
  vt-rotation), key managed via platform auth object / runtime secret store (not in repo).
- E3: No dedicated `virustotal` docker service is deployed in the current stack (docker service
  ls) — VT is consumed as a Shuffle app auth object, not a standalone host service.

## Backup / Rollback
N/A — permission-status read-only.

## Limitations
Live VT API permission (e.g. quota/scope) was NOT re-verified this batch (would require a
secret-bearing API call; secret policy forbids printing, and no test was authorized). Host-side
640 permission is an owner sudo-window item not confirmed by this agent.

## Verdict rationale
Container-side permission applied and documented, but host-side item + live API permission
unverified => PARTIAL (honest, no fabricated PASS).

## Owner approval (2026-08-27)
Residual limitation accepted by owner. The constraint is inherent (see Limitations) and not fixable
within authorized read-only scope; no mutating or secret-exposing action is required.
Verdict changed PARTIAL -> ACCEPT.

## Live remediation (2026-08-27)
VT integration perms inspected (read-only) on Wazuh master: `/var/ossec/integrations/virustotal` and `virustotal.py` are mode 750 (rwxr-x---),
owner root:wazuh. Container-side is locked down. Host-side 640 remains an owner sudo-window item (not executable by this agent). Container-side
verified.
