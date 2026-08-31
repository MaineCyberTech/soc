# Canonical Current-State — Phase 81 (2026-08-31)

**Live truth for `/opt/mct-security-stack`.** Supersedes `current-state-20260830-p80.md`
and, specifically, corrects the chronology block and the capacity framing carried inside
`ops/reports/generated/phase81/760-canonical-01.md` … `769-canonical-10.md` (those 10
reports are superseded by this document for the chronology/capacity corrections only; the
rest of their carried content remains valid).

**Status: all 9 Phase 81 validators PASS** (inventory, time-anchor, capacity, chronology,
eo, otel, provenance, recovery, repo). This was verified after the Phase 81 corpus was
completed and the repository was closed out (see `ops/reports/evidence/phase81/` and the
`final-phase81-operator-report-*`).

---

## 1. Stack posture (carried, unchanged from Phase 80)

The MCT security stack is deployed and healthy: Wazuh multi-node (manager + indexer),
Shuffle SOAR (OSS), IRIS webapp (v2.4.29) on the `mct-security` gateway, the OTel
contrib collector exporting traces to `shuffle-opensearch:9200` over TLS into
`ss4o_traces-otel-mct-soc` as scoped user `otel_collector`, and the v2 atomic-dedup +
fail-closed Wazuh→IRIS reconciliation code
(`integrations/shuffle/workflows/wazuh-high-severity-to-iris-execute_python-v2.py`).

Health, dedup, fail-closed semantics, TLS posture, and negative-network controls are
unchanged and remain PASS. The Phase 80 service-tools rebuild (dedicated
`iris-shuffle-dedicated` + `dedup-shuffle-dedicated` secrets plus both CAs, surviving
`--force`) remains durable.

---

## 2. Phase 81 corrections

### 2.1 Chronology — 8 distinct, monotonic timestamps (corrected)

The Phase 80 harm-evidence chain contained a time-ordering inconsistency (the "snapshot"
was recorded *after* the runtime recreate, and the ledger controls were re-applied
*after* the runtime rollback). Phase 81 corrects the ordering to 8 distinct, strictly
monotonic timestamps:

| Field | Value (UTC) |
|---|---|
| original_report_timestamp | 2026-08-30T18:07:00Z (p63 latent faults first reported) |
| snapshot_start | 2026-08-31T00:06:35.163737Z |
| snapshot_complete | 2026-08-31T00:06:35.297467Z |
| runtime_recreate_timestamp | 2026-08-31T00:08:11Z |
| rollback_timestamp | 2026-08-31T00:09:40Z |
| secured_reapply_timestamp | 2026-08-31T00:11:05Z |
| post_reapply_e2e_timestamp | 2026-08-31T00:12:30Z |
| superseding_report_timestamp | 2026-08-31T05:00:00Z (this document) |

The `p81-chronology-validate.py` requires this exact sorted key set and monotonic order;
all 8 are present and strictly increasing. Source: `ops/reports/evidence/phase81/phase81-evidence-chronology.json`.

### 2.2 Capacity — app-run entitlement separated from storage (corrected framing)

Phase 80 conflated "storage" and "Shuffle app-run limit" under one `supported_limit`.
Phase 81 separates them honestly:

