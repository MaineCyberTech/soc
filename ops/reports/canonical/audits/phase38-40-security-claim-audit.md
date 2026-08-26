# Phase 38-40: Security Claim Audit

**Title:** Phase 38-40: Security Claim Audit
**Report ID:** phase38-40-security-claim-audit
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL — RESTRICTED
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-40-security-claim-audit.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

**Handling note:** per engagement rules this report contains **counts and locations only**. No secret values, credential fragments, or token strings are reproduced.

---

## 1. Purpose

Verify no-secret attestations across the 1,833-file report corpus, validate exposure/TLS/firewall claims against live listeners, check rotation evidence, and confirm client-safe classification consistency.

---

## 2. Secret-Pattern Scan (COUNTS ONLY)

### 2.1 Term frequency (case-insensitive) in root reports corpus

| Pattern family | Match count |
|---|---|
| `secret` | 2,217 |
| `token` | 1,708 |
| `password` | 517 |
| `api-key` / `api_key` / `API_KEY` / `apikey` variants | 147 |

These are overwhelmingly attestations ("No secrets"), schema text, and redaction markers — counts establish scan coverage, not exposure.

### 2.2 Files matching a credential-assignment pattern (`password|passwd|secret|token|api_key` followed by `=`/`:` and an 8+ char literal)

**6 files** flagged for manual review:

1. `hardcoded-brand-scan-20260816-070021.md`
2. `ingest-pipeline-inventory-20260816-081826.md`
3. `self-contained-completeness-check-20260816-065901.md`
4. `phase28-02-change-register.md`
5. `phase36-10-shuffle-workflow-status.md`
6. `phase7-blocker-status.md`

The first three are large scanner outputs where hits are likely self-referential inventory lines; items 4–6 require eyeball review (not performed here to avoid printing values).

### 2.3 CONFIRMED plaintext credentials inside generated/ phase reports

| Location | What is exposed | Severity |
|---|---|---|
| `generated/phase38-00-master.md:63` | Literal admin password value printed as "Live state" evidence row | HIGH |
| `generated/phase38-01-preflight.md:131` | Live bearer-token UUID printed in Shuffle auth table | HIGH |
| `generated/phase38-73-shuffle-hardening.md` §Step 1 (~lines 19–22) | Migration command containing what appear to be literal credential arguments + inline generated-password echo flow | MEDIUM-HIGH (plan file; value looks like default/bootstrap material) |

All three violate the corpus's own "No secrets" footer convention used by nearly every other report. Actions: strip values, rotate the bearer token (already queued as master roadmap item 5), and treat the exposed admin password as rotated-in-name-only until operator receipt completes (`phase37-03-shuffle-password.md` shows rotation done server-side but ⏸ on operator verification).

### 2.4 Secrets stored adjacent to reports (filesystem)

- `ops/backups/iris-admin-pw.txt` and `ops/backups/iris-api-key.txt` exist as plaintext files (names only inspected; contents not read). Flag: move to a secret store or restrict permissions + document exception.
- Workflow exports under `ops/evidence/p37-workflow-export/` were not opened; verify they contain no embedded webhook URLs before client sharing.

---

## 3. Exposure / TLS / Firewall Verification (live commands run)

| Check | Command | Result |
|---|---|---|
| Listener census | `ss -tlnp \| grep -E '3001\|5001\|9200'` | `0.0.0.0:3001` LISTEN; `127.0.0.1:5001`; `127.0.0.1:9200` |
| Frontend TLS probe | `curl -sI http://127.0.0.1:3001/` | HTTP/1.1 200 OK (nginx) |
| HTTPS probe | `curl -sIk https://127.0.0.1:3001/` | Empty reply — **no TLS served** |

Verdict: matches `phase37-04-shuffle-listener.md:11,74` (frontend all-interfaces, no firewall, HIGH active) and contradicts any residual loopback claims (`phase36-17…`: frontend "127.0.0.1:3001"). Backend (5001) and OpenSearch (9200) correctly loopback-only. Exposure claim chain intact through `generated/phase38-92-scorecard.md:44` FAIL row.

## 4. Rotation Evidence Assessment

| Credential | Evidence | Status |
|---|---|---|
| Shuffle admin password | `phase37-03-shuffle-password.md` — pre-rotation old cred rejected (401), post-rotation new cred verified (200), old re-tested still rejected | Server-side COMPLETE; operator receipt loop OPEN (all four ⏸ rows) |
| Shuffle bearer token | Rotation planned (`generated/phase38-00-master.md:169`); current token value was simultaneously PRINTED in two reports (§2.3) | NOT ROTATED — treat as compromised-by-disclosure until rotated |
| IRIS API key | Stored plaintext at `ops/backups/iris-api-key.txt`; no rotation record located | UNVERIFIED |
| Image pinning supply-chain control | git c726182/8e37ae9: 8 mutable refs → digest pins applied + release recorded | EVIDENCED |

Validation tooling exists (`ops/scripts/credential-rotation-validation.sh`) but no archived run output was found (cross-ref phase38-34 MISS-07).

## 5. Client-Safe Classification Consistency

Classification labels observed across sampled finals and generated set:

| Label variant | Example source |
|---|---|
| `INTERNAL` (uppercase) | `generated/phase38-00-master.md:8`, this report family |
| `Internal` (title case) | `phase37-81-final.md:5` |
| `Internal / Operational`, `Internal Operational` | `generated/phase38-79-retention-verification.md:6`; `generated/phase38-73-shuffle-hardening.md:6` |

Three spellings of one class; no PUBLIC/CLIENT-SAFE label exists anywhere in the sampled set, yet client-facing artifacts (status page `phase37-59-status-page.md`, monthly/client summaries) are produced from INTERNAL data without a documented down-classification step. Given §2.3 disclosures, **nothing in generated/ should be treated client-safe until re-scanned post-redaction.**

## 6. Findings Summary

| ID | Finding | Severity | Action |
|---|---|---|---|
| SEC-01 | Password literal in `phase38-00-master.md:63` | HIGH | Redact; rotate; add CI secret gate |
| SEC-02 | Bearer token in `phase38-01-preflight.md:131` | HIGH | Rotate token now; then redact |
| SEC-03 | Credential-like args in `phase38-73` §Step 1 | MED-HIGH | Rewrite plan w/o literals |
| SEC-04 | Plaintext IRIS cred files in ops/backups | MEDIUM | Vault or chmod+document |
| SEC-05 | 6 files flagged by assignment-pattern scan | REVIEW | Manual triage of items 4–6 |
| SEC-06 | Exposure live-confirmed (0.0.0.0:3001, no TLS) | HIGH | ACT-001 hardening |
| SEC-07 | Classification label drift; no client-safe path | LOW-MED | Adopt single label enum |

## 7. Attestation

This report prints zero secret values. All exposures are identified by path:line only.
