# Phase 39 AGENTS Report-Truth Map — Durable Facts vs Volatile Exclusions

**Report ID:** phase39-56-agents-report-truth-map
**Phase:** 39
**Title:** Corpus→AGENTS Truth Map: Every Durable Fact Candidates for AGENTS.md, Source-Linked; Volatile Items Excluded by Policy
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:12:59Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-56-agents-report-truth-map.md`

---

## 1. Purpose

Selects what agents MUST know from the report corpus. Each entry is tagged with the phase39-NN
(or prior) source that established it. This map feeds section-by-section [SRC:] annotations
in the proposed diff (phase39-61).

## 2. Durable Facts (eligible for AGENTS.md)

| # | Fact | Source establishing it | Re-validation today |
|---|---|---|---|
| F1 | Release chain v1.3.0: `RELEASE-NOTES.md` §v1.3.0 (2026-08-24); on-box archive per `release-manifest.json` (`mct-security-stack-release-20260824-203124.tar.gz`, sha256 `da72bde4…`, sensitive_files 0) | phase38-21; phase38-95 | manifest read today ✅ |
| F2 | Canonical current-state doc = `ops/reports/generated/phase38-49-generate-current-state.md` until a phase39 final supersedes it; open work = `phase38-47-generate-openwork.md` + `phase38-90-backlog.md`; chronology = `phase38-48-generate-chronology.md` | phase38-49 §13 supersession statement | files exist today ✅ |
| F3 | CI/gate scripts: `ops/scripts/p38-report-ci.sh` (report corpus), `p29-image-ci-gate.sh`, `p30-audit-gate.sh`, `secret-pattern-scan.sh` | phase38-71; git history | `-x` test passed today ✅ |
| F4 | Credential storage BY PATH ONLY: `config/shuffle-api-key` (mode 600, gitignored via whitelist rule), `compose/.env` + `*.env` gitignored, `/opt/wazuh-docker/multi-node/ops/creds.env` (mode 600, outside repo) holds runtime secrets incl. `WAZUH_ADMIN_PASSWORD` used by scripts | phase39-03…07 (incident+rotation), phase39-09/10 (redaction) | stat 600 verified today ✅ |
| F5 | Snapshot repositories registered in indexer: `wazuh-backup` (filesystem) and `do-spaces` (S3) | phase38-26 correction lineage; P36–P37 retention arc | `_snapshot` API queried today ✅ |
| F6 | Index template `wazuh-archives-fieldlimit`: pattern `wazuh-archives-4.x-*`, `total_fields.limit=2000`, retained ISM config; effectiveness proof pending first post-change index (~2026-08-26) | phase39-21 baseline, phase39-28 certification | `_index_template` API queried today ✅ |
| F7 | Network-attach fix pattern for IRIS reachability from Shuffle exec containers: attach to the shuffle executions overlay network (`docker network connect`, alias nginx) — scripted in `ops/scripts/shuffle-repair-network.sh`; not persisted across full container re-create | phase39-30…33 DNS arc; phase39-36 §3 | script present today ✅ |
| F8 | Shuffle workflows of record: `wazuh-high-severity-to-iris` (Class A/OpenCanary lane, notify-only) and `wazuh-flow-classb-to-iris`; trigger style `POST /api/v1/workflows/<uuid>/execute`; packet workflow remains DEFERRED (ROUT-39-02 preconditions P1–P3) | phase39-38 baseline, phase39-42 decision | reports re-read today ✅ |
| F9 | Standing safety rules S1–S13 (pack READMEs + conventions) | phase39-55 §2 | — |
| F10 | Deployability PARTIAL; full-cluster restore NO-GO until rehearsal on an approved target | phase38-94; p39 pack baseline | carried status ✅ |
| F11 | Report authoring standard: metadata headers, status enums, `phaseNN-slug.md` naming, finals naming/supersession | phase38-56/-57/-65 | conventions observed in corpus ✅ |
| F12 | Approval-gated operations class (production routing enablement, migration APPLY, restore rehearsal, exposure changes) require operator sign-off recorded in change register | phase38-69 (APPLY gated), phase39-42, pack rules | — |

## 3. Volatile Facts (EXCLUDED from AGENTS.md)

Excluded by the dynamic-state policy (formalized in phase39-60): disk %, memory %,
agent connectivity states, error rates/min, execution counts, index counts/dates,
token or key values, IP addresses, `/tmp` usage, shard counts.

These live only in canonical current-state/open-work docs (F2). AGENTS.md points; it never
embeds (S13).

## Verdict

Truth map COMPLETE: 12 durable facts, all source-linked; volatile class defined.
