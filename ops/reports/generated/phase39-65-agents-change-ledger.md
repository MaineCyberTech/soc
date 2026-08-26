# Phase 39 AGENTS Change Ledger — CHG-39-AGENTS-01 (Creation)

**Report ID:** phase39-65-agents-change-ledger
**Phase:** 39
**Title:** Change Ledger Entry CHG-39-AGENTS-01: Root AGENTS.md Creation with Sources, Verification Refs, and Rollback
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:19:22Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-65-agents-change-ledger.md`

---

## Entry CHG-39-AGENTS-01

| Field | Value |
|---|---|
| Type | CREATION |
| Old state | None — zero agent-instruction files existed (phase39-53) |
| New state | `/opt/mct-security-stack/AGENTS.md` — 6576 bytes, 134 lines, sha256 `5a218902…b9b44`, governing instruction file with precedence statement |
| Scope | Repository root (whole-repo governance; nested override model defined for the future) |
| Rationale | First codification of standing safety rules and navigation truth; previously these lived only across pack READMEs outside the repo and in ~100 scattered reports. Codifies rather than invents: every rule traceable to a source. |
| Applied at | 2026-08-25T23:19:22Z |

### Sources (anchors)

- Discovery/precedence/backup policy: phase39-53, phase39-54
- De-facto rule provenance (packs p36–p39 README Safety sections; report + script conventions): phase39-55
- Durable-fact selection: phase39-56 (F1–F12)
- Gap analysis: phase39-57; dynamic-state policy: phase39-60
- Standing-rule provenance packs: `/home/user/mct-p36/README.md`, `mct-p37/README.md`, `mct-p38/README.md`, `mct-p39/README.md`

### Verification references

- Command/path validation: phase39-58 (100% live PASS)
- Safety coverage/non-conflict: phase39-59
- Dry run READY: phase39-62
- Post-validate hash equality + gate re-runs: phase39-64
- Governance CI PASS: phase39-66

### Owner / rollback

- Owner: MCT SOC.
- Rollback: delete `/opt/mct-security-stack/AGENTS.md` (restores verified pre-state of absence).
  For any FUTURE edit: restore newest `ops/backups/agents/AGENTS.md.bak-<ts>` and verify its
  `.sha256` sidecar before trusting the restore.

Ledger COMPLETE. Single entry; no other AGENTS-affecting changes this arc.
