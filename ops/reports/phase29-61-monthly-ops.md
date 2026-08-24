# Phase 29 Monthly Client Ops

Date: 2026-08-24

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Health | **2 FAIL** - Security Onion VM down (ping 100% loss) + SO suricata unreachable | healthcheck 20:22Z |
| CI / secret | PASS / PASS | gates |
| Backups | OK | 42 snapshots; S3 bundle < 48h; phase2 config bundle < 48h |
| Endpoints | 3/3 coverage; 013/015 transient offline; **008 (SO) disconnected since 18:59Z** | wazuh API |
| Routing | Zeek Class A live; guardrail operational (exec 100755, 2 executions/24h) | guardrail |
| DR | component drills PASSED; full-cluster NO-GO (no target) | 40-44 |
| Capacity | root 82%; **swap 98%** (memory pressure), mem 78% | health + free |
| Credentials | VT/PVE/indexer blocked | 49-52 |
| Authorizations | Greenbone unsigned; NetFlow scope pending | 53/56 |
| Consolidation | canonical corrected (45/46); duplicate remediation done | 45-48 |
| Images | 8 mutable refs -> pins prepared, approval-pending (05) | 03-07 |
| Billing | 3/3 coverage; 013/014 quality pending | 59 |
| Release | v1.3.0 preflight/bundle/approval-pending | 65-68 |

## Actions logged

1. Image digest pin set prepared (8 refs) + CI gate + executable-mode audit (07).
2. Cache manifest + schema/profile alignment (09, 10).
3. Canonical source map corrected (scorecard generators = ops/scripts).
4. SO VM outage + memory pressure recorded as incidents (below).

## Incidents this phase

- **Security Onion VM down**: 192.168.222.116 unreachable (100% ping loss), agent 008
  disconnected since 18:59Z. Root cause external (VM offline). Owner action: power/recover
  SO VM; healthcheck returns to 0 FAIL when restored.
- **Memory pressure**: host 15GiB, swap 7.9/8.0GiB used (98%), free mem 249MiB. Consumers:
  3x wazuh-indexer JVM + shuffle opensearch JVM + flowcoll. Watch: if swap exhausts,
  restart shuffle-opensearch or reduce indexer heap (P1 watch).

## Retrospective

- Best: guardrail operational + image pinning prepared + canonical correction.
- Watch: SO VM, memory/swap, 013/015 offline, marker confirmation, release approval.

## No secrets