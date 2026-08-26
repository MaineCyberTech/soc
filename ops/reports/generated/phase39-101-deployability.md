# Phase 39 Deployability Certification

**Report ID:** phase39-101-deployability
**Phase:** 39
**Title:** DEPLOY-39-04 — Verdict PARTIAL (Unchanged, Honest): Four Blockers Enumerated, Ordered Flip-Path With Owners, Phase-39 Improvements Recorded
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:58:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-101-deployability.md`

---

## 1. Verdict

**PARTIAL — unchanged from phase38-94, stated honestly.** Real deployability substance improved this
phase (on-box labeled asset, first restore-cycle proof, staged criteria and plan), but the four
gating blockers below remain. No verdict inflation: a spot-check is not a rehearsal; a rebuilt-labeled
asset is not the published original; proposed objectives are not signed objectives.

## 2. Blockers (exact)

| ID | Blocker | Why it gates |
|---|---|---|
| **B1** | **No adequate external rehearsal target provisioned/approved.** Host self-disqualified (148G disk, 84% used); criteria exist (phase39-83) but no target meets them and no approval exists to execute against one. | Full-cluster restore cannot be proven on the production host itself; AGENTS.md requires operator sign-off for any rehearsal execution. |
| **B2** | **RTO/RPO unsigned business values.** Draft targets staged as PROPOSED-BUSINESS-DECISION (Alerts RPO≤1h/RTO≤4h; Archives RPO≤24h/RTO≤8h; Config/Workflows RPO≤24h/RTO≤2h; full-cluster RTO undefined until rehearsal). | Without signed objectives there is no pass/fail criterion for the drill, and no honest claim of recoverability. |
| **B3** | **Full-cluster rehearsal never executed** — only a 1 MB single-index spot-check (RESTORE-CHK-39-01, PASS). Manager, configs, multi-index ordering, and timing-under-pressure remain unproven. | Deployability PASS requires recovery evidence at system scope, not component scope. |
| **B4** | **Published-original asset not retrieved.** On-box archive is REBUILT-FROM-TAG, sha256 `65f794a7…`, explicitly NOT byte-equal to published `da72bde4…` (gh/network blocked). | A rebuild proves content-from-tree identity but not release-asset chain-of-custody. |

## 3. Flip Path — ordered steps with owners

```
1. Owner: provision/approve adequate external target per phase39-83 criteria   [clears B1]
2. SOC lead/business: sign RTO/RPO values (meeting, change-register record)     [clears B2]
3. Infra+SOC: execute PLAN-DR-39-01 stages on approved target; measure vs RTO   [clears B3;
   go/no-go flips NO-GO→GO only after Stage0 approvals]                          needs 1,2
4. Release eng+owner: retrieve published da72bde4… asset; hash-match; register  [clears B4]
5. Governance: re-issue DEPLOY certification against evidence pack              [PARTIAL→PASS]
```

Steps 1–2 are independent and can run in parallel; step 3 consumes both.

## 4. What Improved This Phase

1. **Asset on-box, labeled honestly:** `ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz`
   (sha256 verified, extract test PASS, MANIFEST.md carries DIFFERENCE-FROM-PUBLISHED warning).
   The "no artifact on-box" half of B4 is closed; retrieval half remains.
2. **First real restore-cycle proof this quarter:** smallest snapshot index restored GREEN to a temp
   name, count-verified against snapshot-moment expectation (1405 vs 1522 source = snapshot-moment
   delta, explained), deleted clean; production untouched (phase39-73).
3. **Criteria + plan staged for go/no-go:** restore-target criteria (phase39-83) and timed rehearsal
   plan PLAN-DR-39-01 (phase39-84) exist and are approval-gated at Stage0 — the rehearsal is now a
   decision plus a window, not a design task.
4. **Persistence evidence strengthened:** exposure controls proven via compose binding; reboot-cycle
   test queued as follow-up (BCK-39-011).

## 5. Explicit Non-Claims

- This report does NOT claim DR readiness, RTO achievability, or byte-exact release custody.
- Deployability remains PARTIAL until §2 items B1–B4 are cleared in order.
