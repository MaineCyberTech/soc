# Phase 39 ISM Wave Observe — Pending-Window Observation Plan

**Report ID:** phase39-72-ism-wave-observe
**Phase:** 39
**Title:** OBS-39-01 — STATUS PENDING-WINDOW (ETA 2026-08-29T21:00:44Z > Today 2026-08-25); Method Defined; Before/After Inventory Script Ready-to-Run; No Forced Deletion Performed
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** PENDING (observation window not yet open)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-72-ism-wave-observe.md`

---

## 1. Status

**PENDING-WINDOW.** First deletion ETA is **2026-08-29T21:00:44Z**; today is
2026-08-25. The wave is NOT observable yet — no state transition or index removal
can legitimately be recorded today.

## 2. Method (defined now, executed post-ETA)

1. Re-run explain on the candidate:
   ```
   curl -s -k -u admin:'…' \
     "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"
   ```
   Expected outcomes, in order of likelihood:
   - `404` / index_not_found → deletion completed (index gone).
   - `state.name = delete`, action executing → transition happened, watch to completion.
   - still `hot` + `condition_not_met` with new `info` timestamp → ISM job lag; re-check hourly.
2. Confirm absence from inventory:
   ```
   curl -s -k -u admin:'…' "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?h=index,pri.store.size&s=index"
   ```
3. Error/retry watch: capture `retry_info.failed`, `consumed_retries`,
   `info.errors` fields if present; any non-zero retry count escalates to owner.

## 3. Before/after inventory script (inline, ready-to-run)

```bash
#!/usr/bin/env bash
# p39-ism-wave-inventory.sh — run post-ETA and diff against baseline
ES="https://127.0.0.1:9200"; AUTH="admin:<redacted-at-runtime>"
echo "== BEFORE/AFTER archives inventory $(date -u +%FT%TZ)"
curl -s -k -u "$AUTH" "$ES/_cat/indices/wazuh-archives-*?h=index,pri.store.size&s=index" | tee "/tmp/opencode/ism-inv-$(date -u +%Y%m%d-%H%M).txt"
echo "== candidate explain"
curl -s -k -u "$AUTH" "$ES/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15" | head -c 600; echo
echo "== allocation"
curl -s -k -u "$AUTH" "$ES/_cat/allocation?v"
```

Baseline snapshot for the diff is §1 of phase39-71 (captured 2026-08-25).

## 4. Policy-compliance statement

**No forced deletion was performed and none will be.** Deletion must occur via
the approved ISM policy (`wazuh-archives-14d`) only. Manual `DELETE /
wazuh-archives-*` outside policy is prohibited by this record.
