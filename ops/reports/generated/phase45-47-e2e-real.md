# Phase 45: Eligible Real Packet Proof

## Objective
Prove one real allowlisted SID 2027967 event end-to-end with exact destination evidence, no duplicate.

## Pre-conditions
- [ ] All canary tests passed
- [ ] Wazuh bound (Phase 45-45)
- [ ] Real Suricata event available (rule 2027967 fires naturally)
- [ ] Dedup cache clear (no recent 2027967 from same 5-tuple)

## Real Event Criteria
| Criteria | Requirement |
|----------|-------------|
| **Source** | Real Suricata alert (not injected) |
| **SID** | 2027967 (allowlisted) |
| **Fields** | All required fields populated |
| **Synthetic** | False (real traffic) |
| **Dedup** | First event for this 5-tuple in 300s |

## Detection
```bash
# Monitor Wazuh alerts for rule 2027967
tail -f /var/ossec/logs/alerts/alerts.json | grep "2027967"

# Or check Shuffle executions for real events
```

## When Real Event Detected
```bash
# 1. Capture timestamp
REAL_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# 2. Capture full event from Wazuh/Shuffle
EXEC_ID=<from_shuffle_execution>

# 3. Verify end-to-end
```

## Verification
```bash
EXEC_ID=<from_shuffle>
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execution/$EXEC_ID"
```

## Required Proofs
| Proof | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **Real event** | Not injected, natural Suricata alert | [Y/N] | [PASS/FAIL] |
| **SID 2027967** | Allowlisted | [Value] | [PASS/FAIL] |
| **All fields** | src/dst/port/proto all present | [Bool] | [PASS/FAIL] |
| **Not synthetic** | MCT_SYNTHETIC=false | [Bool] | [PASS/FAIL] |
| **Dedup first** | No recent same 5-tuple | [Bool] | [PASS/FAIL] |
| **State** | ROUTED | [State] | [PASS/FAIL] |
| **IRIS object** | Valid alert ID | [ID] | [PASS/FAIL] |
| **No duplicate** | Only one IRIS object | [Count] | [PASS/FAIL] |
| **Exact destination** | IRIS alert matches event | [Bool] | [PASS/FAIL] |

## IRIS Verification
```bash
# Get alert from IRIS
curl -X GET "https://iriswebapp_nginx:8443/alerts/<ALERT_ID>" \
  -H "Authorization: Bearer <IRIS_ADMIN_TOKEN>"
```

| IRIS Field | Expected | Actual |
|------------|----------|--------|
| `alert_source` | suricata | [Value] |
| `alert_source_ref` | 2027967-<src> | [Value] |
| `alert_source_content.sid` | 2027967 | [Value] |
| `alert_source_content.src` | <src_ip> | [Value] |
| `alert_source_content.dst` | <dst_ip> | [Value] |
| `alert_source_content.port` | <port> | [Value] |
| `alert_source_content.proto` | <proto> | [Value] |
| `alert_tags` | source:suricata,class:A,test:true | [Value] |

## Exact Destination Evidence
| Field | Suricata Event | IRIS Alert | Match |
|-------|----------------|------------|-------|
| SID | 2027967 | [Value] | [Y/N] |
| Src IP | <src> | [Value] | [Y/N] |
| Dst IP | <dst> | [Value] | [Y/N] |
| Port | <port> | [Value] | [Y/N] |
| Proto | <proto> | [Value] | [Y/N] |

## Duplicate Check
```bash
# Query IRIS for recent alerts with same source_ref
curl -X GET "https://iriswebapp_nginx:8443/alerts?source_ref=2027967-<src>&limit=10" \
  -H "Authorization: Bearer <IRIS_ADMIN_TOKEN>"

# Count should be 1
```

## Evidence
- [ ] Real event captured (not injected)
- [ ] SID 2027967 confirmed
- [ ] All fields present
- [ ] Not synthetic
- [ ] First in 300s window
- [ ] State = ROUTED
- [ ] IRIS object created
- [ ] No duplicate in IRIS
- [ ] Exact field match Suricata → IRIS
- [ ] No duplicate in IRIS

## Class-A Impact
- Workflow: `test`
- IRIS tag: `class:test,phase:45,real:true`
- No production impact

## Evidence Collection
- [ ] Real event timestamp
- [ ] Shuffle execution ID
- [ ] IRIS alert ID
- [ ] Field-by-field match
- [ ] No duplicate in IRIS
- [ ] All fields exact match

---
*Generated: 2026-08-27T04:20:00Z (UTC) / 2026-08-27T00:20:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after E2E canary (Phase 45-46)*
