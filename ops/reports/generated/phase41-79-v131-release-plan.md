# Phase 41 v1.3.1 Release Plan — RELPLAN-41-01

**Report ID:** phase41-79-v131-release-plan
**Phase:** 41
**Title:** PLAN-RELPLAN-41-01 — v1.3.1 Release Execution Plan For Phase-42 Open: Stage Sequence (Freeze → Docs Sweep → Tag From Verified Tree → Build/Publish → API Hash Verify → On-Box Custody Repeat → MANIFEST v1.3.1 → Closeout), Owners, Rollback Paths, Acceptance Criteria
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:58:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-79-v131-release-plan.md`

---

## 1. Plan identity

| Field | Value |
|---|---|
| Plan ID | **RELPLAN-41-01** |
| Governing decision | DECISION-V131-41-01 (cut at Phase-42 open; phase41-78) |
| Scope | D-1…D-10 inventory (phase41-77) + packet-lane remediation landing at P42 open |

## 2. Stage sequence (Phase-42 open)

| # | Stage | Actions | Owner | Gate to proceed |
|---|---|---|---|---|
| 1 | **Freeze** | Commit packet-lane remediation; confirm clean tree (`git status`); freeze non-release changes for the cut window | Ops agent + operator ack | Clean tree, all deltas labeled |
| 2 | **Docs sweep** | RELEASE-NOTES.md v1.3.1 section; REPO-MAP / PORTS / SECURITY touched-sections verified current against phase41-77 columns | Ops agent | Docs diff reviewed in closeout report |
| 3 | **Tag** | Annotated tag `v1.3.1` from verified HEAD; record tag-object → commit → tree chain | Operator-approved (agents execute only with sign-off in change register) | Chain recorded in assurance report |
| 4 | **Build/publish** | Generate archive; create GitHub release v1.3.1; upload asset | Ops agent | Asset visible via API |
| 5 | **API hash verify** | REST re-read of release metadata; download and sha256; require BYTE-EXACT vs published identity | Ops agent | Hash match evidence block |
| 6 | **On-box custody** | Repeat phase41-75 method verbatim: store original at `ops/releases/v1.3.1/`, embed evidence block | Ops agent | Custody record published same day as release — no rebuilt-first gap |
| 7 | **MANIFEST v1.3.1** | Create `ops/releases/v1.3.1/MANIFEST.md` day-one: published-original row with hash/URL/timestamp/method | Ops agent | MANIFEST row matches API metadata |
| 8 | **Closeout** | Triple-CI gates PASS; report catalogs refreshed; blocker register updated; supersession statement if phase final | Ops agent | CI RESULT: PASS ×3 |

## 3. Rollback

| Failure point | Rollback |
|---|---|
| Pre-tag (stages 1–2) | Unfreeze; fix; no external artifact exists |
| Post-tag pre-publish (stage 3–4) | Delete local/remote tag before any consumer sees it; re-tag after fix (no asset yet = no custody burden) |
| Post-publish hash mismatch (stage 5) | DO NOT distribute; delete release + asset; rebuild from same tag; root-cause build nondeterminism; re-publish as new attempt with fresh timestamp |
| Post-custody defect discovery (stage 6+) | Standard release incident path: yank asset, issue v1.3.2 corrective tag; on-box v1.3.1 artifacts retained under quarantine label for forensics |
| Runtime regression after deploy-from-tag | Services revert individually per rollback column of phase41-77 table; the tag itself is never rewritten |

## 4. Acceptance criteria (all required)

1. Tag chain (tag object → commit → tree) recorded and verified.
2. Published asset sha256 BYTE-EXACT between GitHub release and on-box copy;
   sizes equal API-reported values.
3. `ops/releases/v1.3.1/MANIFEST.md` carries the published-original row
   (hash/URL/timestamp/retrieval-method) within the same session as publish.
4. Triple-CI gates PASS at closeout; zero secret-pattern hits.
5. Every D-1..D-10 item plus packet-lane remediation demonstrably present in
   the tagged tree (inventory-to-tree spot checks).
6. Blocker register updated: "v1.3.1 cut decision" resolved.

## 5. Contingency

If packet-lane work slips at P42 open: per phase41-78 §4 fallback — cut v1.3.1
with D-1..D-10 only; packet-lane moves to the v1.3.2 register. The plan is
otherwise unchanged.
