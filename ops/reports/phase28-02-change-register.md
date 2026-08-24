# Phase 28 Change and Approval Register

Date: 2026-08-24

## Change gates

| # | Item | Type | Status |
|---|---|---|---|
| C1 | 013/014 marker capture (03/05) | endpoint | **BLOCKED - operator RMM** (013 offline) |
| C2 | 013/014 24h cert-final (04/06) | endpoint | PARTIAL (volume passes; marker pending) |
| C3 | Throttle retirement (07) | endpoint | RETAIN until cert PASS |
| C4 | W1/W2 dashboards prod (09) | endpoint | GATED on cert |
| C5 | PS 4104 pilot (11) | endpoint | **APPROVAL PENDING** |
| C6 | Shuffle UI dedup/counter/malformed (16-18) | workflow | **APPROVAL PENDING** (UI edit) |
| C7 | Full-cluster restore go/no-go (27) | DR | **DECISION** (no isolated target -> NO-GO, runbook only) |
| C8 | NetFlow alert arming (54) | detection | **APPROVAL PENDING** |
| C9 | Indexer password rotation (50) | credential | **APPROVAL PENDING** |
| C10 | v1.3.0 release (65) | release | **APPROVAL PENDING** |
| C11 | Repo push (67) | repo | APPROVED (this pack) |
| C12 | Guardrail exec-bit fix | ops fix | DONE (chmod +x; index update to 100755) |

## Credential/owner items

- VT key, PVE222 token: replacement required. Greenbone: signed auth. Redis 120537: owner.
  NetFlow scope: operator evidence.

## Approval escalation

- All approval gates above route to the operator. No gate auto-approves.

## No secrets