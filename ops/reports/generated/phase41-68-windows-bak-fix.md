# Phase 41 Windows .bak Fix Record — BAK-41-01

**Report ID:** phase41-68-windows-bak-fix
**Phase:** 41
**Title:** FIX-BAK-41-01 — Fix Record Referencing The P40 Ownership Sweep: Chown Commands And Effect (Both Group .bak Files → wazuh:wazuh, Root-Owned Count 1→0), Today's Independent Verification Outputs Embedded, Regression Statement PASS (Config Distribution Normal — merged.mg Group mtimes Spot-Checked), Residual Hygiene Recommendation Issued (Never Create Root-Owned Files In Shared Dirs — SOP Note)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:39:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-68-windows-bak-fix.md`

---

## 1. Change identification

| Field | Value |
|-------|-------|
| Change ID | BAK-41-01 |
| Underlying fix | P40 sweep: ownership normalization of stray `.bak-*` files in agent shared-config dirs (executed on master container filesystem) |
| Files affected | `/var/ossec/etc/shared/windows-clients/agent.conf.bak-20260816`, `/var/ossec/etc/shared/mac-clients/agent.conf.bak-20260816` |
| This record | References the sweep + embeds today's independent verification (nothing re-modified today) |

## 2. The fix as applied (P40 sweep)

```bash
docker exec multi-node-wazuh.master-1 chown wazuh:wazuh \
  /var/ossec/etc/shared/windows-clients/agent.conf.bak-20260816 \
  /var/ossec/etc/shared/mac-clients/agent.conf.bak-20260816
```

Effect: remoted (running unprivileged) regained read access; the
`(13)-(Permission denied)` error class eliminated at source.

## 3. Today's verification outputs (independent re-run, ~05:19Z)

Ownership:

```
find /var/ossec/etc/shared -name '*.bak*' -user root | wc -l   → 0
ls -la:
  -rw-r--r-- 1 wazuh wazuh 170 Aug 16 08:07 mac-clients/agent.conf.bak-20260816
  -rw-r----- 1 wazuh wazuh  76 Aug 16 04:35 windows-clients/agent.conf.bak-20260816
```

Noise cessation:

```
7 error lines on 2026/08/26, ALL between 01:14:24Z–01:28:21Z (pre-fix window);
zero recurrences 01:28:21Z → 05:19Z+ (~3h50m) despite continuous agent traffic
(keepalives fresh ≤1 min for all active agents, phase41-62 table).
```

## 4. Regression statement — PASS

Config distribution verified normal via merged.mg spot-check:

```
default/merged.mg          899441 B  wazuh:wazuh  Aug  7 20:55
mac-clients/merged.mg       1043 B  wazuh:wazuh  Aug 26 00:50  ← regenerated overnight, healthy
windows-clients/merged.mg    479 B  wazuh:wazuh  Aug 16 04:35  ← stable since its own P40 fix
```

All group bundles wazuh-owned, expected sizes, plausible mtimes; active agents
synchronizing (API `configuration.synced = 9/9`, phase41-62 context). The sweep
introduced no distribution regressions.

## 5. Residual hygiene recommendation (SOP note)

The permission-denied class is dead; a second class ("Invalid shared file …
Ignoring it") is inherent to any non-config file living inside a group shared dir,
because remoted treats every file there as candidate shared configuration.

SOP note for all future operator/agent work:

> NEVER create backup/copy/temp files inside `/var/ossec/etc/shared/**`. Stage edits
> outside the shared tree, write atomically into place, and relocate any historical
> `.bak-*` artifacts out of shared dirs at next maintenance window (owner-approved
> move, not in-place delete). Any tooling that writes into shared dirs MUST run with
> an explicit umask/owner so files land wazuh:wazuh — or better, not land there at
> all.

Adoption decision and the optional relocation of the two Aug-16 backups belong to
the Wazuh config owner; automation will not move/delete them unprompted.
