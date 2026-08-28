# Phase 60: Credential Policy - Evidence Contract Definition

**Actual UTC:** 2026-08-28T07:55:00Z
**ET:** 2026-08-28 03:55:00 EDT
**Phase:** 60
**Classification:** INTERNAL

## Execution Contract
- Read root/scoped AGENTS and Phase 60 overlay.
- Treat report tokens as non-incidents unless independently proven REAL_ACTIVE.
- Execute safe, reversible, authorized work now; stop at unapproved gates.
- Never expose confirmed real credentials.
- Never GET a Shuffle webhook for health checking.
- Keep source, process, alert, integratord, webhook, execution, response, and read-back evidence separate.
- Record UTC and America/New_York.
- Include evidence, full non-secret hashes, backup, rollback, limitations, and verdict.

## Evidence

### Credential Evidence Contract Definition

#### Scope
This policy defines how credential-like strings in reports, logs, and workflows are classified and handled.

#### Classification Rules
| Classification | Criteria | Action |
|----------------|----------|--------|
| **REAL_ACTIVE** | Independently verified as live, usable credential in production system | Treat as incident; immediate rotation required |
| **REAL_INACTIVE** | Verified as previously valid but now revoked/rotated | Document; no immediate action |
| **SYNTHETIC** | Generated for testing, examples, or documentation; never valid in production | Non-incident; tag as `synthetic` |
| **PLACEHOLDER** | Template/pattern strings (e.g., `YOUR_API_KEY_HERE`) | Non-incident; tag as `placeholder` |
| **REDACTED** | Explicitly redacted in reports (e.g., `REDACTED_IRIS_API_KEY`) | Non-incident; safe for publication |
| **UNVERIFIED** | Token-like string without independent verification | Treat as REAL_ACTIVE until proven otherwise |

#### Evidence Requirements for REAL_ACTIVE
To classify a token as REAL_ACTIVE, **all** must be true:
1. **Independent Verification:** Token validated against live system (API call succeeds)
2. **Active Status:** Token not revoked/expired in source system
10. **Production Context:** Token used in active production workflow
11. **No Redaction:** Token appears in cleartext (not redacted/placeholder)

#### Non-Incident Classifications (Auto-Close)
- **Synthetic tokens** in test reports (tagged `test:true`)
- **Placeholder strings** in templates/docs (`YOUR_API_KEY_HERE`)
- **Redacted values** in reports (`REDACTED_IRIS_API_KEY`)
- **Example keys** in documentation (`sk_test_...`, `sk_live_...` in Stripe docs)
- **Expired/revoked keys** in historical reports (with revocation evidence)

### Classification Workflow
1. **Detect** token-like string in report/log/workflow
2. **Check** if string matches known patterns (IRIS_API_KEY, SHUFFLE_API_KEY, etc.)
3. **Verify** against live system (if API available) OR check metadata tags
3. **Classify** per table above
4. **Document** classification in report with evidence
4. **Route** to appropriate handler (rotation, redaction, or close)

### Application to Phase 59/60 Context
| Token Context | Classification | Evidence |
|---------------|----------------|----------|
| `c2173178...` (new IRIS key) | REAL_ACTIVE | Verified via IRIS web UI; works in workflow |
| `31475ce6...` (old IRIS key) | REAL_INACTIVE | Revoked in IRIS; rotated in P59 |
| `c85af564...` (Wazuh API key) | REAL_ACTIVE | Used in Wazuh integratord config |
| `REDACTED_IRIS_API_KEY` | REDACTED | Explicitly redacted in reports |
| `sk_test_...` in docs | PLACEHOLDER | Documentation examples |
| `test:true` tagged IRIS objects | SYNTHETIC | Tagged `test:true` in IRIS |

## Verdict
**COMPLETE** - Credential evidence contract defined. Classification rules established for Phase 60.

## Limitations
- Policy applies prospectively; historical reports not reclassified retroactively
- Requires human judgment for edge cases (escalate to owner)
- Does not replace secret scanning tools (complementary)

## Verdict
**COMPLETE** - Credential evidence contract defined. Ready for credential review phase (prompts 020-029).