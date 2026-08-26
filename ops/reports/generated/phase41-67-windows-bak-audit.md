# Phase 41 Windows .bak Ownership Audit — Zero Root-Owned Confirmed

**Report ID:** phase41-67-windows-bak-audit
**Phase:** 41
**Title:** AUD-BAK-41-01 — Shared-Directory .bak Ownership Audit Executed Live: find /var/ossec/etc/shared -name '*.bak*' -user root Returns ZERO (P40 Sweep Held), Historical remoted Noise Errors Ceased At 01:28:21Z Today With ~3h50m Silence Post-Fix, All 7 Of Today's Error Lines Predate The Chown Window, No NEW .bak Files Since Aug-16 — Residual Relocation Risk Recorded Honestly
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:38:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-67-windows-bak-audit.md`

---

## 1. Primary check — root-owned .bak files

```
master# find /var/ossec/etc/shared -name '*.bak*' -user root | wc -l
0
```

Current .bak population (all of them, with ownership):

```
-rw-r--r-- 1 wazuh wazuh 170 Aug 16 08:07 /var/ossec/etc/shared/mac-clients/agent.conf.bak-20260816
-rw-r----- 1 wazuh wazuh  76 Aug 16 04:35 /var/ossec/etc/shared/windows-clients/agent.conf.bak-20260816
```

**Expectation met: zero root-owned `.bak-*` remain** — the P40 sweep chown
(wazuh:wazuh on both mac-clients and windows-clients backups) held.

## 2. Remoted noise errors — ceased post-fix (honest read)

Today's error lines touching the windows-clients backup file:

```
grep 'Invalid shared file.*windows' ossec.log | cut -d' ' -f1 | uniq -c
      7 2026/08/26            ← all seven today, none prior days in log window

last occurrences:
2026/08/26 01:26:23  ERROR: Unable to open file '…agent.conf.bak-20260816' due to [(13)-(Permission denied)]
2026/08/26 01:28:21  ERROR: Invalid shared file '…agent.conf.bak-20260816'. Ignoring it.
```

Timeline coherence: all 7 lines fall in the 01:14–01:28Z window, i.e., BEFORE the
ownership fix landed; since **01:28:21Z there have been zero recurrences through
~05:19Z (~3h50m silence)** across normal remoted activity (agents checking in every
~seconds-to-minutes; keepalives fresh). Verdict: noise errors GONE within
observation resolution.

Residual honesty note: both `.bak` files still physically live inside group shared
directories. Ownership fixed the permission-denied class permanently; the generic
"invalid shared file" class can only fully die by relocating backups out of the
shared dirs — recorded as hygiene SOP input (phase41-68 §5), not silently claimed
impossible-to-recur.

## 3. New .bak files since?

None. Both existing files date Aug-16; no newer `.bak*` anywhere under
`/var/ossec/etc/shared`.

## 4. Config distribution sanity (regression side-check)

```
-rw-r--r-- 1 wazuh wazuh 899441 Aug  7 20:55 default/merged.mg
-rw-r--r-- 1 wazuh wazuh  1043 Aug 26 00:50 mac-clients/merged.mg     ← regenerated last night
-rw-r--r-- 1 wazuh wazuh   479 Aug 16 04:35 windows-clients/merged.mg  ← stable since its fix
```

All wazuh-owned; distribution pipeline healthy (phase41-68).
