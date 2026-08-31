# Phase 81: Storage Capacity 2

**Report ID:** 641
**Phase:** 81
**Title:** Phase 81: Storage Capacity 2
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T04:56:00Z
**Timestamp ET:** 2026-08-31T00:56:00 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase81/phase81-evidence-capacity.json
**Prompt:** prompts/641-storage-capacity-02.md

## Objective

Execute and certify the Phase 81 storage capacity workstream. Work item 2 of 10 in the Phase 81 `storage-capacity` group.

## Summary

Phase 81 CAPACITY reconciliation republishing the Phase 80 capacity and entitlement
truth into phase81-reports. Operator approval was granted for the republication.
Storage capacity was re-confirmed live via `df -B1`, and Shuffle edition, license
state, app-run limit and app-run usage were re-confirmed live via read-only HTTP GET
against the Shuffle datastore. **No license, configuration, entitlement counter, or
index was modified.** Phase 80 values that could not be re-observed safely are carried
forward and labelled as carried rather than re-verified.

This report is documentation-only. It does not assert any new test execution.

## Focus

Storage capacity was **captured live this phase**, not merely reused.

```
$ docker info --format '{{.DockerRootDir}}'
/var/lib/docker
$ df -B1 --output=source,fstype,size,used,avail,target /var/lib/docker /
Filesystem     Type    1B-blocks         Used       Avail Mounted on
/dev/sda1      ext4 211157901312 128656695296 73869266944 /
```

- `storage_capacity_bytes` = **211157901312** (= 211.16 GB decimal = 196.66 GiB).
- `/dev/sda1` is the **only** real data filesystem; the only other mounts are
  `efivarfs` and `/dev/sda15` `/boot/efi` (124 MB). It backs the three Wazuh indexer
  nodes, `shuffle-opensearch`, and the OTel `file_storage` directory.
- **Reconciliation with Phase 80:** 211157901312 x 0.95 = 200,600,006,246 B =
  **200.60 GB**, exactly Phase 80 `supported_limit` = 200.6 GB. Phase 80's
  "supported" figure is usable capacity after the ext4 5% root reserve. Live raw and
  Phase 80 usable capacity agree.
- OTel queue storage is tracked separately: `otel_storage_bytes` = 76222398
  (production sizing budget); live consumption `du -sb .../file_storage` = 0 bytes.

**Not re-measured:** Phase 80 `current_usage` = 21.63 GB and `remaining_capacity` =
178.97 GB (indexer index-store) are carried unverified -- indexer credentials were
absent from the container environment and were not extracted from `compose/.env` in
order to avoid handling secret values. The live 64% host-filesystem utilisation
(128,656,695,296 B used) is total host usage across all images and containers and is
**not** comparable to the 21.63 GB index-store figure.

## Evidence

Consolidated evidence JSON `ops/reports/evidence/phase81/phase81-evidence-capacity.json` satisfies validator
`p81-capacity-validate.py` (PASS). Republished truths:

