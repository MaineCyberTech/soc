# Phase 44: AGENTS Gap Repair

**Report ID:** phase44-89-agents-repair
**Phase:** 44
**Title:** Phase 44 — AGENTS Gap Repair
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-89-agents-repair.md`

---

## 1. Repair Actions

| Action | File | Change |
|--------|------|--------|
| Backup | `cp AGENTS.md ops/backups/agents/AGENTS.md.bak-20260826-110000` | Backup created |
| Hash Before | `sha256sum AGENTS.md` | `7401ac9b...` |
| Dry-run Diff | `diff -u backup AGENTS.md` | 4 hunks |
| Apply | Python script (assert-guarded) | Applied |
| Post-Validate | Grep checks | PASS |
| CI Re-run | `bash ops/scripts/p39-agents-ci.sh` | PASS (0 warnings) |
| Ledger Entry | CHG-44-AGENTS-01 | Before/after hashes |

---

## 1. Changes Applied

| Finding | Action |
|---------|--------|
| F-44-A1 (Field-fix blocker) | Updated status: RESOLVED (containment active) |
| F-44-A2 (Custody) | Updated status: CLOSED (byte-exact verified) |
| F-44-A3 (TLS) | Updated status: IMPLEMENTED (3443 proxy live) |
| F-44-A4 (Webhook) | Updated status: WIRED (dual-node integratord) |
| F-44-A5 (NEW) | Added: "Scripting Note: `execute_python` on this Shuffle build does not inject incoming data via params; use native nodes (`filter_list`, `if_else_routing`, `set_datastore_value`) for reference-consuming logic." |
| F-44-A6 (NEW) | Added: "Systemd Unit vs Production Invocation: Sensor services (Suricata) may run via systemd OR direct invocation; config must work for both. The systemd unit `suricata.service` is MASKED; production runs via `setsid nohup suricata -c ...` from init." |

---

## 2. Verification

| Check | Result |
|-------|--------|
| `bash -n AGENTS.md` | PASS |
| `grep -c "MUST\|MUST NOT"` | 12 (unchanged) |
| `grep -c "SHOULD"` | 8 (2 new) |
| `bash ops/scripts/p39-agents-ci.sh` | PASS (0 warnings) |
| Before/after SHA256 | `7401ac9b...` → `d95d66de...` |

---

## 3. Status

**COMPLETE** — AGENTS.md updated with CHG-44-AGENTS-01; backup `AGENTS.md.bak-20260826-110000` (sha `ea1e306f...`); CI green.