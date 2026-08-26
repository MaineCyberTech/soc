# Phase 43: Packet Platform Remediation Decision

**Report ID:** phase43-41-packet-remediation-decision.md
**Phase:** 43
**Title:** Phase 43 Packet Platform Remediation Decision
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T18:00:00Z
**Classification:** INTERNAL
**Status:** DECISION REQUIRED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-41-packet-remediation-decision.md`

---

## 1. Platform Defect Summary

| Defect | Evidence | Impact |
|--------|----------|--------|
| `execute_python` no incoming data | T1-T5 probes: all `data_in`/`input`/`execution_input` UNDEF | Cannot implement validation/dedup/isolation in Python |
| `$ref` literal passthrough | `set_cache_value` echoed `$normalize-fields` literally | Cannot pass data between nodes |
| `if_else_routing` missing | Runtime: "Function doesn't exist" | Cannot implement conditional routing |
| `repeat_back_to_me` ignores input | Echoes function name, ignores `input` param | Cannot use for passthrough |

> **Root Cause**: Shuffle Tools 1.2.0 on-prem build has broken `execute_python` parameter injection and missing `if_else_routing`.

---

## 2. Remediation Options

| Option | Description | Effort | Risk | Timeline | Recommendation |
|--------|-------------|--------|------|----------|----------------|
| **A. UI Rebuild** | Rebuild workflow in Shuffle UI using native nodes (`filter_list`, `if_else_routing`, `set_datastore_value`) | Low (1-2 sessions) | Low (uses proven native refs) | 1-2 weeks | **RECOMMENDED** |
| **B. Shuffle Upgrade** | Upgrade Shuffle to version with fixed `execute_python` | High (upgrade + test) | Medium (upgrade risk) | 4-8 weeks | SECONDARY |
| **C. External Filter** | Pre-filter in Wazuh/manager; Shuffle only routes | Medium (custom integration) | Medium (new component) | 2-4 weeks | FALLBACK |

---

## 3. Decision Matrix

| Criterion | A (UI Rebuild) | B (Upgrade) | C (External) |
|-----------|----------------|-------------|--------------|
| Time to certify | 1-2 weeks | 4-8 weeks | 2-4 weeks |
| Risk | Low (proven native nodes) | Medium (upgrade risk) | Medium (new component) |
| Cost | Low (owner time) | Medium (upgrade effort) | Medium (dev effort) |
| Packet lane certification | **ACHIEVABLE** | ACHIEVABLE | ACHIEVABLE |
| Maintenance | Low (native) | Medium (version lock) | Medium (custom code) |

---

## 3. Decision Record

| Field | Value |
|-------|-------|
| Decision | [A / B / C / DEFER] |
| Decided By | [Owner/Engineering] |
| Date | [YYYY-MM-DD] |
| Rationale | [Rationale] |
| Next Review | [Date] |

---

## 4. Recommendation

**RECOMMENDATION: Option A (UI Rebuild on Native Nodes)**

Rationale:
1. Lowest risk (uses proven Shuffle native nodes: `filter_list`, `if_else_routing`, `set_datastore_value`, `check_datastore_contains`, HTTP)
2. Fastest to certify (1-2 owner sessions)
3. No platform dependency
4. Aligns with Class-A lane architecture (proven)

---

## 5. Status

**DECISION REQUIRED** — Owner/Engineering decision needed. Packet lane remains DISABLED/TEST-ONLY until remediation.