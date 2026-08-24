# MCT Security Stack - Final Phase 27 Operator Report

Date: 2026-08-24
Pack: /home/user/mct-p27 (Endpoint Telemetry Certification, Workflow-Native Idempotency, Multi-Index Recovery Validation, Credential Recovery, Capacity Plateau Verification, v1.3.0 Release)
Stack root: /opt/mct-security-stack | Release: v1.2.0 (v1.3.0 staged)

## Executive summary

Phase 27 delivered: **multi-index OpenSearch restore drill PASSED** (3 states indices under
`p27-restore-*`, cross-index query validated, exact-prefix cleanup, sources + snapshot
intact) - the third DR drill type; **Shuffle workflow backed up and versioned** with the
dedup/rate-limit/malformed-branch specs documented (the API surface strips node/condition
edits, so native implementation is a UI step) and the **cron guardrail failover re-verified**
as the independent backstop; **endpoint certification advanced** (015 certified; 013/014
PARTIAL with strong volume evidence - EID7 0/30m, EID1 healthy - marker confirmation pending
operator); **retention rolling** (08-10 deleted; next wave 08-29..09-01) with the **capacity
plateau identified** (81%, ~76-78% projected); and **v1.3.0 release gates prepared**
(approval-pending). Credential rotations, NetFlow scope, Redis, Greenbone, canarytokens
remain owner/replacement-gated.

## Endpoint certification (013/014)

- Both: EID7 0/30m sustained, EID1 flowing (39/7 per 30m), buffers clean. Marker confirmation
  (`sysmon -s` dump after re-apply/restart) pending operator - certification PARTIAL until
  then. Throttle retirement criteria defined per endpoint (retain until certified).
- 015: certified (bounded telemetry; 33 archive docs/24h vs 1.4M/day pre-fix).

## Windows / PS 4104

- W1/W2 dashboards gated on certification (quality-aware panels specified).
- PS 4104 pilot: approval-pending; enable/review/decision methods prepared (privacy +
  volume review before any fleet-wide rollout).

## Shuffle / Zeek

- Workflow backed up + versioned (redacted export saved; update API verified for rollback).
- Native dedup (datastore key rule.id+src+dst+1h, TTL 1h, drop branch), daily rate limit
  (>=5 -> notify + suppress), malformed branch (reject + metric, no IRIS) - **UI-editor
  implementation specs**; API does not support these edits (conditions stripped).
- Cron guardrail (rate limit + kill switch) failover **re-verified** (disable/enable +
  analysisd -t clean). Real case window: 0 real Class A alerts (clean network).

## DR / recovery

- **Multi-index restore drill PASSED**: 3 states indices from snap-20260824-0517 restored
  under p27-restore-* (include_global_state/aliases false), validated per-index
  (114/447/2248 snapshot-consistent; mappings 4/9/3 match), cross-index query (2809 hits),
  no aliases/blocks, then exact-prefix cleanup; sources + snapshot intact.
- RTO/RPO evidence updated: RPO <= 24h (daily bundle + 5-hourly snapshots); RTO per-scope
  (config bundle < 1 min; small-index restore seconds); full-cluster RTO unclaimed.

## Retention / capacity

- 08-10 deleted by archives-14d; remaining 08-15..18 (~7.4GB) delete ~08-29..09-01.
- Daily archive growth collapsed (~1.2GB/day -> ~100MB/day). Node disk 81% (plateau band
  ~76-81%; projected ~76-78% after next wave). No watermark changes; no capacity action.

## Credentials / owners

- VT key, indexer rotation, PVE222 token: blocked (replacement/approval); post-credential
  baseline healthy. NetFlow scope/arming, Redis, Greenbone, canarytokens: owner/approval-gated.

## Billing / scorecard / monthly ops

- Fleet 3/3 covered + active; 015 certified; 013/014 coverage with quality pending marker.
- Scorecard released (draft-final) with internal + client-safe variants. Monthly ops complete
  (health, backups, endpoints, routing+guardrail, DR drills, retention, capacity, credentials,
  authorizations, billing, retrospective).

## Audits

- Full system + code/security/supply-chain regression audits: **no regressions**; CI/secret/
  health green; drift zero; image policy PASS; guardrail + backup verified.

## Remaining risks (top)

1. 013/014 marker confirmation pending (operator) - certification PARTIAL; throttle retirement
   deferred.
2. Native Shuffle dedup/rate-limit/malformed = UI implementation; cron guardrail is the
   backstop (proven).
3. Blocked replacements/approvals: VT key, indexer rotation, PVE222, NetFlow scope, Redis,
   Greenbone, canarytokens.
4. v1.3.0 release approval-pending.

## Recommended Phase 28 roadmap

1. **Endpoint certification completion**: operator runs re-apply/restart + `-s` dump on
   013/014 -> PASS -> retire throttles -> activate W1/W2 dashboards.
2. **Shuffle UI implementation**: add datastore dedup + daily counter + malformed branch in
   the workflow editor (specs provided) -> replay test proves idempotency; guardrail remains
   fail-safe.
3. **v1.3.0 release** (approval): notes, bundle, tag, GitHub release, post-release verify.
4. **Full-cluster DR drill**: scratch-cluster OpenSearch restore (all indices, timings) to
   formalize RTO.
5. **Credential recovery**: VT key, indexer rotation (approval), PVE222 token.
6. **PS 4104 pilot** (approval) -> privacy/volume review -> rollout decision.
7. **NetFlow scope** -> arm alerts; **Redis** VPS fix; **Greenbone** signed auth;
   **Canarytokens** hosted account.
8. **Capacity watch**: confirm 08-15..18 deletes land (~09-01); plateau ~76-78%.

## Files added (summary)

- 49 Phase 27 deliverables (00-48): preflight, change register, endpoint certification
  (013/014 reapply/marker/24h, throttle retirement, windows certification, dashboards,
  PS4104 approval/enable/review/decision), Shuffle (backup, dedup, rate-limit, malformed,
  replay, failover - specs + guardrail test), zeek window, multi-index restore
  (plan/restore/validate/cleanup - PASSED), RTO/RPO update, retention followup, capacity
  plateau, credentials + post-validation, netflow/redis/greenbone/canarytokens,
  billing/scorecard/monthly ops, audits, v1.3.0 gates/release/postrelease, repo commit, final
  report, master status. New artifact: Shuffle workflow backup (redacted) under
  integrations/shuffle/backups/.

## No secrets

All reports cite paths/variable names only; no secret values printed.