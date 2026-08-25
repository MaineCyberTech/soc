# Phase 38-32: Stale Claim Scan

**Title:** Phase 38-32: Stale Claim Scan
**Report ID:** phase38-32-stale-claim-scan
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-32-stale-claim-scan.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)
**Supersedes:** prior draft of this same report ID (adds fleet-list, disk-number, workflow-backup and master-count staleness; preserves chronology of every superseded claim)

---

## 1. Purpose

Flag claims that have been superseded by later, directly evidenced state — while preserving chronology (a stale claim is not a false claim at its write time). Each entry maps: stale statement → source → superseding evidence → canonical replacement statement valid as of 2026-08-25.

---

## 2. Stale Claims and Canonical Replacements

### STALE-01: `decoder_order_size` default = 256

| Field | Value |
|---|---|
| Stale claim | "Suricata stats (522 fields) > decoder_order_size (256)" as the current-state diagnosis |
| Sources | `phase36-29-field-cardinality-baseline.md`; restated in `phase36-75-final-report.md:26` |
| Superseded by | Config raised to 512 in P36 (`phase36-32-field-cardinality-fix-applied.md`; restart PID recorded); then proven INSUFFICIENT (`phase37-36-field-522-vs512.md`, `phase37-38-field-postlogs.md:17`) |
| **Canonical (2026-08-25)** | `decoder_order_size=512` is applied and ACTIVE but **INSUFFICIENT**: "Too many fields" errors continue at ~100/min (18,849+ cumulative). Contingency plan to 1024 exists (`phase37-41-field-limit-plan.md`) with apply procedure staged but NOT executed (`phase37-42-field-limit-apply.md:3` "NOT YET APPLIED"). |
| Note | The 512 value itself is now the stale layer if quoted as a *resolution*; it is only current as a *config state*. |

### STALE-02: Shuffle frontend on loopback / auth broken

| Field | Value |
|---|---|
| Stale claim | "Shuffle backend: UP on 127.0.0.1:5001; Shuffle frontend: UP on 127.0.0.1:3001" and "Username login: BROKEN" |
| Sources | `phase36-17-shuffle-wazuh-integration-blocker.md` §Current state; `phase36-16-shuffle-evidence-bundle.md` §Auth status |
| Superseded by | Listener census showing 0.0.0.0:3001 (`phase37-04-shuffle-listener.md:11`); auth resolved via password rotation (`phase37-03-shuffle-password.md`: old credential rejected 401 pre/post, new credential verified 200 + bearer issued) |
| **Canonical (2026-08-25)** | Frontend binds **0.0.0.0:3001 plaintext HTTP, no TLS, no firewall** (`ss -tlnp` confirms; HTTPS probe fails). Backend loopback-only on 5001. Admin auth functional after P37 rotation; operator-side rotation receipt still pending (`phase37-03` §Operator Rotation Status all ⏸). |

### STALE-03: ISM policy "not attached" / "no wave possible"

| Field | Value |
|---|---|
| Stale claim | Policy existed but attached to nothing; deletions impossible |
| Source | Early-P36 disk/relief reporting (referenced from `phase36-75-final-report.md:12-14`: "existed but was NOT attached… Fix applied: All 11 archive indices") |
| Superseded by | Attachment completed P36; first deletion forecast 2026-08-29; verification snapshot `generated/phase38-79-retention-verification.md` lists all 11 archive indices (2026.08.15–08.25, ~8.7GB primary total), zero deletions |
| **Canonical (2026-08-25)** | `wazuh-archives-14d` attached to all 11 archive indices. Realized relief to date: **0 bytes**. ~7.9GB relief remains a FORECAST for 2026-08-29 pending wave observation; ISM explain endpoint returned empty, so execution mechanics still need observation. |

### STALE-04: Fleet lists without agent 016 / with different composition

| Field | Value |
|---|---|
| Stale claim | Older operator reports describe a fleet where 016 is absent/not forwarding and 012/014 are the pilot endpoints in recovery (e.g., `final-phase22-operator-report-20260822-034811.md`, `final-phase23-operator-report-20260822-050546.md:98` "015 restored; 014 degraded; 013 offline") |
| Superseded by | Agent 016 active with Suricata (`phase36-39-endpoint-status.md`; eve.json forwarding applied per git dca1691 "P34 update: agent 016 eve.json forwarding applied"); P34 observe window 17h/8.3M pkts (git 3d4d072) |
| **Canonical (2026-08-25)** | Active agents: **000, 006, 007, 011, 012, 014, 016 (7)**. Disconnected: 013, 015. Retired: 008. |

