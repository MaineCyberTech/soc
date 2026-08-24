# MCT Security Stack - Final Phase 29 Operator Report

Date: 2026-08-24
Pack: /home/user/mct-p29 (Immutable Runtime Packaging, Fresh-System Deployment Proof, Endpoint Certification Closure, Workflow-Native Idempotency, Full-Cluster Recovery Readiness, v1.3.0 Release)
Stack root: /opt/mct-security-stack | Release: v1.2.0 (v1.3.0 bundle built; release approval-blocked on P0)

## Executive summary

Phase 29 advanced **immutable runtime packaging** (the P0 release blocker) to a prepared
state: all 8 mutable production image refs were resolved to registry manifest digests,
captured in `config/image-pin-set.json`, with a CI gate that fails any new undocumented
mutable ref and an executable-mode audit that now passes for all tracked scripts. **v1.3.0
bundle built deterministically** (sha256 da72bde4..., 0 sensitive files). The fresh-system
deployability gate remains **PARTIAL and truthfully unproven**: a candidate isolated target
(`mct-soc-scan`, Debian 13, reachable) was identified but is under-resourced for the full
multi-node stack and not operator-approved — **no simulated PASS**. The canonical source map
was **corrected** (scorecard generators canonical = ops/scripts/ per actual callers). Two
environmental incidents were recorded: **Security Onion VM down** (agent 008 disconnected,
healthcheck/CI reflect it) and **memory pressure (swap 98%)**. Endpoint certification stays
PARTIAL (markers operator-pending); full-cluster restore remains NO-GO (no target). Guardrail
remains fully operational (exec 100755, cron firing, failover re-proven).

## Immutable runtime packaging (03-10)

- **Inventory (03)**: all active runtime images catalogued (compose + swarm), owners/arches.
- **Digests (04)**: 8 mutable refs -> registry manifest digests (buildx). Drift findings:
  opencanary compose pin stale (db6bf96d vs registry c374c68b vs running 07bf63d8);
  shuffle-orborus compose pin stale (94e61e79 vs registry 5c300bcb).
- **Pinning (05)**: pin set prepared in config/image-pin-set.json (apply approval-pending);
  rollback = recorded tag refs; feed/versioned exceptions preserved.
- **Cache/rollback (06)**: pins registry-resolvable; rollback set + docker service rollback.
- **CI enforcement (07)**: p29-image-ci-gate.sh (0 undocumented mutable, 28 documented
  exceptions) + p29-executable-mode-audit.sh (**all tracked .sh now 100755** - fixed 2
  lib/render scripts; closes the P28 exec-bit incident class).
- **Sysmon cache (08)**: identity recorded (15.21 / schema 4.91 / EULA cache-only);
  cache not redistributed.
- **Manifest refresh (09)** + **bundle completeness (10)**: cache manifest + profile/schema
  alignment (required union 24 vars, no undefined vars).

## Endpoint certification (11-16)

