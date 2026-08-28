# Phase 45: Single-Action Capability Decision

## Decision Matrix

| Live Probe Result | Decision | Path |
|-------------------|----------|------|
| **PASS** - All markers exact, no loss | **PROCEED** with single-action design | Continue to IRIS auth, Wazuh bind, E2E |
| **FAIL** - Input transformation/loss | **RETIRE** single-action design | Switch to multi-action canonical design |

## Probe Results (To Be Filled)
| Metric | Result |
|--------|---------|
| Probe executed | [YES/NO] |
| All markers exact | [PASS/FAIL] |
| Input transformation detected | [YES/NO] |
| Static fixtures detected | [YES/NO] |

## Decision

### If PASS
**Verdict:** Single-action `execute_python` design is capable on live webhook path.
**Evidence:** [Reference probe report phase45-22]
**Next Steps:**
1. Proceed to IRIS auth object creation (Phase 45-24/25)
2. Replace placeholder with auth object reference
3. Continue to Wazuh bind (Phase 45-45)
4. E2E canary (Phase 45-46)

### If FAIL
**Verdict:** Single-action design has platform limitation on live webhook path.
**Evidence:** [Reference probe report phase45-22]
**Remediation Path (Approved):**
1. **Retire** single-action consolidated design
2. **Implement** multi-action canonical design:
   - `regex_capture_group` (parse)
   - `merge_json_objects` (normalize)
   - `filter_list` / `if_else_routing` (validate, synthetic, allowlist)
   - `check_cache_contains` (dedup)
   - `set_cache_value` (counter)
   - `http` POST (IRIS)
   - `repeat_back_to_me` (logging)
   - Proper Shuffle branches per state
3. Deploy to canonical path (Phase 45-13)
4. Re-run live probe on multi-action design

## Platform Limitation Evidence (If FAIL)
| Symptom | Root Cause | Workaround |
|---------|------------|------------|
| Input not received | `self.full_execution` not populated on webhook | Use trigger output directly |
| Transformation detected | Shuffle parameter interpolation | Use raw webhook body |
| Static fixtures | Action parameter resolution | Pass raw body to execute_python |

## Approval
| Role | Decision | Signature | Date |
|------|----------|-----------|------|
| Capability Owner | [PROCEED/RETIRE] | [Sig] | [Date] |
| Platform Engineer | [Concur] | [Sig] | [Date] |

## Documentation
- If PROCEED: Document capability evidence in Phase 45 completion
- If RETIRE: Document limitation, implement multi-action, update canonical layout

---
*Generated: 2026-08-27T03:48:00Z (UTC) / 2026-08-26T23:48:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after live probe (Phase 45-22)*
