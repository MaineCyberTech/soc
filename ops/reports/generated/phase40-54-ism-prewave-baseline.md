# Phase 40 ISM Pre-Wave Baseline

**Report ID:** phase40-54-ism-prewave-baseline
**Phase:** 40
**Title:** Pre-Wave Baseline — Live `_cat/indices` Inventory, 08.15 ISM State (`condition_not_met`), ETA Math, Snapshot Coverage, Disk/Allocation/Blocks/Writes
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-54-ism-prewave-baseline.md`

---

## 1. Fresh archive index inventory — REAL OUTPUT (run 02:18Z)

```
$ curl -sk -u admin:'***' 'https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?v&h=index,status,health,docs.count,store.size'

health status index                         uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   wazuh-archives-4.x-2026.08.19 V8MrMRcVTXOypTjMNYz7yA   1   1    2519199            0      3.8gb          1.9gb
green  open   wazuh-archives-4.x-2026.08.18 ql8qSGuOTAeEfrzGP5Ik-Q   3   1    2397160            0        2gb            1gb
green  open   wazuh-archives-4.x-2026.08.17 T5RkX0yqRNKl_c3ueI7rBQ   3   1    2633464            0      2.4gb          1.2gb
green  open   wazuh-archives-4.x-2026.08.16 cI3D0nwLREOVOjkl_o1Olg   3   1    2150542            0      1.2gb        649.9mb
green  open   wazuh-archives-4.x-2026.08.22 haxHRZjfTb28jDNNFpl8zQ   1   1     599196            0    707.8mb        357.2mb
green  open   wazuh-archives-4.x-2026.08.21 fwwGwr4pQC6Bz_ozcqLytQ   1   1    1423025            0      1.2gb        627.4mb
green  open   wazuh-archives-4.x-2026.08.20 GWT8MoVnQDyGRCpCEAYoWQ   1   1    1486141            0      1.2gb        622.4mb
green  open   wazuh-archives-4.x-2026.08.15 -Br6HnmISduxdrRhPXbYMw   3   1    3007251            0      1.8gb        932.4mb
green  open   wazuh-archives-4.x-2026.08.26 PYoV36MlRKO9UIYsgGNUBg   1   1     128567            0    125.2mb         69.4mb
green  open   wazuh-archives-4.x-2026.08.25 1VrUzd0PTGyAZIQ47xkq_Q   1   1     882772            0    570.9mb        284.8mb
green  open   wazuh-archives-4.x-2026.08.24 LuiE7mB8SUi-2vzdexg4dg   1   1     248458            0    139.8mb         69.8mb
green  open   wazuh-archives-4.x-2026.08.23 e2_DRFGQQzCNvYJva04gAQ   1   1     170521            0     98.3mb         49.1mb
```

12 archive indices, all `green/open`. **08.26 exists** at 125.2 MB (partial day,
128,567 docs, created 2026-08-26T00:00:02Z). Oldest = **08.15, 1.8 GB total /
932.4 MB primary**, 3,007,251 docs.

## 2. ISM state for 08.15 — explain API — REAL OUTPUT

```
$ curl -sk -u admin:'***' 'https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15?show_policy=true'
```

Key fields (abridged from full JSON):

```json
"policy_id":"wazuh-archives-14d",
"index_creation_date":1786827644251,
"state":{"name":"hot","start_time":1787383324399},
"action":{"name":"transition", ... "failed":false,"consumed_retries":0},
"step":{"name":"attempt_transition_step",
        "step_status":"condition_not_met"},
"info":{"message":"Evaluating transition conditions [index=wazuh-archives-4.x-2026.08.15]"}
```

Interpretation:

- Policy attached: `wazuh-archives-14d` (14d hot → delete).
- State machine is live and polling: action=`transition`,
  step=`attempt_transition_step`, status=**`condition_not_met`**.
- `failed:false, consumed_retries:0` → zero error pressure.

## 3. ETA math — FORECAST

- Created: epoch `1786827644251` ms = **2026-08-15T21:00:44Z**
- Condition: `min_index_age: 14d`
- First deletion ETA = creation + 14 d = **2026-08-29T21:00:44Z**
- At report time 2026-08-26T02:18Z: **~3.78 days remain**.
- Expected first victim: `wazuh-archives-4.x-2026.08.15` (~932 MB primary,
  ~1.8 GB on-disk with replica), followed by 08.16 (+24 h) etc.

**Label: FORECAST.** No deletion has occurred yet; this section projects, it does not attest.

## 4. Snapshot coverage of the candidate — REAL OUTPUT

```
$ curl -sk -u admin:'***' 'https://127.0.0.1:9200/_cat/snapshots/wazuh-backup?v&s=id' | tail -3

snap-20260825-1517 SUCCESS 1787671024  15:17:04 ... 56 shards ...
snap-20260825-2017 SUCCESS 1787689025  20:17:05 ... 56 shards ...
snap-20260826-0017 SUCCESS 1787703424  00:17:04   00:17:11   7.2s   58   106   0   106
```

Latest snapshot `snap-20260826-0017`: **SUCCESS**, 106/106 shards, 0 failed.
Body inspection confirms `wazuh-archives-4.x-2026.08.15` **and**
`wazuh-archives-4.x-2026.08.26` are both members (58 indices total). The
deletion candidate is therefore recoverable post-deletion via restore.
Second repo (`do-spaces`, s3) reported healthy in P39/P40 backup audits.

## 5. Disk / allocation / blocks / writes

```
$ df -h / | tail -1
/dev/sda1       148G  116G   26G  82% /

$ curl ... _cat/allocation?v
shards disk.indices disk.used disk.avail disk.total disk.percent host           ip           node
    94        8.2gb   121.7gb     25.7gb    147.4gb           82 wazuh2.indexer 172.18.0.4 wazuh2.indexer
    94        6.6gb   121.7gb     25.7gb    147.4gb           82 wazuh1.indexer 172.18.0.5 wazuh1.indexer
    94        6.8gb   121.7gb     25.7gb    147.4gb           82 wazuh3.indexer 172.18.0.7 wazuh3.indexer
```

- Host FS 82% used (116 G of 148 G); indexer nodes agree (82%).
- Read-only block check:
  `{"defaults":{"cluster":{"blocks":{"read_only":"false"}}}}` — **no flood
  write-block active**; writes continue normally (08.26 grew to 128 k docs).

## 6. Verdict

Baseline captured pre-wave: candidate identified (08.15, ~932 MB primary),
mechanism armed and polling (`condition_not_met`), recovery path proven
(snapshot membership), headroom 26 GB, blocks clear. Next milestone =
**2026-08-29T21:00:44Z** (FORECAST) — see phase40-55 observation plan.
