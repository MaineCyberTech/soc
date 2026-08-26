# Phase 41 ISM Restore Spot-Check #3 — PASS (Third Consecutive)

**Report ID:** phase41-57-ism-restore-spotcheck
**Phase:** 41
**Title:** SPOTCHECK-41-03 — Third Consecutive Snapshot Restore Spot-Check Executed Live This Run: Smallest Snapshot Index wazuh-archives-4.x-2026.08.23 Restored From fs snap-20260826-0330 As restored-p41-* → Health GREEN → Count Parity 170,521 = 170,521 EXACT → Temp Deleted Cleanly, Original Untouched (UUID Unchanged)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:26:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (verdict: PASS — 3× streak P39/P40/P41)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-57-ism-restore-spotcheck.md`

---

## 1. Scope disclaimer

This spot-check restores **one small index from one snapshot to a temporary renamed
copy**, verifies it, and deletes the copy. It proves snapshot restorability at the
index level. It is NOT a full-cluster restore rehearsal (that remains NO-GO pending
external target + owner approvals, phase41-34) and makes no claim beyond read-back
integrity of the tested index.

## 2. Execution record (live outputs, ~05:25Z)

Selection: smallest archive index in the latest fs snapshot =
`wazuh-archives-4.x-2026.08.23` (98.3mb store / 49.1mb pri / 170,521 docs).

First attempt failed with a payload typo (`\.` invalid JSON escape → HTTP 400,
`json_parse_exception`) — corrected to `\\.` and re-run; the failed attempt is
recorded here for honesty.

```
POST _snapshot/wazuh-backup/snap-20260826-0330/_restore
{"indices":"wazuh-archives-4.x-2026.08.23",
 "rename_pattern":"wazuh-archives-(4\\.x-.+)",
 "rename_replacement":"restored-p41-$1"}
→ {"accepted":true}
```

Health wait:

```
GET _cluster/health/restored-p41-4.x-2026.08.23?wait_for_status=yellow&timeout=90s
→ status green, timed_out:false, active_primary_shards:1, active_shards:2
```

Count parity:

```
restored: {"count":170521,...}   live: {"count":170521,...}   EXACT MATCH
_cat indices restored-*:
green open restored-p41-4.x-2026.08.23 B80tCOjGQheVX8R4QYs8zA  170521 docs  98.3mb
```

Teardown:

```
DELETE /restored-p41-4.x-2026.08.23 → {"acknowledged":true}
_cat indices restored-* → empty (temp gone)
original intact: green open wazuh-archives-4.x-2026.08.23 e2_DRFGQQzCNvYJva04gAQ 170521 docs
```

## 3. Verdict

| Criterion | Result |
|-----------|--------|
| Restore accepted | PASS |
| Health reached (green exceeded yellow requirement) | PASS |
| Doc-count parity exact | PASS (170,521 = 170,521) |
| Store-size sane vs live | PASS (98.3mb both) |
| Temp removed, original byte-identity preserved | PASS (same UUID pre/post) |

Streak: spot-check #1 (P39), #2 (P40), #3 (this run) — all PASS. Snapshot-based
recovery remains demonstrably real, which is what keeps the Aug-29 wave safe to
observe.
