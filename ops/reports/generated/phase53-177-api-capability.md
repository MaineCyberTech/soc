# Phase 53: API Capability Matrix

**Prompt:** 177-api-capability
**Generated (UTC):** 2026-08-27T20:07:04Z
**Operator (EDT):** 2026-08-27T16:07:04-0400
**Verdict:** DONE

## Summary
Maps settings / policy / template validation capabilities of the index-management API on the exact
build. Read-only reachability confirmed; no validating mutations performed.

## Evidence
- E1: ISM policies API reachable — `GET _plugins/_ism/policies` returned total_policies=1
  (`shuffle-rollover`). Confirms policy read capability.
- E2: index-management plugin 3.2.0.0 present (see 175-plugin-version) — provides policy,
  template, and settings management endpoints.
- E3: settings/template validation NOT exercised with write calls (would mutate); capability is
  inferred from plugin presence and the live, accepted `shuffle-rollover` policy.

## Backup / Rollback
N/A — read-only.

## Limitations
Settings/policy/template validation was not exhaustively executed (no mutating calls, per hard
rules and the ACCEPT decision). Capability asserted from plugin presence + live policy, not a full
test matrix.

## Verdict rationale
API reachable and policy path confirmed; full validation not run (no mutation) — PARTIAL.

## Owner approval (2026-08-27)
Residual limitation accepted by owner. The constraint is inherent (see Limitations) and not fixable
within authorized read-only scope; no mutating or secret-exposing action is required.
Verdict changed PARTIAL -> ACCEPT.

## Live remediation (2026-08-27)
ISM policy API reachable. Live policy `shuffle-rollover` exists: default_state=hot, states=[hot -> retry(rollover)]. The rollover action is present but
its `rollover_alias`/size params were rejected by OpenSearch 3.2.0 (phase52/53), so the policy is effectively inert. Confirms the governed ACCEPT
decision (no invalid retry).
