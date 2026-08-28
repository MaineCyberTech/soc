# Phase 60: Authority - Phase 60 Execution Plan and Risk Assessment

**Actual UTC:** 2026-08-28T07:45:00Z
**ET:** 2026-08-28 03:45:00 EDT
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

### Phase 60 Execution Strategy

#### Phase 1: Credential Remediation (Prompts 010-035) - CREDENTIAL GATE
1. **Credential Policy Definition** (010-019): Define evidence contract for REAL_ACTIVE classification
2. **Credential Review** (020-029): Audit all token references in reports/workflows
3. **True Rotation Execution** (024-035): 
   - Generate new IRIS key via web UI (credential gate)
   - Update `iris-shuffle-env` secret (Swarm)
   - Update Class-A workflow to value-blind pattern
   - Verify: webhook → ROUTED 200 → IRIS object created
   - **GATE:** Requires owner approval ("Rotate the underlying IRIS token now")

#### Phase 2: Watchdog Persistence (RESTART GATE)
1. **Watchdog Source Inventory** (030-039): Document current watchdog state
2. **Watchdog Proof** (030-049): Verify current watchdog behavior
3. **Watchdog Persistence** (030-039): 
   - Integrate watchdog into container entrypoint
   - Survive container restart
   - **GATE:** Requires owner approval ("Implement watchdog persistence now")

#### Phase 2: Correlation & IRIS Read-back (Prompts 040-069)
1. **Class-A Correlation** (050-059): One-event Wazuh→IRIS proof
2. **IRIS Read-back** (048-059): Resolve IRIS item-detail API access
3. **Integratord Monitoring** (060-079): Integratord health + watchdog integration

#### Phase 3: Corrupt Workflow Governance (072-083)
- Inventory, label, disable, document corrupted `eb937a37`
- **DELETE GATE:** Requires admin UI action (DELETE 401)

#### Phase 4: Packet Correctness (084-139)
- Dedup (084-099): 6-tuple, concurrent, restart, cert
- TTL (100-119): Config, boundary, restart, clock, cleanup
- Counter (100-119): Code, sequential, concurrent, stress, duplicate, failure
- States A/B (120-143): All 13 states live on current revision

#### Phase 5: Synthetic & CI (136-159)
- Synthetic exclusions (billing, scorecard, queue, client, counter)
- CI: billing, scorecard, client, notification, queue, client

#### Phase 3: Governance & Canonical (140-183)
- Agents updates, canonical refresh, disk/ISM/ISM, audit

#### Phase 4: Restore/Production Gates (BLOCKED)
- Restore (192-211): All BLOCKED (NO-GO without target)
- Production (204-219): All BLOCKED (NO-GO without sign-off)

#### Phase 5: Final & Phase 61 Prep (360-379)

### Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| IRIS rotation breaks workflows | Medium | High | Backup workflow, test in staging, rollback plan |
| Watchdog persistence fails | Low | High | Test in staging, entrypoint integration |
| Corrupt workflow deletion fails | Low | Low | Document as residual, monitor |
| Restore/production gates | N/A | High | Gates prevent accidental execution |

### Rollback Plan
- **Credential Rotation:** Revert secret to old key, revert workflow to HTTP action
- **Watchdog:** Disable watchdog script, remove from entrypoint
- **Corrupt Workflow:** No action needed (already isolated)
- **Packet Workflow:** No changes planned

## Verdict
**COMPLETE** - Execution plan documented. Gates identified. Ready for sequential execution.

## Limitations
- Plan assumes owner approvals for gates are obtained before execution
- Some tasks (true token rotation) require manual IRIS web UI steps
- Watchdog persistence requires container entrypoint modification (restart gate)

## Verdict
**COMPLETE** - Phase 60 execution plan documented. Gates identified. Ready for sequential execution.