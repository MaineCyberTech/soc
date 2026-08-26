# MCT Security Stack — State of the Stack (Phase 42 Complete)
**Date**: 2026-08-26 ~09:30Z  
**Git**: `c96dc5f` (main, clean, pushed)  
**Report Count**: 1,111 total (Phases 27–42)  
**Operator**: Automation (opencode)  
**Verdict**: PASS-WITH-PRECISE-BLOCKERS

---

## 1. Executive Summary

Phase 42 achieved its primary gates: **repair-churn eliminated**, **v1.3.1 shipped**, **secret hygiene closed**, **EID discrepancy root-caused + fixed**, **delivery monitor dual-fault proof**, **field-growth contained at source**. The stack is operationally stable with all CI gates green and zero secrets in the repository.

**Verdict**: PASS-WITH-PRECISE-BLOCKERS — all automation-executable gates achieved; owner items precisely packaged; two significant honest disclosures converted into tracked decisions.

---

## 2. Critical Findings (Honest Disclosures)

| Finding | Impact | Status |
|---------|--------|--------|
| `disk.threshold_enabled=false` in indexer | 85% watermark is **advisory-only**, not enforced | Documented as R-DISKBYPASS; owner decision queued |
| EID discrepancy | `event.code` never populated; real signal = `data.win.system.eventID` (1.96M hits) | Root-caused; v2 artifact (.keyword) imported 4/4; swap pending owner |
| Field growth legacy baggage | 08.26 index at 1852/2000 fields (441 legacy stats); 2746 rejections in bursts | Self-extinguishes at midnight rollover; 08.27 index is true test |
| Shuffle Tools platform defect | `execute_python` has NO incoming data injection; `$refs` pass as literals; `if_else_routing` missing at runtime | Packet lane DEFERRED; remediation B(upgrade)>A(UI-test)>C(external) |
| GitHub token | v1.3.1 release page publish blocked (no GH token in env/creds) | Documented; runbook in phase42-79 |

---

## 3. Operational State (Live Verified)

### Fleet (7 active)
| ID | Name | Status | Notes |
|----|------|--------|-------|
| 000 | wazuh.master | Active | Manager |
| 006 | docker-host | Active | |
| 007 | mct-portal-dev | Active | |
| 011 | mct-linux-client01 | Active | |
| 012 | MCT-WIN11PILOT | Active | |
| 014 | DESKTOP-MI54LFT | Active | |
| 016 | mct-packet-sensor | Active | Suricata + compact stats lane |
| 013 | SAMSUNG | **Disconnected** | >26h offline; owner action |
| 015 | Julians-Air | **Disconnected** | Flapping (macOS sleep); permission fixed |
| 008 | securityonion | **Stopped** | Retired; volumes preserved |

### Indices (OpenSearch)
- **Alert indices**: 22 daily (08.07–08.26), ~52k–713k docs/day
- **Archive indices**: 12 daily (08.15–08.26), 233–932 MB each
- **08.26**: 1852 fields (1766 unique + legacy 441 stats); CRIT guardrail
- **08.27**: **NOT YET BORN** (expected ~00:00:02Z)
- ISM: `wazuh-archives-14d` attached; 08.15 ETA 2026-08-29T21:00:44Z

### Shuffle
- Frontend: `192.168.222.149:3001` (mgmt only), TLS proxy `:3443` (nginx, HSTS/XFO/nosniff, pinned digest)
- Backend: `127.0.0.1:5001` (loopback)
- Workflows: 3 (Class-A test, Class-B draft, Packet test-only)
- Bearer: rotated (old→401, new in `config/shuffle-api-key` 600 gitignored)

### IRIS
- 5 containers healthy; delivery via `iriswebapp_nginx:8443/alerts/add`
- Delivered: 46 (was 40); failures: 31; aborted: 3
- 3 consecutive real deliveries proven (E2E-007 chain)

---

## 4. Key Artifacts & Locations

