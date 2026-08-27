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
- `ops/scripts/` — gates, audits, utilities, including the `p33-`–`p46-` phase series.
- `ops/reports/generated/` — governed report corpus with `catalog-reports.csv` / `catalog-reports.json`.
- `ops/reports/current/` — operator final reports (phaseNN-operator-report).
- `ops/evidence/` — exports and evidence artifacts (treat as immutable).
- `integrations/shuffle/workflows/suricata-packet-routing/` — canonical workflow layout (changelog, expected, rollback, tests).
- `docs/` — policy documents including `SECRET-HANDLING.md`; root-level `REPO-MAP.md`, `SECURITY.md`.
_Sources: [SRC: phase39-56] [SRC: phase45-13] [SRC: phase46-12]_

## Canonical Truth & Navigation

- Current operational truth: `ops/reports/canonical/current/current-state-20260827-p48.md`
  (Post-P48 refresh; supersedes the Post-P42 snapshot and earlier pointers per its own
  supersession statement; superseded only by a newer current-state doc).
  This canonical state was refreshed in Phase 48 (operator-authorized) to clear the
  Phase-42 staleness. Open-work ledger: `ops/reports/canonical/current/open-work.md`.
  Do not act on any claim older than the canonical current-state doc without re-verification.
_Sources: [SRC: phase48-014] [SRC: phase39-56]_

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
field-fix VERIFIED (phase40-13), then field-growth CONTAINED AT SOURCE in P41
(eve.json stats removed on sensor; compact-stats emitter+timer live; certification
flips on the 08.27 guardrail via staged adjudicator `ops/scripts/p42-field-cycle-adjudicate.sh`,
window = 08.27 index birth — phase41-15/-18, phase42-03); Wazuh→Shuffle trigger
WIRED+PROVEN end-to-end in Phase 40 (phase40-37/-40) with overnight soak PASS incl.
one real fail-closed ERROR caught (phase41-40) and monitor watchdog live (phase41-39/-43);
Shuffle TLS implemented on :3443, plaintext LAN exposure closed (phase40-32), XFO dedup
DONE (phase41-66); agent-015 merged.mg defect FIXED (phase40-24); W1/W2 dashboards
imported 8/8 into the global tenant (phase40-62); dual-suricata-process defect
FIXED via unit MASK + exact-args production invocation (phase41-15); v1.3.0
published-original custody CLOSED byte-exact (phase41-75/-76); P42 closures: repair-churn
ELIMINATED+certified via gated repair script — healthy no-op x3 + forced-failure controlled
recovery (phase42-48); nosniff dedup DONE single-header at :3443 (phase42-50); VT conf
container-side 640 applied, host-side 640 = owner sudo-window item (phase42-53); v1.3.1
CUT+TAG pushed to origin with on-box asset sha256-verified, release-page publication
token-blocked (phase42-79/-80); EID discrepancy ROOT-CAUSED (signal=data.win.system.eventID;
event.code never populated) with W2 v2 artifact staged pending owner swap (phase42-69).

Resolved-in-P44/45 (packet rebuild): workflow REBUILT as single execute_python (phase44-13); 10 state transitions TEST PROVEN (phase45-29…35); canonical layout created (phase45-13); P45 final corrected via addendum (phase46-05…08).

Open blockers — pointers only; live values in linked reports, never here:

- Webhook trigger STOPPED — manual UI start required; hook "Hook ID not valid" when stopped (phase46-14…16).
- IRIS auth PLACEHOLDER (`[REDACTED-IRIS-TOKEN]`) — needs real auth object in Shuffle UI; IRIS 401 (phase46-21…25).
- Owner session NOT SCHEDULED — 8 gates: Agent 013/015, RTO/RPO, restore target, VT host, GitHub auth, dashboard, disk (phase46-57…66).
- Wazuh→Shuffle BIND PENDING — baseline documented, not configured (phase46-40…42).
- Agent 013 SAMSUNG offline — owner device-side. Agent 015 flap — owner device-side; merged.mg fixed (phase40-24).
- First ISM deletion wave unobserved — window opens 2026-08-29. RTO/RPO sign-off pending (phase40-72).
- Restore rehearsal NO-GO until adequate external target approved.
- v1.3.1 PUBLISHED — release v1.3.1 + asset `v1.3.1-from-tag.tar.gz` (sha256 `4e6c3712…ebf596`) live at `github.com/MaineCyberTech/soc/releases/tag/v1.3.1` (phase48-114/-116).
- Dashboard v2 ACTIVATION PENDING — signed off, not activated (phase46-71…75).
- Canonical current-state REFRESHED to Phase 48 (20260827-p48) this session; operator-authorized (phase48-014).
- Phase 46 Full COMPLETE — 121 reports (000-120) from `/home/user/mct-p46-full/`; corpus 225+ (phase46-full-120-final).
- Phase 47 COMPLETE — 130 reports from `/home/user/mct-p47/`. Phase 48 COMPLETE — 150 reports from `/home/user/mct-p48/`.
_Sources: [SRC: phase39-56] [SRC: phase44-13] [SRC: phase45-29…35] [SRC: phase46-14…120]_

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
- Scripting note: never pipe a heredoc through `ssh host bash <<EOF` — the remote
  command's stdin collides with the heredoc stream (consumed twice/misrouted; bit
  twice in one day, P41). Stage the script to a file on the target or use
  `ssh host bash -s < localfile`.
- Scripting note: systemd unit state may NOT reflect what production runs — e.g. the
  sensor Suricata unit is deliberately MASKED while production runs via an exact-args
  setsid invocation. Verify with `pgrep -af` before reasoning about runtime state.
- Scripting note: Shuffle `execute_python` cannot receive workflow variables via template
  interpolation today (`$hook.data`, `$exec` arrive as literal strings — param-injection
  platform defect R-PKT-PLATFORM). However, it CAN access the full execution context via
  `self.full_execution.get('execution_argument', '{}')` which contains the raw webhook
  payload as a JSON string. Prefer native reference-consuming nodes (`filter_list`,
  `set_cache_value`, `check_cache_contains`) which resolve $refs. Verified: the HTTP app
  node is the ONLY node type that interpolates `${…}` references into requests (T5,
  phase42-15) — Tools-family nodes pass refs as literals.
  _Sources: [SRC: phase39-56] [SRC: phase44-13] [SRC: phase45-29]_
- Config-truth note: indexer disk-watermark enforcement is DISABLED cluster-wide
  (`cluster.routing.allocation.disk.threshold_enabled: false` in
  `multi-node/config/wazuh_indexer/wazuh1.indexer.yml`, mounted as opensearch.yml;
  live on all 3 nodes) — watermarks advisory-only, capacity is manual-watch
  (R-DISKBYPASS; owner decision tracked OW-42-01).
- Tool note: `gh` (GitHub CLI) v2.98.0 installed at `~/.local/bin/gh` and **authenticated** (token in creds.env valid; full `repo` scope). v1.3.1 release published (phase48-114/-116). _Sources: [SRC: phase48-109]_
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
