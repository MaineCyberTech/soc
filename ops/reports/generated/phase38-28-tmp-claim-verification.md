# Phase 38-28 — /tmp Hygiene Claim Verification

**Report ID:** phase38-28-tmp-claim-verification
**Phase:** 38
**Title:** Phase 38-28 — /tmp Hygiene Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-28-tmp-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:35 UTC
**Scope:** Verify /tmp usage, file counts, cron cleanup, first-run timing, thresholds, logs, and post-checks.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | /tmp usage 1.6 GB of 7.6 GB (21 %) | **VERIFIED** | `du -sh`, `df -h` |
| 2 | Cron cleanup entry `0 3 * * * find /tmp -name 'pip-*' -mtime +1 -delete` | **VERIFIED** | `crontab -l` |
| 3 | First cron run not yet executed (pending 2026-08-26 03:00) | **VERIFIED (consistent)** | entry added after today's 03:00; phase37-56 records pending state |
| 4 | Thresholds defined (DEGRADED 50 %, FAILED 70 %, inode/file-count/rate) | **VERIFIED** | phase37-55-tmp-thresholds.md |
| 5 | File count within threshold (<50k) | **VERIFIED** | 10,213 top-level entries |
| 6 | Trend stable vs P36 | **PARTIAL** — same 1.6 GB reading reproduced today; multi-day trend needs the pending cron data | phase37-56 + live du |
| 7 | Post-cleanup service regression checks in place | **UNVERIFIED** | no runbook execution evidence found this session |

---

## Evidence Detail

### 1. Usage
```
$ df -h /tmp | tail -1
tmpfs  7.6G  1.6G  6.1G  21%  /tmp

$ du -sh /tmp/
1.6G    /tmp/
(du emitted permission-denied on three systemd-private dirs: exim4/polkit/logind
 — root-only; effect on total is negligible but exactness is bounded)
```
Matches the claimed 1.6 GB / 21 % exactly. **VERIFIED.**

### 2–3. Cron and first-run timing
```
$ crontab -l | grep -i tmp
0 3 * * * find /tmp -name 'pip-*' -mtime +1 -delete 2>/dev/null
```
Entry exists at the claimed schedule (03:00 daily). Supporting context: `phase37-56-tmp-recurrence.md` explicitly states "First cron run has not yet executed (scheduled 2026-08-26 03:00 UTC)" with expected removal of ~10,195 stale `pip-*` directories. Today is Aug 25; the next 03:00 firing is tomorrow — consistent with "first run pending". No `/tmp/wazuh-snapshot-cron.log`-style artifact for this specific job exists yet either, matching pre-first-run status. **VERIFIED as pending** (i.e., claim correctly says it hasn't run).

Related cron entries observed (context): elastic-snapshot 03:30, health-check 04:30, config backup 02:30.

### 4–5. Thresholds and headroom
From `ops/reports/phase37-55-tmp-thresholds.md`:
```
DEGRADED      >50% usage        (>3.8 GB)
FAILED        >70% usage        (>5.3 GB)
INODE WARNING >80% inode
FILE COUNT    >50,000 files
CREATION RATE >1,000 files/hour
Dedup: 2 consecutive readings to trigger state change; auto-recovery post-cleanup; owner SOC
```
Current 21 % sits far below DEGRADED.
```
$ ls /tmp/ | wc -l
10213
```
File-count proxy well under the 50 k threshold. **VERIFIED** for both design and current margin.

### 6. Trend
Today's independent measurement reproduces 1.6 GB — identical to the P36-end and P37-56 readings, supporting "stable" over the observed window. However the formal trend series depends on the recurring measurements that begin with tomorrow's cron run; only two-three points exist so far. **PARTIAL** (stable-so-far confirmed, trend confidence limited).

### 7. Post-checks
Threshold doc includes a runbook (check cron → manual cleanup → producer investigation), and scripts `p32-tmp-audit.sh`, `p32-tmp-clean-check.sh`, `p33-tmp-health.sh`, `p34-tmp-trend.sh`, `p35-tmp-trend.sh` exist under `ops/scripts/`. But no evidence of a scheduled post-cleanup regression check wired to fire after the 03:00 deletion (e.g., health-check re-run trigger tied to tmp job) was found this session. **UNVERIFIED.**

### Producer identification
P37-56 attributes accumulation to Python/pip temp dirs (`pip-*` pattern) — consistent with the cron's narrow glob targeting exactly that pattern.

---

## Verification Commands Used
```bash
du -sh /tmp/
df -h /tmp | tail -1
crontab -l | grep -i tmp
ls /tmp/ | wc -l
sed -n '1,40p' ops/reports/phase37-55-tmp-thresholds.md
sed -n '1,30p' ops/reports/phase37-56-tmp-recurrence.md
ls ops/scripts/ | grep -iE "^p3[2-5]-tmp"
```

## Summary
All quantitative /tmp claims reproduce exactly (1.6 GB, 21 %, cron line verbatim). The system is correctly reported as **pre-first-run**: the cleanup fires 03:00 UTC on 2026-08-26, and the real proof point is the morning-after delta (~10.2 k stale pip dirs expected gone). Threshold framework is documented with sensible dedup/recovery semantics; the missing piece is an automated post-cleanup regression check rather than a manual runbook step.

## No secrets
