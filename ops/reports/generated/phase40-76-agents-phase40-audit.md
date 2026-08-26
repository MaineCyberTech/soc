# Phase 40 AGENTS.md Audit

**Report ID:** phase40-76-agents-phase40-audit
**Phase:** 40
**Title:** AGENTS-40-AUDIT — Full Read of Root AGENTS.md Against Phase-40 Reality; Durable-Fact Drift Findings F-40-x With Severities; Path/Command Validations
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-76-agents-phase40-audit.md`

---

## 1. Method

Root `AGENTS.md` read fully (137 lines pre-edit). Every durable claim cross-checked
against live system state and the phase40 evidence chain. Referenced paths and commands
validated mechanically (`test -x`, `-f`) in addition to CI Gate6/7.

## 2. Findings Table

| ID | Section | Drift | Severity | Evidence |
|---|---|---|---|---|
| F-40-01 | Known Blockers | "Automated Wazuh→Shuffle trigger not wired" is FALSE today — lane wired and proven end-to-end (E2E-007 → IRIS alert 42) | MEDIUM — would misdirect agents to re-do closed work or distrust the live lane | phase40-37/-40 |
| F-40-02 | Known Blockers | "Shuffle LAN exposure without TLS" is CLOSED-via-implementation (:3443 nginx + HSTS; plaintext LAN listener gone) | MEDIUM | phase40-27…32; live ss/openssl |
| F-40-03 | Known Blockers | Agent-015 line ("015 flapping") omits that the manager-side merged.mg defect was FIXED (83,736 lifetime errors ended); only device-side flap remediation remains | LOW-MEDIUM | phase40-18…24; frozen ossec.log count |
| F-40-04 | Canonical Truth & Navigation | Current-truth pointer names P38-era `phase38-49-generate-current-state.md` as "currently" authoritative — superseded this phase by `canonical/current/current-state-20260826.md`; open-work pointers name generated copies rather than the canonical copy; change register pointer names P39 register, now G40-series | MEDIUM — navigation is AGENTS' core function | phase40-75 |
| F-40-05 | Credential Handling | Missing scripting hazard: `$(cat file)` embeds a trailing newline into tokens/Authorization headers and reproduces intermittent 401s (cost a full mystery arc to isolate); strip-whitespace rule should be durable | MEDIUM — recurrence risk across all agents | phase40-41 §3 probes C1/E1 |
| F-40-06 | Required Gates / Repo Map | All referenced commands and paths still exist and execute (see §3) | INFO — no drift | live checks |
| F-40-07 | Known Blockers (accuracy spot-check of already-updated field-fix entry) | Field-fix RESOLVED line accurate (VERIFIED phase40-13); its residual wording "ISM policy-attachment anomaly on 08.26" is now itself stale — attachment corrected to archives-14d (verified via explain) | LOW — absorbed by F-40-01..03 rewrite | phase40-56; live explain |

Not drift: approval-gated list, safety rules, report conventions, out-of-scope, owners —
all remain correct against current reality.

## 3. Mechanical Validations (pre-edit)

```
$ test -x ops/scripts/p38-report-ci.sh           → OK
$ test -x ops/scripts/secret-pattern-scan.sh     → OK
$ test -x ops/scripts/p39-agents-ci.sh           → OK
$ test -f config/shuffle-api-key                 → OK (mode 600)
$ test -f /opt/wazuh-docker/multi-node/ops/creds.env → OK
$ for f in compose/docker-compose.{shuffle,dfir-iris,misp,greenbone,opencanary,velociraptor,phase2}.yml → all exist
$ ls docs/SECRET-HANDLING.md REPO-MAP.md SECURITY.md → all exist
$ p39-agents-ci.sh (pre-edit) → PASS errors=0 warnings=0 (Gate6 scripts + Gate7 docs clean)
```

## 4. Verdict

Six actionable findings (F-40-01…05,07), all pointer/text-level; zero structural or
command-level breakage. Minimal-diff repair specified and applied under CHG-40-AGENTS-01
in phase40-77.
