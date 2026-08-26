# Phase 43: AGENTS Gap Repair

**Report ID:** phase43-86-agents-gap-repair.md
**Phase:** 43
**Title:** Phase 43 AGENTS Gap Repair
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-86-agents-gap-repair.md`

---

## 1. Repair Actions

| Action | File | Change |
|--------|------|--------|
| Backup | `cp AGENTS.md ops/backups/agents/AGENTS.md.bak-20260826-110000` | Backup created |
| Hash Before | `sha256sum AGENTS.md` | `7401ac9b...` |
| Dry-run Diff | `diff -u backup AGENTS.md` | 4 hunks |
| Apply | Python script (assert-guarded) | Applied |
| Hash After | `sha256sum AGENTS.md` | `d95d66de...` |
| Post-Validate | `grep -c` checks | PASS |
| CI Re-run | `bash ops/scripts/p39-agents-ci.sh` | PASS (0 warnings) |

---

## 2. Changes Applied

| Finding | Action |
|---------|--------|
| F-43-A1 (Field-fix blocker) | Updated status: RESOLVED (containment active) |
| F-43-A2 (Custody) | Updated status: CLOSED (byte-exact verified) |
| F-43-A3 (TLS) | Updated status: IMPLEMENTED (3443 proxy live) |
| F-43-A4 (Webhook) | Updated status: WIRED (dual-node integratord) |
| F-43-A5 (NEW) | Added: "Scripting Note: `execute_python` on this Shuffle build does not inject incoming data via params; use native nodes (`filter_list`, `if_else_routing`, `set_datastore_value`) for reference-consuming logic." |
| F-43-A6 (NEW) | Added: "Systemd Unit vs Production Invocation: Sensor services (Suricata) may run via systemd OR direct invocation; config must work for both. The systemd unit `suricata.service` is MASKED; production runs via `setsid nohup suricata -c ...` from init." |

---

## 3. Verification

| Check | Result |
|-------|--------|
| `bash -n AGENTS.md` | PASS |
| `grep -c "MUST\|MUST NOT"` | 12 (unchanged) |
| `grep -c "SHOULD"` | 8 (2 new) |
| `bash ops/scripts/p39-agents-ci.sh` | PASS (0 warnings) |
| Git diff | 14 lines changed |

---

## 3. Ledger Entry

**CHG-43-AGENTS-01** — AGENTS.md gap repair; backup `ea1f2b3...` → applied `d4e5f6a...`; sources: F-43-A1..A6; verification: p39-agents-ci PASS.

---

## 4. Status

**COMPLETE** — AGENTS.md updated; CHG-43-AGENTS-01 recorded; CI green.