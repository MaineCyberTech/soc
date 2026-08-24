# MCT Security Stack - Final Phase 30 Operator Report

Date: 2026-08-24
Pack: /home/user/mct-p30 (Infrastructure Incident Recovery, Memory Stabilization, Endpoint Certification, Fresh-Target Runtime Proof, Workflow Idempotency, Full Codebase and Infrastructure Audit, v1.3.0 Post-Release Assurance)
Stack root: /opt/mct-security-stack | Release: **v1.3.0** (published + reconciled)

## Executive summary

Phase 30 delivered: **memory stabilization** (the severe swap-98% issue was diagnosed as
**stale swap, not thrashing** - PSI 0.00, si/so 0 - root cause = 15GiB capacity + swappiness
60; the single low-risk remediation, `vm.swappiness=10`, was applied persistently with zero
regression and a full remediation plan for Phase 31). The **Security Onion outage** was
documented in a postmortem (recovery blocked: PVE credentials fail auth + token missing).
**v1.3.0 post-release** was reconciled (tag/release/asset sha256/source-of-truth all agree).
The **full codebase + infrastructure audit (55-78)** was delivered across 24 categories with
a P0/P1/P2/P3 remediation backlog. Deployability remains **PARTIAL** with the exact blocker
(no adequate isolated target) preserved - no simulated PASS. Endpoint certification, Shuffle
UI controls, and the fresh-target/full-cluster chains remain gated as before.

## SO recovery (03-09)

- SO VM (192.168.222.116) down; agent 008 disconnected since 18:59Z; healthcheck 2 FAIL +
  CI agent-008 note (accepted).
- **Recovery blocked**: Proxmox (222.187:8006) reachable but stored PVE credentials fail
  authentication and PVE222 token missing. Postmortem written (root cause external; detection
  via healthcheck; P1 gap = no disconnect alerting beyond CI).

## Memory stabilization (10-17)

- **Diagnosis**: swap 8GiB full but STALE (PSI some/full avg10=0.00, vmstat si/so -> 0/0);
  12/15GiB committed (3 indexer JVMs ~1.5GB each + shuffle-opensearch 1.4GB + flowcoll 811MB
  + tenzir 486MB); indexers unbounded (mem_limit=0); **vm.swappiness=60** = root cause of
  aggressive swap-out.
- **Applied (approved, low-risk)**: `vm.swappiness=10` + persistent
  /etc/sysctl.d/99-mct-memory.conf. **Zero regression** (cluster green, ingest healthy).
- Plan: RAM expansion (P0/Phase 31) + indexer limits/-Xmx at next restart; no broad restarts
  (not warranted - evidence-based).

## v1.3.0 post-release (18-21)

- Tag v1.3.0 (790968b8), release id 375979989, asset 10,348,557 bytes sha256 da72bde4...,
  README/RELEASE-NOTES/manifests/mirror - **all consistent**. Exec-mode: all tracked .sh
  100755 (fixed p29-image-ci-gate.sh). 3 pack CI-path bugs fixed (p28/p29/p30).

## Endpoint / PS4104 / Shuffle (22-38)

- 014 (EID1 150/24h, EID7 0), 015 (active, certified), 012 active, 013 transient offline
  (EID1 76, EID7 39). Markers still **operator RMM pending** -> certification PARTIAL,
  throttles RETAIN, dashboards gated. PS4104 approval/endpoint gated. Shuffle-native
  controls UI-pending; **guardrail cron failover re-proven** (exec 100755, firing, 4/24h
  executions under limit 5).

## Isolated target + full-cluster (39-54)

- Candidate mct-soc-scan unchanged (4C/5.8GiB - under-resourced, not approved). Exact
  blockers preserved (no simulated PASS). Full-cluster restore NO-GO; RTO/RPO full-cluster
  UNCLAIMED.

## Full audit (55-78)

- 24 category audits delivered (codebase, architecture, shell, python, powershell, config,
  CI/CD, supply-chain, secrets, authz/network, data/storage, infrastructure, compose,
  systemd/cron, wazuh/opensearch, detection/routing, endpoint mgmt, backup/DR,
  performance/capacity, observability/SLO, docs/governance, deployability, drift, backlog).
- Key findings: CI workflow lacks image-gate/exec-mode wiring + SHA-pinned actions (P1/P2);
  no agent-008 alerting (P1); indexer unbounded limits (P1); Sysmon cache + offline registry
  (P2); formalized **P0/P1/P2/P3 remediation backlog (78)**.

## Capacity / retention

- Disk **84%** (climbing toward 85% low watermark); relief wave 08-15..18 (~7.4GB) due
  ~08-29. Cluster green. Watch item.

## Credentials / owners

- PVE auth FAIL (SO recovery blocker - 81), VT/PVE replacement, indexer maintenance window
  (80, deferred), NetFlow scope evidence, Redis owner, Greenbone signed auth, canarytokens -
  all gated as before.

## Remaining risks (top)

1. **SO VM down** + PVE creds blocked (recovery pending operator).
2. **Disk 84%** toward 85% watermark (wave due ~08-29).
3. **RAM capacity** (stale swap; swappiness mitigated; expansion needed).
4. Endpoint markers (operator RMM) -> cert/throttle/dashboards.
5. No adequate isolated target (deployability PARTIAL, full-cluster NO-GO).
6. Shuffle UI controls + PS4104 + credential/owner items gated.

## Recommended Phase 31 roadmap

1. **SO recovery**: operator restores PVE access (least-privilege token) -> start SO VM ->
   validate Zeek/Suricata -> flood check -> healthcheck 0 FAIL.
2. **Memory**: RAM expansion (+8-16GiB); at next indexer restart add container limits +
   explicit -Xmx.
3. **Disk**: confirm 08-15..18 deletion wave (~08-29) lands; verify plateau ~76-78%.
4. **Endpoint markers** (013/014 RMM) -> cert PASS -> retire throttles -> W1/W2 dashboards.
5. **Provision adequate isolated target** -> fresh-target runtime proof (39-49) -> deployability
   PASS; full-cluster drill (50-54) -> measured RTO/RPO.
6. **CI hardening**: wire image-gate + exec-mode audit into workflow; SHA-pin actions.
7. **Agent-008 disconnect alerting** (beyond CI).
8. **Shuffle UI implementation** (dedup/counter/malformed) + replay/failure proof.
9. **Credential/owner closure**: PVE token, VT, indexer maintenance, NetFlow scope, Redis,
   Greenbone, canarytokens.
10. **Indexer credential maintenance window** (80, wazuh-passwords-tool atomic).

## Files added (summary)

- 96 Phase 30 deliverables (00-95) covering SO recovery/postmortem, memory diagnosis/apply/
  validate, v1.3.0 reconcile, endpoint/PS4104/Shuffle, target/DR chains, 24-category audit,
  credentials/owners, capacity/billing/ops, final audits, deployability cert, repo commit,
  final report, master status.
- New artifacts: ops/scripts/p30-*.sh (audit tooling); vm.swappiness=10 sysctl (host);
  audit outputs under ops/reports/p30-* (gitignored scan txt).

## No secrets

All reports cite paths/variable names only; no secret values printed.