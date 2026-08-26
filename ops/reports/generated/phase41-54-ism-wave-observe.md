# Phase 41 ISM Wave Observation — Status PENDING-WINDOW

**Report ID:** phase41-54-ism-wave-observe
**Phase:** 41
**Title:** OBSERVE-41-01 — First Deletion Wave Observation Post Established At T-3.7 Days: Nothing To Observe Yet (Lead Candidate hot/condition_not_met, ETA 2026-08-29T21:00:44Z), Watch Commands Pre-Staged, Forced Intervention Explicitly Ruled Out
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:23:00Z
**Classification:** INTERNAL
**Status:** PENDING (window opens 2026-08-29T21:00:44Z)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-54-ism-wave-observe.md`

---

## 1. Status: PENDING-WINDOW

The observation post for the first policy-driven ISM deletion wave is established
3.7 days before the window opens. Current live state (05:20Z):

```
wazuh-archives-4.x-2026.08.15 → state hot, step condition_not_met, failed:false
message: "Evaluating transition conditions [index=wazuh-archives-4.x-2026.08.15]"
```

There is nothing to observe yet, and that is the correct pre-window state.

## 2. What the wave should look like

1. On/after **2026-08-29T21:00:44Z**, ISM's transition evaluation on 08.15 satisfies
   `min_index_age: 14d`.
2. State flips `hot → delete`; the policy's `delete` action (retry count 3,
   exponential backoff from 1m) removes the index.
3. `_cat indices wazuh-archives-*` no longer lists 08.15; explain reports the index
   gone or unmanaged.
4. Subsequent days remove 08.16, 08.17… one per day sequentially.

## 3. Ready command blocks (pre-staged)

Wave watch (run at ETA and hourly after):

```bash
source /opt/wazuh-docker/multi-node/ops/creds.env
# policy state of lead candidate
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
  "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"
# candidate inventory + sizes
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
  "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?v&s=index"
# ISM-managed index count over time
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
  "https://127.0.0.1:9200/_plugins/_ism/stats/wazuh-archives-14d"
```

Diff against baseline (phase41-56 methodology):

```bash
diff <(curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
      "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?format=json") \
     <(python3 -c "import json;print(json.dumps(json.load(open('/opt/mct-security-stack/ops/evidence/p41-ism-baseline.json'))['candidates_in_wave_order']))")
```

## 4. Non-negotiables during the window

- No forced deletion, ever, regardless of lag past ETA (ISM transitions run on a
  jittered internal interval; hours of slack are normal).
- Any manual ISM/index intervention requires operator sign-off per AGENTS.md.
- All observations land in phase41-55/-56 diff artifacts with raw outputs.
