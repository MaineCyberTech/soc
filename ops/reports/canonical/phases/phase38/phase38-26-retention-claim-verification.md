# Phase 38-26 — Retention / ISM Claim Verification

**Report ID:** phase38-26-retention-claim-verification
**Phase:** 38
**Title:** Phase 38-26 — Retention / ISM Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-26-retention-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:35 UTC
**Scope:** Verify retention policy existence/attachment/state, deletion behavior, disk/watermarks/allocation, and forecast-vs-realized labeling.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | ISM policy exists for archives (14d) | **VERIFIED** | `_plugins/_ism/policies` |
| 2 | Policy attached to daily archive indices | **VERIFIED** | explain output on `wazuh-archives-4.x-2026.08.15` |
| 3 | Policy state machine functioning (hot→delete) | **VERIFIED (engine)** — no deletions due yet | transition evaluated, `condition_not_met` at 10 d < 14 d |
| 4 | Deletions are occurring per policy | **CONTRADICTED as "realized"** | oldest archive = Aug 15 (10 d old); zero indices deleted by policy to date |
| 5 | Disk pressure persists (~84 %) | **VERIFIED** | allocation 83 %/node, host 83–84 %, ~24.6 GB avail |
| 6 | Snapshot repo available for DR | **CONTRADICTED / GAP** | `_cat/snapshots/*` → repository_missing_exception |

---

## Evidence Detail

### 1. Policies present
```
$ curl -sk -u admin:*** https://127.0.0.1:9200/_plugins/_ism/policies
elastiflow            states [hot, delete]   delete action in 'delete' state
wazuh-archives-14d    states [hot, delete]   delete action
wazuh-retention       states [hot, delete]   delete action
wazuh-states-retention states [hot, delete]  delete action
```
Four policies defined; the archives policy is named exactly `wazuh-archives-14d`. **VERIFIED.**

### 2–3. Attachment & live state on the sampled index
```
$ curl -sk -u admin:*** ".../_ism/explain/wazuh-archives-4.x-2026.08.15"
policy_id: wazuh-archives-14d          enabled: true
index_creation_date: 1786827644251     (= 2026-08-15)
state.name: hot                        start_time: 1787383324399
action: transition, failed:false       step: attempt_transition_step
step_status: condition_not_met         message: "Evaluating transition conditions"

$ policy detail:
hot → delete under {min_index_age: 14d}; delete state carries the delete action
```
The engine is actively evaluating the transition (attempted again this evening); it correctly refuses because the index is 10 days old against a 14-day minimum. This is correct behavior, not a fault. **VERIFIED.**

### 4. Realized deletions — none yet
```
$ _cat/indices/wazuh-archives-*?h=index,docs.count,store.size&s=index
2026.08.15  3,007,251 docs  1.8gb   ← OLDEST retained archive
2026.08.16  2,150,542        1.2gb
... contiguous through ...
2026.08.25    709,247        477.9mb
```
Archive coverage begins exactly at Aug 15 — i.e., data from the pre-policy era is absent (consistent with an earlier manual cleanup wave) and the policy has not yet crossed any 14-day boundary since attachment. Any report describing deletions as *already realized by this policy* mislabels forecast as realized. First eligible expiry ≈ 2026-08-29 for the Aug-15 index. **Claim of realized deletions: CONTRADICTED; claim of pending first run: consistent.** Note also alerts indices retain full back-history to Aug 7 — the 14d policy applies to the archives stream attached here, and alerts-side retention was not exercised.

### 5. Disk / allocation
```
$ curl -sk -u admin:*** .../_cat/allocation?v
shards disk.indices disk.used disk.avail disk.total disk.percent node
  92      8.1gb      122.7gb    24.6gb   147.4gb     83      wazuh2.indexer
  91      6.5gb      122.7gb    24.6gb   147.4gb     83      wazuh1.indexer
  91      6.6gb      122.7gb    24.6gb   147.4gb     83      wazuh3.indexer

$ df -h /
/dev/sda1 148G 117G 25G 83% /
```
All three indexer nodes at 83 %; host filesystem 83–84 %. Matches the reported ~84 % state within rounding. No watermark breach observed (cluster GREEN, 274/274 shards active, 100 % active). **VERIFIED.**
```
cluster health: status=green, nodes=3, active_shards=274, unassigned=0,
active_shards_percent=100.0
```

### 6. Snapshot capability (DR dependency)
```
$ curl -sk -u admin:*** .../_cat/snapshots/*?v
{"error":{"root_cause":[{"type":"repository_missing_exception","reason":"[*] missing"}],...}}
```
No snapshot repository is registered cluster-wide. Even though cron runs `/opt/wazuh-docker/multi-node/ops/scripts/elastic-snapshot.sh` nightly (03:30), nothing is retrievable through the cluster API now. This materially weakens any retention/restore narrative that presumes snapshot-backed recovery. **CONTRADICTED / open gap.**

### Memory/disk context
`free -m`: 15553 total, 11952 used, 3600 available; swap pressure noted in ops state (64 %). Not directly a retention claim but relevant to watermark headroom planning.

---

## Verification Commands Used
```bash
curl -s -k -u admin:*** "https://127.0.0.1:9200/_plugins/_ism/policies"
curl -s -k -u admin:*** "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"
curl -s -k -u admin:*** "https://127.0.0.1:9200/_plugins/_ism/policies/wazuh-archives-14d"
curl -s -k -u admin:*** "https://127.0.0.1:9200/_cat/indices/wazuh-*?h=index,docs.count,store.size&s=index"
curl -s -k -u admin:*** "https://127.0.0.1:9200/_cat/allocation?v"
curl -s -k -u admin:*** "https://127.0.0.1:9200/_cluster/health"
curl -s -k -u admin:*** "https://127.0.0.1:9200/_cat/snapshots/*?v"
df -h / ; free -m
crontab -l | grep -iE "snapshot|tmp"
```

## Summary
Policy design and attachment are sound and the ISM engine is correctly evaluating transitions; however **no policy-driven deletion has actually occurred yet**, so any "retention working" phrasing must be downgraded to "armed, first expiry pending (~Aug 29)". Disk sits at 83–84 % with only ~25 GB headroom across indexer nodes, and **no snapshot repository is registered**, contradicting snapshot-backed restore assumptions. Forecast-vs-realized language in prior reports needs correction.

## No secrets
