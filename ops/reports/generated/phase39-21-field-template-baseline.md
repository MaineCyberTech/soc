# Phase 39 Field-Template Baseline

**Report ID:** phase39-21-field-template-baseline  
**Phase:** 39  
**Title:** Field-Limit Template Baseline — `wazuh-archives-fieldlimit` Body, Priority/Overlap Audit, and Pre-Proof Rejection Counters  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:58:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-21-field-template-baseline.md`  
**Retention Class:** LONG

---

## 1. Purpose

Freezes the complete baseline for the field-template proof arc (phase39-21…28). The fix
template `wazuh-archives-fieldlimit` was applied during Phase 38 (2026-08-24 session,
PUT acknowledged:true). Because index settings are inherited **at creation time**, no
existing archive index benefits from it; proof is therefore time-gated to the first
matching index roll (`wazuh-archives-4.x-2026.08.26`, expected ~00:00:02 UTC Aug-26).
Everything that CAN be verified before that roll is verified here with live output.

## 2. Template Body — MEASURED (live GET)

```
$ curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template/wazuh-archives-fieldlimit" | python3 -m json.tool
```

```json
{
    "index_templates": [
        {
            "name": "wazuh-archives-fieldlimit",
            "index_template": {
                "index_patterns": [
                    "wazuh-archives-4.x-*"
                ],
                "template": {
                    "settings": {
                        "index": {
                            "mapping": {
                                "total_fields": {
                                    "limit": "2000"
                                }
                            },
                            "plugins": {
                                "index_state_management": {
                                    "policy_id": "wazuh-archives-14d"
                                }
                            }
                        }
                    }
                },
                "composed_of": [],
                "priority": 320
            }
        }
    ]
}
```

Annotated:

| Property | Value | Note |
|---|---|---|
| index_patterns | `["wazuh-archives-4.x-*"]` | exact daily archive family |
| priority | 320 | highest of all templates matching this pattern (see §3) |
| mapping.total_fields.limit | `"2000"` | the fix (default otherwise = 1000) |
| ISM policy_id | `wazuh-archives-14d` | carried forward deliberately so the new template does not strip retention policy assignment |
| composed_of | `[]` | standalone template, no component templates |
| rollover settings | **absent** | body carries NO rollover_* / alias config; rollover behavior unchanged from p19-retention posture (policy-driven only) |

## 3. Overlapping-Template Audit — MEASURED (live GET)

```
$ curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); [print(t['name'], t['index_template'].get('priority'), t['index_template'].get('index_patterns')) for t in d.get('index_templates',[])]"
```

Full composable inventory (22 templates). Only three match `wazuh-archives-4.x-*`:

| Template | Priority | Patterns | Conflict-relevant contents |
|---|---|---|---|
| **wazuh-archives-fieldlimit** | **320** | `wazuh-archives-4.x-*` | limit=2000, ISM=wazuh-archives-14d |
| wazuh-archives-p19-retention | 310 | `wazuh-archives-4.x-*` | ISM policy_id=`wazuh-archives-14d` only (full body fetched live) |
| wazuh-main | 300 | `wazuh-alerts-4.x-*`, `wazuh-archives-4.x-*` | limit=**10000**, refresh_interval 5s, number_of_shards 3, auto_expand_replicas 0-1, ISM policy_id=**wazuh-retention**, large query.default_field list |
| wazuh (**legacy** `_template`) | order 0 | same pair | mappings carrier; settings contain **no** total_fields / ISM keys (audited live via `_template/wazuh`: `total_fields/ISM settings: {}`) |
| elastiflow-* (5), states-inventory-* (12), wazuh-states-retention | 1–100 | non-matching | out of scope |

Conflict analysis:

1. **No template matching the archive pattern has priority >320** → fieldlimit wins all
   conflicts. Verified empirically by simulation (§4), not inferred.
2. `wazuh-main` would set limit=10000 and ISM=wazuh-retention if it won; it loses on
   both keys (300 < 310 < 320). Its presence is benign today but is a standing hazard:
   any future bump of wazuh-main above 320 silently rewrites both keys. See phase39-27 §5.
3. The legacy `wazuh` template supplies the actual **mappings** for archives indices;
   it holds no total_fields setting, so nothing in the legacy layer can override 2000.
4. Deduction recorded honestly: indices through 08.25 carry NO explicit total_fields
   setting (§5), yet current wazuh-main carries 10000. Therefore wazuh-main's present
   body post-dates 2026-08-25T00:00:02Z creation (installed or modified later), or its
   settings changed after creation. Either way it did not influence existing indices.

## 4. Inheritance Preview — MEASURED (simulate_index, POST)

The authoritative pre-proof: OpenSearch itself resolves tomorrow's composition today.

```
$ curl -s -k -u admin:[REDACTED-PW] -XPOST \
  "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.26"
