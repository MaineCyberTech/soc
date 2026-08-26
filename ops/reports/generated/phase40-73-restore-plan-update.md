# Phase 40 Restore Plan Update v2 — RESTORE-PLAN-40-02

**Report ID:** phase40-73-restore-plan-update
**Phase:** 40
**Title:** PLAN-DR-40-02 — Restore Plan v2 Incorporating Phase 40 Deltas: TLS Proxy in Stack Definition, Webhook Blocks + merged.mg Fix in Config Baseline, Hooks-Datastore Registration + Delivery-Monitor Cron + Dashboard NDJSON Re-Import in Validation, ISM Policy Correction Procedure Noted; Measurement Protocol Unchanged; NO-GO Maintained
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:45:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY (NO-GO for execution maintained)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-73-restore-plan-update.md`

---

## 1. Relationship to prior plan

This plan updates **PLAN-DR-39-01** (phase39-84) in place-of-reference only;
the P39 report is historical and is not rewritten. Everything not listed as a
delta below carries forward unchanged. Execution remains gated by Stage0 and by
GATE-DR-40-01 (phase40-74), which today records **NO-GO**.

## 2. Delta register (what changed since P39 and why)

| # | Delta | Evidence |
|---|---|---|
| D1 | **TLS proxy service added to stack definition.** A rebuild that deploys the P39-era Shuffle compose will NOT reproduce today's posture: `shuffle-tls-proxy` (TLS :3443 on 192.168.222.149) must be part of the compose set brought up in Stage1 | phase40-25..32 (decision → implementation → certification); live binding verified phase40-69 §3 |
| D2 | **Webhook integration blocks are now config baseline (both nodes).** The Wazuh→Shuffle trigger depends on integration blocks deployed on manager AND worker; a restored cluster missing them silently loses the automation lane | phase40-33..40 (current-state → schema → apply → certification); "both nodes" scope per phase40-35/36 |
| D3 | **Hooks datastore doc registration added to post-restore validation.** A workflow import alone does not restore the webhook lane: `hooks/_doc/<trigger-id>` must exist with correct start/owner/org_id or hook POSTs 404 | Defect proven phase40-33 §2 (404 "Failed getting hook"); fix recorded phase40-35 §table, phase40-36 §Defect 2; e2e proof phase40-37/38 |
| D4 | **merged.mg ownership fix included in config baseline.** Shared-config dirs must end with `merged.mg`/`agent.conf` owned `wazuh:wazuh`; root-owned copies break remoted config delivery (EACCES loop) — a fresh deploy can regress this | PERM-40-01: defect baseline phase40-18, fix+apply phase40-19, postcheck phase40-20/23, certification phase40-24 |
| D5 | **Delivery-monitor cron is a post-restore checklist item.** Host crontab entry for the IRIS delivery monitor must be recreated on the target; it is independent of container lifecycle and of git-tracked compose | phase40-65..68 (design → implement → schedule → test); persistence context phase40-69 §5 |
| D6 | **Dashboard imported state = re-import from ndjson.** Saved objects are not assumed present after snapshot restore of `.kibana` alone; the certified ndjson artifacts are the rebuild source of truth | artifact inventory phase40-61, import executed+validated phase40-62/63 |
| D7 | **ISM policy correction procedure noted.** If policy attachment anomalies recur on restored indices (as seen today), do NOT force-delete; verify attachment, re-apply policy via the documented correction path before retention reliance | anomaly chain phase40-54..56; safe-restore interaction phase40-57; guardrail script p40-field-growth-check.sh |

## 3. Updated stage table (deltas mapped onto PLAN-DR-39-01 stages)

| Stage | Content (unchanged unless noted) | v2 additions | Evidence links |
|---|---|---|---|
| Stage0 — Approvals + target | Gate unchanged: criteria met (≥8c/32GB/300GB SSD isolated), RTO/RPO decisions logged or rehearsal-runs-to-define, rebuilt-asset acceptance, rollback authorization | Add: DEC-40-01 sheet returned (phase40-72) satisfies the objectives gate | RESTORE-CRIT-39-01 (phase39-83); GATE-DR-40-01 (phase40-74) |
| Stage1 — Release-asset deploy | Copy asset (rebuilt sha256 65f794a7… unless published-original ever retrieved), extract, compose up, T0 at extraction start | **D1:** bring up shuffle-tls-proxy with cert mounts as part of the stack definition; record proxy health as part of "stack healthy" | custody distinction phase40-70 §6; TLS phase40-27/32 |
| Stage2 — Configs/secrets injection | .env from example; creds.env placement; cert mounting; ownership verification; T1 at first healthy container | **D2:** install webhook integration blocks on BOTH nodes from baseline. **D4:** assert shared-config ownership `wazuh:wazuh` (check per group dir). **D6:** stage ndjson artifacts for Stage4 import | webhook phase40-35/36; perms phase40-19; dashboards phase40-61/62 |
| Stage3 — Snapshot restore order | Security indices → states-inventory → alerts sample → archives sample (932mb class); replicas:0 during bootstrap; T2 per batch | **D7:** after each batch, check ISM policy attachment state; if anomalous, run correction procedure (re-apply policy) and note it — never delete | ISM phase40-54..56; spot-check mechanics phase39-73 + phase40-57 |
| Stage4 — Validation battery | V1 agent enrollment · V2 ingest canary (sid 2027967 lineage) · V3 Shuffle auth+exec · V4 IRIS delivery probe; T3 at completion | **D3:** add V5 hooks-doc registration check (`hooks/_doc/<id>` found=true, start=<trigger-id>) BEFORE V3 counts. **D6:** V6 dashboard re-import from ndjson + panel sanity. **D5:** V7 delivery-monitor cron installed + one manual monitor run exits 0 (`p39-iris-delivery-check.sh`) | hooks phase40-33→38; monitor phase40-66..68; probe script ops/scripts/p39-iris-delivery-check.sh |
| Stage5 — RTO/RPO measurement | UNCHANGED: T0 extraction start · T1 stack healthy · T2 per restore batch · T3 validation complete; measured RTO = T3−T0; measured RPO per tier = newest-data-time − snapshot start_time; results supersede proposals where measured | No change (protocol deliberately frozen so P39/P40 proposals stay comparable) | protocol phase39-84 §5; evidence inventory phase40-70 |
| Stage6 — Teardown/cleanup | compose down -v → remove extracted tree/images → delete clone lineage → zero-residual verification → archive T0–T3 logs | No change; cleanup contract reaffirmed READY by GATE-DR-40-01 matrix | phase39-83 §4 |

## 4. Standing status

**NO-GO maintained.** No stage may execute on the production host under any
circumstance (RESTORE-CRIT-39-01 disqualification stands; host re-measured
2026-08-26T02:36Z at 148G/117G used/83%). The plan is complete and staged so
that an adequate target plus owner sign-off converts NO-GO to GO without
further design work.