- 013: EID1 62/24h, EID7 39/24h - **PARTIAL** (marker pending + transient offline).
- 014: EID1 124/24h, EID7 0/24h, active/stable - **PARTIAL** (marker pending).
- Throttles RETAIN (acceptance #5). W1/W2 dashboards gated. PS 4104 (17-20) approval-pending,
  no enablement.

## Shuffle / Zeek (21-27)

- Native dedup/counter/malformed: specs ready, **UI implementation approval-pending**;
  replay/failure methods ready (need UI nodes).
- **Cron failover re-proven (27)**: exec 100755; cron firing (timestamped log entries,
  executions 2/24h limit 5); disable/enable + analysisd -t rc=0 both ways.

## Fresh-system deployment (28-39) + full-cluster DR (40-44)

- **Isolated target preflight (28)**: candidate found (`mct-soc-scan` 192.168.222.154,
  Debian 13, 4C/5.8GiB/51GB free, root SSH) - **NO-GO this phase**: under-resourced for the
  full multi-node stack, not operator-approved, snapshot access not arranged. Exact blockers
  documented for 29-39 (no simulated PASS).
- **Full-cluster restore**: NO-GO (no target); preflight gates + runbook ready; RTO/RPO for
  full cluster remain **UNCLAIMED**.

## Consolidation (45-48)

- **Canonical correction**: scorecard generators canonical = ops/scripts/ (runbooks + cron
  call that path; P28 map was backwards). reporting/generators copies deprecated, retained
  as evidence.
- Canonical reference validation PASS (all live callers use canonical paths); golden-path
  validation + upgrade/rollback drill NOT RUN (target absent).

## Capacity / retention / incidents (58-62)

- Disk 82% (projected ~76-78% after 08-15..18 wave ~08-29..09-01); cluster green 264 shards.
- **Incident: Security Onion VM down** - 100% ping loss, agent 008 disconnected since 18:59Z
  (healthcheck 2 FAIL + CI "action required" = same root cause, external). Owner action.
- **Incident: memory pressure** - swap 98% (7.9/8.0GiB), free mem 249MiB; consumers =
  indexer JVMs + shuffle opensearch. Watch; restart/heap action if exhausts.

## Credentials / owners (49-57)

- VT key, PVE222 token (replacement), indexer rotation (approval), Greenbone (signed auth),
  NetFlow scope (operator evidence), Redis 120537 (owner), canarytokens (hosted) - all
  blocked as before; post-credential baseline healthy.

## Audits / deployability (62-64)

- Full-system + code/supply-chain: **no phase regressions**; 2 environmental incidents.
  Secret/CI-code/image-gate/exec-mode all PASS.
- **Deployability certificate: PARTIAL** (acceptance #11) - exact blockers: approved
  adequate isolated target + image-pin apply approval.

## v1.3.0 (65-68)

- **Bundle built** (66): 10,348,557 bytes, sha256 da72bde4..., 0 sensitive files.
- **Release preflight (65): NOT CLEAR** - P0 (image pin apply) + deployability runtime proof
  + approval all pending. Release blocked per safety; v1.2.0 remains current.

## Remaining risks (top)

1. Security Onion VM down (external; healthcheck/CI reflect it).
2. Memory/swap pressure (98% swap) - could degrade stack.
3. 013/014 markers operator-pending -> certification PARTIAL, throttles RETAIN.
4. P0 image pinning apply approval-pending.
5. Deployability runtime proof needs approved adequate target.
6. Shuffle UI native controls + PS4104 + release approvals pending.
7. Blocked replacements (VT/PVE/indexer/NetFlow/Redis/Greenbone/canarytokens).

## Recommended Phase 30 roadmap

1. **Operator: recover Security Onion VM** (agent 008 -> healthcheck 0 FAIL, CI PASS).
2. **Operator: run 013/014 markers** -> cert PASS -> retire throttles -> W1/W2 dashboards.
3. **Approve image pinning apply** -> P0 closed -> v1.3.0 release (bundle ready).
4. **Provision/approve adequate isolated target** (upgrade mct-soc-scan or equivalent) ->
   fresh-system deployment proof (29-39) + full-cluster restore drill (40-44) -> deployability
   PASS + measured RTO/RPO.
5. **Shuffle UI implementation** (dedup/counter/malformed) + replay/failure proof.
6. **PS4104 pilot** (approval) + review + decision.
7. **Credential/owner closure**: VT, PVE222, indexer, NetFlow, Redis, Greenbone, canarytokens.
8. **Memory**: reduce indexer heap or add RAM before the stack degrades.

## Files added (summary)

- 71 Phase 29 deliverables (00-70) covering image packaging, endpoint cert, PS4104, Shuffle,
  isolated-target chain, full-cluster DR, consolidation, credentials/owners, capacity/billing/
  scorecard/monthly ops, audits, deployability, v1.3.0 gates/bundle, repo commit, final report,
  master status.
- New artifacts: config/image-pin-set.json; ops/scripts/p29-*.{sh,py} incl. image-ci-gate.sh;
  v1.3.0 bundle (sha256 da72bde4...) + manifest.
- Corrections: canonical-source-map (scorecard generators -> ops/scripts/); schema.json
  required union; executable modes (2 lib/render scripts -> 100755).

## No secrets

All reports cite paths/variable names only; no secret values printed.