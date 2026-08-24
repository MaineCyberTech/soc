# Phase 30 Monthly Client Ops

Date: 2026-08-24

## Run checklist

| Item | Status |
|---|---|
| Health | **2 FAIL** - Security Onion VM + suricata (accepted; SO off) |
| CI / secret | code gates PASS / PASS (agent-008 environmental) |
| Backups | 42 snapshots; bundle + S3 < 48h; v1.3.0 mirrored |
| Endpoints | 3/3 coverage; 014/015/012 active; 013 transient; 008 (SO) down |
| Routing | Zeek Class A live + guardrail (exec 100755, firing, failover proven) |
| DR | component drills PASSED; full-cluster NO-GO (no target) |
| Memory | **swappiness 60->10 applied** (stale-swap diagnosis; PSI 0) |
| Capacity | disk 84% (watch; wave ~08-29); cluster green |
| Credentials | PVE auth FAIL (SO recovery blocked); VT/PVE/indexer gated |
| Release | **v1.3.0 published** + reconciled (18-21) |
| Audits | full codebase + infrastructure audit COMPLETE (55-78) |

## Actions logged

1. Memory: diagnosed stale swap (PSI 0, si/so 0), root cause = capacity + swappiness 60;
   applied swappiness=10 (persistent, reversible) - no regression.
2. SO postmortem + recovery path (blocked on PVE creds).
3. v1.3.0 reconcile (tag/release/asset/hash/source-truth consistent).
4. Exec-mode: all tracked .sh 100755 (fixed p29-image-ci-gate.sh); 3 pack CI-path bugs fixed.
5. Full audit stack delivered (55-78) + remediation backlog (78).

## Retrospective

- Best: memory diagnosis prevented unnecessary restarts; audit breadth; release reconcile.
- Watch: disk 84% toward low watermark; SO VM recovery (PVE creds); RAM capacity;
  endpoint markers; Shuffle UI.

## No secrets