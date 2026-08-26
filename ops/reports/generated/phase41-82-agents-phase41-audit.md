# Phase 41 AGENTS.md Audit (Pre-Repair)

**Report ID:** phase41-82-agents-phase41-audit
**Phase:** 41
**Title:** AUDIT-AGENTS-41-01 — Root AGENTS.md Audited Against Phase-41 Reality: Two Stale Blocker/Pointer Entries + One Stale Canon Pointer Found; All Referenced Scripts/Docs Exist and Are Executable; Three Durable Scripting-Note Additions Justified by Same-Day Incidents; Repair Scoped as Minimal Diff Under CHG-41-AGENTS-01
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:38:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-82-agents-phase41-audit.md`

---

## 1. Scope & method

Audited the root `AGENTS.md` (143 lines, sha256
`b91b5e2f8cbeb75061794681b25077d4478d4465d1765330438d6dbf55491a00`, pre-repair
baseline captured in `ops/backups/agents/AGENTS.md.bak-20260826-063721`) against the
Phase-41 evidence chain. Checks: section completeness, canon pointers, Known Blockers
currency vs open-work register, referenced-path existence, volatile-metric hygiene.

## 2. Findings table

| ID | Severity | Finding | Evidence | Disposition |
|---|---|---|---|---|
| F-41-A1 | MEDIUM | **Stale canon pointer**: Canonical Truth names `current-state-20260826.md` (CS-40-01) as current truth; superseded this phase by `current-state-20260826-postp41.md` | phase41-81 supersession statement | Repair: update pointer |
| F-41-A2 | LOW | **Stale change-register pointer**: "current change register … phase40-02 (G40 series)" — current is phase41-02 (G41 series) | phase41-02 header | Repair: update pointer |
| F-41-A3 | MEDIUM | **Stale blocker entry — field-fix**: resolved list cites only phase40-13 field-limit raise; P41 moved containment to SOURCE (eve.json stats removed on sensor, compact emitter live, certification flips 08.27) — re-litigation risk | phase41-15/-18; live counts [phase41-81] | Repair: refresh line |
| F-41-A4 | MEDIUM | **Stale blocker entry — packet routing**: DEFERRED bullet still points solely at phase40-41/ROUT-PKT-40-01; omits ROUT-PKT-41 test-only state and the execute_python platform defect (R-PKT-PLATFORM) now central to the lane's future | phase41-52 probe; workflows API live | Repair: refresh bullet |
| F-41-A5 | INFO | Resolved-in-P40 list missing P41 closures (custody byte-exact, XFO dedup done, dual-process defect fixed/unit masked, soak PASS, watchdog live) — blockers stay honest only if closures land too | phase41-75/-76, -66, -15, -40, -43 | Repair: add one P41 resolved line |
| F-41-A6 | PASS | All three referenced gate scripts exist and are executable (`p38-report-ci.sh`, `secret-pattern-scan.sh`, `p39-agents-ci.sh`: `test -x` = YES ×3); all referenced generated docs exist (0 missing); length 143 ≤ 200 cap; no non-loopback IPs; no volatile metrics | test -x + greps live this session | None |

## 3. Durable additions proposed (ONLY where justified — same-day incidents)

Three scripting-note bullets under Credential Handling, each backed by an incident that
bit the arc twice or a live platform limitation:

1. **Heredoc-via-ssh stdin collision** — piping a heredoc into `ssh host bash <<EOF`
   collides with the remote command's stdin (consumed twice / misrouted); bit this arc
   twice today. Rule: stage scripts to a file on the target or use explicit
   `ssh host bash -s < localfile`.
2. **systemd-unit-vs-production-invocation divergence** — sensor production Suricata
   runs via exact-args setsid invocation while `suricata.service` is MASKED; unit state
   (incl. stale `failed`) does NOT reflect runtime. Verify with `pgrep -af <iface>`
   before reasoning about what is running.
3. **Shuffle execute_python param-injection limitation** — keys `data_in`, `input`,
   `execution_input`, `execution_data`, `data` are ALL UNDEF in the node globals;
   prefer native reference-consuming nodes (`filter_list`, `if_else_routing`,
   `set_datastore_value`) which resolve $refs; tracked R-PKT-PLATFORM.

Volatile metrics (counts, hashes of changing files, dates beyond anchors) deliberately
kept OUT of AGENTS.md per its own convention.

## 4. Compliance pre-checks run

```
$ test -x ops/scripts/p38-report-ci.sh        → YES
$ test -x ops/scripts/secret-pattern-scan.sh  → YES
$ test -x ops/scripts/p39-agents-ci.sh        → YES
$ grep referenced generated/*.md paths → 0 missing docs
$ wc -l AGENTS.md → 143 (cap 200)
```

## 5. Verdict

**AUDIT-AGENTS-41-01: COMPLETE — repair REQUIRED and scoped.** Five findings (A1–A5)
fold into one minimal diff executed in phase41-83 under CHG-41-AGENTS-01 with backup +
sha256 already banked (bak-20260826-063721). A6 clean.
