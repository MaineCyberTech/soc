# Phase 42 Packet Backup — Workflow Definition & Hook-Bearing Trigger Exported

**Report ID:** phase42-17-packet-backup
**Phase:** 42
**Title:** BKUP-42-01 — COMPLETE: Fresh Live Export Of Packet Workflow e133a645 (No Prior Current-State Export Existed; Only P39 Import Artifact) Plus Hook-Bearing WEBHOOK Trigger Doc Saved To ops/evidence/p42-workflow-export/ With sha256SUMS; Rollback = Restore Exports
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:16:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-17-packet-backup.md`

---

## 1. Prior-state check [VERIFIED]

`ops/evidence/` audited this session: `p37-workflow-export/`,
`p38-workflow-export/`, `p39-workflow-export/packet-workflow-import.json`.
The P39 artifact is the **creation-time import definition**, not current
state. **No existing export of live e133a645 existed.**

## 2. Export performed [VERIFIED live]

Current live definition pulled via GET `/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`
and saved, together with the hook-bearing trigger object extracted verbatim:

| Artifact | Content | sha256 |
|---|---|---|
| `packet-workflow-current.json` | full live workflow def (13 actions, status=test, start→parse-eve-json) | `bb57369f57d37e1798441d871389eae9c12236d3e2da01f811b2ce961ae45195` |
| `packet-hook-trigger-doc.json` | WEBHOOK trigger doc verbatim: label `suricata-eve-in`, id 736b7410-ed6a-52af-b369-89dbef6386cb, custom_url `p39-suricata-test`, status **stopped**, isStartNode=true | `8aa01ac2ddd23fd5e32467535503d847d650893c2a8a39bb0bf7d6e77db57bcd` |
| `SHA256SUMS.txt` | both hashes | — |

Location: `ops/evidence/p42-workflow-export/`.

## 3. Hook-doc honesty note [VERIFIED]

Direct hooks-database read is credential-blocked on this build:
`/api/v1/hooks/list` returns 401 under API-key auth (header and query-param
variants tested); admin session login path returned 403;
`GET /api/v1/hooks` is 405 (invocation-only POST endpoint). The backup
therefore captures the **hook-bearing object from the live workflow
definition** (the trigger doc above), which is what binds webhook URL →
workflow. It is labeled DERIVED-FROM-LIVE-DEF, not the raw hooks-db document.

## 4. Secret scan [VERIFIED]

Credential-named fields in both artifacts are empty strings
(`token_uri`, `client_secret`, `upload_token` all `''`); high-confidence
secret-pattern scan clean. Safe for the evidence corpus.

## 5. Rollback path

Restore = re-import/update from these exports (workflow def + trigger
binding). Evidence dir treated as immutable per AGENTS; restoration creates a
new change-register entry, never an in-place edit of evidence.
