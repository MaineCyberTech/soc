# Phase 39 Token Backup Plan

**Report ID:** phase39-05-token-backup-plan  
**Phase:** 39  
**Title:** Pre-Rotation Backup Inventory and Forward-Only Rollback Policy for ROT-39-01  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:28:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-05-token-backup-plan.md`  

---

## 1. Objective

Define what was captured before rotating the Shuffle admin bearer (ROT-39-01), what the
rollback path would be, and why rollback-to-compromised is explicitly prohibited.
This report contains no secret values.

## 2. Pre-Rotation Backup Inventory (all taken/verified before datastore write)

| # | Item | Form | Location | Purpose | Secret-content policy |
|---|---|---|---|---|---|
| B1 | Workflow exports (high-severity, classb) + execution records | JSON files + SHA256SUMS.txt | `ops/evidence/p38-workflow-export/`, `ops/evidence/p37-workflow-export/` | restore reference for workflow params if API PUT mis-fired | values redacted post-op; hashes refreshed phase39-11 |
| B2 | Users doc STRUCTURE | field-names-only documentation (this report) — `_id` = `39dd09d3-7874-46a0-8672-e7acb8827b2c`, index `users`, fields incl. `apikey`, `id`, `username`, role fields | documented here as schema, not values | proves exact write target without storing old value | NO VALUES |
| B3 | Compose file backup | yml copy | `ops/backups/docker-compose.shuffle.yml.pre-p39-hardening` | G3 rollback | no secrets in compose |
| B4 | UI login path check | operator password login verified independent of API key | live test in ops window | guarantees operator lockout impossible during rotation | NO VALUES |
| B5 | Old value itself | **NOT preserved anywhere by design** | — | see §4 | intentionally discarded |

B2 detail (structure only, field names as used by the rotation):

```
index:   users
doc_id:  39dd09d3-7874-46a0-8672-e7acb8827b2c
fields referenced by rotation: apikey (write target)
observed auth behavior: backend caches apikey material in memory → restart required
```

## 3. Why the Datastore Write Is the Supported Mechanism

Self-hosted Shuffle exposes no administrative "rotate my API key" REST endpoint; the
supported self-hosted path is a direct update of the user record's `apikey` field in
the `shuffle-opensearch` datastore, followed by a backend restart because authentication
material is cached in memory with TTL well above operational need (>95s observed
behavior: old token still accepted ~22:11Z pre-restart). The mechanism, steps, and
proof are recorded in phase39-06 and phase39-07.

## 4. Rollback Path Analysis

### 4.1 Rollback-to-old-value

Restoring the prior `apikey` value would require re-writing the compromised bearer —
the exact value whose disclosure triggered INC-39-01. Preserving it "just in case"
would recreate the incident inside a new location (key file, backup, report).

**Policy: PROHIBITED.** The compromised value was not copied to any Phase-39 artifact,
and the only copies that ever existed (reports, .env, datastore) were overwritten or
redacted. Consequence: there is deliberately NO technical rollback to the old token.

### 4.2 Forward-only recovery (the actual rollback story)

If the NEW token were lost or mis-issued:

1. Repeat the same supported mechanism: write a freshly generated value into
   `users` doc `39dd09d3-7874-46a0-8672-e7acb8827b2c` field `apikey`.
2. Restart shuffle-backend to flush cache.
3. Update consumers (`config/shuffle-api-key`, `.env`).
4. Re-run the INV-style proof (old-newest=401 / newest=200).

Any number of rotations can be executed this way; availability risk is bounded by the
restart window (~seconds) and does not depend on retaining any compromised material.

### 4.3 Failure modes considered pre-write

| Failure mode | Mitigation in place |
|---|---|
| Datastore write hits wrong doc | doc `_id` pinned from B2 structure capture; single-user admin model |
| Backend fails to restart cleanly | compose-managed service; restart policy verified running in ops window; workflows idle at chosen time |
| New value lost before persisting to key file | generation→write→chmod 600→.env update performed as one operator step sequence |
| Consumer scripts read stale cached env | .env is sourced per-run by ops scripts; no daemon holds it |

## 5. Safe Recovery Locations for the CURRENT Token

Exactly three sanctioned storage points exist post-rotation:

1. `config/shuffle-api-key` — mode 600 (`-rw-------`), gitignored (verified entry in
   `.gitignore`: `config/shuffle-api-key`). Primary store.
2. `.env` `SHUFFLE_API_KEY` — runtime consumer convenience; `.env` gitignored
   (`*.env` rule with `!*.env.example` carve-out).
3. The datastore record itself (source of truth for validation).

Anywhere else = policy violation. Post-rotation grep sweeps confirm zero additional
copies in the tracked set (phase39-10).

## 6. Access Control on Backup Material

| Asset | Who can read | Protection |
|---|---|---|
| `ops/backups/*` (incl. pre-hardening compose, credential txts) | host operator account only | directory outside git; ignore rules; LXC-local |
| Workflow export evidence | repo readers (post-redaction: placeholder-form) | tracked + hash-manifested |
| Users-doc structure (B2) | report corpus readers | field names only — no values by construction |
| New token material | host operator; runtime processes sourcing `.env` | mode 600 ×2 stores; gitignored |

## 7. Drill Definition (how this plan gets tested)

Forward-only recovery is drillable without touching production auth:

1. Generate a THROWAWAY value; write to a scratch user record (or dry-run the update
   expression against a copy of the doc in a scratch index).
2. Verify restart-flush behavior on a non-prod backend instance if available.
3. Time the full §4.2 sequence end-to-end; target < 5 minutes operator time.

First formal drill scheduled with Phase 40 rotation-candidate work (F-1 IRIS bearer),
which will exercise the same machinery for a second credential family.

## 8. What Would Have Made This Plan Fail (pre-mortem retained)

- Preserving old value "for safety" → would have re-created disclosure. Avoided by
  explicit prohibition and by generating the new value only after the prohibition was
  recorded.
- Writing .env before key file → single-store window where a crash loses the only
  durable copy. Sequence chosen: datastore → key file (durable) → .env (consumer).
- Skipping B4 check → risk of locking out the sole admin path mid-operation. UI
  password independence verified BEFORE any write.

## Appendix A — Backup Asset Digests (post-redaction state)

Evidence assets referenced by this plan carry current digests (see phase39-11 for the
full before/after ledger): export JSONs and SHA256SUMS.txt are consistent as of this
report; compose backup `docker-compose.shuffle.yml.pre-p39-hardening` remains
byte-identical to its creation-time state (no secrets inside; no redaction needed).

## Appendix B — Sanctioned Store Verification Verbatim

```
$ stat -c '%a %U %s %n' config/shuffle-api-key .env
600 user 37 config/shuffle-api-key
600 user 671 .env

$ grep -n "shuffle-api-key" .gitignore
config/shuffle-api-key
```

Both stores restrictive-permission; both paths ignored by git; key-file rule explicit.

## Appendix C — Retention Decisions

| Asset | Retain until | Then |
|---|---|---|
| Compose backup (B3) | next successful exposure-hardening change | delete (superseded) |
| Workflow exports (B1) | indefinite (evidence lineage) | keep, hash-refresh on any future sanitization |
| Users-doc structure note (B2) | until doc id changes | re-capture on any user-store migration |
| Old value copies | none exist under Phase-39 control | n/a by design |

## 9. Verdict

**COMPLETE.** Backups sufficient for structural recovery; rollback policy is
forward-only with explicit prohibition on restoring compromised material; current-token
storage minimized to sanctioned locations.
