# Phase 41 Repo Record

**Report ID:** phase41-99-repo
**Phase:** 41
**Title:** REPO-41-03 — Pre-Commit PLAN Record: Gates Run Triple-GREEN (Embeds in phase41-98 §6), Redaction Sweep Zero, Change Classification, Planned Single Logical Commit, Push-If-Approved Policy, Expected-Clean-Tree Checklist. DO NOT COMMIT YET.
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T07:00:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-99-repo.md`

---

## 1. HOLD STATEMENT

**DO NOT COMMIT YET.** Per standing policy, the main orchestrator commits only after reading this
record and confirming the checklist in §7. Everything below is prepared evidence for that decision.

## 2. Gates Run (all three GREEN, post-closeout-corpus)

| Gate | Result | Key lines |
|---|---|---|
| `p38-report-ci.sh` | **PASS (0 warnings)** | metadata/links/status enums clean over the generated corpus incl. phase41 closeout batch; secret_lines=0 |
| `p39-canonical-ci.sh` | **PASS (0 warnings)** | manifest hash matches; high-confidence secrets: **0 hits tree-wide** |
| `p39-agents-ci.sh` | **PASS (0 warnings)** | all gates PASS incl. secrets zero + volatile-content zero over CHG-41-AGENTS-01 |

Full verbatim outputs are embedded in phase41-98 §6 (single evidence copy per corpus convention).
Scope note: p38-report-ci ran after reports phase41-93…97 and -99 plus the operator final landed;
report phase41-98 was authored last to embed those outputs and was hand-verified against the
metadata convention set — the tree-wide canonical Gate4 sweep covers it, and §7 requires a fresh
triple-CI immediately pre-commit regardless.

## 3. Redaction Verification — sweep counts ZERO

1. Canonical CI Gate4 (high-confidence secret patterns, whole tree): **files_with_hits=0**.
2. Report CI Gate4 over generated corpus: **total_matching_lines=0**.
3. AGENTS-CI Gate4/Gate5: zero secret-pattern lines; no metrics/bearer/non-loopback IPs embedded.
4. Value-blind handling held all cycle: the master-ossec.conf virustotal key was flagged WITHOUT
   printing any value or truncation (masked awk probe, phase41-87); release hashes are content
   identities, not credentials; no bearer/token material anywhere in the batch.
5. Ignore posture re-confirmed: `config/shuffle-api-key`, `*.env`, `*.key` remain gitignored;
   release tarballs resolve via `.gitignore:15` (`*.tar.gz`) — verified live this session against
   both `ops/releases/v1.3.0/*.tar.gz` artifacts.

## 4. Classification of Changes

Tree at authoring time: **7 modified, 98 untracked** (grows by this closeout batch: +7 generated
companions +1 operator final → expected ≈106 untracked at commit time; see §7).

| Class | Paths | Rationale |
|---|---|---|
| **SENSOR-CONFIGS** | `/etc/suricata/suricata.yaml` (+`.bak-p41-containment`), `/usr/local/bin/suricata-compact-stats.py`, systemd timer/service units, agent ossec.conf localfile — ALL REMOTE on sensor mct-soc-scan (**not repo files**) | Runtime-side config of record; apply record + rollback sequence documented phase41-15; paths listed in release manifest next commit per G41-11 |
| **HOST-CONFIGS / CODE** | root `AGENTS.md` (M: CHG-41-AGENTS-01) · `config/shuffle-tls/nginx-shuffle-proxy.conf` (M: XFO dedup) · `ops/scripts/p41-monitor-watchdog.sh` (NEW) · cron entries (runtime-side crontab — noted, not repo artifacts) | Behavior/security-posture changes that must version-control cleanly |
| **EVIDENCE** | `ops/releases/v1.3.0/MANIFEST.md` (M: published-original primary row) · `ops/evidence/p41-fp-sampling/` (sample JSON, sha256-pinned) · `ops/evidence/p41-ism-baseline.json` · `ops/reports/p41-monitor-watchdog.log` + `p40-field-growth-state.tsv` (M: trend rows) · `check-unpinned-docker-images-20260826-062918.md` (aux audit output) | Immutable-grade artifacts and receipts. NOTE: both v1.3.0 `.tar.gz` archives are gitignored BY DESIGN (`*.tar.gz`) — bytes stay on-box; hashes travel in git via MANIFEST.md; backup-policy inclusion of `ops/releases/**` remains a flagged owner gap (phase41-76 §4) |
| **REPORTS** | `ops/reports/generated/phase41-00…99` full corpus · `ops/reports/current/final-phase41-operator-report-20260826-0700Z.md` · `ops/reports/canonical/current/current-state-20260826-postp41.md` (NEW canonical copy) · `open-work.md` (M: OPENWORK-41-01 rewrite) · ledgers catalogs ×2 (M: csv/json, 392 rows reconciled) | Corpus records; metadata-compliant per CI |

## 5. Planned Commit Structure

**Single logical commit** (one atomic unit: the fixes are inseparable from the reports that prove
them). Proposed message, verbatim:

```
Phase 41: field growth contained at source (compact-stats lane live), dual-suricata defect fixed,
release custody closed byte-exact, delivery monitor matured with watchdog, packet lane proven then
honestly deferred (platform defect), Phase 41 closeout corpus
```

Style matches repo history (`Phase 40: …`, `Phase 39: …`). No secret values anywhere in the
message; credentials referenced by path only.

## 6. Push-If-Approved Policy

Push follows ONLY on the same approval record as the commit (no auto-push path exists or may be
created): if the orchestrator approves §5's commit, push executes in the same approved action;
if approval is withheld, the tree stays as-is with this PLAN record as the handoff artifact.

## 7. Expected-Clean-Tree Requirement Checklist

- [ ] `git status --porcelain` categories limited to ` M` (the 7 modified files of §4) and `??`
      (untracked sets enumerated in §4) — expected ≈7 M / ~106 ?? once the closeout batch lands;
      NO deletions, NO renames.
- [ ] Untracked sets enumerated (superset check): `ops/evidence/p41-fp-sampling/`,
      `ops/evidence/p41-ism-baseline.json`,
      `ops/reports/canonical/current/current-state-20260826-postp41.md`,
      `ops/reports/check-unpinned-docker-images-20260826-062918.md`,
      `ops/scripts/p41-monitor-watchdog.sh`,
      `ops/reports/generated/phase41-00…99` (all 100 generated entries),
      `ops/reports/current/final-phase41-operator-report-20260826-0700Z.md`.
- [ ] Gitignored tarballs NEVER appear in status: spot-check
      `git check-ignore -v ops/releases/v1.3.0/v1.3.0-published-original.tar.gz` resolves to
      `*.tar.gz`; if ignore posture regresses, STOP the commit.
- [ ] Generated-location catalogs (`generated/catalog-reports.csv/.json`) refreshed to include the
      phase41 corpus before commit (ledger copies are current at 392 rows; mirror pass per P40
      practice), OR the delta explicitly accepted in the commit note.
- [ ] Re-run triple CI immediately pre-commit; require 3× `RESULT: PASS (0 warnings)` including
      the closeout reports in tree-wide scope.
- [ ] `config/shuffle-api-key` absent from index (`git status` shows no reference).
- [ ] Commit message matches §5 verbatim; single parent; no co-authored-by noise.
- [ ] Post-commit verification: `git show --stat HEAD` count sanity vs §4 classes; value-form leak
      grep on HEAD tree returns documentation/pattern-definition hits only.

## 8. Residual Notes for Orchestrator

- v1.3.1 tag cut happens AFTER this commit lands (RELPLAN-41-01 stage 1 consumes the clean tree;
  phase41-78 decision fixed the cut at Phase-42 open).
- Sensor-side artifacts are NOT in this commit by design; their custody lives in the apply record
  and the next manifest refresh.
