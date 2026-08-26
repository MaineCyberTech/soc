# Phase 20 Security, Secret Hygiene, and Compliance Audit

Date: 2026-08-19

## 1. Secret-pattern scans

- `ops/scripts/secret-pattern-scan.sh` (CI-integrated) + `scan-docs-for-secret-patterns.sh` run.
- Most hits are false positives: vendored JS/emoji tables inside report files
  (`ingest-pipeline-inventory`, `hardcoded-brand-scan`) and the scan scripts' own pattern
  literals. No real secret VALUES printed (scanner redacts as `<value-hidden>`).
- Three `value-hidden` hits flagged for review (no values printed here):
  - `integrations/wazuh/custom-filebeat-archives-plan.md`
  - `integrations/levelio/phase8-device-group-results.md`
  - `compose/docker-compose.misp.yml`

## 2. No secret values in reports/docs/commits (this phase)

- All Phase 20 reports cite paths/variable names only; no secret values written.
- Phase 19/20 files remain UNCOMMITTED (so nothing new pushed). No secret pushed this phase.

## 3. Hardcoded credentials found (code audit - HIGH)

| Location | Item |
|---|---|
| `ops/scripts/endpoint-count-report.sh` | hardcoded WAZUH_WUI_PASSWORD default |
| `ops/scripts/client013-baseline-report.sh` | hardcoded WAZUH_WUI_PASSWORD default |
| `ops/scripts/capacity-threshold-check.sh` | hardcoded PVE_PASSWORD default |
| `compose/docker-compose.override.yml` | inline EF_OUTPUT_OPENSEARCH_PASSWORD / ES_PASS |
| `config/wazuh_cluster/wazuh_manager.conf` | VirusTotal API key inline (version-controlled) |

These are repo-hygiene issues (values live in files that could be shared/committed). Mitigate
by moving to env/secrets (Phase 21 backlog). No values were exposed in reports.

## 4. Approval-gated actions and evidence

- Zeek v2/v2.2 deploy: approval-gated - approved + deployed; before/after counts captured.
- Retention ISM changes: approval-gated - applied; tradeoff documented; rollback runbook exists.
- IRIS packet/flow routing: gated - NOT enabled (manual-only). Evidence: routing-readiness reports.
- Greenbone client scan: gated on signed authorization - NOT performed.
- Suricata severity rules: gated - NOT enabled (quiet network).
- NetFlow new-subnet alerting: gated on operator subnet confirmation - unarmed.
- No `docker compose down -v` run; no invasive packet/scan traffic generated.

## 5. Client-safe outputs

- Monthly scorecard + progress use no secrets; classification header "CLIENT CONFIDENTIAL".
- Fleet/billing readiness docs name endpoints (013/014/015) + IPs as internal ops artifacts, not
  client-facing deliverables; client-facing copy produced at delivery time per templates.

## 6. Compliance / gates

- Safety rules followed: no endpoint telemetry reduced without documented tradeoff; macOS
  changes carry backup/rollback; no unauthorized scans; no secrets pushed.
- Signed authorization for Greenbone remains outstanding (client action).

## Verdict

Secret hygiene: GOOD for reports/commits; ACTION NEEDED on hardcoded credential defaults in
3 scripts + 2 compose/config files. Approval gates: correctly held. No compliance violations.

## No secrets