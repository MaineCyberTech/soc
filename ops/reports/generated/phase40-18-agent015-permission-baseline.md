# Phase 40-18: Agent 015 mac-clients merged.mg Permission Defect — Baseline Record

**Report ID:** phase40-18-agent015-permission-baseline
**Phase:** 40
**Title:** Phase 40-18: Baseline Record — mac-clients merged.mg Ownership Defect (wazuh-remoted EACCES)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:46:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-18-agent015-permission-baseline.md`

---

## 1. Summary

The manager-side shared-config regeneration for group `mac-clients` was broken by a
file-ownership defect: `/var/ossec/etc/shared/mac-clients/{merged.mg,agent.conf}`
were owned `root` (not writable by the `wazuh` user that `wazuh-remoted` runs as),
so remoted could not open/regenerate `merged.mg`. Every affected-agent config request
logged an EACCES error every 10 seconds from 2026-08-16 07:48:07Z until the fix at
2026-08-26 00:50Z. Fixed same-night under PERM-40-01 (phase40-19); this report is the
permanent baseline of the defect as-found. [VERIFIED]

## 2. Exact Error Signature (verbatim from ossec.log)

```
2026/08/26 00:00:15 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
```

Cadence: every 10 s (00:00:15, 00:00:25, 00:00:35 … — consecutive timestamps in §5).

## 3. Occurrence Counts — MEASURED, with briefing correction [VERIFIED]

Per-day counts (`zcat -f $f | grep -c "mac-clients/merged.mg"` over all rotated logs
+ current log):

```
ossec-16.log.gz: 5706    <- defect began mid-day Aug-16
ossec-17.log.gz: 8640
ossec-18.log.gz: 8640
ossec-19.log.gz: 8640
ossec-20.log.gz: 8640
ossec-21.log.gz: 8640
ossec-22.log.gz: 8623
ossec-23.log.gz: 8636
ossec-24.log.gz: 8633
ossec-25.log.gz: 8639
ossec.log:        299    (Aug-26 00:00:10 rotation -> 00:49:55 pre-fix tail)
TOTAL:         83736
```

First-ever occurrence:

```
2026/08/16 07:48:07 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
```

> **Correction vs. briefing:** the working figure cited was "638 lifetime
> occurrences". Real measured lifetime total is **83,736** (≈8,640/day = exactly one
> per 10 s per full day). The 638 figure is superseded by this measurement; all other
> briefing facts held true.

Last occurrence before fix: **2026-08-26 00:49:55Z** (see phase40-19 §6).

## 4. As-Found Ownership / Modes (path + before state)

Path mapping: `/var/ossec/etc/shared/mac-clients/` **inside container**
`multi-node-wazuh.master-1` (config-mount pattern: container `/var/ossec/etc/shared`
is the live shared-config root served by remoted to group members).

Before-state ownership (as recorded pre-fix; dir still in this state — dir untouched):

| Object | Owner:Group | Mode |
|--------|-------------|------|
| `/var/ossec/etc/shared/mac-clients/` (dir) | root:root | 755 |
| `.../mac-clients/merged.mg` | root:wazuh → treated unwritable by remoted (root-owned) | 644 |
| `.../mac-clients/agent.conf` | root:root | 644 |

Post-fix live `ls` (captured 2026-08-26T01:33Z) showing dir unchanged + files fixed:

```
/var/ossec/etc/shared/:
drwxr-xr-x 2 root  root  4096 Aug 16 08:09 mac-clients      <- dir left root:root 755 (traversal OK)

/var/ossec/etc/shared/mac-clients/:
total 20
drwxr-xr-x 2 root  root  4096 Aug 16 08:09 .
-rw-r--r-- 1 wazuh wazuh  535 Aug 17 04:22 agent.conf
-rw-r--r-- 1 root  root   170 Aug 16 08:07 agent.conf.bak-20260816
-rw-r--r-- 1 wazuh wazuh 1043 Aug 26 00:50 merged.mg
```

## 5. Cadence Sample (consecutive real lines)

```
2026/08/26 00:00:15 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
2026/08/26 00:00:25 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
2026/08/26 00:00:35 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
...
2026/08/26 00:49:35 ... (same signature)
2026/08/26 00:49:45 ... (same signature)
2026/08/26 00:49:55 ... (same signature)   <- LAST EVER
```

299 occurrences today pre-fix = exact 10 s cadence across the 49m40s window.

## 6. Canonical Expectation

Match sibling groups, where merged.mg/agent.conf are `wazuh:wazuh` and remoted can
regenerate freely:

```
-rw-r--r-- 1 wazuh wazuh 899441 Aug  7 20:55 /var/ossec/etc/shared/default/merged.mg
-rw-r--r-- 1 wazuh wazuh   1360 Aug  8 21:45 /var/ossec/etc/shared/linux-servers/merged.mg
```

## 7. Update Mechanism & Blast Radius

- Mechanism: when a group's `agent.conf` or group files change, **remoted itself
  regenerates `merged.mg`** (the flattened per-group bundle agents download). Root-owned
  files made that write fail with EACCES; remoted retried every 10 s indefinitely.
- Affected group: **mac-clients** — sole member **agent 015 Julians-Air**
  (API: `"id":"015" ... groups=['mac-clients']`). No other group impacted:
  default/linux-servers/windows-clients delivered normally throughout.
- Note: because 015 was asleep/flapping during most of the defect window, the
  agent-side impact (stale merged.mg downloads) is bounded but unconfirmed until its
  next connect — tracked in phase40-20.

## 8. Backups Taken Before Fix [VERIFIED]

Host path `/opt/mct-security-stack/ops/backups/p40-agent015-perms/`:

```
6fc1014a7dc1411e9691a940a34e2ecfef042090b8c6028bc8cd799c9f4829e7  agent.conf.pre-fix
4aea884bdc95dd437e9d1bdadca73626043e8a034e654b002769dd90367046c6  merged.mg.pre-fix
```

(Both sha256 verified against briefing values; pre-fix merged.mg was 611 bytes.)

## 9. Rollback Procedure (if ever needed)

```bash
docker cp ops/backups/p40-agent015-perms/merged.mg.pre-fix multi-node-wazuh.master-1:/var/ossec/etc/shared/mac-clients/merged.mg
docker cp ops/backups/p40-agent015-perms/agent.conf.pre-fix multi-node-wazuh.master-1:/var/ossec/etc/shared/mac-clients/agent.conf
docker exec multi-node-wazuh.master-1 chown root:wazuh /var/ossec/etc/shared/mac-clients/merged.mg
docker exec multi-node-wazuh.master-1 chown root:root   /var/ossec/etc/shared/mac-clients/agent.conf
```

Rollback intentionally restores the defective state; it exists only for evidentiary
integrity drills, not for operational use.
