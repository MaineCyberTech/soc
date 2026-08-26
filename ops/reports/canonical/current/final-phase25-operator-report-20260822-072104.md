# MCT Security Stack - Final Phase 25 Operator Report

Date: 2026-08-22
Pack: /home/user/mct-p25 (Windows Telemetry Remediation, Release Execution, Credential Recovery, DR Restore Proof, Service Activation)
Stack root: /opt/mct-security-stack | Release: v1.2.0 (published P24, re-verified)

## Executive summary

Phase 25 delivered the headline items: **Zeek Class A routing ENABLED (approved)** via a
native Wazuh integration (rule_id 122001-122003 -> Shuffle webhook -> IRIS, synthetic tests
FINISHED, kill switch documented); **DR S3 restore drill PASSED** (download + SHA-256
checksum match vs trusted manifest + safe scratch extraction - the first end-to-end S3
restore proof); **retention aligned** (archives-14d attached to ALL archives indices,
~14.4GB of policy-compliant relief projected at the disk watermark); **v1.2.0 re-verified**
(published P24) with the P25 bundle staged; and the **Windows Sysmon tuning pipeline
progressed** (014 policy accepted rc=0; 013 re-apply pending operator run). WATCH: agent 013
lagging reconnect after the master restart (~07:07 last keepalive).

## 015 closeout / scorecard

- Closeout PARTIAL (window completes 04:22 UTC 08-23): keepalive continuous, archives 1 doc,
  buffer 0, bounded events flowing. Scorecard promotion gated on closeout; variants under
  governed paths.

## Windows Sysmon

- Platform inventory: Sysmon 15.21 (schema 4.91), Sysinternals standalone, exe
  `C:\WINDOWS\Sysmon64.exe`, config `C:\Windows\Sysmon\sysmon-config.xml`.
- 014: include-oriented policy (4.91 + Signed) accepted (rc=0); effective-config backup
  retained; load confirmation pending service restart + check. EID1/10 flowing.
- 013: re-apply of corrected policy pending operator RMM run (stale 4.90 file will be
  overwritten by the script).
- Throttle retirement: criteria per endpoint (EID7 < 2K/day + buffer clean 24h + load
  confirmed); retained until then.

## Windows dashboards / PowerShell

- W1/W2 dashboards: gated on tuning validation (throttle must not be treated as health).
- ScriptBlockLogging (Event 4104): prepared (GPO policy, privacy note, 4104 rule, rollback),
  pilot staged on 012, deployment approval-gated.

## Zeek Class A routing (APPROVED + ENABLED)

- Wazuh integration `custom-json-output` rule_id 122001,122002,122003 level 8 ->
  http://shuffle-frontend/api/v1/hooks/webhook_24636c49 (existing high-severity workflow ->
  IRIS). analysisd -t rc=0; container restarted; integration verified live in running config.
- Synthetic tests: 2 webhook POSTs -> workflow executions FINISHED (pipeline verified,
  notify-only). Case window OPEN (real Class A cases ~0/day expected).
- Controls: dedup key rule.id+src+dst+1h + 5-case/day stop threshold (operator-monitored at
  IRIS review; hard automation staged Phase 26); kill switch = remove block + restart, or
  disable webhook.

## Suricata

- Staged (1 event; quiet network). No invasive traffic. Severity 1-2 rules remain gated.

## v1.2.0 (verification)

- Already published (P24): tag 62d7457, release id 374836261, asset
  mct-security-stack-release-20260822-061237.tar.gz (3,909,144 bytes). Gates re-verified
  (CI/secret/audit/docs). P25 bundle (20260822-070718, 0 sensitive files) staged for the next
  release (v1.3.0 candidate, approval-gated).

## Credential recovery

- VT key, indexer rotation, PVE222 token: **BLOCKED** (replacement values/approval). Post-
  credential validation baseline healthy (cluster green, auth OK, CI/secret PASS).

## DR restore drill (PASSED)