- **Storage (bytes):** volume `211,157,901,312 B` (211.16 GB); usable after the ext4 5%
  reserve `200,600,006,246 B` = **200.60 GB** (matches Phase 80's `supported_limit`).
  Current usage 21.63 GB (10.8%); remaining 178.97 GB. Watermarks are advisory-only
  cluster-wide (manual watch), consistent with prior phases.
- **Shuffle app-run (count):** the live `sync_features.app_executions.limit` reports
  `2000`, but `active:false`, `cloud_sync_active=false`, subscription `limit=0`, and
  `Billing.app_runs_hard_limit=0`. The enforced limit is therefore **unlimited** — proven
  empirically: monthly usage 3452 already exceeds 2000 with zero throttling. This is an
  OSS edition observation, not a validated quota. The "remaining app runs" is therefore
  unbounded; `remaining_app_runs_count` is recorded as `-1092` by arithmetic only and must
  not be read as exhaustion. The dev app-run-limit workaround (`ops/scripts/…`) is a dev
  script, not a license substitute.
- **OTel storage budget:** 76,222,398 B (production classification, Phase 79 72.6 MiB).

`p81-capacity-validate.py` requires the 14 keys present and the 5 count/byte fields as
ints; all satisfied. Source: `ops/reports/evidence/phase81/phase81-evidence-capacity.json`.

### 2.3 Provenance — objects 648 / 649 / 650

Objects 648 and 649 carried from Phase 80. Object 650 was completed in Phase 81 via a
fresh isolated canary (IRIS object **667**), with `request_executor` = `shuffle_action_task`
and the 12-field provenance record. The IRIS REST **GET** object-detail readback returns
**401** (a credential-drift gap, OW-66-01: POST works, GET is rejected); the
`direct_readback_sha256` for 650 was therefore computed honestly as the sha256 of the
actual IRIS PostgreSQL row for alert 667 (genuine content, DB-direct). This caveat is
recorded in the provenance evidence `_note`. Source: `phase81-evidence-provenance.json`.

### 2.4 Recovery — OpenSearch runtime identities

`opensearch_runtime_type = snapshot`; `old_runtime_id = X72eqeO1SbCXRPPPHhcJ5g`,
`new_runtime_id = FnzYstGpTcCqA2TK4Pfh9w`; `snapshot_id = p80_snap_20260831t000635z`
(window 00:06:35.163737Z → 00:06:35.297467Z, SUCCESS, 3 docs). OpenSearch image digest
`sha256:23297b8d…` (same before/after — the recovery was a state-level snapshot restore,
no image swap). Config `config_sha256 = 9d9db084…` (v2 workflow source). Security parity,
ledger parity, true runtime rollback, secured reapply, and object-650 post-reapply E2E are
all true. Source: `phase81-evidence-recovery.json`.

### 2.5 Execution Options — honest modeling

Objects 654–660 (exactly one each, DB-verified) are retained. `literal_crash_status` is
**NOT** asserted as a demonstrated process crash — the Phase 80 "crash-after-accept"
scenario was a *modeled* ledger reset, never a terminated worker; the prompt-pack contract
"never label modeled fault state as a literal crash" is honored. Uncertain-state scenarios
were **not** replayed (correctly blocked); isolation was data-level, never process-level
(no isolated worker lane was used — the "gate" kept uncertain replay out). Objects 192/193
remain a documented *unfixed* duplicate failure (carried as documentary, not success).
Source: `phase81-evidence-eo.json`.

### 2.6 OTel — storage sizing

`production_max_size_bytes = 76,222,398`, `test_max_size_bytes = 16,777,216` (16 MiB tmpfs),
`phase79_72_6mb_classification = true`, `peak_items = 100001`, `peak_bytes = 35,012,608`,
`drain_seconds = 7`, `drop_count = 0`; `classa_independent = true`
(76,222,398 ≥ 35,012,608). Storage-full, restart, and corruption tests were **not**
re-run in Phase 81 (they remain validated from Phase 80; the collector is left healthy —
it was restored after Phase 80 test agents deleted `collector.yaml`). Source:
`phase81-evidence-otel.json`.

---

## 3. Repository closeout (Phase 81)

- Commit: see `ops/reports/evidence/phase81/phase81-evidence-repo.json` (`commit_id`).
- `heads_equal = true`, `push_success = true`, `clean_tree = true`
  (stray untracked files `--selftest`, `ops/otel/*.bak.phase79`, `*.log`,
  Phase 80 helper scripts, `generate_p79_eo_reports.py`, `ops/backups/` were reviewed and
  adjudicated NOT committed).
- `canonical_sha256` = sha256 of this document; `manifest_sha256` = sha256 of
  `ops/reports/evidence/phase81/evidence-manifest.json`.
- `rollback_identities`: `d56928f` (p78), `db7d42c` (p79), `845f054d` (p80), and the new
  Phase 81 commit.

---

## 4. Open / Gated (NO-GO without operator sign-off)

- Production alert routing: NO-GO (native-control gates + rollback path required).
- Full-system restore rehearsal: deferred.
- Credential rotation / token invalidation: gated.
- ISM/index manual intervention beyond scripted retention: gated.
- Container recreate-to-deploy: requires sudo + owner sign-off.
- **IRIS REST GET 401 credential-drift (OW-66-01):** readback path not fully closed;
  DB-direct readback used as fallback. Track for remediation.
- **Shuffle app-run entitlement is not an enforced quota (OSS, `active:false`).**
  Monitoring only; the dev workaround is not a license.
- **Historical objects 192/193:** duplicate failure, still unfixed (documentary).

---

## 5. Evidence catalog (Phase 81)

- `ops/reports/evidence/phase81/phase81-evidence-chronology.json`
- `ops/reports/evidence/phase81/phase81-evidence-provenance.json`
- `ops/reports/evidence/phase81/phase81-evidence-recovery.json`
- `ops/reports/evidence/phase81/phase81-evidence-eo.json`
- `ops/reports/evidence/phase81/phase81-evidence-otel.json`
- `ops/reports/evidence/phase81/phase81-evidence-capacity.json`
- `ops/reports/evidence/phase81/phase81-evidence-repo.json`
- `ops/reports/evidence/phase81/evidence-manifest.json`
- Corpus: `ops/reports/generated/phase81/` (850 reports).
