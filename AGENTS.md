# AGENTS.md — MCT Security Stack

Governing instruction file for every automated or human agent working inside this
repository. DURABLE-ONLY: this file holds directives and pointers only — never volatile
operational metrics or per-phase history. Per-phase truth lives in
`ops/reports/canonical/current/`. Precedence: this root file governs the entire repository;
a future nested `AGENTS.md` may refine its own subtree only and can never weaken any
MUST / MUST NOT item below.

## Purpose & Scope

- Directive source for agent behavior within `/opt/mct-security-stack`.
- This file holds directives and pointers only — never volatile operational metrics.

## Repository Map

- Repo root: git repository `git@github.com:MaineCyberTech/soc.git`
  (verify with `git rev-parse --show-toplevel`).
- `compose/` — service compose files.
- `config/` — stack configuration; secrets are referenced by path only (see Credential Handling).
- `ops/scripts/` — gates, audits, utilities.
- `ops/reports/generated/` — governed report corpus.
- `ops/reports/current/` — operator final reports (phaseNN-operator-report).
- `ops/reports/canonical/current/` — canonical current-state docs (the live truth).
- `ops/evidence/` — exports and evidence artifacts (treat as immutable).
- `ops/source/` — governed source for deployed artifacts (e.g., integratord watchdog).
- `ops/runbooks/` — operator runbooks.
- `integrations/shuffle/workflows/` — canonical workflow layouts.
- `docs/` — policy documents including `SECRET-HANDLING.md`.

## Canonical Truth & Navigation

- Current operational truth: `ops/reports/canonical/current/current-state-20260828-p61.md`
  (Phase 61 refresh; supersedes the Post-P48 snapshot and all earlier pointers per its own
  supersession statement; superseded only by a newer current-state doc).
- Open-work ledger: `ops/reports/canonical/current/open-work.md`.
- Do not act on any claim older than the canonical current-state doc without re-verification.

## Required Gates Before Commit

1. Secrets scan: `ops/scripts/p38-report-ci.sh` must show zero secret-pattern hits for new
   or changed report content; run `ops/scripts/secret-pattern-scan.sh` for wider sweeps.
2. Redaction before commit: credential-bearing material is redacted FIRST, committed after;
   hashes and catalogs refreshed post-redaction.
3. Report metadata compliance for any new report (see Report Authoring Conventions).
4. If this file or any path it references changed, `ops/scripts/p39-agents-ci.sh` must pass;
   phase-specific CI (e.g. `ops/scripts/p61-agents-ci.sh`) must pass for that phase's artifacts.

## Operational Safety Rules

MUST NOT:

- Print, copy, commit, or catalog secret values anywhere.
- Run `docker compose down -v`.
- Delete indices outside sanctioned retention tooling; never force-delete ISM-managed
  indices merely because a forecast date passed.
- Delete `/tmp` contents indiscriminately.
- Enable production alert routing without passing native-control gates plus a rollback path.
- Weaken Shuffle exposure controls or disk watermarks.
- Rewrite immutable, signed, client-delivered, release, or evidence artifacts in place.
- Fabricate or simulate PASS evidence.
- GET a Shuffle webhook for health (POST a synthetic canary instead).

MUST:

- Fail closed on malformed, unknown, or datastore-failure events.
- Keep synthetic events isolated from production counters, cases, billing, and scorecards.
- Take a timestamped backup plus sha256 into `ops/backups/agents/` BEFORE editing this file.

## Approval-Gated Operations

Operator sign-off, recorded in the change register, is REQUIRED before:

- Enabling production routing on any lane.
- Applying a report migration APPLY step or any destructive corpus operation.
- Executing a full-system restore rehearsal against a chosen target.
- Changing Shuffle exposure, firewall, or TLS posture.
- Rotating credentials or invalidating tokens.
- Any manual ISM/index intervention beyond scripted retention.
- Recreating/restarting a production container to deploy a new artifact (e.g. watchdog
  recreate-survival) — requires root/sudo access plus owner sign-off.

## Credential Handling

- Values never enter any file. Reference storage locations by path only:
  - `config/shuffle-api-key` — mode 600, gitignored.
  - `compose/.env` and `*.env` — gitignored (`*.env.example` allowlisted).
  - Runtime credentials: `/opt/wazuh-docker/multi-node/ops/creds.env` (outside this repo,
    mode 600); scripts consume variables such as `${WAZUH_ADMIN_PASSWORD}` from it.
- Indexer auth pattern: `curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" https://127.0.0.1:9200/…`.
- Scripting note: strip whitespace whenever reading tokens from files (`tr -d '[:space:]'`)
  to avoid intermittent 401s.
- Config-truth note: indexer disk-watermark enforcement is DISABLED cluster-wide
  (`cluster.routing.allocation.disk.threshold_enabled: false`); watermarks advisory-only,
  capacity is manual-watch (R-DISKBYPASS; owner decision OW-42-01).

## Report Authoring Conventions

- Filenames: `phaseNN-slug.md` inside `ops/reports/generated/` (digit-prefixed index to
  satisfy the inventory validator, e.g. `000-authority-01.md`).
- Required metadata headers: **Report ID:** / **Phase:** / **Title:** / **Date:** /
  **Timestamp:** (UTC, Z suffix) / **Classification:** INTERNAL / **Status:** / **Source Path:**.
- Status values restricted to the Phase 38 CI enum set (COMPLETE, PARTIAL, BLOCKED,
  DEFERRED, PENDING, PLAN-ONLY, …).
- Claims carry flags (VERIFIED / PARTIAL / UNVERIFIED) with evidence references.
- Phase finals carry an explicit supersession statement; historical reports are never
  rewritten in place.

## Known Blockers

Durable-only pointer. Volatile per-phase history and open/gated items are NOT embedded here
(they are volatile). The live list of open blockers and gated (NO-GO) operations is maintained
in the canonical current-state doc: `ops/reports/canonical/current/current-state-20260828-p61.md`
(see "Open / Gated (NO-GO without sign-off)"). Recurring durable blockers: production routing,
restore rehearsal, credential rotation, ISM/index intervention, and container recreate-to-deploy
all require operator sign-off per Approval-Gated Operations.

## Out of Scope

- PVE host access and RAM expansion. No agent may plan, script, request, or execute either.

## Escalation & Owners

- Reports/corpus governance: ops-reports-owner.
- Shuffle/SOAR: SOAR ops owner.
- Wazuh manager/indexer configuration: Wazuh/indexer config owner.
- Infrastructure (disk, snapshots, ISM): Infrastructure owner.
- Endpoints: Endpoint ops owner.
- Overall owner: MCT SOC. Gated or uncertain situations escalate to operator sign-off;
  agents do not improvise past a gate.
