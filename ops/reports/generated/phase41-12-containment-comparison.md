# Phase 41 Containment Comparison

**Report ID:** phase41-12-containment-comparison
**Phase:** 41
**Title:** Phase 41 Containment Options Matrix — Limit-Raise Rejected by Policy; YAML Values Impossible (Silently Ignored ×2); EVE-Stats-Drop + Compact Emitter Chosen
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:04:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-12-containment-comparison.md`

---

## 1. Decision Frame

Problem: `data.stats` contributes 441 unique leaves (~27% of the day's vocabulary) to
every future index birth. Options considered, with the full decision matrix.

## 2. Options Matrix

| # | Option | Verdict | Guarantees bound? | Touches thresholds? | Blast radius | Notes |
|---|---|---|---|---|---|---|
| O1 | Raise template limit (2000→4000) | **REJECTED-BY-POLICY** | No — grows budget, not vocabulary | YES (forbidden) | cluster-wide | Solves nothing: P39 set 2000 deliberately; raising ceilings against a WARN was the exact anti-pattern this arc exists to avoid |
| O2a | YAML `values:` under eve-log stats | **IMPOSSIBLE** (silently ignored, attempt 1) | No — 437 leaves still emitted | No | sensor only | Suricata 7.0.10 ignores directive without warning |
| O2b | YAML `values:` under top-level stats | **IMPOSSIBLE** (silently ignored, attempt 2) | No | No | sensor only | Second placement, same silent outcome |
| O3 | Indexer-side ingest filter (drop stats docs at agent/manager) | REJECTED | Partial | No | manager-wide | Drops docs AFTER they traverse pipeline; filtering at wazuh level is doc-granular not field-granular here; adds hidden coupling between agent config and index health |
| O4 | Agent-side content filtering of eve.json lines | REJECTED | Partial | No | sensor+manager | No content-filter capability on localfile lanes (line-granular only) — "rejected-no-content-filter"; would need a shipper rewrite, out of proportion |
| O5 | Mapping template with `enabled:false` on data.stats | REJECTED | Yes | Effectively yes (schema surgery) | ALL indices, all tenants | Kills the family for EVERYONE incl. historical re-index patterns; also lies about data presence (docs carry fields that can't be searched) |
| **O6** | **Remove `- stats:` from EVE types + unix-command socket + compact emitter (16 aliases) + timer + localfile** | **CHOSEN / APPLIED** | **Yes — by construction** | No | sensor + one localfile lane | Source elimination; replacement lane's vocabulary = script's whitelist |

## 3. Why O6 Wins on Every Axis

1. **Bounded by construction**: future vocabulary = 16 whitelisted names (~20 mapped
   leaves incl. detect_engines subtree + metadata). Not "less noise" — NO noise.
2. **Threshold integrity**: limit stays 2000, soft 1400, hard 1800 untouched.
   Containment achieved by shrinking demand, not enlarging supply (contrast O1).
3. **Evidence preserved**: all six required ops-evidence classes survive in compact
   form (phase41-08 §3 table), searchable and alert-lane-independent.
4. **Attribution simplicity**: single yaml edit on single producer host (phase41-07 §3);
   rollback equally scoped.
5. **Observability improved**: compact cadence (60s) vs old stats interval gives finer
   capture-health resolution than the thing it replaced.

## 4. Honest Cost Accounting for O6

| Cost | Assessment |
|---|---|
| New moving parts (socket, script, timer, localfile) | 4 small artifacts, each independently rollbackable; failure modes are loss-of-freshness (visible via missing docs), not wrongness |
| Stats events no longer in archives stream verbatim | Accepted: consumer audit proved zero consumers (phase41-09); investigation playbook rewritten around compact predicates |
| Historical/new index asymmetry for cross-range queries | Bounded by 14d retention; documented residual (phase41-09 §5) |
| Dual-process discovery forced unplanned ops work | Actually a latent defect FIXED (unit masked) — net win beyond containment |

## 5. O6 Risk Register (chosen option scrutinized)

| Risk | Likelihood | Impact | Handling |
|---|---|---|---|
| Emitter silent failure → blindspot | low-med | capture-health visibility gap | monotonic freshness observable; flip condition #4 checks daily initially (phase41-18 §4) |
| Socket path drift after reboot | low | lane stops | explicit filename + timer retry; postcheck re-run book covers it |
| Historical/new query asymmetry | certain | minor analyst friction | documented playbook shift (phase41-09 §4) |
| Mask hides unit misconfig indefinitely | certain while masked | ops debt | R-4 tracked; ExecStart fix queued next ops window |

No risk identified outweighs returning to the stats-era vocabulary cost.

## 6. Scoring Detail (axes behind the matrix verdicts)

| Option | Bound guarantee | Threshold integrity | Evidence preserved | Ops complexity | Failure mode honesty | Net |
|---|---|---|---|---|---|---|
| O1 limit-raise | ✗ | ✗ (forbidden edit) | n/a | trivial | silent budget erosion | reject |
| O2a/O2b yaml values | ✗ (proven) | ✓ | n/a | low | **dishonest** — looks contained, isn't | reject |
| O3 manager-side drop | half | ✓ | loses ops evidence entirely | medium | hidden coupling | reject |
| O4 agent content filter | half | ✓ | loses ops evidence entirely | high | no capability exists on localfile lane | reject |
| O5 mapping enabled:false | ✓ | schema-surgery class | searchable-lie risk | medium | affects all indices/tenants | reject |
| **O6 source-drop + compact emitter** | **✓ by construction** | **✓ untouched** | **six classes kept (§3)** | 4 small artifacts | failure = visible staleness | **chosen** |

The "failure-mode honesty" axis deserves emphasis: O6's worst case is a file that
stops growing — observable within minutes via doc-freshness. O2's worst case was a
config that *appears* to whitelist while emitting everything — only discoverable by
accident during field accounting. Systems whose failures are loud are preferable at
equal evidence value.

## 7. Rejection Citations for the Register

- O1 → policy basis: P39 threshold design + phase41-03 §6 table ("P41 changes sources,
  not ceilings").
- O2a/O2b → empirical basis: phase41-10 §2–3 (437 leaves still emitted after each edit).
- O4 → capability basis: Wazuh localfile lanes are line-granular; no field-level
  content filter exists to configure.
- O3/O5 → risk/benefit: cross-lane coupling and tenant-wide schema effects disproportionate
  to a problem solvable with one host's config edit.

## 8. Decision Record

CHOSEN: O6. REJECTED with prejudice: O1 (policy), O2a/O2b (empirically non-functional),
O3/O4/O5 (risk/benefit fail). Applied under gates G41-01..07 (phase41-02); lab-tested
before apply (phase41-14); verified after (phase41-16); certified CONTAINED-PENDING-
FULL-CYCLE (phase41-18).
