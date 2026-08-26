# Phase 39 AGENTS Apply — Root AGENTS.md Created, Hashed, Backup Policy Armed

**Report ID:** phase39-63-agents-apply
**Phase:** 39
**Title:** Apply Record: /opt/mct-security-stack/AGENTS.md Written with Validated Content — Bytes, sha256, Timestamp Recorded
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:19:22Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-63-agents-apply.md`

---

## 1. Action

`/opt/mct-security-stack/AGENTS.md` was created with the exact validated content from the
dry run (phase39-62), which is byte-identical to the proposal embedded in phase39-61.

## 2. Apply Facts

| Attribute | Value |
|---|---|
| Path | `/opt/mct-security-stack/AGENTS.md` |
| Bytes | **6576** |
| sha256 | `5a2189025e04c4a50345290d844594dc1870af4b62d509b2f8568af8436b9b44` |
| Lines | 134 (LF endings) |
| Applied at | 2026-08-25T23:19:22Z (file mtime) |
| Pre-state | absent (phase39-53) → creation, not modification |

## 3. Backup-Policy Note

- Pre-create backup: N/A — nothing existed to back up (documented in phase39-54).
- Forward policy active as of this timestamp: every future edit must first create
  `ops/backups/agents/AGENTS.md.bak-<ts>` + `.sha256` sidecar (directory exists, gitignored).

## 4. Git Intent

This file is a NEW untracked path. It is staged for inclusion in the Phase 39 commit that
lands at report 103 per the arc plan (`git add AGENTS.md` alongside the phase39 reports and
scripts). No commit is performed by this report; HEAD remains `04e689d…` with P39 changes
pending.

## 5. Companion Artifact Created

`ops/scripts/p39-agents-ci.sh` (executable) was created in this same apply window so every
path referenced by the new file resolves immediately (dry-run finding #2). Its full run is
recorded in phase39-66.

## Verdict

Apply COMPLETE.
