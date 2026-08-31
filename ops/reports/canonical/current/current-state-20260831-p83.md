# Canonical Current-State — Phase 83 (2026-08-31)

**Live truth for `/opt/mct-security-stack`.** Supersedes `current-state-20260831-p82.md`
and closes the credential-exposure scope (P82-CRED-EXP-001), rotates the OpenSearch
credential under supervision, reduces wildcard authorization, and proves audit continuity
plus two post-rotation Class-A certifications.

**Status: all 9 Phase 83 validators PASS** (inventory, time-anchor, audit, crash, e2e,
exposure, rbac, rotation, repo). Verified after the corpus was completed and the
repository was closed out (see `ops/reports/evidence/phase83/` and
`final-phase83-operator-report-*`).

---

## 1. Stack posture (carried, unchanged)

Wazuh multi-node, Shuffle OSS, IRIS 2.4.29, OTel contrib collector, and the v2 atomic-dedup
+ fail-closed Wazuh→IRIS workflow remain deployed and healthy. Phase 83 changed credentials,
audit config, and RBAC only — all reversible with backups/rollback.

---

## 2. OpenSearch credential rotated under supervision

The OpenSearch credential exposed in Phase 81 (a terminal echo of the Wazuh indexer admin
password) was rotated in Phase 83 via the supported `securityadmin` + admin-certificate path
(approval `P83-OSCRED-ROTATION-APPROVED`). Verified live: old password → 401, new password →
200, indexer cluster GREEN, all consumers (filebeat on master/worker) converged on the new
credential, old grants unchanged. A versioned swarm secret (`opensearch_admin_password_v2`)
and documented rollback (backup + restore) are in place.

- The reserved `shuffle-opensearch` `admin` user could NOT be safely rotated (no usable
  admin-cert path; REST edits forbidden) — it was left untouched and honestly reported (it was
  not the exposed branch).
- Source: `phase83-evidence-rotation.json`.

---

## 3. Audit continuity + hardening enabled

Security audit logging (enabled in Phase 82) was verified continuous through the rotation, and
the hardening that had not persisted was enabled and verified this phase: `AUTHENTICATED`/
`GRANTED_PRIVILEGES` categories on; `audit_viewer` read-only role; 180-day ISM retention +
rollover on `security-auditlog-*`; a failed-login-spike alerting monitor; and an explicit disk
watermark threshold so audit cannot exhaust disk. All 14 audit properties verified live.
- Source: `phase83-evidence-audit.json`.

---

## 4. Exposure incident P82-CRED-EXP-001 CLOSED

Both exposed branches are `rotated_revoked`: `iris_api_key` (rotated Phase 82) and
`opensearch_admin_password` (rotated Phase 83). Incident status = closed; scans were
value-blind (no secret value in any artifact). `credential_value_absent` confirmed.
- Source: `phase83-evidence-exposure.json`.

---

## 5. RBAC — `readall` wildcard reduced

A least-privilege role `soc_least_priv` (explicit index patterns, no `*`, no cluster admin)
was created and verified (denied on unrelated indexes, cluster-admin, and the security index).
`readall` is reserved/static at the role level, so it was reduced at the **mapping** layer
(removed the `backend_role: readall` catch-all) and the residual grant is exception-governed
with expiry **2026-09-30**. Inventory of `readall` mappings recorded.
- Source: `phase83-evidence-rbac.json`.

---

## 6. Two post-rotation Class-A certifications (E2E)

Two independent end-to-end Wazuh→IRIS writes via the Shuffle action task
(`request_executor = shuffle_action_task`) were created (IRIS objects **688** and **689**) and
each read back via REST GET returning **200**, with the unique marker matched between write and
read. This proves the pipeline works after the Phase 83 OpenSearch credential rotation.
- Source: `phase83-evidence-e2e.json` (`certification_one`, `certification_two`).

---

## 7. Literal crash — honest modeled result

Per the Phase 81/82 honesty standard, no literal process crash was executed: this shared
environment has no safe isolated lane (the pipeline uses a shared v2 webhook/action task). The
crash-after-accept scenario was therefore **modeled** on isolated synthetic data; the report
states this explicitly and does not claim a literal crash. Historical objects 192/193 remain a
documented unfixed duplicate failure.
- Source: `phase83-evidence-crash.json`.

---

## 8. Repository closeout

- Commit: see `phase83-evidence-repo.json` (`commit_id`).
- `heads_equal = true`, `push_success = true`, `clean_tree = true` (stray untracked files
  adjudicated not committed).
- `canonical_sha256` = sha256 of this document; `manifest_sha256` = sha256 of
  `ops/reports/evidence/phase83/evidence-manifest.json`.
- `rollback_identities`: `d56928f` (p78), `db7d42c` (p79), `845f054d` (p80),
  `51b6acc` (p81), `ac4e30f` (p82), and the new Phase 83 commit.

---

## 9. Open / Gated (NO-GO without operator sign-off) & caveats

- **Phase 83 terminal echo (minor):** during the RBAC step a fragment of the *already-revoked*
  old indexer admin password was echoed to the agent's terminal from its backup file. No secret
  value was written to any report, evidence JSON, or committed artifact; the credential was
  already revoked, so exposure is low. A precautionary re-rotation is optional. (This is a
  separate, low-severity event from P82-CRED-EXP-001, which is closed.)
- `readall` exception expires 2026-09-30 — schedule review/removal.
- The reserved `shuffle-opensearch` admin remains un-rotated (not the exposed branch; rotation
  was unsafe). Monitor.
- Production alert routing, full-system restore rehearsal, other credential rotations, ISM/index
  intervention, and recreate-to-deploy remain operator-sign-off gated.
- Historical objects 192/193 remain a documented unfixed duplicate failure.

---

## 10. Evidence catalog (Phase 83)

- `ops/reports/evidence/phase83/phase83-evidence-rotation.json`
- `ops/reports/evidence/phase83/phase83-evidence-audit.json`
- `ops/reports/evidence/phase83/phase83-evidence-exposure.json`
- `ops/reports/evidence/phase83/phase83-evidence-rbac.json`
- `ops/reports/evidence/phase83/phase83-evidence-e2e.json`
- `ops/reports/evidence/phase83/phase83-evidence-crash.json`
- `ops/reports/evidence/phase83/phase83-evidence-repo.json`
- `ops/reports/evidence/phase83/evidence-manifest.json`
- Corpus: `ops/reports/generated/phase83/` (920 reports).
