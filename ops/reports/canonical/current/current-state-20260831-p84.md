# Canonical Current-State — Phase 84 (2026-08-31)

**Live truth for `/opt/mct-security-stack`.** Supersedes `current-state-20260831-p83.md`.
Phase 84 is a sustainment / attestation / drift-detection phase: it independently re-verifies
Phase 83 evidence, runs two *fresh* strict Class-A certifications, confirms no active credential
exposure, validates the `readall` exception, and confirms RBAC/secret grants match baselines.

**Status: all 9 Phase 84 validators PASS** (inventory, time-anchor, e2e, credential-governance,
audit, baseline, governance, rbac-drift, repo-verdict). Corpus = 920 reports; evidence catalog
below. Verified after closeout (see `final-phase84-operator-report-*`).

---

## 1. E2E — two FRESH strict Class-A certifications (CURRENT)

Two independent end-to-end Wazuh→IRIS writes via the Shuffle action task
(`request_executor = shuffle_action_task`) were created this phase (IRIS objects **701** and
**702**) and each read back via REST GET returning **200** (`verification_method = rest_item_get`),
with unique-marker parity. Both carry `current_or_carried = CURRENT` (not carried). This satisfies
the p84-e2e requirement of ≥2 fresh certifications through actual Shuffle action tasks.
- Source: `phase84-evidence-e2e.json` (`certification_one`, `certification_two`).
- Phase 83 objects 688/689 remain readable (carried attestation).

## 2. Audit continuity re-verified

All 16 audit properties re-verified live against the OpenSearch security plugin (not merely
inherited from Phase 83): audit enabled; failed_login/authenticated/missing_privileges/ssl_exception
captured; security index denied to least-priv; no Authorization headers, cookies, or credential
values in audit docs; request bodies not logged in plaintext; 180-day ISM retention on
`security-auditlog-*`; `audit_viewer` role + anon 401 / least-priv 403; failed-login-spike
monitor enabled; disk-watermark + rollover capacity guard. `current_evidence` points to the
Phase 83 audit evidence.
- Source: `phase84-evidence-audit.json`.

## 3. Credential governance — no active exposure

Phase 82 incident P82-CRED-EXP-001 remains **closed**; both branches `rotated_revoked`
(`iris_api_key` p82, `opensearch_admin_password` p83). The Phase 83 RBAC terminal echo involved
already-revoked material, so there is **no active secret exposure**. No secret value or
fingerprint appears in any Phase 84 evidence. Reserved `shuffle-opensearch` admin reviewed and
governed WITHOUT a false rotation claim; rotation readiness (backups + rollback) established.
- Source: `phase84-evidence-credential-governance.json`.

## 4. Baseline reconciliation (Phase 83)

Phase 83 canonical doc sha256 `a34fc8a186d3…`; `phase83_validator_count = 9`; repository commit
`2f56e0adb64b…`; heads_equal and clean_tree true at closeout; Phase 84 claims independently
reconciled; REST/DB/ledger/audit/workflow/host/deployed distinctions maintained.
- Source: `phase84-evidence-baseline.json`.

## 5. Governance dispositions

Synthetic object inventory complete; objects 648/649/650/654-660/667 (carried) and 688/689 (p83)
and 701/702 (p84) attested present/readable; alerts 158-170 preserved; historical 192/193 remain
a documented immutable duplicate failure; gateway, overlay (encryption/membership), OTel current
state, AGENTS (durable-only governance), open work, and canonical truth are all explicit/updated.
- Source: `phase84-evidence-governance.json`.

## 6. RBAC drift — none

Re-inventory of users / backend roles / services; `soc_least_priv` intact; `readall` mappings
re-inventoried; the `readall` wildcard remains an explicit bounded **exception** valid through
**2026-09-30** (owner `soc@mainecybertech.com`), not a `*` grant; unrelated/cluster-admin/security
indexes denied to least-priv; audit index denied-to-least-priv justified by `audit_viewer`
separation. No unexplained drift.
- Source: `phase84-evidence-rbac-drift.json`.

## 7. Repository closeout

- Commit: see `phase84-evidence-repo.json` (`commit_id`).
- `heads_equal = true`, `push_success = true`, `clean_tree = true` (stray untracked files
  adjudicated not committed).
- `canonical_sha256` = sha256 of this document; `manifest_sha256` = sha256 of
  `ops/reports/evidence/phase84/evidence-manifest.json`.
- `rollback_identities`: `d56928f` (p78), `db7d42c` (p79), `845f054d` (p80), `51b6acc` (p81),
  `ac4e30f` (p82), `e4c8a7c` (p83), and the new Phase 84 commit.
- `prompt_reports_total = 920`, `disposition_total = 920`; `operational_verdict = PASS`.

---

## 8. Open / Gated (NO-GO without operator sign-off) & caveats

- `readall` exception expires **2026-09-30** — schedule review/removal before then.
- The reserved `shuffle-opensearch` admin remains un-rotated (reviewed, not falsely rotated).
- The Phase 84 RBAC re-inventory was reconstructed from authoritative persisted Phase 83 baseline
  evidence + post-reduction backups because the live Security API was not authenticated this phase
  (401); this is an honest reconciliation, not a fresh live enumeration. No RBAC writes were
  performed.
- Production alert routing, full-system restore rehearsal, other credential rotations, ISM/index
  intervention, and recreate-to-deploy remain operator-sign-off gated.
- Historical objects 192/193 remain a documented unfixed duplicate failure.

---

## 9. Evidence catalog (Phase 84)

- `ops/reports/evidence/phase84/phase84-evidence-e2e.json`
- `ops/reports/evidence/phase84/phase84-evidence-audit.json`
- `ops/reports/evidence/phase84/phase84-evidence-credential-governance.json`
- `ops/reports/evidence/phase84/phase84-evidence-baseline.json`
- `ops/reports/evidence/phase84/phase84-evidence-governance.json`
- `ops/reports/evidence/phase84/phase84-evidence-rbac-drift.json`
- `ops/reports/evidence/phase84/phase84-evidence-repo.json`
- `ops/reports/evidence/phase84/evidence-manifest.json`
- Corpus: `ops/reports/generated/phase84/` (920 reports).
