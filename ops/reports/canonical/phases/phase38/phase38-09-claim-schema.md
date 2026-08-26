# Phase 38 Claim Schema

**Report ID:** phase38-09-claim-schema  
**Phase:** 38  
**Title:** Phase 38 Claim Schema — Claim Definition and Verification Framework  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-09-claim-schema.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Purpose

Define the schema for claims made by reports in the MCT Security Stack. Claims are the atomic units of truth that reports assert. Each claim must be verifiable, traceable, and resolvable.

---

## 2. Claim Schema

Every claim MUST contain the following fields:

### 2.1 Required Fields

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `claim_id` | string | YES | Unique identifier. Format: `CLM-{phase}-{seq}` | `CLM-38-001` |
| `statement` | string | YES | The assertion being made. Must be testable/falsifiable. Max 300 chars. | `Wazuh field error rate exceeds 50/min` |
| `source_report` | string | YES | Report ID where this claim originates. | `phase38-01-preflight` |
| `source_section` | string | YES | Section within the source report. | `## 6. Wazuh Field Errors` |
| `claim_type` | enum | YES | Type of claim. Values: `FACT`, `ASSESSMENT`, `PREDICTION`, `RECOMMENDATION`, `MEASUREMENT`. | `MEASUREMENT` |
| `status` | enum | YES | Verification status. Values from Status Taxonomy (phase38-08): `UNVERIFIED`, `VERIFIED`, `CONTRADICTED`, `STALE`, `PARTIAL`. | `VERIFIED` |
| `evidence_refs` | array[string] | YES | Paths to evidence files or commands that support this claim. Empty if unverified. | `["/opt/mct-security-stack/ops/evidence/p37-workflow-export/"]` |
| `owner` | string | YES | Responsible party for resolving this claim. | `opencode/big-pickle` |
| `last_verified` | ISO 8601 datetime | YES | Timestamp of last verification attempt. `null` if never verified. | `2026-08-25T19:56:00Z` |

### 2.2 Optional Fields

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `verification_command` | string | NO | Shell command or query to verify this claim. | `curl -s localhost:9200/_cat/health` |
| `verification_query` | string | NO | OpenSearch/Wazuh query to verify this claim. | `GET /_cat/health?v` |
| `observed_result` | string | NO | What was actually observed when verification was run. | `GREEN 3 3 274 ...` |
| `contradiction_refs` | array[string] | NO | Report IDs or evidence that contradicts this claim. Empty if not contradicted. | `["phase35-04-agent016-drift"]` |
| `next_action` | string | NO | What to do next to resolve this claim. | `Re-verify after decoder_order_size increase` |
| `confidence` | enum | NO | Confidence level. Values: `HIGH`, `MEDIUM`, `LOW`, `NONE`. | `HIGH` |
| `expires` | ISO 8601 datetime | NO | When this claim should be re-verified. | `2026-09-01T00:00:00Z` |

---

## 3. Claim Types

### 3.1 FACT
```
Definition: An objective, verifiable statement about system state.
Examples:
  - "OpenSearch cluster status is GREEN"
  - "3 indexer nodes are running"
  - "Shuffle frontend is bound to 0.0.0.0:3001"
Verification: Direct observation or API call.
```

### 3.2 ASSESSMENT
```
Definition: A subjective evaluation based on facts.
Examples:
  - "Disk utilization is concerning at 84%"
  - "Memory pressure is moderate"
  - "Shuffle exposure is a P0 risk"
Verification: Comparison against thresholds or benchmarks.
```

### 3.3 PREDICTION
```
Definition: A statement about future system behavior.
Examples:
  - "First archive deletion will occur on 2026-08-29"
  - "Disk will reach 90% within 14 days without intervention"
Verification: Time-delayed observation.
```

### 3.4 RECOMMENDATION
```
Definition: A suggested action based on assessment.
Examples:
  - "Increase decoder_order_size beyond 512"
  - "Bind Shuffle frontend to 127.0.0.1"
  - "Consolidate backup-dr-audit reports"
Verification: Implementation of the recommendation.
```

### 3.5 MEASUREMENT
```
Definition: A quantitative observation with units.
Examples:
  - "1,281 'Too many fields' errors in current log window"
  - "11,750 MB of 15,553 MB memory used (75%)"
  - "796 Shuffle executions, all healthchecks"
Verification: Metric query or log analysis.
```

---

## 4. Claim Status Transitions

```
UNVERIFIED → VERIFIED (verification performed, claim confirmed)
UNVERIFIED → CONTRADICTED (verification performed, claim disproved)
UNVERIFIED → STALE (verification not performed within expiry window)
VERIFIED → STALE (re-verification needed due to system change)
VERIFIED → CONTRADICTED (new evidence contradicts claim)
CONTRADICTED → VERIFIED (contradiction resolved, claim re-confirmed)
STALE → VERIFIED (re-verification confirms claim)
STALE → CONTRADICTED (re-verification disproves claim)
```

---

## 5. Claim Template

```yaml
claims:
  - claim_id: "CLM-38-001"
    statement: "OpenSearch cluster is GREEN with 3 nodes and 274 shards"
    source_report: "phase38-01-preflight"
    source_section: "## 4. OpenSearch Cluster"
    claim_type: "FACT"
    status: "VERIFIED"
    evidence_refs:
      - "Live state snapshot 2026-08-25T19:56:00Z"
    verification_command: "curl -s localhost:9200/_cat/health?v"
    observed_result: "green 3 3 274 14 ..."
    contradiction_refs: []
    owner: "opencode/big-pickle"
    next_action: null
    last_verified: "2026-08-25T19:56:00Z"
    confidence: "HIGH"
    expires: "2026-08-26T19:56:00Z"
```

