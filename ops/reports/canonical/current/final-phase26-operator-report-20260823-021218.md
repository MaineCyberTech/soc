# MCT Security Stack - Final Phase 26 Operator Report

Date: 2026-08-23
Pack: /home/user/mct-p26 (Endpoint Policy Confirmation, Automated Detection Guardrails, Snapshot Restore Validation, Credential Recovery, Capacity Verification, v1.3.0 Readiness)
Stack root: /opt/mct-security-stack | Release: v1.2.0 (v1.3.0 staged)

## Executive summary

Phase 26 delivered: **OpenSearch snapshot restore drill PASSED** (first index-level restore
proof - p26-restore scratch, 114/114 docs, mappings/settings validated, cleaned up);
**Zeek Class A hard guardrails implemented** (rate-limit 5/day + proven kill switch + cron);
**retention relief observed, not assumed** (archives 08-07/08/09 deleted by ISM; node disk
84.7% -> 79.5%, below the low watermark); **agent 013 reconnected** (root cause: endpoint
wake + agent retry after the P25 manager restart) with fleet 3/3 active; **agent 015 closed
out** (24h window: 33 archive docs vs 1.4M/day pre-fix, 0 buffer, bounded telemetry);
**replay/idempotency gap documented** (datastore dedup node = Shuffle UI step; guardrail as
backstop); and **v1.3.0 readiness gates prepared** (approval-pending). Endpoint policy
confirmation (013/014 marker), credential rotations, and NetFlow/Redis/Greenbone/canarytokens
remain owner/replacement-gated.

## Endpoint workstreams

- **013**: reconnected (01:59 08-23); reconnect lag root-caused to endpoint wake + retry
  backoff. Re-apply of the corrected 4.91 policy pending operator RMM run (script ready;
  EID7 currently 0/30m).
- **014**: policy accepted (rc=0, P25); restart + marker check pending operator. EID7 0/30m;
  EID1/10 flowing.
- **015**: **CLOSED OUT (PASS)** - keepalive continuous, archives 33 (~21.7h window), 0
  queue-full, 69 bounded macos events; scorecard-eligible.
- Throttle retirement: per-endpoint criteria (marker + EID7 < 2K/day + 24h clean buffer);
  retained until confirmation.

## Windows dashboards / PS 4104

- W1/W2 activation gated on policy confirmation (quality-aware: throttle/policy/buffer/
  freshness surfaced).
- PS 4104: preflight complete (GPO policy, privacy note, 4104 rule, rollback, pilot 012);
  pilot apply approval-pending.

## Zeek Class A guardrails

- **Inventory**: workflow eb937a37 (webhook -> log -> IRIS alert), integration
  rule_id 122001-122003 live.
- **Hard rate-limit**: `ops/scripts/zeek-classa-guardrail.sh` (cron */15) counts 24h
  executions; >= 5 -> comments the Wazuh integration (kill switch) + restarts container +
  logs. Manual disable/enable.
- **Kill switch PROVEN**: disable -> live config block commented (analysisd -t rc=0);
  enable -> restored. Tested end-to-end.
- **Dedup**: datastore node design (key rule.id+src+dst+1h, TTL 1h, drop-branch) requires the
  Shuffle UI (API catalog unavailable); interim guardrail backstop. Replay test documents the
  current non-idempotent behavior honestly.
- Real window: 0 real cases (clean network).

## Suricata

- Staged (1 event, quiet). No forced traffic. Severity rules gated.

## Snapshot restore drill (PASSED)

- Snapshot snap-20260823-0017 (SUCCESS, 51 indices); test index
  wazuh-states-inventory-protocols-wazuh (114 docs).
- Restored under `p26-restore-*` with include_global_state:false, include_aliases:false,
  wait_for_completion:true. Validated: 114/114 docs, 4/4 fields, green, no aliases, search
  OK, source + snapshot intact. Scratch index deleted after evidence.

## Retention / capacity

- **Deletes observed**: archives 08-07/08/09 deleted by archives-14d; 08-10 + 08-15..18 to
  follow (~09-01).
- Node fs **79.5%** (below 85% low watermark; was 84.7%). Root 79%. Cluster green (256
  shards), 0 read-only blocks. No watermark changes (capacity via retention, per policy).

## Credentials / PVE / NetFlow / owner items

- VT key, indexer rotation, PVE222 token: blocked (replacement/approval). Post-rotation
  validation baseline healthy.
- NetFlow: scope blocked; alerts unarmed. Redis: owner-blocked (level 3). Greenbone:
  unsigned. Canarytokens: blocked (hosted account) - no fabricated deployment.

## Billing / scorecard / monthly ops

- Fleet 3/3 covered + active; 015 quality clean; 013/014 quality pending marker confirmation.
- Scorecard finalized (draft-final) with internal + client-safe variants; monthly ops run
  complete (health, backups, endpoints, routing+guardrails, retention, capacity, credentials,
  authorizations, scorecard, billing, retrospective).

## Audits

- Full system + code/security/supply-chain regression audits: **no regressions**; CI/secret/
  health green; guardrail syntax + mechanism tested; drift zero; image policy PASS.

## Remaining risks (top)

1. 013/014 policy marker confirmation pending (operator check) - EID7 quiet, throttle
   retirement deferred.
2. Dedup idempotency gap at ingest (datastore node = Shuffle UI; guardrail backstop).
3. Guardrail count source reliability for real posts (to confirm on first real alerts).
4. Blocked replacements/approvals: VT key, indexer rotation, PVE222, NetFlow scope, Redis,
   Greenbone, canarytokens.
5. v1.3.0 release approval-pending.

## Recommended Phase 27 roadmap

1. **Endpoint confirmation**: 013 re-apply + 014 restart/check (marker) -> validate EID7 ->
   retire throttles per endpoint -> activate W1/W2 dashboards + PS 4104 pilot.
2. **Dedup node**: add the datastore dedup/rate-limit nodes in the Shuffle workflow UI
   (design provided) -> replay test proves idempotency.
3. **v1.3.0 release** (approval): RELEASE-NOTES draft, bundle rebuild, tag, GitHub release.
4. **Credential recovery**: VT key, indexer rotation (approval), PVE222 token -> post-rotation
   validation.
5. **NetFlow scope** -> arm alerts; **Redis** VPS fix; **Greenbone** signed auth;
   **Canarytokens** hosted account.
6. **DR**: full-scope snapshot restore drill (multi-index, timings, RTO formalization).
7. **Capacity watch**: confirm 08-10/08-15..18 deletes land; monitor node fs ~75% plateau.
8. **Case window**: continue Zeek real-case measurement; validate guardrail on first real alert.

## Files added (summary)

- 45 Phase 26 deliverables (00-44): preflight, change register, endpoint (013 reconnect/
  reapply/policy/volume, 014 restart/policy/volume, throttle retirement), windows dashboard/
  PS4104 (preflight/pilot/validation), 015 closeout + scorecard release, Zeek (workflow
  inventory, dedup design, rate-limit guardrail, kill-switch/replay test, real window),
  snapshot restore (plan/test-restore/validate/cleanup - drill PASSED), retention observation
  + capacity validation, credentials + post-validation, netflow/redis/greenbone/canarytokens,
  billing/scorecard/monthly ops, audits, v1.3.0 readiness, repo commit, final report, master
  status. New artifact: `ops/scripts/zeek-classa-guardrail.sh` + cron.

## No secrets

All reports cite paths/variable names only; no secret values printed.