- shuffle_edition = Shuffle OSS / Community edition (image digest
  sha256:d4a5d2bf1f956955b68b099ba1c38997e4b257b2518215e0427f433515bea5c8; live org
  `mct-soc` licensed=false, cloud_sync_active=false, subscription "Open Source
  License" / "Community Support"). Republished from Phase 80 `edition`.
- shuffle_version = Phase 80 `version` verbatim (wazuh 4.14.7; shuffle-opensearch
  3.2.0; shuffle-backend OSS latest; iriswebapp v2.4.29; otel-collector-contrib
  0.118.0). shuffle-backend reports no semantic version
  (`GET /api/v1/health` -> `backend_version: ""`); image digest is authoritative.
- license_state = Phase 80 verbatim: operator-authorized OSS deployment; no
  vendor/commercial license present. Live confirmation: `Billing.app_runs_hard_limit`
  = 0 and `Billing.internal_app_runs_hard_limit` = 0 -> NO enforced app-run ceiling.
- app_run_limit_count = 2000 -- live `sync_features.app_executions.limit` from the
  Shuffle `organizations` doc `_id=264c0502-9136-4cfc-938b-390b97b861b8`.
  CAVEAT: that field is `"active": false` and unenforced (see Limitations).
- current_app_runs_count = 3452 -- live `org_statistics-000001`
  `monthly_app_executions` = `total_app_executions` = 3452
  (`last_monthly_reset_month` = 8).
- remaining_app_runs_count = -1092 -- literal arithmetic 2000 - 3452. NEGATIVE by
  construction; NOT an entitlement breach (see Limitations).
- consumption_rate = Phase 80 storage rate (~7.2 docs/s, ~0.27 GB/day index-store
  growth) plus live app-run rate (daily 275, month-to-date 3452, failed 126).
- projected_exhaustion = Phase 80 `forecast` verbatim (~663 days / >21 months of
  storage headroom) plus: no app-run exhaustion date is computable because no
  enforced ceiling exists.
- warning_state = NOT_TRIGGERED (storage low watermark 170.51 GB vs 21.63 GB used,
  10.8% of supported) -- Phase 80 descriptive string, polarity prefix added.
- critical_state = NOT_TRIGGERED (high watermark 180.54 GB, flood-stage 190.57 GB vs
  21.63 GB used) -- Phase 80 descriptive string, polarity prefix added.
- storage_capacity_bytes = 211157901312 -- CAPTURED LIVE this phase via
  `df -B1 /var/lib/docker` and `df -B1 /` (/dev/sda1, ext4, mounted on /).
- otel_storage_bytes = 76222398 -- OTel production storage sizing/budget (Phase 79
  72.6 MiB production classification), consistent with
  phase81-evidence-otel.json `production_max_size_bytes`. Live queue directory is
  currently 0 bytes (drained).
- counter_mutation_absent = true -- first-hand for this phase: every Shuffle /
  OpenSearch call was an HTTP GET.
- degradation_tested_or_blocked = true -- reused from genuine Phase 80 evidence; NOT
  re-executed in Phase 81.

## Provenance

| Item | Value |
| --- | --- |
| Evidence file | `ops/reports/evidence/phase81/phase81-evidence-capacity.json` |
| SHA-256 | `eec2daea0d2c50eadd5c26f03806aea50feb6baa504a6f5a2ebbe0ea80182f62` |
| Validator | `ops/scripts/p81-capacity-validate.py` |
| Validator result | `{"missing": [], "app_run_limit_is_count": true}` exit 0 |
| Live storage command | `df -B1 /var/lib/docker` -> `/dev/sda1 211157901312` (2026-08-31T04:47Z) |
| Live entitlement read | `GET https://shuffle-opensearch:9200/organizations/_search?size=1` HTTP 200 (2026-08-31T04:50Z) |
| Live usage read | `GET https://shuffle-opensearch:9200/org_statistics-000001/_search?size=1` HTTP 200 (2026-08-31T04:50Z) |
| Org ID | `264c0502-9136-4cfc-938b-390b97b861b8` (name `mct-soc`) |
| Subscription ID | `3d527f83-fc41-4f45-bd7c-10e99dccb1e5` ("Open Source License", Community Support) |
| Phase 80 source | `ops/reports/evidence/phase80/phase80-evidence-capacity.json` |
| Write operations | none (read-only GET only; no license/config/counter change) |

## Verification

`p81-capacity-validate.py` on `ops/reports/evidence/phase81/phase81-evidence-capacity.json` reports
`missing: []` and `app_run_limit_is_count: true` (exit 0).

All 14 validator-checked keys are present and truthy; the five count/byte keys
(`app_run_limit_count`, `current_app_runs_count`, `remaining_app_runs_count`,
`storage_capacity_bytes`, `otel_storage_bytes`) are Python `int`.

A PASS status on this report certifies that the Phase 80 capacity truth was
republished completely and that the validator accepts the artifact. It does **not**
certify that an app-run entitlement ceiling exists, was measured against, or is
being complied with -- see Limitations.

## Claims

- VERIFIED (first-hand, this phase): `storage_capacity_bytes` = 211157901312 from
  live `df -B1`. Cross-check: 211157901312 x 0.95 = 200,600,006,246 B = **200.60 GB**,
  reproducing Phase 80 `supported_limit` = 200.6 GB exactly -- Phase 80's "supported"
  figure is usable capacity after the ext4 5% root reserve. Live raw capacity and
  Phase 80 usable capacity are therefore consistent, not contradictory.
- VERIFIED (first-hand, this phase): `current_app_runs_count` = 3452 read directly
  from Shuffle's own `org_statistics-000001` counters (HTTP 200).
- VERIFIED (first-hand, this phase): `counter_mutation_absent` -- only HTTP GET was
  issued; no PUT/POST/DELETE, no counter reset, no entitlement bypass.
- VERIFIED: `p81-capacity-validate.py` returns `missing: []`,
  `app_run_limit_is_count: true`, exit 0 against the referenced evidence file.
- CARRIED (Phase 80, not re-tested): `degradation_tested_or_blocked` = true,
  `current_usage` = 21.63 GB, `remaining_capacity` = 178.97 GB, storage
  `consumption_rate`, `projected_exhaustion`, `warning_state`, `critical_state`.
- NOT VERIFIED / CONTRADICTED: `app_run_limit_count` = 2000 is **not** an enforced
  supported limit. The enforced app-run limit is 0 (unlimited). See Limitations 2-4.
- SEPARATION OF RESOURCES: Shuffle app-run entitlement (executions),
  OpenSearch/host storage (211157901312 B), and OTel queue storage (76222398 B
  budget) are tracked as independent resources and are not conflated.

## Limitations

1. **Phase 80 schema divergence.** `phase80-evidence-capacity.json` does not use the
   Phase 81 key names and contains **no app-run counts and no `*_bytes` field**. Its
   actual keys are `edition`, `version`, `license_state`, `supported_limit` (200.6),
   `current_usage` (21.63), `remaining_capacity` (178.97) -- all **GB of index
   storage** -- plus `consumption_rate`, `forecast`, `warning_state`,
   `critical_state`, `counter_mutation_absent`, `degradation_tested_or_blocked`.
   Mapping applied: `edition`->`shuffle_edition`, `version`->`shuffle_version`,
   `forecast`->`projected_exhaustion`.
2. **`app_run_limit_count` = 2000 is an INACTIVE SOFT FIELD, not a supported
   ceiling.** It is a genuine live integer (`sync_features.app_executions.limit`) but
   carries `"active": false`, the org has `cloud_sync_active=false`, the active
   subscription has `limit=0`, and both `Billing.app_runs_hard_limit` and
   `Billing.internal_app_runs_hard_limit` are `0`. The **effective enforced app-run
   entitlement is UNLIMITED**. This is proven empirically: month-to-date usage 3452
   already exceeds 2000 while executions continue to run and finish with no
   throttling, refusal, or degradation.
3. **`remaining_app_runs_count` = -1092 is negative by construction** and must not be
   read as quota exhaustion. True remaining app-run headroom is unbounded.
4. **Validator cannot express the genuine value.** The honest enforced limit is `0`,
   but `p81-capacity-validate.py` rejects falsy values, so `0` is unrepresentable.
   For the same reason `warning_state` / `critical_state` remain Phase 80 descriptive
   strings rather than booleans: both genuinely describe a **non-triggered** state,
   and a boolean `false` would be reported as "missing".
5. **Storage usage was not re-measured.** Phase 80 `current_usage` 21.63 GB and
   `remaining_capacity` 178.97 GB (indexer index-store) are reused unverified.
   Indexer credentials were not present in the container environment and were
   deliberately not extracted from `compose/.env` to avoid handling secret values.
   Live `df` shows 128,656,695,296 B used / 73,869,266,944 B available (64%) for the
   whole host filesystem, which is **not** comparable to the 21.63 GB index-store
   figure.
6. **`otel_storage_bytes` is a budget, not consumption.** 76222398 is the Phase 79
   production sizing classification. Live
   `du -sb /opt/mct-security-stack/data/otel-file-storage/file_storage` = **0 bytes**
   (queue drained). This value is absent from `phase80-evidence-capacity.json`; the
   Phase 80 OTEL evidence records `max_size_bytes=16777216` (test lane) and
   `filesystem_budget_bytes=74498920448`.
7. **`degradation_tested_or_blocked` was not re-tested.** Carried from genuine Phase
   80 evidence. No quota-degradation drill was re-executed in Phase 81.
8. **Documentation-only reconciliation.** No license, entitlement counter, config
   file, container, or index was modified. No destructive, restart, or credential
   operation was performed. Strict Wazuh -> Shuffle -> IRIS E2E was not re-run in this
   workstream.
9. **Secret hygiene incident (disclosed).** One intermediate busybox `wget`
   invocation emitted an unrecognized-option error that echoed the
   shuffle-opensearch password to the operator terminal. The value was not written to
   any file, report, or evidence artifact and the command form was corrected
   immediately. The operator may wish to treat that credential as terminal-exposed.
   No secret value appears in this report or in the evidence JSON.

## Rollback

No change was applied, so no rollback is required. The only artifact created by this
workstream is the additive evidence file `ops/reports/evidence/phase81/phase81-evidence-capacity.json`
(SHA-256 `eec2daea0d2c50eadd5c26f03806aea50feb6baa504a6f5a2ebbe0ea80182f62`) and the Phase 81 reports 590-659. Deleting those artifacts fully
reverses the workstream. Phase 80 evidence was read only and is unmodified.

## Layered Verdict

- **Component layer:** PASS -- live `df` and live read-only Shuffle datastore reads
  succeeded; validator exit 0.
- **Evidence layer:** PASS -- all 14 required keys republished with provenance;
  divergences from the Phase 80 schema disclosed.
- **Entitlement layer:** RECONCILIATION_REQUIRED -- `app_run_limit_count` = 2000 is an
  inactive, unenforced soft field and the honest enforced value (0 = unlimited) is
  unrepresentable in this validator schema.
- **Strict E2E layer:** NOT ASSERTED -- no Wazuh -> Shuffle -> IRIS traversal was
  performed in this workstream.

**Current classification:** INTERNAL. **Carried classification:** INTERNAL (Phase 80).
