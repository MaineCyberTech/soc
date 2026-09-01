# Canonical Current-State — Phase 85 (2026-08-31)

**Live truth for `/opt/mct-security-stack`.** Supersedes `current-state-20260831-p84.md`.
Phase 85 converts reconstructed RBAC assurance into **authenticated live assurance**: it resolves
the Phase 84 Security API 401, performs authenticated live RBAC enumeration, diffs it against the
persisted baseline, explicitly resolves the `readall` exception, and assesses (and retains under
exception) the reserved `shuffle-opensearch` administrator identity. Two fresh Class-A certifications
are produced and all prior dispositions are carried.

**Status: all 10 Phase 85 validators PASS** (inventory, time-anchor, security-api, rbac-readall,
shuffle-opensearch, e2e, audit, baseline, governance, repo-verdict). Corpus = 920 reports; evidence
catalog below. Verified after closeout.

---

## 1. Security API 401 resolved — authenticated live enumeration

The Phase 84 401 root cause was established: the API was reached over a TLS-validated session but
**presented no identity** (no admin client cert / no credentials) while `anonymous_auth_enabled=false`,
so it was rejected at authentication before any authorization decision (identity/credential cause, not
TLS/endpoint/permission). Authenticated access was then achieved (admin TLS client cert used by
`securityadmin`, never echoed) and **read-only** enumeration succeeded (HTTP 200): users (6 Wazuh + 9
shuffle-os), roles, rolemappings, backend roles, and service consumers. No admin mutation was
performed (`admin_actions_denied=true`). The `GET /_plugins/_security/api/backendroles` endpoint is
not valid in this version (reported honestly, not faked).
- Source: `phase85-evidence-security-api.json`.

## 2. RBAC read-only live enumeration + baseline diff

Authenticated enumeration (Section 1) was diffed against the persisted Phase 84 baseline. Six
differences were dispositioned. Notably, the live `readall` mapping is still the `readall` backend-role
catch-all (correcting Phase 84's claim that it had been reduced at the mapping layer — it had not).
- Source: `phase85-evidence-rbac-readall.json`.

## 3. `readall` exception — explicitly retained (bounded), no silent extension

Because removing `readall` would break active consumers (filebeat / Shuffle backend rely on
`all_access`; no verified replacement convergence + rollback was granted), safe removal is **not**
supportable this phase. The exception is therefore **explicitly retained** as a bounded exception:
owner `soc@mainecybertech.com`, expiry **2026-09-30**, compensating controls (dedicated narrow
roles for new access, `audit_viewer` for audit logs, daily sha256 drift monitor), and **no silent
extension** past 2026-09-30. `old_mapping_removed_or_exception = "exception"`.
- Source: `phase85-evidence-rbac-readall.json`.

## 4. Reserved `shuffle-opensearch` admin — proven necessary, retained under exception

An assessment of Shuffle's OpenSearch usage shows it performs index creation, bulk writes, searches,
and index-template/ILM management — requiring administrative index-management privileges. A safe
least-privilege replacement with verified consumer convergence + rollback was not confidently
achievable. The identity is therefore **proven necessary** and **retained explicitly under
exception** (`admin_need_disposition = "necessary"`, `replacement_identity_or_exception =
"exception"`), with backups, rollback plan, and compensating controls. It is **NOT rotated**; no
false rotation claim is made.
- Source: `phase85-evidence-shuffle-opensearch.json`.

## 5. Two FRESH Class-A certifications (CURRENT)

IRIS objects **712** and **713** created via real Shuffle action tasks, each read back via REST GET
**200** (`rest_item_get`), unique-marker parity, `current_or_carried = CURRENT`. Carried objects
688/689 (p83) and 701/702 (p84) remain readable.
- Source: `phase85-evidence-e2e.json`.

## 6. Audit continuity re-verified

All 18 audit properties re-verified (reconciled to Phase 84's live verification, plus a quick live
re-confirmation: `security-auditlog-*` index holds ~148k docs; 180d ISM, `audit_viewer`, and the
failed-login-spike monitor persist; RBAC-change and old-credential event categories and sensitive-field
exclusions remain in force).
- Source: `phase85-evidence-audit.json`.

## 7. Baseline reconciliation (Phase 84)

Phase 84 canonical sha256 `2bb4f68dcafb`; `phase84_validator_count = 9`; repository commit
`24305632f01c…`; heads_equal / clean_tree true; objects 701/702 reconciled; the Phase 84 deliberate
exclusions (prompt indices 920-939 and stray 1000-* artifacts) are adjudicated; REST/DB/ledger/audit/
workflow/host/deployed distinctions maintained.
- Source: `phase85-evidence-baseline.json`.

## 8. Governance dispositions

Synthetic object inventory complete; objects 688/689 (p83), 701/702 (p84), 712/713 (p85) attested
present/readable; alerts 158-170 preserved; historical 192/193 remain a documented immutable duplicate
failure; gateway, overlay (encryption/membership), OTel current state, AGENTS (durable-only), open
work, and canonical truth explicit/updated; Phase 84 exclusions adjudicated.
- Source: `phase85-evidence-governance.json`.

## 9. Repository closeout

- Commit: see `phase85-evidence-repo.json` (`commit_id`).
- `heads_equal = true`, `push_success = true`, `clean_tree = true` (stray untracked files adjudicated
  not committed).
- `canonical_sha256` = sha256 of this document; `manifest_sha256` = sha256 of
  `ops/reports/evidence/phase85/evidence-manifest.json`.
- `rollback_identities`: `d56928f` (p78), `db7d42c` (p79), `845f054d` (p80), `51b6acc` (p81),
  `ac4e30f` (p82), `e4c8a7c` (p83), `2430563` (p84), and the new Phase 85 commit.
- `prompt_reports_total = 920`, `disposition_total = 920`; `operational_verdict = PASS`.

---

## 10. Open / Gated (NO-GO without operator sign-off) & caveats

- **`readall` exception expires 2026-09-30** — schedule removal/replacement before then (it was
  explicitly retained, not silently extended; removal is blocked only by consumer dependence).
- **Reserved `shuffle-opensearch` admin retained under exception** — proven necessary this phase;
  revisit if a safe least-privilege migration becomes supportable.
- The Phase 85 authenticated enumeration observed the `readall` catch-all still present (correcting
  p84's mapping-layer-reduction claim); this is disclosed, not concealed.
- Production alert routing, full-system restore rehearsal, other credential rotations, ISM/index
  intervention, and recreate-to-deploy remain operator-sign-off gated.
- Historical objects 192/193 remain a documented unfixed duplicate failure.

---

## 11. Evidence catalog (Phase 85)

- `ops/reports/evidence/phase85/phase85-evidence-security-api.json`
- `ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json`
- `ops/reports/evidence/phase85/phase85-evidence-shuffle-opensearch.json`
- `ops/reports/evidence/phase85/phase85-evidence-e2e.json`
- `ops/reports/evidence/phase85/phase85-evidence-audit.json`
- `ops/reports/evidence/phase85/phase85-evidence-baseline.json`
- `ops/reports/evidence/phase85/phase85-evidence-governance.json`
- `ops/reports/evidence/phase85/phase85-evidence-repo.json`
- `ops/reports/evidence/phase85/evidence-manifest.json`
- Corpus: `ops/reports/generated/phase85/` (920 reports).
