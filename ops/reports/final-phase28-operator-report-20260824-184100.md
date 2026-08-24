# MCT Security Stack - Final Phase 28 Operator Report

Date: 2026-08-24
Pack: /home/user/mct-p28 (Endpoint Certification Closure, Workflow Idempotency Activation, Full-System Rebuild Consolidation, Credential Recovery, v1.3.0 Release)
Stack root: /opt/mct-security-stack | Release: v1.2.0 (v1.3.0 staged, approval-pending)

## Executive summary

Phase 28 centered on **consolidation and clean-system deployability** as first-class release
gates, alongside endpoint certification, Shuffle hardening, and DR formalization. Headline
result: the **consolidation audit stack was delivered** (inventory, duplicate audit, canonical
source map, dependency lock, config schema + env profiles, secrets/network/storage audits,
install-order DAG, clean-deploy audit, idempotency, offline/cache, licensing, smoke
readiness, upgrade/rollback, golden-path runbook, fresh-target dry-run, remediation plan) with
**new machine-readable artifacts** (dependency-lock.json, schema.json, service-graph.json,
profiles). A real operational incident was found and closed: the **Zeek guardrail cron had
been down ~40h** because the script lost its executable bit (git index 100644) - restored with
`chmod +x` + index `100755`, failover re-validated. The fresh-target dry-run caught a real
bug in the gate tooling (wrong CI path) - fixed. Full-cluster DR was formalized as
**architecture + runbook with an honest NO-GO** (no isolated target, no overstated restore
claims). v1.3.0 remains **approval-pending**.

## Endpoint certification (013/014/015)

- 013: EID1 62/24h, **EID7 39/24h** (vs 58.8K/1h pre-tune), EID10 0 - **PARTIAL** (marker
  pending + endpoint transiently offline at review, keepalive 17:28Z).
- 014: EID1 99/24h (6/30m), EID7 0/24h, EID10 0, active/stable - **PARTIAL** (marker pending).
- 015: certified (bounded). Throttles: **RETAIN** until 013/014 cert PASS (acceptance #1/#2).
- W1/W2 dashboards: gated. PS 4104: pilot design/privacy/volume/decision methods prepared,
  **approval-pending**, no enablement (safety honored).

## Shuffle / Zeek

- Guardrail: **INCIDENT CLOSED** - cron down ~40h (exec bit lost); restored + failover
  re-validated (disable/enable + analysisd -t clean); git index now 100755.
- Native dedup/counter/malformed: **specs ready, UI implementation approval-pending** (API
  cannot add nodes/conditions - verified); guardrail remains the proven independent backstop.
- Replay/failure tests: methods ready, need UI nodes first. Real Class A cases: 0 (clean
  network).

## DR / RTO-RPO

- Full-cluster architecture documented (OpenSearch 2.19.5.0, 3 nodes, 17 plugins, security,
  snapshot repo FS /snapshots, 42 snapshots, 65 indices / ~21GB, 0 data streams, 21 templates,
  aliases incl. rollover series). Scratch-cluster plan + ordered full-restore runbook written.
- **Go/No-Go: NO-GO** (no isolated target, no approval) - no production restore, no
  overstated claims. RTO/RPO formalized by scope: RPO <= 24h bundle / <= 5h snapshots;
  config RTO < 1 min, small/multi-index seconds; full-cluster RTO **unclaimed**.

## Consolidation / deployability (primary workstream)

- **Delivered**: 31-48 audit stack; new artifacts dependency-lock/schema/service-graph/profiles.
- **Duplicates**: 4 groups (scorecard/alert-quality scripts identical, sysmon-mct.xml stale
  copy, evidence/reports legacy, pycache) - redirect/remove plan in remediation.
- **P0 closed**: guardrail exec bit; script secret fallback confirmed already fail-closed
  (literal only in historical evidence); 7 tracked pycache removed.
- **P0 open**: mutable image tags (8) locked but not yet pinned in compose (bundle gate).
- **Fresh-target dry-run: code/config gates PASS**; exact blockers recorded (no isolated
  target, tag pinning, cache refresh, secrets supply) - **no simulated success**.

## Retention / capacity

- Next archive delete wave 08-15..18 (~7.4GB) due ~08-29..09-01 (ISM 14d on schedule).
- Disk 81% plateau (trajectory 84.7% -> 79.5% -> 81%; projected ~76-78% after wave).
  Daily growth collapsed to ~100MB/day.

## Credentials / owners

- VT key, PVE222 token (replacement), indexer rotation (approval), Greenbone (signed auth),
  NetFlow scope (operator evidence), Redis 120537 (10K/day cap; owner), canarytokens
  (hosted account) - all **blocked as before**, post-credential baseline healthy.

## Audits / certification

- Full-system + code/security/supply-chain: **no regressions**; CI/secret/health green;
  0 live password literals; 0 tracked pycache; drift zero.
- **Deployability certificate: PARTIAL** (code/config/artifacts certified; runtime install
  pending isolated target).

## Remaining risks (top)

1. 013/014 marker confirmation (operator) - certification PARTIAL; throttle RETAIN.
2. Shuffle native dedup/counter/malformed (UI approval) - guardrail is the backstop.
3. Mutable image tags in production (pin pending).
4. Full-cluster DR drill needs an isolated target (currently NO-GO).
5. Blocked: VT/PVE/indexer/NetFlow/Redis/Greenbone/canarytokens; PS4104 approval.
6. v1.3.0 release approval-pending.

## Recommended Phase 29 roadmap

1. **Operator markers** on 013/014 -> cert PASS -> retire throttles -> W1/W2 dashboards.
2. **v1.3.0 release** (approval) once P0 closed (image tag pinning) + notes + bundle.
3. **Isolated fresh target** for the golden-path runtime drill + full-cluster restore drill
   -> upgrade deployability cert to PASS, claim full-cluster RTO.
4. **Shuffle UI implementation** (dedup/counter/malformed) + replay/failure proof.
5. **PS 4104 pilot** (approval) + review + decision.
6. **Credential/owner closure**: VT, PVE222, indexer rotation, NetFlow scope, Redis,
   Greenbone, canarytokens.
7. **Cache refresh** (Sysmon + manifest) and mutable-tag pinning in compose.

## Files added (summary)

- 69 Phase 28 deliverables (00-68) covering endpoint cert, PS4104, Shuffle, DR, retention/
  capacity, consolidation (31-48), credentials/owners, billing/scorecard/monthly ops, audits,
  deployability cert, v1.3.0 gates, repo commit, final report, master status.
- New source artifacts: config/dependency-lock.json, config/schema.json,
  config/service-graph.json, config/profiles/{lab,production,client,scratch}.env.example,
  ops/scripts/p28-*.{sh,py}.
- Removals: 7 tracked __pycache__; stale checklists.
- Guardrail exec-bit fix (index 100755).

## No secrets

All reports cite paths/variable names only; no secret values printed.