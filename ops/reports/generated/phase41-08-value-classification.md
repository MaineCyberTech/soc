# Phase 41 Value Classification

**Report ID:** phase41-08-value-classification
**Phase:** 41
**Title:** Phase 41 Value Classification — Required-Evidence Classes vs Noise Classification Across the Mapped Vocabulary
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-08-value-classification.md`

---

## 1. Purpose

Classify every mapped field family by evidentiary value so containment decisions are
policy-driven rather than size-driven. Classes:

- **R1 REQUIRED-EVIDENCE** — feeds detection, alerting, or incident response.
- **R2 REQUIRED-OPS** — feeds health/capacity/audit operations (dashboards, guardrails).
- **N1 NOISE-STRUCTURAL** — high-cardinality payload residue with no consumer.
- **N2 NOISE-DUPLICATED** — information available elsewhere in richer form.

## 2. Full-Stats Family (the contained one)

| Sub-family | Leaves | Class | Reasoning |
|---|---|---|---|
| stats.decoder / app_layer / flow / tcp / defrag / flow_bypassed | ~412 | **N1** | engine-internal counters; zero consumers (phase41-09); no detection references; pure mapping pressure |
| stats.capture.kernel_packets/drops/errors | 10 | R2 | capture-health evidence — but preserved in compact lane |
| stats.detect.* | 8 | R2 | alert-queue/engine health — preserved in compact lane (detect_alerts, detect_engines, queue_overflow) |
| stats.uptime | 1 | R2 | sensor liveness — preserved via compact uptime |
| stats.ftp/http memuse | 4 | R2 (thin) | memcap early-warning — preserved via compact aliases |

Net: of 441 leaves, **~412 classify N1** (93%) and ~29 carried R2 value — and all R2
value survives in the compact lane's 16 aliases. This is the quantitative core of the
containment justification.

## 3. Required-Evidence Classes Preserved After Containment

The compact lane was designed around six evidence classes the SOC actually requires
(phase41-13 §2). Post-apply verification shows each present in indexed compact docs:

| Class | Aliases | Verified value @04:50Z doc |
|---|---|---|
| Packet/capture health | capture_kernel_packets, _drops, _errors | 368,291 pkts / **0 drops** |
| Memory pressure | flow_memcap/spared/emergency_mode, tcp/http/ftp_memuse | tcp_memuse=1,216,000; flow_memcap=0 |
| Detection health | detect_alerts, detect_engines(+rules_loaded/failed), queue_overflow | alerts=0; rules_loaded=529; skipped=0 |
| Throughput basics | decoder_pkts/bytes/invalid | present each run |
| Freshness/liveness | uptime | 3276s at last sample |
| Ruleset currency | detect_engines.last_reload | 03:55:58.844937+0000 (restart-stamped) |

## 4. Other Families (unchanged this phase)

| Family | Class | Note |
|---|---|---|
| data.win.* | R1 | Windows detections depend on EID/description fields |
| data.audit.*, data.osquery.* | R1/R2 | baseline + posture evidence |
| data.ubiquiti.*, data.unifi.* | R1 | AP-side visibility incl. kick-noise (bounded vocab) |
| data.parameters.* | N1-leaning | URL/form parameter residue; retained — no budget pressure |
| rule./agent./GeoLocation. | R1 core schema | never candidates |
| data.alert.* | R2 | nested suricata alert metadata on archive copies |
| data.docker., origin, MCT_* tags | R2 | provenance/tracking |

## 6. Classification Criteria (definitions used)

| Class | Test applied |
|---|---|
| R1 REQUIRED-EVIDENCE | a detection rule, active response, or IR playbook references the family, OR removal would blind first-line triage |
| R2 REQUIRED-OPS | capacity/health/freshness operations consume it (guardrails, dashboards, this arc's own compact contract) |
| N1 NOISE-STRUCTURAL | mapped only because dynamic mapping saw it once; zero consumers; no human ever queried it in corpus history |
| N2 NOISE-DUPLICATED | same fact available in richer form elsewhere in the document |

Boundary cases adjudicated:

- `stats.uptime` → R2 despite being 1 leaf: liveness evidence with zero substitutes
  pre-lane; now duplicated by compact uptime (N2-flavored, but kept as lane anchor).
- `data.parameters.*` → left UNCLASSIFIED-ACCEPTED: N1-leaning but volume-bounded and
  not budget-relevant post-containment; classing it noise today would invite an
  unbounded cleanup argument with no budget payoff.
- `stats.decoder/app_layer` internals → N1 even though individually "interesting":
  interest ≠ consumer; the consumer audit (phase41-09) is what makes N1 defensible.

## 7. Cross-Reference to Decisions

| Classification outcome | Decision touched |
|---|---|
| stats internals ≈412 N1 | G41-01 source removal (phase41-12 O6) |
| stats ops classes R2 (~29 leaves) | compact lane whitelist design (phase41-13 §2) |
| win = R1 | DEFER containment + triggers (phase41-11) |
| ubiquiti/unifi R1 | accepted as-is |
| parameters N1-leaning | accepted, revisit only if budget pressure returns |

| Verdict | Unique leaves (today) | Action |
|---|---|---|
| Removed as noise | ≈412 (stats internals) | G41-01 applied |
| Preserved as required ops evidence | ≈29 worth → 16 aliases (~20–22 mapped) | compact lane live |
| Remaining vocabulary accepted | ~450 unique outside stats | monitored by guardrail |

## 8. Noise Accounting Summary (retained table header context)

Table above is the arc's net value equation: the removed mass was 93% structural
noise, and every leaf with operational meaning reappears in a bounded, reviewed
whitelist.
