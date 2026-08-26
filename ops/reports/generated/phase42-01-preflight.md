# Phase 42 Preflight

**Report ID:** phase42-01-preflight
**Phase:** 42
**Title:** Full Preflight — Repo 6579919 Clean-at-HEAD, v1.3.0+v1.3.1 Tags Pushed/On-Box, Disk 84%, OS GREEN, Field CRIT-Legacy Situation (Rejections Resumed on Legacy Index 07:02–07:45Z), Monitor Cycles incl. Real ERROR Catch, Repair-Churn Fix Proven, Blockers Register
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-01-preflight.md`

---

## 1. Repository & release state — verified live

```
$ git log --oneline -1        → 6579919 Phase 41: field-growth contained at source, custody closed byte-exact, monitor matured, packet lane honestly deferred
$ git status --short          → M config/shuffle-tls/nginx-shuffle-proxy.conf
                                M ops/evidence/p40-field-growth-state.tsv   (append-only monitor state)
                                M ops/scripts/shuffle-repair-network.sh     (G42-08 churn fix)
                             ?? ops/releases/v1.3.1/                        (G42-11 asset, gitignored-by-design bytes)
                             ?? ops/scripts/p42-field-cycle-adjudicate.sh   (G42-02 staged)
$ git tag | tail              → v1.2.0 v1.3.0 v1.3.1
$ git ls-remote --tags origin → refs/tags/v1.3.0^{} = c726182… ; refs/tags/v1.3.1 = 71701dfd ; refs/tags/v1.3.1^{} = 6579919…
```

Both release tags are **pushed and on-box**. Working-tree deltas are exactly this phase's
intentional artifacts; no drift.

v1.3.1 asset custody (`ops/releases/v1.3.1/MANIFEST.md`): `v1.3.1-from-tag.tar.gz`,
sha256 `4e6c3712ba88f5ab925a2049d5d214fb55222a602c79738028ffee9a23ebf596`, built
2026-08-26T07:52:53Z via `git archive` from tag; publication **BLOCKED-AWAITING-GITHUB-TOKEN**.

## 2. Host & cluster health

| Check | Value at 08:34Z | Verdict |
|---|---|---|
| Disk `/` | 119G used / 24G avail (84%) | GREEN (watch) |
| OpenSearch API | HTTP 200 on `https://127.0.0.1:9200` | GREEN |
| ISM policy `wazuh-archives-14d` | present, states `[hot, delete]` | GREEN |
| Dashboards :443 | HTTP 200 `/app/login`, `osd-name: wazuh.dashboard`, x-frame-options sameorigin | GREEN |

## 3. Field situation — CRIT on legacy index, with materialized interim risk

Fresh guardrail run (embedded verbatim):

```
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1852 limit=2000 verdict=CRIT growth_per_day=0.0
branches: data:1747 syscheck:36 rule:27 GeoLocation:8 agent:6 decoder:6
```

Timeline today (state TSV): `01:44=1604 → 02:43=1706 → 04:41=1766 → 07:37=1852`
(growth_per_day printed 1175.5 at the 07:37 read). Attribution and the raw-vs-basis
reconciliation are reports 11 and 10 respectively. Summary: containment IS working —
zero new full-stats docs since cutover (report 07) — but the legacy index mapping is
immutable and still carries `data.stats` legacy baggage (877 raw / 441 basis leaves), so
today's counter rides on it.

**MATERIALIZED RISK (fresh discovery 08:00–08:35Z window):** field-limit rejections
RESUMED against the legacy index only:

```
$ docker logs --timestamps multi-node-wazuh.master-1 --since 2026-08-26T03:53:00Z | grep -c "Limit of total fields"
2746      # burst histogram: 07:02=1366, 07:03=14, 07:45=1366; zero since 07:45:42Z; worker-1 = 0
```

Cause: OS internal counter ≈ objects(126) + leaves+multi-fields(1852) = ~1978 vs cap
2000 → novel-schema bursts (agent016 `mct-packet-sensor` syscollector packages at 07:02;
vuln-detector solved notices at 07:45) exhausted headroom and whole batches rejected.
Bounded blast radius: archives lane on an index that dies at midnight; alerts lane
unaffected. Full analysis: reports 08, 11, 12.

## 4. Monitor posture

- Delivery monitor (`p39-iris-delivery-check.sh`, */15): log fresh (mtime 08:30Z),
  **26 SUMMARY cycles** recorded including **2 real ERROR lines caught**
  (`ERROR: no API response for eb937a37-…`) — real-catch evidence, not synthetic.
- Watchdog (`p41-monitor-watchdog.sh` @ 3,18,33,48 * * * *): watchdog log EMPTY =
  zero stalls since arming.
- Field guardrail (`p40-field-growth-check.sh`): 9 cycles logged today, verdict ladder
  WARN→WARN→CRIT captured with timestamps.

## 5. Fix verification this morning

- **Repair-churn FIXED + proven**: `shuffle-repair-network.sh` now restarts frontend only
  when actually reconnected. Live proof:
  `PASS: all Shuffle-like containers are on mct-security … NO-OP: frontend network intact; no restart needed`.
- **nosniff**: single-source-of-truth moved container-side; proxy-level duplicate removed
  in working tree (`nginx-shuffle-proxy.conf`: `-add_header X-Content-Type-Options nosniff always;`);
  `shuffle-frontend` nginx.conf serves it at lines 57/98 (verified via docker exec).
- **VT hardened 640**: integration perms verified container-side earlier cycle; carried as DONE (report 02).

## 6. Standing items

| Item | State |
|---|---|
| Packet platform-defect | STANDING — lane test-only (commit 6579919 "packet lane honestly deferred"); production apply blocked upstream (phase31v2-25/26 chain) |
| Agents 013/015 remediation batch | OWNER-GATED (phase41-82/83 gap register) |
| v1.3.1 GitHub publication | BLOCKED-AWAITING-TOKEN |
| Dashboard session | LOGIN-GATED — queries validated via API, visual render pending human session |

## 7. Blockers list (exit criteria for Phase-42 close)

1. B-42-1: index birth + adjudication run (auto-resolves ~00:00Z+1).
2. B-42-2: owner batch decisions (agents 013/015).
3. B-42-3: GitHub token for v1.3.1 publication.
4. B-42-4: dashboard login session for render-proof.
None block tonight's adjudication.
