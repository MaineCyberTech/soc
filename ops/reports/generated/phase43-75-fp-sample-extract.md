# Phase 43: FP Sample Extraction

**Report ID:** phase43-75-fp-sample-extract.md
**Phase:** 43
**Title:** Phase 43 FP Sample Extraction
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-75-fp-sample-extract.md`

---

## 1. Purpose

Extract and document the current FP sample for baseline.

---

## 1. Extraction Command

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-alerts-*/_search?q=rule.groups:suricata&size=25&sort=@timestamp:desc&_source=@timestamp,data.signature_id,data.alert.signature_id,data.src_ip,data.dest_ip,rule.description" > ops/evidence/p42-fp-sampling/sample-25.json
```

---

## 1. Sample Artifact

| File | Path | SHA256 |
|------|------|--------|
| Sample (25) | `ops/evidence/p41-fp-sampling/sample-25.json` | `27620584...` |

> **Note**: Universe is 10; sample of 25 returns all 10.

---

## 2. Sample Content (Summary)

| # | Timestamp | SID | Signature | Src IP | Dst IP | Type |
|---|-----------|-----|----------|--------|--------|------|
| 1 | 2026-08-26T01:28:55 | 2027967 | ET MALWARE LiLocked [MCT-CANARY-P40-E2E-001] | 192.168.222.201 | 192.168.222.1 | Canary |
| ... | ... | 2027967 | ... | ... | ... | Canary |
| 8 | ... | 2027967 | ... | ... | ... | Canary |
| 9 | 2026-08-25T19:18:18 | 2260001 | SURICATA Applayer Wrong Direction | ... | ... | Natural |
| 10 | ... | 2210038 | ... | ... | ... | Natural |

---

## 3. Canary vs Natural Separation

| Method | Canary Marker |
|--------|---------------|
| Field | `MCT_SYNTHETIC: true` |
| Field | `MCT_TEST_ID: P40-E2E-* / P41-*` |
| Field | `MCT_TEST_ONLY: true` |

> **Natural alerts**: 2 (sid 2260001, 2210038) — zero FP observed.

---

## 4. Status

**COMPLETE** — Sample extracted, artifact saved, baseline documented.