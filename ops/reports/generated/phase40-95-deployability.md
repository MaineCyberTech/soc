# Phase 40 Deployability Certification

**Report ID:** phase40-95-deployability
**Phase:** 40
**Title:** DEPLOY-40-05 — Verdict PARTIAL (Maintained, Honest): Four Blockers Re-Stated Against Phase-40 Reality, Improvements Credited, Ordered Flip-Path With Owners
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:00:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-95-deployability.md`

---

## 1. Verdict

**PARTIAL — maintained honestly.** Phase 40 added real deployability substance (second bounded
restore with exact count parity; restore plan v2 folding seven runtime deltas into the rehearsal
stages; config/secrets baselines now version-controlled including this cycle's TLS, webhook, and
ownership fixes), but the four gating blockers below are unchanged in kind. No verdict inflation:
two bounded restores are not a full-cluster rehearsal; a ready-to-sign sheet is not a signature;
a labeled on-box asset is not published custody.

## 2. Blockers (exact)

| ID | Blocker | Why it gates |
|---|---|---|
| **B1** | **External rehearsal target ABSENT — owner decision pending.** Host remains self-disqualified as its own target; criteria exist and plan v2 is staged, but no target has been named or approved. | Full-cluster restore cannot be proven on the production host itself; AGENTS.md requires operator sign-off for rehearsal execution. |
| **B2** | **RTO/RPO objectives AWAITING-OWNER.** DEC-40-01 ready-to-sign sheet exists (proposal RTODRF-40-01 values); interim governance is DRAFT-TARGETS, planning use only. | Without signed objectives there is no pass/fail criterion for the drill and no honest recoverability claim. |
| **B3** | **Full-cluster rehearsal never executed.** Evidence remains component-grade: two bounded single-index restores (P39 spot-check; P40 603=603 parity from snap-20260826-0017). Multi-node ordering and timing-under-pressure unproven. | Deployability PASS requires recovery evidence at system scope. |
| **B4** | **Published-asset custody PARTIAL.** On-box archive is REBUILT-FROM-TAG (sha256 `65f794a7…`); byte-exact published original (`da72bde4…`) unretrieved — needs gh/network path. | A rebuild proves content-from-tree identity, not release chain-of-custody. |

## 3. What Improved This Phase (credited, without inflating the verdict)

1. **Asset on-box, labeled honestly (carried + re-affirmed):**
   `ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz` with DIFFERENCE-FROM-PUBLISHED manifest;
   release-assurance re-run this cycle keeps the label intact (phase40-96).
2. **TWO successful bounded restores now on record:** P39 smallest-index spot-check (explained
   delta) AND P40 count-parity restore (603=603, temp-name isolation, deleted clean). Restore
   mechanics are no longer first-of-quarter novelty — they are a repeatable pattern.
3. **Plan v2 (RESTORE-PLAN-40-02):** all seven phase-40 deltas folded into stages — TLS proxy in
   stack definition, webhook blocks + merged.mg ownership fix in config baseline,
   hooks-datastore registration + delivery-monitor cron + dashboard NDJSON re-import in
   validation, ISM policy-correction procedure noted. The rehearsal is now strictly a
   decision-plus-window, not a design task.
4. **Secrets/config baselines versioned:** TLS proxy conf + cert fingerprint pin, webhook
   integrator blocks (config-of-record both nodes), merged.mg/agent.conf chown procedure, monitor
   cron entry, and AGENTS.md hazard rules all sit in tracked files — a rebuild-from-repo now
   reproduces the security posture, not just the services.

## 4. Flip Path — ordered steps with owners

```
1. Owner: name/approve adequate external target per criteria          [clears B1]
   (owner-batch session item)
2. SOC lead/business: sign DEC-40-01 sheet; record in register        [clears B2]
   (same owner-batch session)
3. Infra+SOC: execute RESTORE-PLAN-40-02 on approved target;
   measure vs signed RTO/RPO; Stage0 approvals gate go/no-go          [clears B3; needs 1+2]
4. Release eng+owner: retrieve published da72bde4… asset via
   gh/authenticated path; hash-match; register                        [clears B4]
5. Governance: re-issue DEPLOY certification against evidence pack    [PARTIAL→PASS]
```

Steps 1–2 are independent and belong in ONE owner session (see phase40-91 §owner-batch);
step 3 consumes both.

## 5. Explicit Non-Claims

- This report does NOT claim DR readiness, RTO achievability, or byte-exact release custody.
- Deployability remains PARTIAL until §2 items B1–B4 clear in order; the P40 improvements move
  readiness-to-flip, not the verdict itself.
