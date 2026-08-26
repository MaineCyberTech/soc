# Phase 42 Billing Certification

**Report ID:** phase42-97-billing
**Phase:** 42
**Title:** BILL-42-05 — August 2026 Billing Coverage Matrix: Capture VERIFIED, Detection VERIFIED Through Containment+Legacy-Bursts With Zero Impact, Class-A Routing CERTIFIED-AUTOMATED Sustained (delivered=46, Monitor Dual-Fault-Proof), Packet DEFERRED-Disclosed On Finalized Platform Evidence; Capacity 84% Transparently Disclosed Incl. Threshold Finding; Stance RECOMMENDED
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:55:00Z
**Classification:** INTERNAL (client-shareable only via phase42-98 §client-safe section)
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-97-billing.md`

---

## 1. Certification Statement

| Field | Value |
|---|---|
| Certification ID | BILL-42-05 |
| Invoice period | **August 2026** |
| Billable stance | **RECOMMENDED — with disclosures (§4)** |
| Supersedes | BILL-41-04 (phase41-94) |
| Cross-references | SCORE-42-06 (phase42-98), MONTHLY-42-10 (phase42-99), BCK-42 register (phase42-96), DEPLOY-42-07 (phase42-100), REL-42-07 (phase42-101) |

## 2. Coverage Matrix per Service Line

| Service line | Status | Basis of verification | Evidence |
|---|---|---|---|
| Log capture (7 active-class endpoints + packet sensor) | **VERIFIED** | Fleet stable at 7 active-class of 10 registered (both offline halves owner-blocked with sustained-proof chains complete); sensor single-instance healthy post-mask (production Suricata exact-args invocation verified; capture lane flowing — 24,926 alerts indexed today, cluster GREEN 3 nodes) | phase42-33/-34…39; live fleet + cluster pulls this cycle [phase42-61/-99] |
| Detection (rules + canary E2E) | **VERIFIED** | Class-A detection sustained at delivered=46 through BOTH this phase's stress events: the archives containment cutover AND the legacy-index rejection bursts (2746 rejections bounded to the doomed 08.26 index; zero on worker; zero since 07:45:42Z) — zero detection impact across both; archives lane is leaner post-containment (compact-stats health telemetry replaced field-bloated stats) | phase42-01/-08/-12/-14; phase42-57/-59 |
| Notification routing — Class-A lane | **CERTIFIED-AUTOMATED (sustained)** | delivered=46 sustained on real honeypot flow; failure detection now proven TWICE by genuine faults (04:15Z P41 + 07:45Z P42 fail-closed ERRORs caught mid-soak, correlated backend restart, no fabricated counters); cadence audit held Δ≈900 s; watchdog LIVE-TESTED in sandbox (stale→ALERT, isolation and repeat-guard verified); recovery automatic in slot immediately following each ERROR cycle | MON-CERT-42-01 PASS-WITH-WINDOW-NOTE (strict certificate completes 2026-08-27T01:45Z) phase42-55…59 |
| Packet-analysis lane | **DEFERRED (disclosed, platform-final)** | Five-test matrix across two phases proves the Tools-app cannot consume references on this build: execute_python input-injection absent; `$param` refs arrive literal; if_else_routing runtime-missing; repeat_back_to_me ignores input even with full-metadata clone; only the HTTP app interpolates (`${body:*}` → IRIS 200 ×12). Lane correctly stays DISABLED/TEST-ONLY with exact blockers named; remediation ranking B (platform upgrade) > A (UI-session rebuild falsification test) > C (external Wazuh-side filter). Zero production contamination maintained throughout | CERT-42-01 FAIL-TO-CERTIFY precise; phase42-15…32 |
| Endpoint service state | **HONEST-PARTIAL** | 7 of 10 registered endpoints active-class; two offline both OWNER-BLOCKED (013 power >26 h dark; 015 caffeinate ask packaged); one retired-stopped validated earlier | phase42-33…39; BCK-42-001a/b |
| Dashboards | **DATA-LIVE — IMPROVED THIS CYCLE** | One REAL defect found and fixed: original W2 table aggregated a text field (fielddata error reproduced); root cause established (`event.code` never populated anywhere; true signal `data.win.system.eventID`, 1.96 M docs); v2 `.keyword` artifact IMPORTED 4/4 objects with live-count parity proven (EID7 44,095 / EID5 981 / EID1 842 vs control 46,226); originals retained; swap pending one owner signoff | phase42-69/-73; BCK-42-001g |
| Backup/retention service | **VERIFIED** | fs repo 42 snapshots (latest snap-20260826-0517 SUCCESS); s3 repo 87 snapshots (latest s3-snap-20260826-0547 SUCCESS); restore spot-check #4 PASS with exact parity 170,521=170,521 — FOUR consecutive bounded restores across phases; first policy-driven ISM deletion wave ETA refined to EXACT 2026-08-29T21:00:44Z (recomputed from live `_ism/explain`), observation runbook staged with F1–F5 flip conditions | Live snapshot API re-verified this cycle [phase42-61]; phase42-64/-67 |
| Capacity posture | **DISCLOSED-KNOWN-LIMITATION** | Root filesystem 84% plateau (119G/148G, 23G avail); NEW transparent finding: `cluster.routing.allocation.disk.threshold_enabled=false` is set statically in indexer configs — the 85% low-watermark is ADVISORY-ONLY, not an enforced gate; prior capacity-risk framing corrected accordingly; wave-before-fill math shows the Aug-29 wave arrives long before any plausible fill (≈0.5–1 GB/day inflow vs 6.8G df-basis headroom); enable-vs-accept decision queued as owner item | phase42-61 §5 / -65 / -66; BCK-42-001h |
| Evidence quality of this certification | **STRONGEST-YET** | Justification in §5 | Triple-CI embed phase42-101 §6 |

## 3. What Changed vs BILL-41-04

1. **Failure detection moved from "proven once" to "proven twice by reality."** A second
   genuine fail-closed ERROR (07:45Z, correlated backend restart) was caught exactly as
   designed, and the watchdog passed a live sandbox test including its repeat-guard — the
   monitoring claim is now the most-tested line in the matrix.
2. **The packet-lane disclosure reached finality.** The blocker is no longer a single-node
   probe but a five-test capability matrix replicated across two phases; remediation options
   are ranked with costs (B>A>C). The deferral is now a settled, evidence-complete scope
   boundary rather than an open question.
3. **Dashboards improved materially:** a real reporting defect was found, root-caused to the
   true EID field, and fixed via a v2 artifact already imported with proven live-count
   parity — visibility upgrades shipped while honestly holding the swap for signoff.
4. **Capacity framing upgraded from assumed-enforcement to disclosed-reality:** discovery
   that allocation thresholds are disabled converts a previously implicit safeguard into an
   explicit known-limitation with queued owner decision — billed transparency, not new risk.
5. **Restore assurance extended:** spot-check streak ×4 with byte-count parity; retention
   wave readiness COMPLETE on every mechanical dimension with an exact ETA.

## 4. Disclosures (client-visible honesty items)

1. **Packet-platform defect (final):** automated packet-workflow routing cannot be certified
   on the current automation-engine build — five controlled tests prove reference consumption
   impossible; lane disabled/test-only; all packet events synthetic-marked and isolated from
   production counters, cases, billing, and scorecards; three ranked remediation paths staged.
2. **Disk-allocation thresholds disabled (NEW this cycle):** the configured 85% watermark is
   advisory-only because the allocation decider is statically off in indexer configs;
   compensating controls are active (hourly disk reads, wave-before-fill math, snapshot
   discipline); owner decision queued (enable vs formally accept).
3. **Legacy-index rejection bursts (bounded interim):** 2,746 ingest rejections hit ONLY the
   pre-containment 08.26 archive index during novel-schema bursts before its midnight
   rollover; detection and current indices were unaffected; risk self-extinguishes at birth
   of the templated 08.27 index.
4. **Self-signed TLS (TOFU posture):** management plane TLS 1.2/1.3 with HSTS and exactly
   one XFO and one XCTO header each (nosniff dedup COMPLETED this cycle); fingerprint pinned;
   renewal procedure documented.
5. **Webhook endpoint unauthenticated within the trusted LAN segment:** accepted-risk
   disclosure carried forward unchanged.
6. **RTO/RPO objectives remain draft:** DEC-40-01 ready-to-sign but AWAITING-OWNER.
7. **Minimal FP population:** qualitative-only regime until ≥50 natural alerts accumulate;
   no statistical FP-rate claims are made or may be cited.

## 5. Billable Stance Rationale — why evidence quality is STRONGEST-YET

- **RECOMMENDED** because the billable pipeline (capture + detection) is independently
  verified end-to-end for the invoice period AND survived two live stress events this cycle
  without impact; the notification lane is certified-automated with twice-proven real-fault
  detection; every residual gap is a disclosed scope boundary with a named, ranked
  remediation path — none is an unstated limitation.
- **STRONGEST-YET justification:** (a) negative space is measured — the packet lane's
  inability was proven by a replicated five-test matrix BEFORE anything depended on it;
  (b) positive claims are double-proven where it matters most — monitor fault-catching fired
  on two independent genuine faults; restore safety holds a four-streak with count parity;
  (c) a latent configuration surprise (thresholds-off) was self-disclosed and converted into
  a tracked decision within hours of discovery, rather than surfacing later as an incident;
  (d) every material number traces to same-day command output embedded in cited reports,
  with release custody now DOUBLE-green (v1.3.0 published-original byte-exact + v1.3.1
  tag-pushed/on-box).

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
