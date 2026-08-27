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

- Webhook trigger **RUNNING** (owner started via Shuffle UI 2026-08-27; verified `status=running`, webhook intake reachable at the host's `.149` TLS interface `:3443` → 200). `suricata-eve-in` (`736b7410-…`) and Class-A `wazuh-high-severity` (`eb937a37-…`) are both live. Trigger start is UI-only **by design** (REST `POST`/`PUT`/`/start`/`/triggers` all 404/405). ROUTED is also fixed (token file at `/shuffle-files/iris-shuffle.env`; standalone replay 200 + real IRIS alert). **Action:** ensure Wazuh/Suricata forwarders POST to the **local** `:3443` TLS URL of this host — NOT the `shuffler.io` default shown in `info.url`.
- IRIS ROUTED **RESOLVED** (phase53 RPT-20260827-iris-routed-fix-01): root cause was a missing value-blind token file, NOT the Shuffle result-passing quirk. The `suricata-packet-routing` workflow (`e133a645-95b9-4e01-9454-e270d2a0b599`) POSTs to IRIS from Python and loads the token from `/shuffle-files/iris-shuffle.env`; after the phase53 header-pivot that file was never (re)created, so `load_iris_token()` returned None → `AUTH_FAILED`. Fix: created the token file at the approved runtime location (`data/shuffle/files/iris-shuffle.env`, gitignored, 600, sourced from `creds.env`) — no secret in code/repo. Verified by replaying the exact POST → HTTP 200 + real IRIS alert. The Class-A Wazuh→IRIS workflow (`eb937a37-5244-46dc-95ff-62ad4c681322`, `wazuh-high-severity-to-iris`) and the value-blind HTTP-app header wiring remain in place. Full end-to-end still requires the owner to **Start the `suricata-eve-in` trigger in the UI** (UI-only start; see `ops/reports/generated/phase53-trigger-start.md`).
- `shuffle-rollover` ISM **incompatible with OpenSearch 3.2.0** (phase52-exec + phase53 governed decision): both `index.rollover_alias` setting and action `rollover_alias` rejected; policy safely UNCHANGED; benign (Shuffle datastore small/healthy). **Decision: ACCEPT** (phase53, owner ratification); no invalid ISM retry. Upgrade path tracked as future work. See `ops/reports/generated/phase53-rollover-decision.md`.
 - Phase 53 (20260827) real-work summary + 240-prompt ledger + blockers: `ops/reports/generated/phase53-final.md` (master ledger `phase53-master.md`). Residual read-only PARTIALs remediated where possible via live inspection (13 -> DONE: 045/050/063/065/066/067/171/177/192/193/197/210/223); 6 inherent limitations remain owner-accepted (046/049/051/176/225/234 — no repo source / needs human or owner-gated action).
- Phase 54 (20260827) COMPLETE: 280-prompt pack executed as real engineering (final `ops/reports/current/final-phase54-operator-report-20260827-2155Z.md`; 280 `phase54-*.md` reports). Core deliverable: durable **service-scoped Swarm secret** `iris-shuffle-env` created value-blind and granted to `shuffle-tools` only (mount `/run/secrets/iris-shuffle.env`); ROUTED re-verified via the secret (exec `2ce46d4a` → IRIS object 67). KEY FINDING: `shuffle-tools` is NOT in `compose/docker-compose.shuffle.yml` (orchestrator-managed); its governed source is the live Swarm service spec, where the secret now persists. Legacy `/shuffle-files` bind retained as explicit fallback (DEFERRED removal, 055). Owner-gated BLOCKED (NO-GO w/o signed approval): Wazuh canary (161/166/168), prod rollout (192-199), dashboard (244/245), restore (253/254). Rollover ACCEPT ratified.
- Phase 55 (20260827) COMPLETE: 300-prompt secret-governance/least-privilege/durability-correction pack (final `ops/reports/current/final-phase55-operator-report-20260827-2345Z.md`; 300 `phase55-*.md` reports — tally 135 DONE / 56 BLOCKED / 53 PARTIAL / 37 DEFERRED / 10 ACCEPT / 7 NOT_EXECUTED / 2 UNVERIFIED). POSITIVELY VERIFIED Phase 54 durability: `iris-shuffle-env` (mode 0444) service-scoped to `shuffle-tools_1-2-0` only, negatively proven across backend/orborus/other apps; ROUTED re-proven (exec `19791f62` → IRIS object 68). DRIFT TO OWNER-VERIFY: Class-A `eb937a37` (`wazuh-high-severity-to-iris`) appears absent from live trigger list / in `test` status with trigger id mismatch (`24636c49` vs integratord `webhook_eb937a37`) — contradicts earlier RUNNING claims; Wazuh→IRIS path may be broken. DEFECT: DUPLICATE dedup key missing `proto`+`agent` (false collapse); counter is a flag not an increment. Owner-gated BLOCKED (NO-GO w/o signed approval): secret rotation/replacement/reconciler, service delete, host reboot, full restore, prod canary/apply, dashboard, disk.
 - Packet-workflow resilience HARDENED (phase53, 2026-08-27): `suricata-packet-routing` (`e133a645-…`) now writes a replayable **dead-letter** (`p53_deadletter` datastore category) and a **failure-notification** (`p53_notifications` category) on every failure state (AUTH_FAILED/TARGET_FAILED/DATASTORE_READ_FAIL/COUNTER_FAIL/UNKNOWN). Change is guarded (try/except, never raises) and reversible via Shuffle workflow revision; ROUTED path unchanged (re-verified: real IRIS alert 66). See `ops/reports/generated/phase53-144-dead-letter.md` and `phase53-145-notification.md` (now DONE).
- Owner session NOT SCHEDULED — 8 gates: Agent 013/015, RTO/RPO, restore target, VT host, GitHub auth, dashboard, disk (phase46-57…66).
- Wazuh→Shuffle **ALREADY WIRED** (Class-A): ossec.conf forwards `<group>suricata,</group>` to hook `webhook_eb937a37` → workflow `wazuh-high-severity-to-iris` (phase40-37/-40). Packet-routing webhook `p39-suricata-test` (`e133a645`) is a SEPARATE test webhook, **STOPPED**; binding Suricata EVE to it is blocked by the stopped trigger (UI-only), not Wazuh config.
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
