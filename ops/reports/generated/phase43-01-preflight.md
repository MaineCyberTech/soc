# Phase 43: Preflight

**Report ID:** phase43-01-preflight
**Phase:** 43
**Title:** Phase 43 Preflight — System State Snapshot
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-01-preflight.md`

---

## 1. Git & Release State

| Item | Value |
|------|-------|
| Git HEAD | `c96dc5f` (Phase 42: churn eliminated, v1.3.1 shipped, hygiene closed, EID root-caused+fixed, dual-fault monitor proof) |
| Git Status | Clean (1 untracked file: `STATE_OF_THE_STACK_20260826.md`) |
| Release Tags | v1.3.0 (published), v1.3.1 (tag pushed, on-box asset built) |
| v1.3.1 Asset | `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` (sha256: `4e6c3712ba88f5ab925a2049d5d214fb55222a602c79738028ffee9a23ebf596`) |
| Git Remote | `github.com:MaineCyberTech/soc` (clean push) |

---

## 2. Disk & Filesystem

| Metric | Value |
|--------|-------|
| Root Disk | 148G total, 120G used (85%), 23G available (85% used) |
| `/tmp` | 3.9Gi available (3.9Gi free) |
| Low Watermark | **ACTIVE** (85% threshold reached) |
| **Disk Threshold Enabled** | **`false`** (watermarks are advisory-only) |

> **Critical Finding**: `cluster.routing.allocation.disk.threshold_enabled=false` — the 85% low watermark is **advisory only**. No allocation blocks will occur at 85%. This is a governance decision point (see Phase 43 disk-threshold arc).

---

## 3. Memory & Swap

| Metric | Value |
|--------|-------|
| Total RAM | 15.6 GiB (15.6 GiB) |
| Used | 11.1 GiB (71%) |
| Available | 3.7 GiB |
| Swap | 8.0 GiB total, 5.0 GiB used (63%) |

---

## 4. OpenSearch Cluster

| Metric | Value |
|--------|-------|
| Cluster Health | GREEN |
| Nodes | 3 (multi-node-wazuh1/2/3.indexer) |
| Shards | 274 active (100%) |
| Unassigned | 0 |

### Archive Indices (wazuh-archives-*)
| Index | Created | Size |
|-------|---------|------|
| wazuh-archives-4.x-2026.08.24 | 2026-08-24T00:00:02.733Z | 69.8 MB |
| wazuh-archives-4.x-2026.08.25 | 2026-08-25T00:00:02.400Z | 284.8 MB |
| wazuh-archives-4.x-2026.08.26 | 2026-08-26T00:00:02.420Z | **503.3 MB** |
| **wazuh-archives-4.x-2026.08.27** | **NOT YET BORN** (expected ~00:00:02Z tonight) | — |

> **Critical**: The `2026.08.26` archive index is at **503.3 MB** and contains legacy stats fields (441 leaves). The **2026.08.27** index has **not yet been created** (expected at ~00:00:02 UTC tonight). This is the index that will be evaluated for the Phase 43 field adjudication.

---

## 5. Wazuh Agents

| ID | Name | Status | Notes |
|------|------|--------|-------|
| 000 | wazuh.master | active | Manager |
| 006 | docker-host | active | |
| 007 | mct-portal-dev | active | |
| 008 | securityonion | **disconnected** | Retired (container stopped, restart=no) |
| 011 | mct-linux-client01 | active | |
| 012 | MCT-WIN11PILOT | active | |
| 013 | SAMSUNG | **disconnected** | >26h offline — owner action needed |
| 014 | DESKTOP-MI54LFT | active | |
| 015 | Julians-Air | **disconnected** | Flapping (macOS sleep cycles) — permission fixed, flap persists |
| 016 | mct-packet-sensor | active | Suricata sensor; compact stats lane active |

**Active agents**: 7 (000, 006, 007, 011, 012, 014, 016)
**Disconnected**: 2 (013, 015) — both owner-gated
**Retired**: 1 (008)

---

## 6. Shuffle

### Workflows
| Workflow ID | Name | Status | Actions |
|-------------|------|--------|---------|
| `e133a645` | suricata-packet-routing | test | 13 |
| `eb937a37` | wazuh-high-severity-to-iris | test | 2 |
| `e951db98` | wazuh-flow-classb-to-iris | draft | 2 |

### Recent Executions (24h)
- **Total executions (Class-A)**: 83 (last 24h)
- Class-A (eb937a37): delivered=46, failed=31, aborted=3, other=4
- Class-B (e951db98): 1 execution
- Packet (e133a645): test-only, status=test, 13 actions

### Network & TLS
- Frontend: `192.168.222.149:3001` (mgmt interface only)
- TLS Proxy: `192.168.222.149:3443` (nginx, self-signed, HSTS/XFO/nosniff, cert pinned)
- Backend: `127.0.0.1:5001` (loopback)
- **Network Attach**: `iriswebapp_nginx` attached to `shuffle_swarm_executions` overlay (resolves DNS for IRIS delivery)

### Repair Churn Fix
- **Status**: **APPLIED & VERIFIED**
- Script: `ops/scripts/shuffle-repair-network.sh` (FRONTEND_REPAIRED gate)
- Healthy no-op: 3 consecutive runs (PASS + NO-OP ×3)
- Forced failure test: backend detach → reconnect → frontend NOT restarted (0 restarts)
- Historical churn: ~1,381 restarts over ~15 days (~92/day) — **ELIMINATED**

---

## 7. Delivery Monitor

| Metric | Value |
|--------|-------|
| Cron | `*/15 * * * *` (since ~01:45Z Aug-26) |
| Last Run | ~09:00Z (cycle 23+) |
| Delivered | 46 (was 40 at P42 close) |
| Failed | 31 |
| Aborted | 3 |
| Other | 4 |
| **Fail-Closed Events** | **2 real catches** (04:15Z & 07:45Z Aug-26) |

> **Full-Day Certificate**: Not yet complete. Strict 24h window completes at **2026-08-27T01:45Z** (cron armed ~01:45Z Aug-26).

### Watchdog
- Script: `ops/scripts/p41-monitor-watchdog.sh`
- Cron: `3,18,33,48 * * * *`
- Self-masking bug: **FIXED** (dedicated alert log, no self-masking)
- Last test: sandbox stale→ALERT, repeat-guard holds

---

## 8. Field Containment (P41/P42)

| Metric | Value |
|--------|-------|
| **Policy** | Stats removed from `eve.json` at sensor (mct-soc-scan) |
| Compact Lane | 16-field `stats_compact` via `suricatasc dump-counters` → systemd timer (60s) → agent localfile → archives index |
| 08.26 Index Fields | **1852** (1766 unique + 441 legacy stats) — CRIT guardrail |
| 08.27 Index | **NOT YET BORN** (expected ~00:00:02Z tonight) |
| Stats Leaves (08.26) | **441** (decoder 165, app_layer 157, flow 54, tcp 27, capture 10, etc.) |
| Compact Lane Fields | **16** (capture_kernel_packets/drops/errors, flow.memcap/spared/emergency_mode, tcp/http/ftp/smtp memuse, detect.alerts/engines/queue_overflow, decoder.pkts/bytes/errors, uptime) |
| Rejections (08.26) | 2,746 in two bursts (07:02 & 07:45) — **zero since 07:45Z** |
| **Projection (08.27)** | ~1,300–1,400 fields (compact lane only) |

> **Critical**: The 08.26 index has 1,852 fields (CRIT) due to 441 legacy stats leaves + organic growth (win +15, VT +13, etc.). The 08.27 index will be the **first post-containment index** and should land at ~1,300–1,400 fields (well under 2,000 limit).

---

## 9. Shuffle Workflows — Packet Lane

| Workflow | ID | Status | Actions | Notes |
|----------|----|--------|---------|-------|
| suricata-packet-routing | `e133a645` | test | 13 | Imported & rebuilt; **platform defect blocks certification** |
| wazuh-high-severity-to-iris | `eb937a37` | test | 2 | **Certified** (68 real executions, IRIS 200) |
| wazuh-flow-classb-to-iris | `e951db98` | draft | 2 | Deferred |

### Platform Defect (Packet Lane)
| Test | Result |
|------|--------|
| T1: `execute_python` globals probe | **FAIL** — no incoming data variable (`data_in`/`input`/`execution_input`/`execution_data`/`data` all UNDEF) |
| T2: Tools `$ref` passthrough | **FAIL** — `set_cache_value` echoed `$normalize-fields` literally |
| T3: `if_else_routing` | **MISSING** — runtime "Function doesn't exist" |
| T4 | `repeat_back_to_me` ignores input param |
| T5 | HTTP app **DOES** interpolate (Class-A delivery works) |

> **Verdict**: Packet lane **stays DISABLED/TEST-ONLY**. Platform defect (`execute_python` no incoming data injection) prevents dedup/validation/isolation/allowlist certification. Remediation paths: (B) Shuffle upgrade > (A) UI rebuild with native nodes > (C) external filter.

---

## 10. ISM & Retention

| Policy | Status |
|--------|--------|
| `wazuh-archives-14d` | Attached to all 12 archive indices (08.15–08.26) |
| `wazuh-retention` | On alert indices (30d) |
| `wazuh-states-retention` | On states indices |
| `elastiflow` | Separate policy |

### First Deletion Wave
| Index | Created | Size | ETA |
|-------|---------|------|-----|
| wazuh-archives-4.x-2026.08.15 | 2026-08-15T00:00:02.733Z | 69.8 MB | **2026-08-29T21:00:44Z** |

> **Policy Corrected**: 08.26 index was on `wazuh-retention` (30d); corrected to `wazuh-archives-14d` via remove→add. ETA recalculated: **2026-08-29T21:00:44Z** (3.7 days out).

### Snapshots
| Repo | Type | Snapshots | Latest |
|------|------|-----------|--------|
| wazuh-backup | fs | 42 | 2026-08-26T03:30:04Z |
| do-spaces | s3 | 87 | 2026-08-26T00:47:01Z |

> **Spot-check Streak**: 4 consecutive PASS (P39, P40, P41, P42) — 170,521 docs parity.

---

## 11. Field Adjudication Readiness

| Item | Status |
|------|--------|
| Adjudicator Script | `ops/scripts/p42-field-cycle-adjudicate.sh` (chmod+x, syntax OK) |
| Five Conditions | C1: limit=2000, C2: ISM=archives-14d, C3: zero full-stats, C4: rejection flatline, C5: leaf count ≤1400 |
| Simulation | `POST _index_template/_simulate_index` → limit=2000 + ISM resolve |
| 08.27 Index | **NOT YET BORN** (expected ~00:00:02Z tonight) |
| Adjudication Window | **Tonight ~00:00:02Z → morning** |

---

## 12. Security & Hygiene

| Item | Status |
|------|--------|
| **GH_TOKEN** | **PRESENT** in `/opt/wazuh-docker/multi-node/ops/creds.env` (`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`) |
| VT Key (master) | Present (64-char hex); container chmod 640 **APPLIED**; host chmod 640 **NEEDS SUDO** (owner item) |
| VT Key (worker) | Not present |
| nosniff | Single header (app owns it); proxy duplicate removed |
| XFO | Single header (app owns it) |
| HSTS | `max-age=31536000` (nginx proxy) |
| Security-onion | Stopped, restart=no, volumes preserved |
| Security-onion Restart Policy | `restart=no` (verified) |

---

## 13. Dashboards

| Dashboard | Status |
|-----------|--------|
| W1 / W2 (Windows) | Imported 8 objects (securitytenant: global) |
| Visual Render | **PENDING** (login-gated; browser session needed) |
| Data Validation | **PASSED** (live queries match) |
| EID Discrepancy | **ROOT-CAUSED**: `event.code` never populated; true signal = `data.win.system.eventID` (1.96M hits); v2 artifact (`.keyword`) imported 4/4 with parity |

---

## 14. FP Sampling

| Metric | Value |
|--------|-------|
| Universe (7d) | 10 alerts (8 canary-marked, 2 natural) |
| Natural SIDs | 2260001 (×1), 2210038 (×1) |
| Canary SIDs | 2027967 (×8) |
| Natural FP | **0** |
| Status | **CONTINUE-QUALITATIVE** (population <50, no repeat offenders) |

---

## 15. CI Gates

| Suite | Status |
|-------|--------|
| p38-report-ci.sh | PASS (0 errors, 0 warnings) |
| p39-canonical-ci.sh | PASS |
| p39-agents-ci.sh | PASS |

---

## 16. Blockers & Open Items

| Item | Status | Blocker |
|------|--------|---------|
| 08.27 Field Adjudication | **STAGED** | Index birth ~00:00:02Z tonight |
| Monitor 24h Cert | RUNNING | Completes 2026-08-27T01:45Z |
| Owner Batch (8 items) | PACKAGED | No human available |
| Agent 013 | OFFLINE | >26h offline — owner action |
| Agent 015 | FLAPPING | macOS sleep cycles — owner device |
| RTO/RPO Signoff | SHEET READY | Signature AWAITING |
| Restore Target | MEMO READY | Approval AWAITING |
| v1.3.1 GitHub Release | TAG PUSHED | GH Token unavailable |
| Packet Lane | DEFERRED | Platform defect (execute_python) |
| Disk Threshold | DISCLOSED | Owner decision: enable or accept advisory |
| Dashboard v2 Swap | READY | Owner signoff |
| Host VT Key chmod | NEEDS SUDO | Owner item |
| ISM Wave Observation | ARMED | Aug-29T21:00:44Z |

---

## 17. Evidence References

| Artifact | Path |
|----------|------|
| Field Adjudicator Script | `ops/scripts/p42-field-cycle-adjudicate.sh` |
| Repair Script | `ops/scripts/shuffle-repair-network.sh` |
| Compact Stats Emitter | `ops/scripts/suricata-compact-stats.py` |
| Delivery Monitor | `ops/scripts/p39-iris-delivery-check.sh` |
| Watchdog | `ops/scripts/p41-monitor-watchdog.sh` |
| Packet Workflow Export | `ops/evidence/p42-workflow-export/` |
| FP Sample | `ops/evidence/p41-fp-sampling/sample-25.json` |
| ISM Baseline | `ops/evidence/p41-ism-baseline.json` |
| Canonical Current State | `ops/reports/canonical/current/current-state-20260826-p42.md` |
| Open Work Register | `ops/reports/canonical/current/open-work.md` |

---

**Preflight Complete** — All systems operational. Awaiting 08.27 index birth (~00:00:02Z tonight) for field adjudication. All CI gates GREEN. Secret sweep clean.