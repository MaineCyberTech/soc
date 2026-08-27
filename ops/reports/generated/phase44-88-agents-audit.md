# Phase 44: AGENTS Phase 44 Audit

**Report ID:** phase44-88-agents-audit
**Phase:** 44
**Title:** Phase 44 — AGENTS Phase 44 Audit
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-88-agents-audit.md`

---

## 1. AGENTS.md vs Phase 44 Reality

| AGENTS.md Section | Current Text | Phase 44 Reality | Gap |
|-------------------|--------------|------------------|-----|
| Known Blockers | Field fix, custody, TLS, webhook listed as open | All resolved except packet | STALE |
| Credential Handling | References config paths | config/shuffle-api-key (600, gitignored) | CURRENT |
| Scripting Hazard | Trailing newline warning | **NEW**: Heredoc-stdin collision bit twice today | ADD |
| Systemd Warning | suricata.service masked | Dual-process defect found/fixed | UPDATE |
| Execute Python | Not mentioned | **CRITICAL**: No incoming data injection on this build | ADD |
| Report Conventions | Metadata headers | Phase 44 closeout reports use headers | CURRENT |

---

## 2. Required AGENTS.md Additions

| Addition | Rationale | Source |
|----------|-----------|--------|
| Heredoc-via-SSH stdin-collision hazard | Bit us twice today (Phase 42/43 probes) | Phase 43 probes |
| Systemd-unit-vs-production-invocation divergence warning for sensor services | Suricata systemd unit masked; production runs via setsid | Phase 43 dual-process discovery |
| execute_python param injection defect | No incoming data injection on this build | Phase 41/42 probes |
| execute_python shadows builtin `input` | Param name collision | Phase 43 fix4 |

---

## 3. Status

**COMPLETE** — Audit complete; 6 findings; 4 new additions for AGENTS.md repair.