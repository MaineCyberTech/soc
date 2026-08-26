# Phase 40 Usability Audit

**Report ID:** phase40-88-usability-audit
**Phase:** 40
**Title:** USE-40-03 — Single Canonical Current-State Doc Live (119 lines/12 sections, Clarity GOOD), Dashboards IMPORTED 8/8 but Runtime Visual Check Honestly PENDING Login-Based Pass, Delivery Monitor SCHEDULED+TAILABLE, Ownership Column Clear, Runbook Discoverability Improved via AGENTS Navigation, Mobile Untested, False-Health Risks Named — Operator Quick-Reference Card Included
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:21:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-88-usability-audit.md`

---

## 1. Current-State Document — Single Canonical

`ops/reports/canonical/current/current-state-20260826.md`: 119 lines, sections 0–11
(verification convention, release/runtime, fleet, routing, TLS, packet lane, field-fix/
retention, dashboards, delivery monitor, DR/deployability, risk register, supersession).

Clarity score: **GOOD (4/5).** Strengths: every claim row carries a flag + evidence ref;
supersession statement explicit; verification convention prevents stale-claim reuse.
The missing half-point: no table of contents and a handful of pointer-only rows require
two hops to reach live values.

## 2. Dashboards — Imported but Runtime Visual Verification PENDING (honest)

Import is real: **8/8 saved objects into `securitytenant: global`**, post-import GETs
verified, rollback IDs recorded (phase40-62), data-validation + usability review done at
artifact level (phase40-63/-64). What remains honestly pending: a **login-based visual
pass** in the dashboard UI confirming panels render against today's data (tenant header,
field-picker rendering, timefilter defaults). Until that pass, "imported" must not be
read as "visually verified." Owner: SOC lead; 15-minute task on next dashboard session.

## 3. Delivery Monitoring — Scheduled and Tailable

Cron `*/15 * * * * p39-iris-delivery-check.sh → shuffle-delivery-monitor.log` live;
flock single-instance patch applied (ae8998cf→48e716c2); log mtime 03:00:01Z today proves
firing; operators tail one file to answer "is delivery flowing":

```
eb937a37 executions=77 delivered=39 failed=31 aborted=3 other=4
e951db98 executions=1  delivered=1  failed=0
== ALERT-39-01 SUMMARY: delivered=40 failed=31 aborted=3 other=4 ==
```

## 4. Alert/Work Ownership Clarity

`canonical/current/open-work.md` carries an Owner column on every OW row (Endpoint ops /
Wazuh config / Infra / SOAR ops / SOC lead) with deps + evidence refs + rollback notes —
no orphan action items found in spot-check of OW-40-01…06/-10.

## 5. Runbook Discoverability — Improved

AGENTS.md navigation now points at the canonical current-state doc, open-work ledger,
change register, and named script gates; runbooks live under `ops/runbooks/`
(velociraptor, credential-rotation-checklist referenced by CI Gate7 so links can't rot
silently). Improvement over the P39 scattered-pointer state.

## 6. Mobile Accessibility — UNTESTED

No mobile-device pass has been made against the Shuffle UI (:3443) or dashboards.
Recorded as untested, not assumed-fine; low priority for an operator-desk workflow.

## 7. Remaining False-Health Risks

| Risk | Mitigation status |
|---|---|
| Cluster GREEN until first policy-driven deletion wave (opens Aug-29) — retention unproven under real deletion | Observation task scheduled (OW-40-03); guardrail metrics already recording |
| Workflow FINISHED ≠ IRIS-delivered ambiguity | MITIGATED by */15 delivery monitor with per-workflow counters |
| field-growth WARN state could normalize alarm fatigue | Threshold rationale documented (1400 soft vs 2000 limit); growth_per_day=0.0 shows stability |
| MISP compose interpolation failure misread as outage | Documented as template-only limitation (phase40-83 §6) |

## 8. Operator Quick-Reference Card

```
STACK STATUS      docker ps --format '{{.Names}}\t{{.Status}}' | sort
                  bash ops/scripts/full-stack-healthcheck.sh
CLUSTER/FLEET     docker exec multi-node-wazuh.master-1 /var/ossec/bin/cluster_control -l
                  docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l | grep -c Active
DELIVERY MONITOR  tail -20 /opt/mct-security-stack/ops/reports/shuffle-delivery-monitor.log
SHUFFLE UI (TLS)  https://192.168.222.149:3443   (CN=shuffle.mgmt self-signed; accept TOFU)
WEBHOOK TEST      curl -sk -X POST -H 'Content-Type: application/json' \
                    -d '{"MCT_SYNTHETIC":"true","MCT_TEST_ID":"MANUAL-SMOKE"}' \
                    http://127.0.0.1:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322
INDEXER QUERY     curl -sk -u admin:"$WAZUH_ADMIN_PASSWORD" https://127.0.0.1:9200/<index>/_count
FIELD GROWTH      bash ops/scripts/p40-field-growth-check.sh
CI SUITES         bash ops/scripts/p38-report-ci.sh; p39-canonical-ci.sh; p39-agents-ci.sh
MONITOR LOG TAIL  tail -f /opt/mct-security-stack/ops/reports/p40-field-growth.log
```

## 9. Verdict

**USABILITY AUDIT: PASS WITH ONE HONEST PENDING ITEM** (dashboard runtime visual check).
Everything an operator needs daily is one command or one file away.
