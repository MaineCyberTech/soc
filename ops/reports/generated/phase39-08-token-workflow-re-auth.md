# Phase 39 Workflow Re-Authentication Proof — REA-39-01

**Report ID:** phase39-08-token-workflow-re-auth  
**Phase:** 39  
**Title:** REA-39-01 — Post-Rotation Verification That Workflows Authenticate Outbound With the IRIS Bearer (Not the Rotated Shuffle Bearer)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:31:00Z  
**Classification:** INTERNAL  
**Status:** PASS  
**Record ID:** REA-39-01  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-08-token-workflow-re-auth.md`  

---

## 1. Claim Under Test

> The Shuffle bearer rotation (ROT-39-01) does not degrade workflow delivery, because
> workflow HTTP actions authenticate OUTBOUND to IRIS with the IRIS bearer; and both
> workflows' action configs are valid post-rotation, proven by three consecutive real
> deliveries finishing with IRIS HTTP 200.

## 2. Direction-of-Trust Analysis

| Flow | Credential | Stored where | Rotation impact |
|---|---|---|---|
| Operator → Shuffle API/UI | password + browser session | Shuffle user store | NONE (password unchanged) |
| Ops scripts → Shuffle API | `[REDACTED-SHUFFLE-TOKEN]` (new) | `.env` / key file | re-synced via .env |
| Workflow HTTP action → IRIS alerts API | IRIS bearer `[REDACTED-IRIS-TOKEN]` | workflow action parameter (header JSON) | NONE from ROT-39-01; repaired earlier same window (G6) |
| Shuffle engine → its own datastore/queue | internal service trust | engine-internal | NONE observed |

Conclusion: no workflow outbound path consumes the rotated Shuffle admin bearer, so
rotation cannot break delivery. This is verified structurally here AND empirically in §4.

## 3. Action Config Verification (post-rotation, post-G6)

Both workflows' HTTP action header parameters inspected in the ops window:

| Workflow | Header param state pre-window | Post-state |
|---|---|---|
| high-severity→IRIS | INVALID JSON — `{"Authorization <REDACTED>, "Content-Type": "application/json"}` (literal placeholder string injected inside the live parameter by an earlier redaction error) | VALID JSON: `{"Authorization": "Bearer [token]", "Content-Type": "application/json"}`; body placeholders unescaped (`\${body:` → `${body:`) |
| classb flow→IRIS | valid but value sourced from leak-location recovery | VALID; execution-proven |

Governance note repeated for the record: the corruption existed because a prior phase
redacted INSIDE a live runtime parameter. Redaction must only ever touch documents.

## 4. Empirical Proof — Three Consecutive Real Deliveries

Executions driven in the ops window after G5 (DNS fix) + G6 (header repair):

| Execution ID | Workflow family | Terminal status | Downstream result |
|---|---|---|---|
| `53e2e193…` | classb flow | FINISHED | IRIS HTTP 200 |
| `ab14f34c…` | classb flow | FINISHED | IRIS HTTP 200 |
| `413c137a…` | high-severity | FINISHED | IRIS HTTP 200 |

IRIS DB cross-check (operator-state): alerts **37, 38, 39** created
**2026-08-25 22:08:24Z**, title pattern "Wazuh flow alert (Class A)" — one persisted
alert per successful action call, closing the loop end-to-end (engine → action → IRIS).

Historical continuity note: IRIS alerts 34–35 prove deliveries also worked on Aug-15,
i.e., the chain was healthy BEFORE the header corruption window; today's run proves it
is healthy again AFTER repair+rotation. The fault was introduced and removed inside
the P37–P39 interval.

These three executions double as the bounded healthcheck required by the rotation
runbook (REA step): no dedicated synthetic replay needed this cycle because real
traffic provided consecutive successes.

## 5. Why This Doubles as Re-Auth Proof

The runbook requires proving that anything holding a copy of the OLD token still works
after rotation. Enumeration (§2) shows workflows hold NO copy of the old Shuffle
bearer; therefore the correct proof is (a) structural absence (this report §2–§3) plus
(b) continued healthy operation of the credential they DO hold (§4). Both provided.

Operator UI session independence is additionally confirmed: password-based sessions
were functional immediately post-restart (INV-39-01 §5 corroboration).

## 6. Limitations

- Three executions is a bounded sample; it satisfies the "consecutive deliveries"
  bound set by the arc plan, not a soak test. Soak coverage exists separately via the
  periodic delivery path if enabled.
- Alert IDs cited from operator DB query; raw query output retained in ops logs
  (contains no secrets), not duplicated here.

## 8. Config Delta Representation (document-form only)

Pre-corruption (working chain, historical):

```json
{"Authorization": "Bearer [REDACTED-IRIS-TOKEN]", "Content-Type": "application/json"}
```

Corrupted intermediate (INC root cause #2 — placeholder injected INSIDE live param):

```json
{"Authorization <REDACTED>, "Content-Type": "application/json"}
```

Restored (current live params):

```json
{"Authorization": "Bearer [token]", "Content-Type": "application/json"}
```

Body placeholder escape fix applied alongside: `\${body:` → `${body:` so Shuffle
expression interpolation resolves at runtime instead of emitting literal escapes.

## 9. Execution-to-Alert Reconciliation

| Execution | Terminal status | Expected alert | Observed in IRIS DB | Match |
|---|---|---|---|---|
| 53e2e193… | FINISHED / action HTTP 200 | new Class A alert | yes (37/38/39 set @ 22:08:24Z) | ✓ |
| ab14f34c… | FINISHED / action HTTP 200 | new Class A alert | yes | ✓ |
| 413c137a… | FINISHED / action HTTP 200 | new Class A alert | yes | ✓ |

Title normalization ("Wazuh flow alert (Class A)") matches the classb flow template,
confirming the repaired body placeholders interpolated correctly end-to-end.

## 10. Runbook Mapping

This report satisfies the following runbook steps for any future credential rotation:

- R-step "enumerate what else authenticates with this credential" → §2 table.
- R-step "bounded healthcheck post-change" → §4 three-consecutive rule.
- R-step "prove no collateral breakage" → UI login + executions + frontend probes
  (INV §5 corroboration).

## Appendix A — Direction-of-Trust FAQ

**Q: Why doesn't the Shuffle engine need its own admin token to run workflows?**
A: Engine components trust the datastore/orchestration plane internally; user API keys
gate external API access, not internal execution. Hence rotating the admin bearer has
no engine-internal effect — consistent with §4's uninterrupted FINISHED executions.

**Q: Could any workflow hold a hard-coded copy of the OLD admin bearer from early
prototyping?**
A: Sweeped: both live workflows' parameters contain only IRIS-bound headers; export
files were swept for the old-token prefix family with zero hits. Historical execution
records store request/response snapshots — those were redacted in RED-39-03/04.

**Q: Does IRIS need to know about the Shuffle rotation?**
A: No. The IRIS↔Shuffle relationship authenticates Shuffle→IRIS via the IRIS bearer;
IRIS never sees the Shuffle credential.

## Appendix B — Pre-Corruption Historical Continuity

| Date | Evidence | Meaning |
|---|---|---|
| Aug-15 | IRIS alerts 34–35 ("Wazuh flow alert" family) | chain worked before corruption era |
| Aug-25 22:08Z | alerts 37–39 post-repair | chain works again |
| between | corrupted header JSON → silent delivery stop | fault bounded to P37–P39 interval |

This bounding matters for incident reporting: no evidence deliveries failed due to
credential invalidity at ANY point — the outage was structural (bad header JSON), not
auth-related.

## Appendix C — Residual Watch Items

| Item | Owner | Trigger |
|---|---|---|
| IRIS bearer own-rotation (value historically disclosed) | P40 ROT candidate | scheduled |
| Soak-length healthcheck (>3 executions) | periodic ops | next monthly cycle |
| Add outbound-auth check to periodic repair script | P40 backlog | automation pass |

## 11. Verdict

**PASS.** Structural analysis + config inspection + three FINISHED executions with
IRIS 200 and matching DB rows prove workflows re-authenticate correctly outbound and
were untouched by the Shuffle bearer rotation.
