# Canonical Current-State — Phase 82 (2026-08-31)

**Live truth for `/opt/mct-security-stack`.** Supersedes `current-state-20260831-p81.md`
and corrects the IRIS REST read-back credential drift (OW-66-01) and closes the
Phase 81 terminal-credential-exposure incident.

**Status: all 8 Phase 82 validators PASS** (inventory, time-anchor, audit, exposure,
provenance, readback, rotation, repo). Verified after the corpus was completed and the
repository was closed out (see `ops/reports/evidence/phase82/` and
`final-phase82-operator-report-*`).

---

## 1. Stack posture (carried, unchanged)

Wazuh multi-node, Shuffle OSS, IRIS 2.4.29, OTel contrib collector, and the v2 atomic-dedup
+ fail-closed Wazuh→IRIS workflow remain deployed and healthy. Phase 82 did not alter the
data path except to rotate the IRIS API key (see §4) and enable OpenSearch audit logging (§5).

---

## 2. IRIS REST read-back restored (fixes OW-66-01)

Phase 81 could not perform an exact IRIS REST item GET (returned 401 — credential drift:
POST worked, GET was rejected). Phase 82 established a correctly-scoped **read** API key for
the `iris-shuffle-dedicated` identity (IRIS user 9001 / `shuffle-classa-svc`) and performed a
real `GET /api/alerts/667` returning **HTTP 200**.

- `verification_method = rest_item_get`, `http_status = 200`
- `iris_version = 2.4.29`, `api_version = 2.0.5`, `customer_scope = IrisInitialClient`
- `unique_marker = aee4278a-5a63-401d-949f-354ba878cb4e`
- `response_sha256` (first12) `cecf512cfd85`

Source: `phase82-evidence-readback.json`. The 401 drift is closed for read access; REST, DB,
and ledger evidence are maintained as separate channels.

---

## 3. Provenance with verified read-back

Object **667** carries the full provenance chain (Wazuh alert → integratord record → Shuffle
execution `af4f76e4…` → action task `484d8d7c…` → IRIS 667), with
`request_executor = shuffle_action_task`, `write_http_status = 201`, and a verified
`rest_read_http_status = 200` (marker matched). Objects 648/649 (Phase 80) and the 650/667
reconciliation are carried. No secret values appear in any provenance artifact.

Source: `phase82-evidence-provenance.json`.

---

## 4. Credential exposure closed + IRIS key rotated

Incident **P82-CRED-EXP-001**: the terminal-exposed credential was the IRIS API key (primary;
the Phase 81 OpenSearch-password terminal echo is a secondary, contained exposure). Scans of
shell history, session logs, process args, artifacts, git history, and backups found **no
committed secret value** (`credential_value_absent = true`).

- **Rotation (primary):** the IRIS API key was rotated (`old_secret_logical_id = iris_api_key`,
  `new_secret_logical_id = iris_api_key_v2`) via IRIS token renewal. The new token passes
  Wazuh→IRIS write (alert 683, 200) and REST read (200); the old token is rejected (401);
  the Shuffle action task was recreated; rollback is defined and the old grants removed. No
  secret value is in evidence.
- **OpenSearch password (secondary):** assessed unsafe to rotate reversibly without risking
  the Wazuh indexer / shuffle-opensearch / OTel, so it was **contained and documented only**
  (never committed; pipeline intact). A scheduled rotation with an indexer maintenance window
  is recommended as follow-up.

Sources: `phase82-evidence-exposure.json`, `phase82-evidence-rotation.json`.

---

## 5. OpenSearch audit logging enabled

Security audit logging was enabled (`plugins.security.audit.type: internal_opensearch`) and all
10 properties verified live: `failed_login`, `authenticated`, `missing_privileges`,
`ssl_exception` events are captured; sensitive headers are excluded; request bodies are not
logged in plaintext; an ISM retention policy (180d) is attached; audit logs are access-restricted
(dedicated `audit_viewer` role); and an alerting monitor fires on failed-login spikes. All
config changes are documented with rollback. Residual minor hardening: the built-in `readall`
role still uses index pattern `*` (left unchanged to avoid dashboard impact).

Source: `phase82-evidence-audit.json`.

---

## 6. Repository closeout

- Commit: see `phase82-evidence-repo.json` (`commit_id`).
- `heads_equal = true`, `push_success = true`, `clean_tree = true` (stray untracked files
  `--selftest`, `*.log`, `*.bak*`, helper scripts, `ops/backups/` were reviewed and
  adjudicated NOT committed).
- `canonical_sha256` = sha256 of this document; `manifest_sha256` = sha256 of
  `ops/reports/evidence/phase82/evidence-manifest.json`.
- `rollback_identities`: `d56928f` (p78), `db7d42c` (p79), `845f054d` (p80),
  `51b6acc` (p81), and the new Phase 82 commit.

---

## 7. Open / Gated (NO-GO without operator sign-off)

- Production alert routing, full-system restore rehearsal, credential rotation of the
  OpenSearch password (scheduled with indexer window), ISM/index manual intervention, and
  container recreate-to-deploy — all remain operator-sign-off gated.
- **OpenSearch password not fully rotated** (contained only) — see §4; schedule a supervised
  rotation.
- **`readall` role index pattern `*`** — minor audit-log hardening follow-up.
- Historical objects 192/193 remain a documented unfixed duplicate failure (carried).

---

## 8. Evidence catalog (Phase 82)

- `ops/reports/evidence/phase82/phase82-evidence-readback.json`
- `ops/reports/evidence/phase82/phase82-evidence-provenance.json`
- `ops/reports/evidence/phase82/phase82-evidence-exposure.json`
- `ops/reports/evidence/phase82/phase82-evidence-rotation.json`
- `ops/reports/evidence/phase82/phase82-evidence-audit.json`
- `ops/reports/evidence/phase82/phase82-evidence-repo.json`
- `ops/reports/evidence/phase82/evidence-manifest.json`
- Corpus: `ops/reports/generated/phase82/` (880 reports).
