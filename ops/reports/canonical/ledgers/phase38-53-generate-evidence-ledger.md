# Phase 38 Evidence Ledger

**Report ID:** phase38-53-generate-evidence-ledger
**Phase:** 38
**Title:** Evidence Catalog — Paths, Hashes, Availability, Classification, Referenced-By (Markdown + JSON)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-53-generate-evidence-ledger.md`
**Retention Class:** LONG
**Supersedes:** `phase38-19-evidence-root-inventory.md` draft (retained as history)
**Owners:** ["ops-reports-owner"]

---

## 1. Conventions

- **Classification:** `immutable` (must never be edited; append-only evidence) · `canonical` (authoritative living artifact; change-controlled) · `cache` (regenerable output/logs).
- **Availability:** `on-box` / `partial` (referenced but not persisted) / `remote-only`.
- **Referenced-by** counts are conservative minimums from the Phase 38 link/reference pass (phase38-20 method); they age as the corpus grows.
- Hashes were computed on-box at ledger time unless marked otherwise. Secret-bearing files are hashed for existence/integrity but their contents are **not reproduced** anywhere in this ledger.

## 2. Markdown Catalog

### EV-38-01 — Workflow export: wazuh-high-severity-to-iris

| Field | Value |
|---|---|
| Path | `/opt/mct-security-stack/ops/evidence/p37-workflow-export/wazuh-high-severity-to-iris.json` |
| sha256 (on-disk) | `b0a2721ae6bb5d0577da9789a2dbd7632d4681e02a5ff4afc9cbc52102b09380` |
| Embedded claimed hash | `2698a42b38000f32b6ca30101cac1e92de0b14bd4c74dda35a8c590279fd7ab5` (trailing comment) |
| Availability | on-box |
| Classification | immutable (with **defect flag**) |
| Defect | Trailing HTML comment `<!-- SHA256: … -->` makes the file invalid strict JSON; embedded hash ≠ on-disk hash (comment included/excluded ambiguity); no `.sha256` sidecar |
| Referenced-by | ≥6 (phase37-10/-11; generated/phase38-23/-44/-46/-53) |
| Notes | Corresponds to the workflow with 68 FINISHED real-payload executions |

### EV-38-02 — Workflow export: wazuh-flow-classb-to-iris

| Field | Value |
|---|---|
| Path | `/opt/mct-security-stack/ops/evidence/p37-workflow-export/wazuh-flow-classb-to-iris.json` |
| sha256 (on-disk) | `8fabaabf936f3c195eac69f3a86135490842a02b6cb89da2c510ec75d444e9d2` |
| Embedded claimed hash | `937b0a1a8a9bb4a4f71cf78ac3ddc85db47c76004ba0d7f77199abccce258be0` (trailing comment) |
| Availability | on-box |
| Classification | immutable (with same defect flag as EV-38-01) |
| Referenced-by | ≥5 (phase37-10/-12; generated/phase38-44/-46/-53) |
| Notes | Draft workflow; no real executions |

### EV-38-03 — v1.3.0 release asset

| Field | Value |
|---|---|
| Path | (none on-box) — release id 375979989, tag 790968b8 |
| sha256 | prefix `da72bde4…`, byte-exact match achieved in-session against fetched artifact |
| Availability | **partial → remote-only after session** (not persisted under `ops/evidence/releases/`) |
| Classification | canonical provenance record; artifact itself missing on-box (MIS-38-04) |
| Referenced-by | ≥8 (P29 commits; phase38-21; summaries) |

### EV-38-04 — Compose stack definition

| Field | Value |
|---|---|
| Path | `/opt/wazuh-docker/multi-node/docker-compose.yml` |
| sha256 | not recorded here (root-owned, changes via approved PRs only; pin state audited by CI gate) |
| Availability | on-box |
| Classification | canonical |
| Referenced-by | corpus-wide (every infra report) |
| Notes | Carries the 8 digest pins applied P29 (git c726182) |

### EV-38-05 — Wazuh local_internal_options.conf (manager container)

| Field | Value |
|---|---|
| Effective path | `/var/ossec/etc/local_internal_options.conf` inside `multi-node-wazuh.master-1`; staged host copy per phase36-32 |
| Content of record | line `analysisg/analysisd.decoder_order_size=512` staged exactly as reported |
| Availability | on-box (container) |
| Classification | canonical config; historically significant as the misattributed-fix site |
| Referenced-by | ≥7 (phase36-31..34; phase37-35..43; generated/phase38-25) |

### EV-38-06 — Shuffle workflow backups directory

| Field | Value |
|---|---|
| Path | `/opt/mct-security-stack/ops/backups/shuffle-workflows/` |
| Contents | 5 JSON snapshots: 20260811-061156, 20260811-224406, 20260812-021212, 20260816-054501, 20260823-054501 (+ export-cron log at reports root) |
| Availability | on-box |
| Classification | immutable (append-only snapshots) |
| Referenced-by | ≥4 (CON-38-04 adjudication; backup-cron verifications) |

### EV-38-07 — IRIS DB dumps

| Field | Value |
|---|---|
| Path | `/opt/mct-security-stack/ops/backups/iris-db-202608*.sql.gz` (daily through 2026-08-25) + `iris-api-key.txt`, `iris-admin-pw.txt` |
| Availability | on-box |
| Classification | immutable backups; credential sidecars are secret-bearing — existence noted only |
| Notes | Daily cadence intact; restore drill PASSED at P27 era |

### EV-38-08 — Snapshot script (broken destination)

| Field | Value |
|---|---|
| Path | `/opt/wazuh-docker/multi-node/ops/scripts/elastic-snapshot.sh` (cron 03:30 nightly) |
| Availability | on-box; **functionally inert** — cluster returns `repository_missing_exception` |
| Classification | canonical script; evidences MIS-38-07 gap |

### EV-38-09 — Credentials env file

| Field | Value |
|---|---|
| Path | `/opt/wazuh-docker/multi-node/ops/creds.env` (mode 600, user-owned) |
| Availability | on-box |
| Classification | secret-bearing canonical — **existence-only entry; contents never reproduced in reports** |
| Notes | Env-abstraction target of P22 credential cleanup; plaintext leaks elsewhere (master.md:63, preflight.md:131, 38-73 §Step1) violate this pattern |

### EV-38-10 — Operational logs (cache class)

| Field | Value |
|---|---|
| Paths | `reports/shuffle-periodic-repair.log` (563KB), `reports/shuffle-boot-repair.log`, `reports/shuffle-export-cron.log`, `reports/zeek-classa-guardrail.log` (+state), `reports/vm103-misp-cron.log`, `reports/vm103-greenbone-cron.log`, `reports/phase5-freshness-cron.log` |
| Availability | on-box |
| Classification | cache/regenerable; git-untracked by design (commit 5d23813) |
| Notes | Useful for incident reconstruction; not certification evidence |

### EV-38-11 — Ops scripts tree

| Field | Value |
|---|---|
| Path | `/opt/mct-security-stack/ops/scripts/` (~30 scripts incl. `full-stack-healthcheck.sh`, `es-snapshot-retention-{apply,report}.sh`, `enter-safe-mode.sh`, scorecard generators) |
| Availability | on-box |
| Classification | canonical code; exec-mode audit timed out this cycle (MIS-38-10); last complete exec-bit audit = P28 closure |

## 3. JSON Block

```json
{
  "ledger_id": "EV-38",
  "generated": "2026-08-25T20:55:00Z",
  "items": [
    {"id":"EV-38-01","path":"ops/evidence/p37-workflow-export/wazuh-high-severity-to-iris.json","sha256_ondisk":"b0a2721ae6bb5d0577da9789a2dbd7632d4681e02a5ff4afc9cbc52102b09380","sha256_embedded":"2698a42b38000f32b6ca30101cac1e92de0b14bd4c74dda35a8c590279fd7ab5","availability":"on-box","classification":"immutable+defect(trailing_comment)","referenced_by_min":6,"notes":"68 FINISHED real executions"},
    {"id":"EV-38-02","path":"ops/evidence/p37-workflow-export/wazuh-flow-classb-to-iris.json","sha256_ondisk":"8fabaabf936f3c195eac69f3a86135490842a02b6cb89da2c510ec75d444e9d2","sha256_embedded":"937b0a1a8a9bb4a4f71cf78ac3ddc85db47c76004ba0d7f77199abccce258be0","availability":"on-box","classification":"immutable+defect(trailing_comment)","referenced_by_min":5,"notes":"draft workflow"},
    {"id":"EV-38-03","path":"(release asset v1.3.0, id 375979989)","sha256_prefix":"da72bde4","availability":"remote-only-after-session","classification":"canonical-provenance/artifact-missing-onbox","referenced_by_min":8,"notes":"MIS-38-04"},
    {"id":"EV-38-04","path":"/opt/wazuh-docker/multi-node/docker-compose.yml","sha256":null,"availability":"on-box","classification":"canonical","referenced_by_min":50,"notes":"8 digest pins active"},
    {"id":"EV-38-05","path":"container:/var/ossec/etc/local_internal_options.conf","sha256":null,"availability":"on-box","classification":"canonical","referenced_by_min":7,"notes":"decoder_order_size=512 staged (irrelevant knob)"},
    {"id":"EV-38-06","path":"ops/backups/shuffle-workflows/","count":5,"availability":"on-box","classification":"immutable","referenced_by_min":4,"notes":"20260811..20260823"},
    {"id":"EV-38-07","path":"ops/backups/iris-db-*.sql.gz + cred sidecars","availability":"on-box","classification":"immutable/secrets-existence-only","referenced_by_min":3,"notes":"daily cadence intact"},
    {"id":"EV-38-08","path":"/opt/wazuh-docker/multi-node/ops/scripts/elastic-snapshot.sh","availability":"on-box/inert","classification":"canonical","referenced_by_min":3,"notes":"repository_missing_exception"},
    {"id":"EV-38-09","path":"/opt/wazuh-docker/multi-node/ops/creds.env","availability":"on-box","classification":"secret-canonical/existence-only","referenced_by_min":2,"notes":"mode 600"},
    {"id":"EV-38-10","path":"reports/*.log operational logs","availability":"on-box","classification":"cache","referenced_by_min":10,"notes":"git-untracked by design"},
    {"id":"EV-38-11","path":"ops/scripts/","availability":"on-box","classification":"canonical-code","referenced_by_min":20,"notes":"exec-mode audit timeout this cycle"}
  ]
}
```

## 4. Handling Rules

1. Immutable items are never edited; corrections happen by supersession pointers only.
2. Any report citing an evidence item must cite its EV-ID or full path + hash class.
3. Secret-bearing entries (EV-38-07 sidecars, EV-38-09) may be referenced but never quoted, printed, or hashed into narrative text beyond existence.
