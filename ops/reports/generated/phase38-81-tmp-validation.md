# Phase 38-81: /tmp Validation Report

**Report ID:** phase38-81-tmp-validation
**Phase:** 38
**Title:** Phase 38-81: /tmp Validation Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-81-tmp-validation.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-81 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PENDING-FIRST-RUN |

**Status:** PENDING
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-81-tmp-validation.md`
**Retention Class:** LONG

---

## 1. Executive Summary

`/tmp` (tmpfs, 7.6G) is at **1.6 GB / 21%** with **10,215 top-level entries** (~230k files including subdirectory contents). A cron cleanup line exists (`0 3 * * * find /tmp -name 'pip-*' -mtime +1 -delete`) but its next fire is **2026-08-26 03:00 UTC — it has not run since being added**, so this report's cleanup status is **PENDING-FIRST-RUN**. Critically, the scheduled line only targets `pip-*`; it will NOT touch the dominant consumer class (`tmp.*` files, ~1.5 GB), so a scope gap persists even after first run.

## 2. Command Output

```
$ df -h /tmp
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           7.6G  1.6G  6.1G  21% /tmp

$ du -sh /tmp          → 1.6G
$ ls /tmp | wc -l      → 10215

$ crontab -l | grep -i tmp
0 3 * * * find /tmp -name 'pip-*' -mtime +1 -delete 2>/dev/null

$ du -sh /tmp/* 2>/dev/null | sort -rh | head -10
15M    /tmp/p32-tmp-audit-20260825-002517
1.1M   /tmp/tmp.phhbIvfUjy        (…and ~thousands more tmp.* of same size)
1.1M   /tmp/tmp.mAoBxmBunl
1.1M   /tmp/tmp.f3AsNzdrnm
1.1M   /tmp/tmp.OfmuzEnL6n
1.1M   /tmp/tmp.JXIY1SKDZs
1.1M   /tmp/tmp.HhTG32GUaC
1.1M   /tmp/p32-clean-candidates-20260825-002545.txt
1.1M   /tmp/p32-clean-candidates-20260825-002520.txt
```

## 3. Producer Analysis & Trend

- **Dominant producer:** `tmp.*` files at uniform ~1.1 MB each — classic `mktemp` output pattern from Shuffle workers/orborus job spillover and p30/p32 audit runs. Thousands of them ≈ **~1.5 GB**, i.e., >90% of `/tmp` usage.
- **Secondary:** `p32-tmp-audit-*`, `p32-clean-candidates-*` artifacts (15 MB + several MB) from Phase 32 audits.
- **Trend log:** `p34-tmp-trend.sh` appends to `/var/log/mct-tmp-trend.log`, but that file does not exist on disk → trend history was never persisted (script never run under cron/privileged context). Trend therefore reconstructed point-in-time only: usage has been stable at 1.6 GB / 21% across today's checks (consistent with the corrected live state).
- **Inode pressure:** `df -Pi /tmp` = 23% inode use per trend-script logic; no exhaustion risk.

## 4. Cron Run Evidence — PENDING-FIRST-RUN

- Line present exactly once in root crontab: `0 3 * * * find /tmp -name 'pip-*' -mtime +1 -delete`.
- Current time at writing: **2026-08-25 21:17 UTC**. Next scheduled: **2026-08-26 03:00 UTC**. No prior execution since addition → **status: PENDING-FIRST-RUN**.
- Verification hook for next phase: check for absence of stale `pip-*` dirs and confirm no errors; suggest appending output to a log file for evidence.

### Scope gap (recurrence risk: HIGH)
Even after a successful run, expected relief ≈ tens of MB (`pip-*` only). The ~1.5 GB `tmp.*` population is untouched by design of the current line and will continue to accumulate with every Shuffle workflow execution and audit script run. Recommend either:
- broaden to `find /tmp -maxdepth 1 -name 'tmp.*' -mtime +2 -delete`, or
- enable/rely on `systemd-tmpfiles-clean.timer` (present: next Wed 2026-08-26 04:54 UTC) after verifying its age policy covers `/tmp`.

## 5. Docker/Wazuh/OpenSearch tmp Usage

- Host `/tmp`: no `opensearch*` or wazuh temp dirs found (`find /tmp -maxdepth 1 -name 'opensearch*' -o -name 'wazuh*'` → only cron logs `wazuh-health.log`, `wazuh-snapshot-cron.log`, `wazuh-backup-cron.log`).
- Indexer JVMs write temp into container-local `/tmp/opensearch-<rand>` (per `-Djava.io.tmpdir` in ps output) — invisible to host `/tmp`, bounded by JVM lifecycle. Not a contributor to the 1.6 GB.

## 6. Exclusions & Safety

Cleanup excludes anything newer than `-mtime +1`; `/tmp` is tmpfs so deletion risk is limited to in-flight temp data. No exclusions required for `tmp.*` beyond an mtime guard ≥24h to avoid racing active Shuffle executions.

---
*Evidence: commands executed 2026-08-25 21:05–21:17 UTC.*