| Artifact | Path |
|----------|------|
| Field adjudicator | `/opt/mct-security-stack/ops/scripts/p42-field-cycle-adjudicate.sh` |
| Repair script (fixed) | `/opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh` |
| Delivery monitor | `/opt/mct-security-stack/ops/scripts/p39-iris-delivery-check.sh` |
| Watchdog | `/opt/mct-security-stack/ops/scripts/p41-monitor-watchdog.sh` |
| Compact stats emitter | `/opt/mct-security-stack/ops/scripts/suricata-compact-stats.py` |
| Release v1.3.0 (original) | `ops/releases/v1.3.0/v1.3.0-published-original.tar.gz` (sha256 `da72bde4...`) |
| Release v1.3.1 | `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` (sha256 `4e6c3712...`) |
| Packet workflow export | `ops/evidence/p42-workflow-export/` |
| FP sample | `ops/evidence/p41-fp-sampling/sample-25.json` |
| ISM baseline | `ops/evidence/p41-ism-baseline.json` |
| Current-state snapshot | `ops/reports/canonical/current/current-state-20260826-p42.md` |
| Open work register | `ops/reports/canonical/current/open-work.md` |
| Final P42 report | `ops/reports/current/final-phase42-operator-report-20260826-1000Z.md` |
| AGENTS.md | `/opt/mct-security-stack/AGENTS.md` (134 lines, sha-pinned) |

---

## 5. Pending Actions (Gated)

| Item | Status | Blocker |
|------|--------|---------|
| 08.27 field adjudication | STAGED | Index birth ~00:00:02Z tonight |
| Monitor 24h cert | PENDING | Flip at 2026-08-27T01:45Z |
| ISM wave observation | ARMED | Aug-29T21:00:44Z |
| Owner batch (8 items) | PACKAGED | No human available |
| RTO/RPO signoff | SHEET READY | Signature AWAITING |
| Restore target | MEMO READY | Approval AWAITING |
| v1.3.1 GitHub release | TAG PUSHED | GH token unavailable |
| Packet lane certification | DEFERRED | Platform defect (execute_python) |
| Disk threshold policy | DISCLOSED | Owner decision: enable or accept |
| Dashboard v2 swap | READY | Owner signoff |
| Host VT key chmod | NEEDS SUDO | Owner item |

---

## 5. Git State
- **HEAD**: `c96dc5f` (Phase 42 commit)
- **Remote**: `github.com:MaineCyberTech/soc` (main, clean)
- **Tags**: v1.0.0, v1.1.0, v1.2.0, v1.3.0, **v1.3.1 (pushed)**
- Working tree: **CLEAN** (`git status --short = 0`)

---

## 6. Quick Commands Reference

```bash
# Field adjudication (tonight ~00:00Z)
bash /opt/mct-security-stack/ops/scripts/p42-field-cycle-adjudicate.sh

# Check 08.27 index
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-4.x-2026.08.27?v"

# Monitor status
bash /opt/mct-security-stack/ops/scripts/p39-iris-delivery-check.sh

# Watchdog test
/opt/mct-security-stack/ops/scripts/p41-monitor-watchdog.sh

# Field guardrail
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh

# Repair script (safe to run --apply)
bash /opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply

# Check 08.27 index settings
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_settings"

# Check field count on 08.27
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.27

# Git status
cd /opt/mct-security-stack && git status

# View final report
cat /opt/mct-security-stack/ops/reports/current/final-phase42-operator-report-20260826-1000Z.md
```

---

## 6. Handoff Notes

> **Tonight**: 08.27 index births at ~00:00:02Z. Run adjudication script immediately. If PASS → field certification VERIFIED. If PARTIAL/FAIL → document and escalate.
>
> **01:45Z tomorrow**: Monitor full-day certificate flips. Verify 24h contiguous evidence.
>
> **Owner session**: Schedule 1-hour block for 8-item agenda. All artifacts ready.
>
> **Aug-29 21:00Z**: ISM wave observation. First archive (08.15) deletion expected.
>
> **Packet lane**: Do not certify until native rebuild or platform upgrade. Current test-only lane is safe (disabled/test-only, zero production contamination).
>
> **v1.3.1**: Tag is public (`git ls-remote origin refs/tags/v1.3.1` works). Asset on-box. Only GitHub release page upload blocked.

---

*Document generated: 2026-08-26 ~09:30Z | Phase 42 complete | Next: await 08.27 index birth*
