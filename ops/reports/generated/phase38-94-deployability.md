# Phase 38 Deployability Certification

**Report ID:** phase38-94-deployability
**Phase:** 38
**Title:** Phase 38 Deployability Certification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-94-deployability.md`

**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-94-deployability.md`
**Retention Class:** LONG

| Field | Value |
|-------|-------|
| **Report ID** | phase38-94 |
| **Generated** | 2026-08-25 21:30 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL (unchanged) — blockers enumerated exactly, flip conditions defined |
| **Supersedes** | Draft written 2026-08-25T20:12Z |

---

## 1. Certification Statement

Deployability remains **PARTIAL**. The stack is reproducible in its parts and its safety nets are now proven live, but no evidence exists that the full system can be restored onto an adequate target within defined objectives. This report enumerates the exact blockers, what would flip the certification to PASS, and the verified positive evidence that carries forward.

## 2. Exact Blockers (complete list)

### B-1 — No adequate-target runtime restore proof

- The strongest restore evidence on file remains snapshot-level: repositories hold restorable index snapshots (fs 42 snapshots latest today 20:17Z; s3 85 snapshots latest 20:47Z). That proves DATA recoverability.
- What is absent: a timed, observed restoration of the full runtime (compose stack + manager + indexer cluster + SOAR) onto hardware adequate to run it (resource-parity target). Prior partial restores were same-host or reduced-scope.
- Consequence: "deployable" cannot be claimed beyond component level.

### B-2 — RTO/RPO undefined

- No signed recovery-time or recovery-point objectives exist for any service tier (ingest, detection, SOAR, dashboards).
- Consequence: even a successful drill could not be graded pass/fail against an objective. This blocks B-1's evidence from being meaningful.

### B-3 — Full-cluster restore NO-GO

- Standing NO-GO on full-cluster restore operations outside a rehearsal window: risk of clobbering the production cluster from which all current evidence flows, with disk at 84% leaving no room for parallel restore experimentation.
- NO-GO is a control, not a capability judgment — but until lifted via a controlled rehearsal (B-1), deployability cannot exceed PARTIAL.

### B-4 — Release asset not archived on-box

- Manifest declares `mct-security-stack-release-20260824-203124.tar.gz` (9.9M, 2,040 files, sha256 da72bde…) with byte-exact chain verified against tag v1.3.0 @ c726182 — but the tarball itself is not stored on-box.
- Consequence: rebuild-from-artifact depends on external retrieval; a true offline redeploy test cannot start from local truth.

No other blockers are load-bearing. Items sometimes cited as blockers are dispositioned in §5 as non-blocking.

## 3. What WOULD Flip Certification to PASS

Ordered sequence; each step has an owner in backlog phase38-90:

1. **Archive the release asset on-box** (BCK-38-009): store tarball + sidecar sha256 matching manifest; register location. → Clears B-4 immediately.
2. **Author and ratify RTO/RPO** (BCK-38-015): per-tier objectives signed by SOC lead (e.g., ingest RTO hours-class, search RTO days-class, RPO bounded by twice-daily snapshot cadence). → Clears B-2.
3. **Rehearse full restore on an adequate target** (needs out-of-scope PVE access or equivalent resource-parity environment): timed drill from on-box artifact + snapshot restore; measure against ratified objectives; document command-by-command. → Clears B-1 and lifts NO-GO B-3 upon successful completion.
4. **File PASS evidence pack**: drill log + timings + objective scorecard appended to verification ledger; certification upgraded.

Stretch condition (not required for PASS but expected for v1.4): automated restore-drill script so the proof is re-runnable each release.

## 4. Verified Positive Evidence (carries forward)

| Evidence | Status | Reference |
|----------|--------|-----------|
| Compose pins | Verified P36 — image digests pinned across services; drift-free since | release-manifest.json; compose/ tree; phase38-83 |
| Snapshot repositories healthy | VERIFIED LIVE today: fs 42 snaps (newest 20:17Z), s3 85 snaps (newest 20:47Z); stale missing-repo claim retired (D-03b) | phase38-79 §6 |
| Release integrity chain | Tag/asset/sha256 byte-exact (v1.3.0) | phase38-95 §2 |
| Report-CI gate green-capable | Script operational; currently honest-FAIL on secret patterns only (governance gate, not deployability) | ops/scripts/p38-report-ci.sh |
| Config reproducibility | Index templates declarative (`wazuh-archives-fieldlimit` applied today is idempotent template state, not hand-tuned index surgery) | phase38-78 §3 |
| Cluster health at snapshot time | GREEN, 274 shards, 3 nodes | live check this cycle |

This table is why the certification is PARTIAL rather than NO-GO overall: every ingredient for a passing drill exists except the target environment and the objectives.

## 5. Non-blocking Dispositions

- **Field-limit defect:** fixed at template level today (proof T+1); affects data completeness, not redeployability.
- **Shuffle exposure/token issues:** security posture items (P0s in backlog); they change what must be configured at deploy time, not whether deployment is possible.
- **Endpoint outages (013/015):** fleet operations, orthogonal to platform deployability.
- **Migration APPLY pending:** documentation-plane; runtime unaffected.

## 6. One-line Verdict for the Final Operator Report

> Deployability PARTIAL — components reproducible and backups proven current; full-system restore unproven on adequate target, RTO/RPO undefined, full-cluster restore NO-GO pending rehearsal, release asset not yet on-box; four-step flip path defined and owned.
