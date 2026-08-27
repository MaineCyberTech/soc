# Phase 46: Export Exact Workflow

## Workflow Identity

| Field | Value |
|-------|-------|
| ID | `e133a645-95b9-4e01-9454-e270d2a0b599` |
| Name | `suricata-packet-routing` |
| Status | `test` |
| Owner | `39dd09d3-7874-46a0-8672-e7acb8827b2c` |
| Org | `264c0502-9136-4cfc-938b-390b97b861b8` |
| Created | `1787717303` (epoch) |

## Trigger

| Field | Value |
|-------|-------|
| ID | `736b7410-ed6a-52af-b369-89dbef6386cb` |
| Name | `suricata-eve-in` |
| Type | `WEBHOOK` |
| Status | **STOPPED** |
| Custom URL | `p39-suricata-test` |
| Is Start Node | Yes |
| Valid | Yes |

## Actions

| Field | Value |
|-------|-------|
| Action ID | `722fb255-4e6a-4d73-87f9-19c05fab1ca2` |
| App | `Shuffle Tools 1.2.0` |
| App ID | `105a94f1-725a-4cab-b085-520b4eec1f86` |
| Name | `execute_python` |
| Label | `parse-eve-json` |
| Is Start Node | Yes |
| Valid | Yes |
| Environment | `Shuffle` |

### Action Parameters
1. `call` = `execute_python` (STATIC_VALUE)
2. `code` = Full Python routing logic (inline)

### Code Hash
SHA256 of code parameter content: *(computed at export time)*

## Revisions
- Current revision: single-action architecture
- Previous revisions: multi-node (deprecated, replaced in Phase 44)

## Auth References
| Reference | Status |
|-----------|--------|
| `[REDACTED-IRIS-TOKEN]` (IRIS Bearer) | **PLACEHOLDER** — needs real token |

## Execution History
| Test | Result | State |
|------|--------|-------|
| Normal event (SID 2027967) | PASS | routed |
| Duplicate event | PASS | duplicate-suppressed |
| Non-allowlisted SID | PASS | not_allowed → DEADLETTER |
| Synthetic event | PASS | synthetic → SINK |
| Malformed event | PASS | malformed → DEADLETTER |

## No Secrets in Export
- IRIS token: placeholder `[REDACTED-IRIS-TOKEN]`
- API key: not included in workflow definition
- All credential references redacted

## Verification
- [ ] Workflow ID matches
- [ ] Trigger status: STOPPED
- [ ] Action valid: Yes
- [ ] No secret values in export
- [ ] All test results documented

---
*Generated: 2026-08-27T06:00:00Z (UTC) / 2026-08-27T02:00:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