- Downloaded `s3://wazuh/dr/current/config-20260822-040001.tar.gz` (160,538 bytes) via s3cmd
  (region nyc3).
- **Checksum MATCH**: sha256 4c00952dcc34374d... == trusted local stage (ETag not used as
  checksum).
- Safe extraction: 0 path traversal, 82 files, --no-same-owner; no production touch.
- Validation: inventory complete, placeholders clean, compose parse (override tag expected).
- RTO observed 0.2s download; RPO <= 24h (daily 04:00 bundle). NOT a production restore.

## Disk / retention

- Node fs 84.7% (at 85% low watermark; no read-only blocks). **Retention aligned**:
  archives-14d attached to all archives indices (08-07..08-18 re-attached this phase);
  ~14.4GB relief projected as ages cross 14d (node -> ~76-78%). Alerts 30d; flow 14d.

## NetFlow / Redis / Greenbone / Canarytokens

- NetFlow: scope blocked (operator); alerts unarmed. Redis: owner-blocked (level 3). Greenbone:
  unsigned. Canarytokens T1: blocked (hosted account) - no fabricated deployment.

## Fleet / billing / scorecard

- 3/3 covered+active pre-restart; **013 lagging reconnect post-restart** (WATCH). Billing:
  3/3 covered; quality attestation pending tuning confirmation. Scorecard draft; final after
  015 closeout + tuning confirmation.

## Audits

- Full system + code/security/supply-chain regression audits: **no regressions**; CI/secret/
  health green; syntax/XML/compose clean; drift zero; image policy 0 violations; canonical +
  running configs aligned.

## Remaining risks (top)

1. 013 reconnect lag post-restart (operator: endpoint check) + EID7 tuning confirmation pending.
2. EID7 cyclic floods on 013/014 until load confirmed (throttle bounds impact).
3. Disk at low watermark (relief in motion via retention).
4. Blocked replacements/approvals: VT key, indexer rotation, PVE222, NetFlow scope, Redis,
   Greenbone auth, canarytokens account.
5. Zeek case-volume window measuring (threshold 5/day).

## Recommended Phase 26 roadmap

1. **Endpoint tuning confirmation**: 014 restart + check (marker), 013 re-apply -> validate
   EID7 drop; retire throttles per endpoint; then W1/W2 dashboards + PS logging pilot.
2. **013 reconnect**: confirm endpoint power/network if still offline.
3. **015 closeout** (04:22 08-23) -> scorecard finalization + client-safe delivery.
4. **DR full-scope drill**: scratch OpenSearch index restore from snapshots (extend the
   config-bundle proof).
5. **Credentials**: VT key, indexer rotation (approval), PVE222 token -> post-rotation
   validation.
6. **Routing automation**: Shuffle workflow with hard dedup/rate-limit nodes (workflow
   builder), keep Class A scope; measure case volume.
7. **Release**: v1.3.0 (approval) with the P25/P26 bundle.
8. **NetFlow scope** -> arm alerts; **Redis** VPS fix; **Greenbone** signed auth;
   **Canarytokens** hosted account.
9. **Disk watch**: confirm 14d deletes land (~09-02 onward); monitor node fs < 82%.

## Files added (summary)

- 45 Phase 25 deliverables (00-44): preflight, change register (C3 approved), 015 closeout/
  scorecard, sysmon platform inventory + 013/014 precheck/apply/validation + throttle
  retirement, windows dashboard/PS readiness, zeek approval/enable/case-validation (approved
  + enabled), suricata, v1.2.0 preflight/bundle/release/postrelease (verification), credential
  rotations + post-validation, DR restore plan/download/checksum/scratch/validation (drill
  PASSED), disk watch + retention projection (alignment applied), netflow scope/arming,
  redis/greenbone/canarytokens, billing/scorecard/monthly ops, audits, repo commit, final
  report, master status. Canonical manager config updated (integration block).

## No secrets

All reports cite paths/variable names only; no secret values printed.