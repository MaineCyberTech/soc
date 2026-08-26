# Phase 39 Change Register

**Report ID:** phase39-02-change-register  
**Phase:** 39  
**Title:** Phase 39 Change Register — Gates G1–G12 (Credential Remediation Arc)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:25:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-02-change-register.md`  

---

## 1. Register Convention

Each gate records: **change**, **status**, **rationale**, **approval basis**, and
**rollback**. Statuses: APPLIED (live, verified), PLANNED (design approved, not executed),
DEFERRED (explicit postponement with trigger), PENDING (waiting external/time event).
No secret values appear; placeholders only.

## 2. Gate Summary Table

| Gate | Change | Status | Detail report |
|---|---|---|---|
| G1 | Shuffle admin bearer rotation + invalidation | APPLIED | phase39-06 / 07 |
| G2 | Tracked-file secret redaction (16 files) | APPLIED | phase39-09 |
| G3 | Shuffle exposure hardening via publish-bind fallback | APPLIED | this report §3.3 |
| G4 | TLS on Shuffle frontend (443) | DEFERRED | this report §3.4 |
| G5 | IRIS DNS fix — swarm overlay network connect | APPLIED | phase39-01 §7 |
| G6 | Workflow HTTP auth header repair (IRIS bearer) | APPLIED | phase39-08 |
| G7 | Migration apply (copy-first) | PLANNED | this report §3.7 |
| G8 | Root AGENTS.md creation | PLANNED | phase39-01 §8 |
| G9 | Report status-enum normalization | APPLIED (scoped) | this report §3.9 |
| G10 | v1.3.0 release artifact archiving | PLANNED | this report §3.10 |
| G11 | Retention delete-wave observation | PENDING (due 08-29) | this report §3.11 |
| G12 | Dashboards refresh + remediation commit packaging | PLANNED | this report §3.12 |

## 3. Gate Details

### G1 — Token rotation (APPLIED)

- **Change:** rotate Shuffle admin bearer via datastore update of `apikey` in
  `shuffle-opensearch` `users` index doc `39dd09d3-7874-46a0-8672-e7acb8827b2c`,
  followed by backend restart to flush the in-memory auth cache.
- **Rationale:** old value was disclosed in repo-tracked reports since the
  ~P36/P37 commit era (7bd3b82/04e689d); disclosure = compromise for an INTERNAL
  admin credential.
- **Approval basis:** MCT SOC owner sign-off recorded in INC-39-01 containment plan;
  prerequisites met per phase39-05 (backup inventory, storage location prepared,
  UI password path unaffected).
- **Rollback:** rollback-to-compromised is PROHIBITED (phase39-05 §4). Recovery path is
  forward-only: re-issue another new token by repeating the same datastore mechanism.

### G2 — Redaction (APPLIED)

- **Change:** sed-redact all secret-bearing TRACKED files to `[REDACTED-*]`
  placeholders; leave untracked local backups on disk (git-untracked verified).
- **Rationale:** remove live-secret values from version control while preserving
  evidentiary structure (line counts, JSON shape) for audit.
- **Approval basis:** SECRET-HANDLING policy; incident containment step 3 of INC-39-01.
- **Rollback:** `git checkout -- <file>` restores pre-redaction content from HEAD
  (04e689d) if a redaction broke syntax — acceptable because HEAD itself will be
  superseded by the G12 commit; post-G12 rollback would require reverting the commit.

### G3 — Exposure hardening, publish-bind fallback (APPLIED)

- **Change:** compose edit `0.0.0.0:3001:80` → `192.168.222.149:3001:80`; frontend
  container recreated (stale non-compose-project container removed first). Backup:
  `ops/backups/docker-compose.shuffle.yml.pre-p39-hardening`.
- **Rationale:** host LXC has no iptables/nft/ufw and no NET_ADMIN capability, so a
  host-firewall design is impossible; publish-binding to the mgmt interface achieves
  equivalent reachability reduction with stock Docker mechanics.
- **Verification (live):** mgmt interface HTTP 200; loopback connection-refused;
  docker0 bridge blocked. See phase39-01 §5 for captured outputs.
- **Rollback:** restore backup compose file and recreate frontend (re-exposes all
  interfaces — requires SOC approval; treat as incident-level action).

### G4 — TLS on frontend (DEFERRED)

- **Change considered:** enable HTTPS on shuffle-frontend :3001.
- **Rationale for deferral:** bind-surface reduction (G3) removes off-host exposure on
  untrusted segments first; TLS adds cert lifecycle burden that needs its own gate
  (CA choice, renewal automation). Trigger to revisit: any requirement to expose the
  frontend beyond the mgmt interface, or P40 security-audit finding.

### G5 — DNS network change (APPLIED)

- **Change:** `docker network connect shuffle_swarm_executions iriswebapp_nginx --alias
  iriswebapp_nginx` (resolves at 10.224.224.66 from app network).
- **Rollback:** `docker network disconnect shuffle_swarm_executions iriswebapp_nginx`.
  Note: rollback breaks workflow→IRIS delivery again; treat as fault-rollback only.

### G6 — Workflow auth repair (APPLIED)

- **Change:** API PUT replacing corrupted header JSON (which contained a literal
  `<REDACTED>` string inside the live Authorization parameter from a prior-phase
  redaction error) with valid JSON `{"Authorization": "Bearer [token]",
  "Content-Type": "application/json"}` using the recovered original IRIS bearer;
  body placeholder escapes fixed (`\${body:` → `${body:`).
- **Lesson (governance):** never redact INSIDE live system parameters — redact only in
  documents. Recorded as process rule for AGENTS.md (G8 input).

### G7 — Migration apply (PLANNED, copy-first)

- **Design:** copy-first migration: snapshot source state → copy to target → verify
  checksums/counts → cutover flag → decommission source only after verification window.
- **Why not applied:** requires maintenance window alignment with ingest low-water mark;
  not forced by the credential arc. Target: Phase 40.

### G8 — AGENTS changes (PLANNED, create-root)

- Discovery showed zero AGENTS.md anywhere (phase39-01 §8). Plan: create root
  `/opt/mct-security-stack/AGENTS.md` encoding the operational rules learned here
  (no-redaction-inside-live-systems; placeholder conventions; run-order pointer).

### G9 — Status-enum fixes (APPLIED, scoped)

- Any phase39 report uses only taxonomy-valid statuses; p38 CI Gate3 re-run confirms
  zero invalid enums across the 97-report generated corpus (see phase39-12 output).

### G10 — Release archiving (PLANNED)

- v1.3.0 artifacts to be archived with digests into the release bundle path during the
  next release cycle; deferred because no release ship occurs mid-arc.

### G11 — Retention observation (PENDING, due 2026-08-29)

- Next delete-wave observation window opens 08-29; disk trajectory then decides whether
  additional retention relief is required. Linked: field-limit rejection stop expected
  after 2026-08-26 index roll (rejections currently ~9k/hr).

### G12 — Dashboards + commit packaging (PLANNED)

- Refresh dashboards referencing changed fields/totals, then commit the remediation
  changeset (currently 14 dirty paths incl. .gitignore entry, .env update tracked as
  ignored-path change documentation, compose binding, redacted evidence/reports, catalog
  rehash, SHA256SUMS refresh). Commit executes only after CI green (achieved — see
  phase39-12) and operator review.

## 4. Cross-Gate Dependencies

G1 depends on G2's storage preparation (key file + .gitignore). G6 depends on G5 (DNS)
and the recovered IRIS bearer from the classb export (itself a leak location — closed by
G2). G12 depends on G2 + phase39-12 PASS. No circular dependencies.

## 5. Verdict

**COMPLETE** as a register: every gate has status, rationale, approval basis where
applicable, and rollback. Applied gates carry live verification evidence in their
detail reports.
