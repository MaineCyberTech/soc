# Phase 40 Post-Template Index Detection

**Report ID:** phase40-04-post-template-index-detect
**Phase:** 40
**Title:** Phase 40 DETECTED — First Post-Template Archive Index `wazuh-archives-4.x-2026.08.26` (Creation 00:00:02.420Z)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:54:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Claims:** VERIFIED (MEASURED)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-04-post-template-index-detect.md`

---

## 1. Purpose

Gate C1/C2 of the phase39-22 checklist: detect and characterize the first index created
under `wazuh-archives-fieldlimit`. Everything below is MEASURED this session.

## 2. Index Exists — `_cat/indices` Excerpt (MEASURED ~01:33Z)

```
$ curl -sk -u admin:[REDACTED] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?v&h=health,status,index,docs.count,store.size,creation.date.string"
health status index                         docs.count store.size creation.date.string
green  open   wazuh-archives-4.x-2026.08.19    2519199      3.8gb 2026-08-19T00:00:01.954Z
green  open   wazuh-archives-4.x-2026.08.18    2397160        2gb 2026-08-18T00:00:01.869Z
green  open   wazuh-archives-4.x-2026.08.17    2633464      2.4gb 2026-08-17T00:00:02.094Z
green  open   wazuh-archives-4.x-2026.08.16    2150542      1.2gb 2026-08-16T00:00:01.702Z
green  open   wazuh-archives-4.x-2026.08.22     599196    707.8mb 2026-08-22T00:00:02.243Z
green  open   wazuh-archives-4.x-2026.08.21    1423025      1.2gb 2026-08-21T00:00:03.199Z
green  open   wazuh-archives-4.x-2026.08.20    1486141      1.2gb 2026-08-20T00:00:02.537Z
green  open   wazuh-archives-4.x-2026.08.15    3007251      1.8gb 2026-08-15T21:00:44.251Z
green  open   wazuh-archives-4.x-2026.08.26      86940     76.9mb 2026-08-26T00:00:02.420Z   ← TARGET
green  open   wazuh-archives-4.x-2026.08.25     882772    570.9mb 2026-08-25T00:00:02.400Z
green  open   wazuh-archives-4.x-2026.08.24     248458    139.8mb 2026-08-24T00:00:02.733Z
green  open   wazuh-archives-4.x-2026.08.23     170521     98.3mb 2026-08-23T00:00:02.625Z
```

- **Exact name:** `wazuh-archives-4.x-2026.08.26`
- **Creation timestamp:** **`2026-08-26T00:00:02.420Z`** (`creation.date.string`;
  epoch `1787702402420`) — inside the predicted window 00:00:02.000–04.000Z, one day
  after its predecessor at .400Z: pure daily-rollover behavior.
- Note the 08.15 outlier stamp (21:00:44Z) is the known rebuild-time manual index.

## 3. Identity and Topology (MEASURED)

```
$ .../wazuh-archives-4.x-2026.08.26/_settings?flat_settings=true
"index.creation_date" : "1787702402420"
"index.uuid" : "PYoV36MlRKO9UIYsgGNUBg"
"index.number_of_shards" : "1"      / "index.number_of_replicas" : "1"
"index.replication.type" : "DOCUMENT"

$ _cat/shards/wazuh-archives-4.x-2026.08.26?v
index                          shard prirep state   docs  store ip         node
wazuh-archives-4.x-2026.08.26  0     p      STARTED 97132 53.1mb 172.18.0.7 wazuh3.indexer
wazuh-archives-4.x-2026.08.26  0     r      STARTED 97132 40.1mb 172.18.0.5 wazuh1.indexer
```

1 primary + 1 replica, both STARTED — identical shape to 08.25; confirms checklist
note C5 that wazuh-main's 3-shard setting has never applied to archives (priority).
Aliases: `{}` (none) — verified via `_alias`; matches simulation output.

## 4. Template Match Confirmation

Two methods per C2: (a) live effective settings carry fieldlimit's exact keys
(phase40-06); (b) re-simulation still resolves to fieldlimit with the expected
overlapping list (phase40-05). Creation-time resolution is additionally proven by
arithmetic: only fieldlimit defines limit=2000 anywhere in the cluster, and the index
was born with it.

## 5. Verdict

**DETECTED — VERIFIED.** Name, timestamp, topology, and alias state all match the
P39 predictions exactly.