### STALE-05: Disk percentage snapshots

| Field | Value |
|---|---|
| Stale claim | "85% (120G/148G)" early P36; plateau references "81%" in P27 era (git 9f09dda context); P37 final "84% (119G/148G)" |
| Sources | `phase36-75-final-report.md:57`; P27/P28 finals; `generated/phase38-00-master.md:96` |
| Superseded by | Live OS `df -h /` 2026-08-25: **117G used / 148G, 83%**, 25G avail; ES low watermark ACTIVE |
| **Canonical (2026-08-25)** | ~83–84% depending on measurement source (OS df vs ES disk stats differ slightly). Any single hard number must carry its source and timestamp. |

### STALE-06: "/tmp 100% incident" as current state

| Field | Value |
|---|---|
| Stale claim | "/tmp at 100% — docker exec restored" incident framing (git 91f6789, P31v2) |
| Superseded by | Cleanup cron 03:00 UTC + thresholds (`phase37-55-tmp-thresholds.md`, `phase37-56-tmp-recurrence.md`) |
| **Canonical (2026-08-25)** | `/tmp` at **21% (1.6G/7.6G)**, cron active, healthy (live `df -h /tmp`; `phase37-81-final.md:86-93`). Incident is historical. |

### STALE-07: "No workflows to back up"

| Field | Value |
|---|---|
| Stale claim | `final-phase35-operator-report-20260825-1841Z.md:54` — "Workflow backup: N/A — No workflows to back up" |
| Superseded by | 2 workflows discovered P36 (`phase36-75-final-report.md:19`); exports written P37 (`phase37-10-workflow-export.md`); periodic backup JSONs exist at `ops/backups/shuffle-workflows/shuffle-workflows-20260811-061156.json` … `-20260823-054501.json` |
| **Canonical (2026-08-25)** | 2 workflows exist, both healthcheck; exports + dated backups present on disk. |

### STALE-08: "Routing deferred" as forward-looking plan (chronology preserved)

| Field | Value |
|---|---|
| Claim chain | P34 commit dca1691 "production routing still deferred" → P35 commit cbcca53 "Shuffle routing deferred (UI-gated)" → `phase37-32-routing-decision.md:9` "Routing to production is DEFERRED" → P37 roadmap item |
| Status | **Not stale — still true.** Listed here because multiple summaries phrase deferral as an event that already happened ("routing handled"); it has never been applied. |
| **Canonical (2026-08-25)** | Zero production routing configured; deferral decision stands (`phase37-32`); 796 executions are healthchecks only. |

### STALE-09: Phase 38 master self-description of corpus scope

| Field | Value |
|---|---|
| Stale claim | "Phase 38 executed 9 prompts… All 9 reports have been written"; §8 "Total: 10 reports, ~51 KB" |
| Source | `generated/phase38-00-master.md:19,27,241` |
| Superseded by | `generated/` now holds 55 phase38 files spanning IDs 00–96 (with gaps); Phase 38 was extended beyond the original 9-prompt plan |
| **Canonical (2026-08-25)** | Phase 38 corpus = 55 generated files (and growing); master §1/§8 counts are a point-in-time snapshot superseded by later batches. |

### STALE-10: Memory 78%

| Field | Value |
|---|---|
| Stale claim | `phase36-75-final-report.md:64` "78% used" |
| Superseded by | `phase37-81-final.md:110` "11,747 MB (75%)" |
| **Canonical (2026-08-25)** | Memory 75%, swap pressure HIGH at 64%. |

---

## 3. Chronology Preservation Note

No stale claim above is deleted or rewritten in its source file. Each source remains intact under G2/G4 gates; this report is the sole redirect layer. Readers of any source listed in §2 MUST consult the matching canonical statement before citing the figure.

## 4. Recommendations

1. Add `superseded_by:` front-matter keys pointing at this report's section anchors when migration apply (phase38-69) is approved.
2. Any summary reusing a §2 stale figure without the canonical replacement is itself non-compliant and should be flagged by report CI (phase38-71).
