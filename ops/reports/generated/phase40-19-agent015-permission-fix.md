# Phase 40-19: PERM-40-01 — mac-clients merged.mg Ownership Fix (APPLY Record)

**Report ID:** phase40-19-agent015-permission-fix
**Phase:** 40
**Title:** Phase 40-19: APPLY Record PERM-40-01 — merged.mg/agent.conf chown Fix at 00:50Z
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:47:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-19-agent015-permission-fix.md`

---

## 1. Change Record

| Field | Value |
|-------|-------|
| Change ID | **PERM-40-01** |
| Applied | 2026-08-26 **00:50Z** |
| Target | container `multi-node-wazuh.master-1`, `/var/ossec/etc/shared/mac-clients/` |
| Scope | exactly two files (`merged.mg`, `agent.conf`) — ownership only |
| Approval basis | pack-instructed fix with identity-preservation + rollback path (phase40-18 §8–9); minimal-change principle enforced |
| Result | **SUCCESS — errors stopped; last occurrence 00:49:55Z; zero since** |

## 2. Exact Commands Executed

```bash
# 1) Backups out of the container first (host-side, hashed):
docker cp multi-node-wazuh.master-1:/var/ossec/etc/shared/mac-clients/merged.mg \
          ops/backups/p40-agent015-perms/merged.mg.pre-fix
docker cp multi-node-wazuh.master-1:/var/ossec/etc/shared/mac-clients/agent.conf \
          ops/backups/p40-agent015-perms/agent.conf.pre-fix

# 2) Minimal fix INSIDE the master container — two files, no recursion:
docker exec multi-node-wazuh.master-1 chown wazuh:wazuh /var/ossec/etc/shared/mac-clients/merged.mg
docker exec multi-node-wazuh.master-1 chown wazuh:wazuh /var/ossec/etc/shared/mac-clients/agent.conf

# NOT done (deliberate): no chmod, no -R, no directory changes, no service restart.
```

## 3. Before / After Tables

Before (as-found, from phase40-18 baseline):

```
-rw-r--r-- 1 root  root   170 Aug 16 08:07 agent.conf.bak-20260816   (untouched, unrelated)
-rw-r--r-- 1 wazuh wazuh  535 Aug 17 04:22 agent.conf                <- pre-fix: root-owned per backup record*
-rw-r--r-- 1 root  root   611 Aug 16 08:07 merged.mg                 <- pre-fix: root:wazuh, unwritable by remoted
drwxr-xr-x 2 root  root  4096 Aug 16 08:09 .                         <- dir left root:root 755
```

(*pre-fix ownership preserved in `agent.conf.pre-fix` backup + briefing record.)

After (live `stat`, captured 2026-08-26T01:36Z):

```
/var/ossec/etc/shared/mac-clients/merged.mg  wazuh:wazuh 644 1043 2026-08-26 00:50:05.284928547 +0000
/var/ossec/etc/shared/mac-clients/agent.conf wazuh:wazuh 644  535 2026-08-17 04:22:09.669672627 +0000
```

Directory itself: **left root:root 755** — traversal by the `wazuh` user is
unaffected (execute bit on dir); only file-level write permission was required for
remoted's merged-config regeneration. No recursive or broad changes were made.

## 4. Proof the Regeneration Ran

`merged.mg` mtime flipped to **00:50:05** (five seconds after the chown) and grew
611 → 1043 bytes as remoted successfully rebuilt the bundle:

```
-rw-r--r-- 1 wazuh wazuh 1043 Aug 26 00:50 merged.mg
head -3 merged.mg:
#mac-clients
!267 ar.conf
restart-ossec0 - restart-ossec.sh - 0
```

## 5. Backup Integrity [VERIFIED]

```
6fc1014a7dc1411e9691a940a34e2ecfef042090b8c6028bc8cd799c9f4829e7  agent.conf.pre-fix
4aea884bdc95dd437e9d1bdadca73626043e8a034e654b002769dd90367046c6  merged.mg.pre-fix
```

## 6. Post-Fix Error Counts (embedded greps)

Last three occurrences before fix (current ossec.log):

```
2026/08/26 00:49:35 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
2026/08/26 00:49:45 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
2026/08/26 00:49:55 wazuh-remoted: ERROR: Unable to open file: 'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].   <- LAST
```

Occurrences after 00:50:00 in current log (spanning all subsequent daemon restarts):

```
$ grep "mac-clients/merged.mg" /var/ossec/logs/ossec.log | awk '$2 > "00:50:00"' | wc -l
0
$ docker logs multi-node-wazuh.master-1 --since 45m 2>&1 | grep -c "mac-clients/merged.mg"
0
```

Durability note: five daemon-restart cycles occurred after the fix during webhook
wiring work (remoted restarts at 01:00:13, 01:01:14, 01:01:52, 01:03:43, 01:14:24,
per `wazuh-remoted ... Started (pid:)` lines). The error stayed at zero through every
restart — the fix is config-state, not process-state.

## 7. Rollback

Documented and unused — see phase40-18 §9. Not needed: result was immediate success.
