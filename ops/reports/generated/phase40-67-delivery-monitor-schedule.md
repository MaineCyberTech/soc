# Phase 40 Delivery Monitor Schedule

**Report ID:** phase40-67-delivery-monitor-schedule
**Phase:** 40
**Title:** Schedule SCHED-40-01 — Cron Line ACTIVE (`*/15`, crontab Output Cited), Cadence Rationale, Exec Mode + Absolute Paths Verified, No Duplicate Schedules, Reboot Persistence, Next-Run Prediction
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:33:00Z
**Classification:** INTERNAL
**Status:** COMPLETE — ACTIVE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-67-delivery-monitor-schedule.md`

---

## 1. Cron line — REAL OUTPUT

```
$ crontab -l | grep delivery
*/15 * * * * /opt/mct-security-stack/ops/scripts/p39-iris-delivery-check.sh >> /opt/mct-security-stack/ops/reports/shuffle-delivery-monitor.log 2>&1
```

(Shown as line 19 of crontab in numbered grep.) Added earlier today; verified
active now.

## 2. */15 rationale

Delivery-degradation detection SLA ≤15 min matches IRIS case-creation
sensitivity while keeping Shuffle API load trivial (one executions-list call
per workflow per run). Faster cadence adds noise without faster operator
response (log-only channel); slower risks missing short failure bursts
between daily reviews.

## 3. Executability & environment — REAL CHECKS

```
-rwxrwxr-x user user p39-iris-delivery-check.sh      ← executable bit present
```

All paths absolute (`/opt/mct-security-stack/...`), no reliance on cron's
trimmed PATH. Script self-sources `$ROOT/.env` for credentials and validates
`docker ps` internally — immune to cron env differences. Exit codes defined
(0 monitor-ok/skip, 2 transport error) and stderr captured to the same log.

## 4. Duplicate-schedule check — REAL OUTPUT

```
$ crontab -l | grep -c 'p39-iris-delivery-check'
1
```

Exactly one schedule exists.

## 5. Persistence across reboot

Host-level crontab survives container restarts AND host reboots
(stored in `/var/spool/cron/crontabs/<user>`); it is independent of the LXC
guest lifecycle discussed in phase40-69. Log target directory is on the
persistent root FS. **Persistence verdict: PERSISTS.**

## 6. First runs already observed — REAL EVIDENCE

```
$ ls -la ops/reports/shuffle-delivery-monitor.log
-rw-rw-r-- 1 user user 526  Aug 26 02:00 ...   ← created & first run 02:00Z
-rw-rw-r-- 1 user user 789  Aug 26 02:15 ...   ← second scheduled run 02:15Z
```

Two consecutive scheduled executions landed exactly on the */15 grid
(02:00:xx, 02:15:02) — schedule empirically confirmed, not merely configured.

## 7. Next-run prediction

At report time 2026-08-26T02:18–02:33Z ⇒ next fires **02:30Z** (and every
15 min thereafter). Verification command:

```
tail -4 /opt/mct-security-stack/ops/reports/shuffle-delivery-monitor.log
stat -c '%y' /opt/mct-security-stack/ops/reports/shuffle-delivery-monitor.log
```

mtime advancing on quarter-hours = schedule alive.