```

```json
{"template":{"settings":{"index":{"mapping":{"total_fields":{"limit":"2000"}},
"plugins":{"index_state_management":{"policy_id":"wazuh-archives-14d"}}}},
"aliases":{}},
"overlapping":[
 {"name":"wazuh-main","index_patterns":["wazuh-alerts-4.x-*","wazuh-archives-4.x-*"]},
 {"name":"wazuh","index_patterns":["wazuh-alerts-4.x-*","wazuh-archives-4.x-*"]},
 {"name":"wazuh-archives-p19-retention","index_patterns":["wazuh-archives-4.x-*"]}]}
```

Composed result: **limit=2000 + ISM policy wazuh-archives-14d**, aliases empty.
Note: `_simulate_index` composes only the composable layer; runtime mappings will still
arrive from the legacy `wazuh` template as they do today. This simulation is the single
strongest artifact available before midnight and is cited by phase39-23 as pre-captured
proof-of-inheritance.

## 5. Why Rejections Continue Tonight — MEASURED

Existing daily indices inherit settings only at creation. The active write target
(08.25) predates the template:

```
$ curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.25/_settings?filter_path=**.total_fields*&pretty"
{ }
```

Empty result ⇒ no explicit limit on 08.25 ⇒ engine default **1000** governs, and the
mapping is already saturated at ~999–1000 fields (measured across 08.23–08.25, see
phase39-26). Any document introducing one unseen path is rejected with status=400 until
the write target rolls to an index created under the 2000-limit template.

Creation timestamps confirm the roll timing model:

```
$ curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?v&h=index,creation.date.string" | sort | tail -3
wazuh-archives-4.x-2026.08.23 2026-08-23T00:00:02.625Z
wazuh-archives-4.x-2026.08.24 2026-08-24T00:00:02.733Z
wazuh-archives-4.x-2026.08.25 2026-08-25T00:00:02.400Z
```

Expected window for 08.26: **2026-08-26T00:00:02.000–00:00:04.000Z**
(historical spread across 11 indices: 00:00:01.7–00:00:03.2; outlier 08.15 created
21:00:44 during stack rebuild).

## 6. Pre-Proof Rejection Counters — MEASURED (live, ~22:50–22:55Z)

Channel clarification (important for tomorrow's comparison): rejections are Filebeat
stdout events, NOT ossec.log entries.

```
$ docker exec multi-node-wazuh.master-1 sh -c "grep -c 'Limit of total fields' /var/ossec/logs/ossec.log"
0

$ docker logs multi-node-wazuh.master-1 2>&1 | grep -c "Limit of total fields"
9109
```

Rate windows (same session):

| Window | Count | Rate |
|---|---|---|
| last 60 min (`--since 60m`) | 8960 | ≈149/min |
| last 10 min (`--since 10m`) | 1503 | ≈150/min |
| projection at 150/min | — | ≈9000/hr ≈216k rejected events/day |

Representative signature (tail -2, truncated):

```
2026-08-25T22:50:57.468Z	WARN	[elasticsearch]	elasticsearch/client.go:408	Cannot index event
publisher.Event{... "event":{"dataset":"wazuh.archives"... "log":{"file":{"path":"/var/ossec/logs/archives/archives.json"}...
(status=400): {"type":"illegal_argument_exception","reason":"Limit of total fields [1000] has been exceeded"}
```

Reconciliation note: P38 records "~147/min ≈14k/day". Measured tonight, 147–150/min
compounds to ≈212–216k/day, not ≈14k/day; the P38 daily figure appears to be an
arithmetic slip or a different unit. Both figures retained here; tomorrow's flatline
check (phase39-24) does not depend on which is correct — only on the counter reaching
zero against 08.26.

## 7. Cluster Context — MEASURED

```
status:green, number_of_nodes:3, active_shards:274 (145 primary), unassigned:0, active_shards_percent:100.0
allocation: wazuh1/2/3.indexer — 91–92 shards each, disk.percent 83 (23.7GB avail of 147.4GB)
```

Disk 83% matches the ops-window record (preflight noted 83→84% intra-hour drift).
Post-fix disk relief is also time-gated: rejection-stop reduces indexer-side write-fail
churn but the dominant storage term remains indexed volume.

## 8. Verdict

**COMPLETE.** Template existence, exact body, precedence (320 > 310 > 300 > legacy),
and simulated inheritance (2000 + wazuh-archives-14d) all verified live. Rejection
baseline frozen at ≈150/min ≈9k/hr on the docker-logs channel (ossec.log channel = 0).
Proof arc proceeds per phase39-22 at 2026-08-26T00:00:02Z ±2s.
