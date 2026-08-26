# Phase 43: Disk Threshold Risk Acceptance

**Report ID:** phase43-39-disk-risk-acceptance.md
**Phase:** 43
**Title:** Phase 43 Disk Threshold Risk Acceptance
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T17:40:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (Decision Documented)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-39-disk-risk-acceptance.md`

---

## 1. Decision Record

| Decision | **ACCEPT ADVISORY-ONLY** (Do not enable `disk.threshold_enabled`) |
|----------|---------------------------------------------------------------|
| Date | 2026-08-26 |
| Decided By | [Owner Name - AWAITING] |
| Rationale | Current growth predictable; ISM wave Aug-29 relieves ~7.8GB; manual cleanup available; enabling thresholds risks allocation blocks during active ingestion |

---

## 1. Risk Acceptance Details

| Risk | Likelihood | Impact | Accepted? | Mitigation |
|------|------------|--------|-----------|------------|
| Hit 95% flood stage | Low (5-10 days at current rate) | Critical (read-only) | **ACCEPTED** | ISM wave Aug-29 reclaims ~7.8GB; manual purge available |
| Allocation blocks at 85% | N/A (thresholds disabled) | — | N/A | N/A |
| No early warning | Medium | Medium | ACCEPTED | Hourly guardrail script + manual monitoring |

---

## 2. Compensating Controls (Active)

| Control | Frequency | Action |
|---------|-----------|--------|
| Field guardrail script | Hourly (cron) | Alert if >1,800 fields or >85% disk |
| ISM wave monitoring | Hourly (cron) | Alert if wave delayed |
| Manual cleanup playbook | On-demand | `DELETE /wazuh-archives-4.x-2026.08.15` etc. |
| Emergency purge script | On-demand | `curl -X DELETE ...` documented |

---

## 3. Review Triggers

| Trigger | Action |
|---------|--------|
| Disk > 90% | Re-evaluate enable thresholds |
| Growth rate > 5%/day | Re-assess |
| ISM wave delayed > 24h | Escalate |

---

## 4. Status

**DECISION DOCUMENTED** — Advisory-only accepted with compensating controls. Re-evaluate at Phase 44 or if conditions change.