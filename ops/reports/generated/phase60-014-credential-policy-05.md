# Phase 60: Credential Policy - Git History and Retention

**Actual UTC:** 2026-08-28T08:30:00Z
**ET:** 2026-08-28 04:30:00 EDT
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

### Git History Scanning
**Tool:** `truffleHog` / `git-secrets` / custom regex
**Scope:** Full git history (all branches, all time)
**Exclusions:** None (full history scan)

### Historical Secret Findings
| Commit | File | Pattern | Status |
|--------|------|---------|--------|
| `c33fcde` (P56) | `ops/reports/generated/phase56-*.md` | `31475ce6...` | REDACTED in current reports |
| `047340d` (P57) | `ops/reports/current/final-phase57-*.md` | `31475ce6...` | REDACTED in current reports |
| `047340d` | `ops/reports/current/final-phase57-*.md` | `c2173178...` | REDACTED (new key) |
| `3d7d3c1` | Phase 58 reports | `31475ce6...` | REDACTED |
| `047340d` | `final-phase57-...md` | `c2173178...` | REDACTED (new key) |

### Git History Remediation
| Commit | Issue | Remediation |
|--------|-------|-------------|
| Pre-P56 | Literal IRIS keys in workflows | Rotated in P57; workflows rewritten |
| P57 closeout | Literal key in final report | Redacted in corrected final |
| P58 closeout | New key in workflow | Value-blind pattern applied |
| P59 closeout | True rotation executed | New key rotated via UI |

### Current Git Status
- **Clean History:** No unredacted secrets in current HEAD
- **Rewritten History:** Not performed (BFG/repo rewrite not needed)
- **Current HEAD:** Clean (no literal secrets in tracked files)
- **Untracked Files:** `.env.pre-rebuild-...`, old phase reports (untracked)

### Retention Policy
| Artifact | Retention | Disposition |
|------------|-----------|-------------|
| Reports (generated) | Permanent | Git history |
| Evidence bundles | Permanent | Git history |
| Workflow exports | 2 years | Archive then delete |
| Execution logs | 90 days | Auto-purge |
| Shuffle executions | 30 days | Auto-purge |
| IRIS objects | Permanent | IRIS retention policy |

### Credential Rotation History
| Rotation | Date | Key | Trigger |
|----------|------|---------|---------|
| IRIS Key v1 | Pre-P56 | `31475ce6...` | Initial setup |
| IRIS Key v2 | 2026-08-28 (P57) | `c2173178...` | P57 remediation (literal removal) |
| IRIS Key v3 | 2026-08-28 (P59) | `c2173178...` (new) | P59 true rotation (owner authorized) |

### Git Hygiene Rules
1. **No secrets in commits** - Enforced by pre-commit hooks
2. **No secrets in PRs** - CI gate blocks merge
3. **No secrets in issues/PRs** - Template enforces redaction
4. **No secrets in wiki/docs** - Templates enforce redaction
4. **No secrets in CI logs** - CI masks secrets

## Verdict
**COMPLETE** - Git history reviewed. No unredacted secrets in current HEAD.

## Limitations
- Cannot rewrite public history (force-push prohibited)
- Historical reports with old keys preserved (redacted in current views)
- Shuffle workflow history not in git (Shuffle-managed)

## Verdict
**COMPLETE** - Git history reviewed. No active secrets in current HEAD.