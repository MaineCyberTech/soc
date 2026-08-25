# Phase 38-29 — Deployability Claim Verification

**Report ID:** phase38-29-deployability-claim-verification
**Phase:** 38
**Title:** Phase 38-29 — Deployability Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-29-deployability-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:40 UTC
**Scope:** Verify PARTIAL/PASS/NO-GO deployability claims, clean-target/restore evidence, blockers, RTO/RPO, and runtime-proof statements.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | Overall deployability = PARTIAL | **VERIFIED** | phase37-78 header |
| 2 | Full-cluster deployability = NO-GO | **VERIFIED** (and independently re-supported) | phase37-78 + live cross-checks |
| 3 | Blockers: no isolated target; Shuffle exposure; field errors; no Wazuh→Shuffle integration | **MIXED** — 2 VERIFIED, 1 VERIFIED-worse, 1 CONTRADICTED | see below |
| 4 | Clean-target / fresh-target evidence exists (code/config gates PASS) | **VERIFIED (gates)** — target itself absent | P28/P30 reports + p29-fresh-target-smoke.sh |
| 5 | Rollback tested | **UNVERIFIED** | matrix says No; no contrary artifact |
| 6 | RTO/RPO figures | **UNVERIFIED (absent)** | grep in phase37-78 returns nothing |
| 7 | Runtime proof claims overstated? | **PARTIAL CONFIRMED** | "fresh-target/full-cluster chains remain gated as before" (P30) — proof limited to gates, not execution |

---

## Evidence Detail

### 1–2. Statuses
```
$ cat ops/reports/phase37-78-deployability.md
## Overall Status: PARTIAL
Full-cluster deployability: **NO-GO**
...
**Result: NO-GO** — Full-cluster deployment not recommended until blockers resolved.
```
Both headline statuses match the claimed state. **VERIFIED.**

### 3. Blocker-by-blocker against tonight's live data

| Blocker (P37-78) | Live finding this session | Verdict on blocker claim |
|---|---|---|
| Shuffle exposure unhardened (HIGH) | `ss`: frontend 0.0.0.0:3001 plaintext; https→000, http→200 | **VERIFIED** |
| Field errors unresolved (HIGH) | 4491 indexer-rejection errors last 30 min (~150/min); ongoing; misattributed fix (see phase38-25) | **VERIFIED — and worse than stated** |
| No adequate isolated target (HIGH) | No target host/artifacts found (`p29-fresh-target-smoke.sh` present but only gate-level PASS references in P28/P30) | **VERIFIED** |
| No Wazuh→Shuffle integration (MEDIUM) | Two routing workflows exist & execute with real payloads (phase38-23); delivery-to-IRIS unproven but "no integration" is false as absolute | **CONTRADICTED as absolute** — downgrade to "integration present but delivery assurance incomplete" |

The NO-GO conclusion survives even after correcting the fourth blocker: three HIGH items remain live.

### Deployability matrix spot-check
```
Matrix rows vs reality:
Wazuh cluster Yes        → GREEN, 274 shards, health FAIL count 0      ✓ consistent
Shuffle stack Partial    → functional+authed but exposed               ✓ consistent
ISM policy attached      → wazuh-archives-14d attached                 ✓ consistent
Field config staged      → decoder_order_size=512 staged, not effective for the observed error class ✓ consistent
Routing: "No / Not implemented" → contradicted by live workflows       ✗ stale row
Packet workflow: design-only → routing wf exists w/ 1 exec             ✗ partially stale
```

### 4–7. Restore/runtime/RTO-RPO specifics
```
$ grep -n -iE "rto|rpo" ops/reports/phase37-78-deployability.md
(no output)                        ← RTO/RPO never quantified in the current assessment

$ grep -rlE "fresh.target|runtime proof" ops/reports/phase30-*.md
phase30-21-v130-source-truth.md
phase30-76-deployability-portability-audit.md
phase30-93-deployability-cert.md
$ sed -n relevant lines:
P28: "fresh-target dry-run caught a real [issue]"; "code/config gates PASS";
     exact blockers recorded (no isolated target)
P30: "the fresh-target/full-cluster chains remain gated as before"
```
Runtime proof exists at gate level only (syntax/layout/pin/mode checks pass; smoke script shipped), while an actual clean-target bring-up has never been executed — consistent with the "overstated runtime proof" concern: language implying exercised runtime should be read as *gate-passed, not run*. Additionally, tonight's snapshot-repository check (`_cat/snapshots/*` → repository_missing_exception) removes a key restore capability that any full-cluster restore plan would rely on — reinforcing NO-GO and making restore-time objectives unmeasurable. Rollback: matrix self-declares "Rollback tested: No"; no contradicting evidence found.

### Independent corroboration of NO-GO inputs (live, this session)
- Cluster GREEN but disk 83 % across all indexers, ~24.6 GB free.
- ~150/min sustained indexing failures into archives indices.
- No snapshot repository registered.
- Frontend exposed cleartext on LAN IP 192.168.222.149.

---

## Verification Commands Used
```bash
grep -rl "deployability" ops/reports/phase37-*.md          # → phase37-78 only
cat ops/reports/phase37-78-deployability.md
grep -rn -iE "rto|rpo|clean.target|fresh|rollback" ops/reports/phase37-78-deployability.md
grep -rln -iE "runtime proof|fresh.target" ops/reports/phase30-*.md
sed -n '1,80p' ops/reports/final-phase28-operator-report-20260824-184100.md
sed -n '1,20p' ops/reports/final-phase30-operator-report-20260824-220404.md
ls ops/scripts/p29-fresh-target-smoke.sh ops/scripts/p29-deploy-evidence-pack.sh
# live cross-checks: ss/curl (Shuffle), docker logs counts (field errors),
# curl _cat/snapshots, _cat/allocation, agent_control -l
```

## Summary
The PARTIAL / NO-GO pair is accurate and remains correct under independent re-testing tonight — arguably stronger, given the field-error rate is higher than recorded and no snapshot repo exists for restore. One blocker needs rewriting (integration now demonstrably exists in firing form), one matrix row is stale (routing "Not implemented"), and the document's biggest omission is any RTO/RPO quantification. Treat all "runtime proof" language as CI-gate-passed, never executed-on-clean-target.

## No secrets
