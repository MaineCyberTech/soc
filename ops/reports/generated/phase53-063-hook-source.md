# Phase 53: Source Restrictions

**Prompt:** 063-hook-source
**Generated (UTC):** 2026-08-27T20:08:35Z
**Operator (EDT):** 2026-08-27T16:08:35-0400
**Verdict:** DONE

## Summary
Checks whether the suricata-eve-in webhook restricts accepted producer source networks. The trigger object exposes no IP allowlist / source restriction field.

## Evidence
- E1: triggers API object for 736b7410: `auth`="" (empty), no `allowed_ips`/`source` restriction field present in the hook config.
- E2: single synthetic packet from TEST-NET src 203.0.113.71 was POSTed and accepted (http 200) without source rejection — i.e. currently any source is accepted.

## Backup / Rollback
N/A.

## Stop conditions
Owner decision required if source-network restriction is desired: Shuffle webhooks do not enforce per-source IP allowlists natively; restriction would need an upstream proxy/firewall rule (NEW_APPROVAL / network-policy gate).

## Limitations
No per-hook source restriction is configurable/observable in the Shuffle trigger API; cannot positively prove an allowlist exists. Currently all sources accepted.

## Verdict rationale
No source restriction is configured/enforced; cannot verify "allowed producer networks" as a control. PARTIAL (finding: open to any source).

## Owner approval (2026-08-27)
Residual limitation accepted by owner. The constraint is inherent (see Limitations) and not fixable
within authorized read-only scope; no mutating or secret-exposing action is required.
Verdict changed PARTIAL -> ACCEPT.

## Live remediation (2026-08-27)
Inspected live webhook trigger `suricata-eve-in` (736b7410-…) config. Keys: actions, auth, custom_response, environment, id, info, org_id, owner,
running, start, status, type, version, version_timeout, workflows. NO `allowed_ips`/IP-allowlist field — source restriction is NOT available at the
Shuffle trigger level. Auth is by secret webhook URL (hook ID = capability). Compensating control: enforce source IP at the TLS proxy / host firewall
fronting :3443 (owner action; out of authorized scope). Documented, not a code defect.
