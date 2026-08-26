# Phase 38-36: Duplicate Action Scan

**Title:** Phase 38-36: Duplicate Action Scan
**Report ID:** phase38-36-duplicate-action-scan
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-36-duplicate-action-scan.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Purpose

Identify differently-named actions across phases that cover identical work, propose canonical action IDs (ACT-xxx), and preserve every source link. Where Phase 38 already assigned BCK IDs (`generated/phase38-90-backlog.md`), ACT IDs are mapped to them rather than replacing them.

---

## 2. Duplicate Action Clusters

### Cluster A — Restrict Shuffle frontend exposure → **ACT-001** (maps BCK-38-001)

Same work, five namings:

| Source naming | Location |
|---|---|
| "Apply iptables rule to restrict Shuffle frontend (port 3001) to localhost-only access" | `phase37-07-shuffle-exposure-apply.md:11` (plan: `phase37-06-shuffle-exposure-plan.md`) |
| "Harden Shuffle — TLS, firewall, restrict bind address" | `phase37-81-final.md:133` (roadmap #1); duplicated verbatim in `final-phase37-operator-report-20260825-1943Z.md:133` |
| "Shuffle exposure hardening … plaintext HTTP on all interfaces" | `phase37-74-backlog.md` P1 #2 |
| "Bind Shuffle frontend to 127.0.0.1 or add reverse proxy" + "Rotate Shuffle bearer token" split-out | `generated/phase38-00-master.md:168-169` (items 4–5; token rotation split into Cluster E) |
| "Shuffle Frontend Exposure Hardening" (BCK-38-001) + hardening steps §Step 2 | `generated/phase38-90-backlog.md:29-59`; `generated/phase38-73-shuffle-hardening.md`; gate G5 `generated/phase38-00-master.md:204` |

Also same-family: `phase37-05-shuffle-threat-model.md`, `phase37-08-shuffle-exposure-validate.md` (validate step never run — apply never happened). **Canonical scope:** restrict 3001 to loopback/management path + TLS/proxy + persist rules + validate blocked/allowed sources.

### Cluster B — Resolve field cardinality errors → **ACT-002** (maps BCK-38-002)

| Source naming | Location |
|---|---|
| "Increase decoder_order_size beyond 512 and validate" | `generated/phase38-00-master.md:167` (item 3) |
| "Field cardinality resolution — 512 insufficient… increase to 1024 or minimize sources" | `phase37-81-final.md:134` (roadmap #2); `phase37-74-backlog.md` P1 #1 |
| "Suricata stats minimization" (option a) + "field limit increase to 1024" (option b) | `phase37-39-stats-minimization.md`; `phase37-41-field-limit-plan.md:13` / `phase37-42-field-limit-apply.md` |
| Combined decision record "try (a) first then (b)" | `phase37-43-field-resolution.md:15-17` |
| Gate G6 non-compliance row | `generated/phase38-00-master.md:205` |

**Canonical scope:** single remediation track with two levers (minimize fields at source; raise limit ≥1024), one acceptance metric (<10/min sustained).

### Cluster C — Create production packet workflow → **ACT-003** (maps BCK-38-004)

| Source naming | Location |
|---|---|
| "Create packet workflow — implement isolated workflow design" | `phase37-81-final.md:135` (roadmap #3) |
| Packet series design docs (17 prompts) | `phase37-17-packet-workflow-decision.md` … `phase37-31-packet-volume.md` |
| P38 re-design | `generated/phase38-75-packet-workflow.md` (DESIGN-COMPLETE), proof methodology `generated/phase38-76-packet-workflow-proof.md` |
| Backlog entry | `generated/phase38-90-backlog.md` BCK-38-004 (dependency on ACT-001 at :103) |

### Cluster D — Wazuh→Shuffle webhook integration → **ACT-004**

| Source naming | Location |
|---|---|
| Resolution path steps 3–5 (webhook trigger, ossec.conf integration, E2E test) | `phase36-17-shuffle-wazuh-integration-blocker.md` |
| Operator rec "Configure Wazuh→Shuffle webhook integration via Shuffle UI" | `phase36-75-final-report.md:72` |
| Roadmap #4 "Integrate Wazuh→Shuffle" | `phase37-81-final.md:136` |
| Backlog P2 #3 | `phase37-74-backlog.md` |

### Cluster E — Credential rotation (Shuffle) → **ACT-005**

| Source naming | Location |
|---|---|
| Operator rec "Change Shuffle password after first login" | `phase36-75-final-report.md:71` |
| Server-side admin rotation (done) + operator receipt loop (open) | `phase37-03-shuffle-password.md` §Operator Rotation Status |
| "Rotate Shuffle bearer token" | `generated/phase38-00-master.md:169` (item 5) |
| Hardening Step 1 credential verification/rotation incl. inline generation procedure | `generated/phase38-73-shuffle-hardening.md` §Step 1 |

Note: master splits token rotation out of BCK-38-001 while phase38-73 folds it into Step 1 — consolidate under one ID with sub-tasks (admin password receipt; bearer token; validation via `ops/scripts/credential-rotation-validation.sh` output artifact).

### Cluster F — Observe ISM deletion wave → **ACT-006**

| Source naming | Location |
|---|---|
| "Monitor disk daily until wave executes (2026-08-29)" | `phase36-75-final-report.md:73` |
| Roadmap #5 "Observe ISM wave — validate first deletion on 08-29" | `phase37-81-final.md:137` |
| Backlog P2 #5 "ISM wave observation" | `phase37-74-backlog.md` |
| Master item 11 "Monitor disk post-ISM archive deletion" | `generated/phase38-00-master.md:180` |

### Cluster G — Recover agents 013/015 → **ACT-007**

| Source naming | Location |
|---|---|
| "Monitor agent 013/015 for reconnection" | `phase36-75-final-report.md:74` |
| Recovery program reports | `phase36-41-endpoint-recovery-strategy.md`, `phase36-43/44` summaries |
| Status-only follow-ups | `phase37-51-agent013-status.md`, `phase37-52-agent015-status.md` |
| Backlog P3 #6 "Agent 013/015 recovery" | `phase37-74-backlog.md` |

### Cluster H — Validate /tmp cleanup cron first execution → **ACT-008**

Roadmap #6 (`phase37-81-final.md:138`) = backlog P3 #7 (`phase37-74-backlog.md`) = monitoring plan `phase36-49-tmp-monitoring.md`. One item, three namings.

### Cluster I — Corpus stub/duplicate cleanup → **ACT-009** (maps BCK-38-003 + master items 1–2, 9–10)

Delete 8 empty stubs + mark 60 superseded + consolidate backup-dr-audit/alert-volume families: `generated/phase38-00-master.md:165-166,178-179`; `generated/phase38-04-report-inventory.md:43`; `generated/phase38-05-report-hash-duplicates.md` §Summary table.

### Cluster J — Approve & apply report migration (+ rollback proof) → **ACT-010**

Plan `generated/phase38-59-migration-plan.md` → dry-run `generated/phase38-68-migration-dryrun.md` → deferred apply `generated/phase38-69-migration-apply.md`. Single workstream referenced by three IDs.

---

## 3. Canonical Register

| ACT ID | Canonical action | Merged source count | Maps to |
|---|---|---|---|
| ACT-001 | Restrict + encrypt Shuffle frontend (bind/firewall/TLS) + validate | 7+ | BCK-38-001, G5 |
| ACT-002 | Resolve field cardinality (minimize + raise limit) to <10/min | 6+ | BCK-38-002, G6 |
| ACT-003 | Create + prove packet workflow in production-safe mode | 4+ | BCK-38-004 |
| ACT-004 | Wazuh→Shuffle webhook integration E2E | 4 | — |
| ACT-005 | Complete credential rotation loop (operator receipt + bearer token) | 4 | subset of BCK-38-001 scope |
| ACT-006 | Observe + validate ISM wave 2026-08-29 | 4 | G7 watch |
| ACT-007 | Recover/re-image agents 013, 015 or retire formally | 4 | — |
| ACT-008 | Validate /tmp cron execution + thresholds | 3 | — |
| ACT-009 | Corpus hygiene: stubs, superseded markers, consolidation | 5 | BCK-38-003 |
| ACT-010 | Migration approval, apply, verify, rollback proof | 3 | — |

## 4. Recommendation

Adopt ACT-xxx as the cross-phase canonical namespace; keep BCK-38-xxx as the Phase 38 backlog view. Every future report referencing this work must use the canonical ID plus its own local naming in parentheses, e.g., "ACT-001 (Shuffle hardening)".
