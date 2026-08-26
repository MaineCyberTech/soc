# Usability Audit USE-39-02

**Report ID:** phase39-94-usability-audit
**Phase:** 39
**Title:** Usability Audit USE-39-02 — Navigation, Dashboards, Failure Alerting, Ownership, Runbooks, Discoverability, False-Health Risks
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:27:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-94-usability-audit.md`

---

## 1. Authoritative Navigation — NOW EXISTS

`canonical/INDEX.md` (55 lines) + `AGENTS.md` (134 lines) + `canonical/current/open-work.md`
(written this phase) form the navigation triad. INDEX.md evaluation:

- **Structure score: 8.5/10.** Strengths: explicit directory map with live counts (current 38,
  phases 1,431 across 39 subdirs, audits 177, ledgers 33, archive 305), five numbered navigation
  rules answering the five real questions ("what is true now", "what happened in phase N", "latest
  audit of X", "where did file Y come from"), evidence-index pointer with sha256 pins, maintenance
  rules including append-only zones. Deductions: no per-family audit index (newest-instance lookup
  is rule-based, not listed); client-safe section empty pending first redacted deliverable.
- AGENTS.md complements with behavioral rules and known-blocker pointers (no volatile metrics —
  correct separation).

## 2. Dashboards

W1/W2 artifacts ready (`ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson`); runtime
import into OpenSearch Dashboards **pending** (BCK-38-014). Interim usability: text tables in
audit reports serve operators today (endpoint counts, cluster health, delivery counters all
reproducible from documented commands). Score: **6/10** (content ready, visual surface absent).

## 3. Alerting for Failures

Delivery-failure detection exists as a runnable gate (`p39-iris-delivery-check.sh`, 0.41s,
machine-parsable summary) but is **NOT scheduled** — a human must remember to run it.
Recommendation (cron candidate, activation DEFERRED to operator approval):

```
*/30 * * * * /opt/mct-security-stack/ops/scripts/p39-iris-delivery-check.sh >> /opt/mct-security-stack/ops/reports/iris-delivery-check.log 2>&1
```

(Alert-on-regression wrapper to be added when scheduling is approved; log-only first.)
Score: **5/10** (tooling exists, automation gap).

## 4. Ownership Clarity

Every open-work row in phase39-88 carries owner + dependency; AGENTS.md §Escalation maps domains
(ops-reports-owner, SOAR ops, Wazuh/indexer config, Infrastructure, Endpoint ops). Ambiguity
remaining: shared-owner rows (BCK-38-006/-007 dual ownership) lack named lead. Score: **8/10**.

## 5. Runbooks Discoverability

`ops/runbooks/` holds 20+ procedure docs (alert-routing, backup-cron operations/troubleshooting,
break-glass, canarytokens lifecycle, credential-rotation, dfir-iris, DR addendum, DO-spaces key
rotation, dr-scratch-restore series…). AGENTS.md repository map points at docs/ but not explicitly
at ops/runbooks/ — minor discoverability gap; INDEX does not list runbooks either.
Score: **7/10**.

## 6. Mobile Accessibility

Untested — honest statement: Shuffle UI responsive-behavior claim from vendor docs is UNVERIFIED;
no mobile session has been exercised against :3001 this program. No claims made. Score: **N/A (untested)**.

## 7. Report Discoverability Post-Migration

Materially improved: canonical tree groups 1,983 md files into navigable structure; catalog
(183 rows) + manifest (1,992 rows) give machine lookup; INDEX rules resolve the four canonical
questions. Pre-migration flat-root hunting is obsolete for readers who start at INDEX.md.
Score: **9/10**.

## 8. False-Health Risks Remaining

| Risk | State |
|---|---|
| Green-cluster masking watermark pressure | OPEN until Aug-29 ISM wave proves relief (disk 84% while all-green dashboards) |
| FINISHED ≠ delivered trap | Now DOCUMENTED and SCRIPTED (delivery-check distinguishes workflow-FINISHED from IRIS-landed; lifetime split delivered=37/failed=31 visible) |
| merged.mg error noise masking real remoted faults | Open until perms fix |
| Rejection-rate "success" misread pre-cutover | Documented: current indices still reject at ~150/min until 08.26 index |

## 9. Dimension Scores Summary

| Dimension | Score |
|---|---|
| Navigation | 8.5 |
| Dashboards | 6 |
| Failure alerting | 5 |
| Ownership | 8 |
| Runbook discoverability | 7 |
| Mobile | N/A |
| Report discoverability | 9 |
| False-health hygiene | 7 (two traps closed, two calendar-bound) |

Overall: **7.2/10 weighted** — largest single lever remaining is dashboard import plus scheduled
failure alerting.
