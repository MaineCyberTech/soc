# Phase 41 Packet Workflow Schema Validation — 13-Action Inventory Vs Intended Design

**Report ID:** phase41-43-schema-validate
**Phase:** 41
**Title:** SCHEMA-41-01 — Live API Inventory: All 13 Actions Present On Real Functions (7 Passthrough/Sink, 4 execute_python, check_datastore_contains, set_cache_value, HTTP POST); Functional-vs-Placeholder Split Stated Honestly Against The Platform Blocker
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:39:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (inventory VERIFIED live; capability split recorded)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-43-schema-validate.md`

---

## 1. Method

Workflow object re-read live from the API this session (not trusted from import
payload). Trigger and branch counts cross-checked.

## 2. Inventory [VERIFIED live]

Trigger: `suricata-eve-in` — status **stopped** (test-only posture). Branches: 13.

| # | Node label | Function | Role in intended design |
|---|------------|----------|--------------------------|
| 1 | parse-eve-json | Tools repeat_back_to_me | passthrough of raw event |
| 2 | normalize-fields | Tools execute_python | field normalization — **fail-open** (see §3) |
| 3 | validate-required-fields | Tools execute_python | schema gate — **gating unprovable** |
| 4 | synthetic-isolation-check | Tools execute_python | isolation branch — **branching unprovable** |
| 5 | sid-allowlist-filter | Tools execute_python | SID allowlist — **enforcement unprovable** |
| 6 | datastore-dedup-set | Tools check_datastore_contains | duplicate suppression key — key unresolved-static |
| 7 | counter-routed-increment | Tools set_cache_value | counter note — literal `$ref` echoed |
| 8 | iris-test-route-p39tag | HTTP POST | IRIS delivery — **PROVEN: HTTP 200 in-execution** |
| 9 | done-routed-log | Tools repeat_back_to_me | terminal log sink |
| 10 | SINK-synthetic-logonly | Tools repeat_back_to_me | synthetic-only sink |
| 11 | duplicate-suppressed-logonly | Tools repeat_back_to_me | suppression-path sink |
| 12 | DEADLETTER-target-fail | Tools repeat_back_to_me | dead-letter: downstream failure |
| 13 | DEADLETTER-malformed | Tools repeat_back_to_me | dead-letter: malformed input |

Function reality context: original build used non-existent functions
(json_dumps, set_fields, filter_required_fields, check_regex, filter_by_id,
set_state ×2, wrong-case post_request). Empirical inventory pulled from the
API: 53 real Tools functions; http exposes POST/GET etc. Rebuild mapped every
node onto real functions (this table IS that mapping, verified server-side).

## 3. Functional vs placeholder — the honest split

- **Functional-proven end-to-end:** webhook trigger fire; all 13 nodes execute
  without function errors (final rounds err-nodes=0 across 9+ executions);
  IRIS route delivers 200 (report 46); dead-letter/sink/logonly nodes present
  and reachable by branch structure.
- **Executes-but-semantics-unresolved:** datastore dedup (key never populated
  with resolved values), cache counter (echoes literal `$ref`) — both stem from
  the platform blocker (reports 44–45).
- **Fail-open placeholders pending platform fix or UI-session rebuild:**
  normalize / validate / isolation / allowlist python nodes run against
  undefined input — they cannot gate anything today (root cause statement in
  phase41-52).

## 4. Verdict

Schema matches intended design structurally [VERIFIED]; behavioral certification
is split exactly along the blocker line, and no report in this phase claims
otherwise.
