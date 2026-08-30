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
- `integrations/shuffle/workflows/` — canonical workflow layouts (e.g.
  `wazuh-high-severity-to-iris-execute_python-v2.py`, the v2 atomic-dedup + fail-closed
  reconciliation code for Wazuh→IRIS workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`).
- `docs/` — policy documents including `SECRET-HANDLING.md`.
- `ops/scripts/` — per-phase validators and gates (e.g. `p77-eo-validate.py`,
  `p77-recreate-validate.py`, `p77-otel-validate.py`, `p77-network-validate.py`,
  `p77-slo-validate.py`, `p77-inventory.py`, `p77-time-anchor.py`); they read a consolidated
  evidence JSON at argv[1] and require all keys true.
- `ops/reports/evidence/` — per-phase evidence JSONs consumed by the validators (e.g.
  `phase77/phase77-evidence-{recreate,eo,otel,network,slo}.json`).
- `ops/reports/generated/` — per-phase generated corpus (digit-prefixed reports; e.g. `phase77/`
  satisfies the inventory validator).
- `/home/user/mct-pNN/` — Phase NN prompt packs (prompts + validators + acceptance + run-order).
  NOT in this repo; executed against it.
- `ops/otel/collector.yaml` + `compose/docker-compose.otel.yml` — OTel collector (contrib);
  exports traces to `shuffle-opensearch:9200` over TLS into `ss4o_traces-otel-mct-soc` as scoped
  user `otel_collector`.
- `ops/scripts/phase77-slo-monitor.py` — self-contained SLO burn-rate monitor (PAGE = local
  alert log; no external pager).

## Canonical Truth & Navigation

- Current operational truth: `ops/reports/canonical/current/current-state-20260830-p77.md`
  (P77 — all seven `p77-*` validators PASS; shuffle-tools rebuilt with dedicated secrets + both CAs,
  two worker replacements + E2E, OpenSearch recreate/rollback/TLS/RBAC/ledger, full eo fault matrix
  (one destination object), Collector outage/restart/queue/cardinality independent from Class-A,
  negative-network denied, fast/slow/reset/low-traffic SLO. Residual: isolated synthetic IRIS alerts
  + IRIS loopback isolation + supported-capacity license gate. Supersedes
  current-state-20260830-p76.md; superseded only by a newer current-state doc).
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
- Use dedicated service-scoped secrets for each integration; never mount a broad mixed env file
  into a service merely for convenience.
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
- Docker Swarm secrets (dedicated, service-scoped — the Phase 77 durable pattern):
  - `iris-ca.crt` — IRIS CA (mounted at `/run/secrets/iris-ca.crt`).
  - `opensearch-ca` — OpenSearch CA bundle (mounted at `/opt/mct/security/ca-bundle.pem`).
  - `iris-shuffle-dedicated` — ONLY `IRIS_API_KEY` + `IRIS_BASE_URL` + `IRIS_CA` + `VERIFY_CERTS`.
  - `dedup-shuffle-dedicated` — ONLY `OPENSEARCH_DEDUP_*` + CA-bundle path + `VERIFY_CERTS`.
  - `shuffle-tools` mounts ONLY these dedicated secrets + both CAs — never the broad mixed
    `iris-shuffle-env` / compose `.env`. Dedicated service-scoped secrets only; never a broad
    mixed env file merely for convenience.
- IRIS API key (host-side): `config/shuffle-api-key` — mode 600, gitignored (also carried in the
  dedicated secret); never print.
- Config-truth note: indexer disk-watermark enforcement is DISABLED cluster-wide
  (advisory-only; threshold checks off); watermarks advisory-only, capacity is manual-watch
  (R-DISKBYPASS; owner decision OW-42-01). Operational detail lives in the canonical
  current-state doc.

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
in the canonical current-state doc: `ops/reports/canonical/current/current-state-20260830-p77.md`
  (see "Open / Gated (NO-GO without sign-off)"). Recurring durable blockers: production routing,
restore rehearsal, credential rotation, ISM/index intervention, and container recreate-to-deploy
all require operator sign-off per Approval-Gated Operations.

- Note (P73/P77, dev-approved): the IRIS gateway republish on the mct-security gateway and
  Shuffle worker `extra_hosts`/secret-mount augmentation (OPEN-ENV-04) are approved
  dev-environment repairs (user-granted dev latitude), not new-artifact deploys; they are
  guarded by `ops/scripts/iris-gateway-publish.sh` and `ops/scripts/shuffle-worker-augment.sh`
  via cron. Phase 77 extended this: `shuffle-tools` was rebuilt from desired state with dedicated
  `iris-shuffle-dedicated` + `dedup-shuffle-dedicated` secrets and both CAs (`iris-ca.crt`,
  `opensearch-ca`) durably mounted (survives `--force`); the broad mixed env is no longer mounted.
  The Shuffle 25K app-run limit dev workaround (OPEN-ENV-03) is a dev script, not a license
  substitute. Detail in the canonical current-state doc.

## Phase Pack Execution (durable pattern)

Prompt packs are executed against this repo but live at `/home/user/mct-pNN/` (outside the repo).
A pack is a set of `NNN-theme-xx.md` prompts plus per-phase validator scripts (the `pNN-*.py`
  files in `ops/scripts/`), `acceptance.md`, and `run-order.md`. Executing a pack durably:

1. Generate the per-phase corpus (e.g. `ops/reports/generated/phase77/`) — one digit-prefixed
   report per prompt (satisfies the inventory validator: exactly N unique indices, no missing/
   duplicates). Subagents parallelize documentation ranges; live-stack workstreams own their ranges.
2. Produce consolidated evidence JSONs (e.g. `ops/reports/evidence/phase77/`) that the validators
   read at argv[1]; every required key must be genuinely true (no fabricated PASS).
3. Run ALL per-phase validators (e.g. `p77-*`) to PASS (inventory, time-anchor, substantive ones).
4. Write a canonical current-state doc (e.g. `ops/reports/canonical/current/current-state-20260830-p77.md`)
   and a final operator report (e.g. `ops/reports/current/final-phase77-operator-report-20260830T0830Z.md`).

Live-stack workstreams (recreate, eo fault matrix, otel resilience, negative-network, slo burns)
require operator approval and produce the evidence JSONs; they must be reversible and preserve
evidence before cleanup.

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