---

## 6. Phase 38 Master Claim Register

All claims made by Phase 38 reports:

| Claim ID | Statement | Source Report | Type | Status | Confidence |
|---|---|---|---|---|---|
| CLM-38-001 | OpenSearch cluster is GREEN with 3 nodes, 274 shards | phase38-01-preflight | FACT | VERIFIED | HIGH |
| CLM-38-002 | Disk is at 84% (118G/148G) with LOW WATERMARK ACTIVE | phase38-01-preflight | MEASUREMENT | VERIFIED | HIGH |
| CLM-38-003 | 7 Wazuh agents are active, 3 retired/disconnected | phase38-01-preflight | FACT | VERIFIED | HIGH |
| CLM-38-004 | Wazuh field errors at ~100/min, 18,849+ cumulative | phase38-01-preflight | MEASUREMENT | VERIFIED | HIGH |
| CLM-38-005 | decoder_order_size=512 is insufficient for field error resolution | phase38-01-preflight | ASSESSMENT | UNVERIFIED | MEDIUM |
| CLM-38-006 | Shuffle frontend on 0.0.0.0:3001 is externally accessible | phase38-01-preflight | FACT | VERIFIED | HIGH |
| CLM-38-007 | Shuffle has 796 executions, all healthchecks, zero real routing | phase38-01-preflight | MEASUREMENT | VERIFIED | HIGH |
| CLM-38-008 | Shuffle bearer token is exposed in plaintext configuration | phase38-01-preflight | FACT | VERIFIED | HIGH |
| CLM-38-009 | First archive deletion expected 2026-08-29 | phase38-01-preflight | PREDICTION | UNVERIFIED | MEDIUM |
| CLM-38-010 | Deployability is PARTIAL, full-cluster restore is NO-GO | phase38-01-preflight | ASSESSMENT | UNVERIFIED | MEDIUM |
| CLM-38-011 | Memory at 75% (11,750/15,553 MB), swap at 64% | phase38-01-preflight | MEASUREMENT | VERIFIED | HIGH |
| CLM-38-012 | 1,856 total files in ops/reports, 1,831 .md | phase38-01-preflight | MEASUREMENT | VERIFIED | HIGH |
| CLM-38-013 | 8 empty .md files (phase33-61 through phase33-68) | phase38-04-report-inventory | FACT | VERIFIED | HIGH |
| CLM-38-014 | 3 byte-identical duplicate groups found | phase38-05-report-hash-duplicates | FACT | VERIFIED | HIGH |
| CLM-38-015 | 73 files (4.0%) have near-duplicate relationships | phase38-06-report-near-duplicates | MEASUREMENT | UNVERIFIED | MEDIUM |
| CLM-38-016 | 36 final operator reports exist (phases 2–37) | phase38-04-report-inventory | FACT | VERIFIED | HIGH |
| CLM-38-017 | Missing final-phase1 and final-phase36 operator reports | phase38-04-report-inventory | FACT | VERIFIED | HIGH |
| CLM-38-018 | Report corpus totals 12.77 MB across 1,831 .md files | phase38-04-report-inventory | MEASUREMENT | VERIFIED | HIGH |
| CLM-38-019 | 14 containers running in the security stack | phase38-01-preflight | FACT | VERIFIED | HIGH |
| CLM-38-020 | /tmp at 21% (1.6G/7.6G) with daily cron cleanup | phase38-01-preflight | MEASUREMENT | VERIFIED | HIGH |

---

## 7. Verification Commands Reference

| Claim | Verification Command |
|---|---|
| OpenSearch GREEN | `curl -s localhost:9200/_cat/health?v` |
| Disk utilization | `df -h /` |
| Agent status | `curl -s -u admin:admin localhost:55000/agents -k` |
| Field errors | `grep -c "Too many fields" /var/log/ossec.log` |
| Shuffle frontend binding | `ss -tlnp \| grep 3001` |
| Shuffle executions | `curl -s -H "Authorization: Bearer {token}" localhost:5001/api/workflows` |
| Memory/swap | `free -m` |
| Container count | `docker ps --format '{{.Names}}' \| wc -l` |
| /tmp usage | `du -sh /tmp` |
| Empty files | `find /opt/mct-security-stack/ops/reports/ -name "*.md" -empty` |

---

## 8. Claim Lifecycle

```
1. CLAIM CREATED → status: UNVERIFIED
2. VERIFICATION ATTEMPTED → status: VERIFIED or CONTRADICTED
3. EVIDENCE GATHERED → evidence_refs populated
4. OBSERVED RESULT → observed_result populated
5. CONFIDENCE ASSESSED → confidence set
6. EXPIRY SET → expires populated
7. RE-VERIFICATION (if expired) → status updated
8. RESOLUTION → next_action cleared, claim closed
```

---

## 9. Integration with Report Schema

Claims defined here are embedded in reports via the `claims` array field in the Report Schema (phase38-07). Each report's `claims` array contains claim objects following this schema.

**Cross-reference:**
- Report Schema: phase38-07-report-schema.md → `claims` field definition
- Status Taxonomy: phase38-08-status-taxonomy.md → `UNVERIFIED`, `VERIFIED`, `CONTRADICTED`, `STALE` values
- Hash Duplicates: phase38-05-report-hash-duplicates.md → Claim CLM-38-013, CLM-38-014
- Near-Duplicates: phase38-06-report-near-duplicates.md → Claim CLM-38-015
