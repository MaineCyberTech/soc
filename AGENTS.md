# AGENTS.md — MCT Security Stack

Governing instruction file for every automated or human agent working inside this
repository. Created 2026-08-25 by the Phase 39 AGENTS reconciliation arc. Precedence:
this root file governs the entire repository; a future nested `AGENTS.md` may refine its
own subtree only and can never weaken any MUST / MUST NOT item below.
_Sources: [SRC: phase39-53]_

## Purpose & Scope

- Directive source for agent behavior within `/opt/mct-security-stack`.
- This file holds directives and pointers only — never volatile operational metrics.
_Sources: [SRC: phase39-57] [SRC: phase39-60]_

## Repository Map

- Repo root: git repository `git@github.com:MaineCyberTech/soc.git`
  (verify with `git rev-parse --show-toplevel`).
- `compose/` — service compose files (`docker-compose.shuffle.yml`, `docker-compose.dfir-iris.yml`,
  `docker-compose.misp.yml`, `docker-compose.greenbone.yml`, `docker-compose.opencanary.yml`,
  `docker-compose.velociraptor.yml`, `docker-compose.phase2.yml`).
- `config/` — stack configuration; secrets are referenced by path only (see Credential Handling).
- `ops/scripts/` — gates, audits, utilities, including the `p33-`–`p39-` phase series.
- `ops/reports/generated/` — governed report corpus with `catalog-reports.csv` / `catalog-reports.json`.
- `ops/evidence/` — exports and evidence artifacts (treat as immutable).
- `docs/` — policy documents including `SECRET-HANDLING.md`; root-level `REPO-MAP.md`, `SECURITY.md`.
_Sources: [SRC: phase39-56]_

## Canonical Truth & Navigation

- Current operational truth: `ops/reports/canonical/current/current-state-20260826.md`
  (Phase-40 refresh; supersedes `phase38-49-generate-current-state.md` pointer-wise;
  superseded only by a newer current-state doc per its own supersession statement).
- Open work ledger: `ops/reports/canonical/current/open-work.md`; current change register:
  `ops/reports/generated/phase40-02-change-register.md` (G40 series).
- Do not act on any claim older than the canonical current-state doc without re-verification.
_Sources: [SRC: phase39-56]_

## Required Gates Before Commit

1. Secrets scan: `ops/scripts/p38-report-ci.sh` must show zero secret-pattern hits for new
   or changed report content; run `ops/scripts/secret-pattern-scan.sh` for wider sweeps.
2. Redaction before commit: credential-bearing material is redacted FIRST, committed after;
   hashes and catalogs refreshed post-redaction.
3. Report metadata compliance for any new report (see Report Authoring Conventions).
4. If this file or any path it references changed, `ops/scripts/p39-agents-ci.sh` must pass.
_Sources: [SRC: phase39-56] [SRC: phase39-55]_

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

MUST:

- Fail closed on malformed, unknown, or datastore-failure events.
- Keep synthetic events isolated from production counters, cases, billing, and scorecards.
- Take a timestamped backup plus sha256 into `ops/backups/agents/` BEFORE editing this file.
_Sources: [SRC: phase39-55]_

## Approval-Gated Operations

Operator sign-off, recorded in the change register, is REQUIRED before:

- Enabling production routing on any lane.
- Applying the report migration APPLY step or any destructive corpus operation.
- Executing a full-system restore rehearsal against a chosen target.
- Changing Shuffle exposure, firewall, or TLS posture.
- Rotating credentials or invalidating tokens.
- Any manual ISM/index intervention beyond scripted retention.
_Sources: [SRC: phase39-56]_

## Known Blockers

Resolved-in-P40 (details in linked reports; listed to prevent re-litigation):
field-fix VERIFIED (phase40-13); Wazuh→Shuffle trigger WIRED+PROVEN end-to-end
(phase40-37/-40); Shuffle TLS implemented on :3443, plaintext LAN exposure closed
(phase40-32); agent-015 merged.mg defect FIXED (phase40-24); W1/W2 dashboards
imported 8/8 into the global tenant (phase40-62).

Open blockers — pointers only; live values in linked reports, never here:

- Agent 013 SAMSUNG offline — owner device-side action; endpoint status reports.
- Agent 015 flap remediation — owner device-side; manager-side merged.mg defect fixed
  (phase40-24).
- First policy-driven ISM deletion wave not yet observed — window opens 2026-08-29.
- Packet workflow import + routing proofs DEFERRED by choice until refinement — see
  `ops/reports/generated/phase40-41-packet-workflow-import.md` and ROUT-PKT-40-01.
- RTO/RPO sign-off awaiting owner decision — see
  `ops/reports/generated/phase40-72-rto-rpo-owner-decision.md`.
- Restore rehearsal NO-GO until an adequate external target is approved.
_Sources: [SRC: phase39-56]_

## Credential Handling

- Values never enter any file. Reference storage locations by path only:
  - `config/shuffle-api-key` — mode 600, gitignored.
  - `compose/.env` and `*.env` — gitignored (`*.env.example` allowlisted).
  - Runtime credentials: `/opt/wazuh-docker/multi-node/ops/creds.env` (outside this repo,
    mode 600); scripts consume variables such as `${WAZUH_ADMIN_PASSWORD}` from it.
- Indexer auth pattern: `curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" https://127.0.0.1:9200/…`.
- Scripting note: reading key files with `$(cat file)` embeds a trailing newline in the
  value (and therefore in the `Authorization: Bearer …` header), which reproduces
  intermittent 401s; strip whitespace (`tr -d '[:space:]'` or equivalent) whenever
  scripting tokens read from files. Lesson from phase40-41 (probes C1 vs E1).
_Sources: [SRC: phase39-56]_

## Report Authoring Conventions

- Filenames: `phaseNN-slug.md` inside `ops/reports/generated/`.
- Required metadata headers: **Report ID:** / **Phase:** / **Title:** / **Date:** /
  **Timestamp:** (UTC, Z suffix) / **Classification:** INTERNAL / **Status:** / **Source Path:**.
- Status values restricted to the Phase 38 CI enum set (COMPLETE, PARTIAL, BLOCKED,
  DEFERRED, PENDING, PLAN-ONLY, …).
- Claims carry flags (VERIFIED / PARTIAL / UNVERIFIED) with evidence references.
- Phase finals carry an explicit supersession statement; historical reports are never
  rewritten in place.
_Sources: [SRC: phase39-56]_

## Out of Scope

- PVE host access and RAM expansion. No agent may plan, script, request, or execute either.
_Sources: [SRC: phase39-55]_

## Escalation & Owners

- Reports/corpus governance: ops-reports-owner.
- Shuffle/SOAR: SOAR ops owner.
- Wazuh manager/indexer configuration: Wazuh/indexer config owner.
- Infrastructure (disk, snapshots, ISM): Infrastructure owner.
- Endpoints: Endpoint ops owner.
- Overall owner: MCT SOC. Gated or uncertain situations escalate to operator sign-off;
  agents do not improvise past a gate.
_Sources: [SRC: phase39-56]_
