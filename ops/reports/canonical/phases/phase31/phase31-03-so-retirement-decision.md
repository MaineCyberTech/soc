# Phase 31 Security Onion Retirement Decision

Date: 2026-08-24
Status: **RETIRED (operator decision, effective immediately)**.

## Decision

- Security Onion packet scanning is **discontinued** (outage since 08-24 18:59Z unrecovered;
  PVE recovery + RAM expansion explicitly out of scope for Phase 31).
- Reason: SO VM unavailable; recovery requires PVE access (blocked); a replacement must be a
  sub-2-GiB measured-memory sensor. Retirement is the operative decision per pack scope.

## Scope / residual risk

- No active packet-visibility expectation from SO. Compensating telemetry: NetFlow (flowcoll),
  endpoint logs, existing device logs. Detection gap on raw packet inspection documented (21).
- **Reactivation prerequisites**: working PVE access, SO VM recovered OR approved replacement
  sensor passing the sub-2-GiB benchmark (16) + production SPAN approval.

## Retained assets (06)

- SO configs, rules, runbooks, reports, hashes, snapshot references, endpoint 008 history -
  preserved as historical evidence (no deletion).

## No secrets