# Phase 42 VirusTotal Value-Blind Baseline

**Report ID:** phase42-51-vt-valueblind-baseline.md
**Phase:** 42
**Title:** VT-42-01 — Value-Blind Secret Baseline For VirusTotal api_key (Length-Classification Only, 64-hex Class); Presence Map Across Master/Worker/Host-File/Git/History; Perms Drift 644→640 Container; Exposure-Surface Diagram; Value Itself Never Read
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:02:00Z
**Classification:** INTERNAL (contains no credential material)
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-51-vt-valueblind-baseline.md`

---

## 1. Method — value-blind by construction

Every check below classifies **shape, location, and permissions only**. The
key's value was never printed, copied, hashed, or transmitted. Lengths were
computed inside the container (`awk -F"[><]" '{print length($3)}'` over the
`<api_key>` element) so even intermediate tool output carried no material.

## 2. Presence map [VERIFIED live]

| Location | VT key present? | Evidence (value-blind) |
|---|---|---|
| Master runtime conf `/var/ossec/etc/ossec.conf` | **YES** | `<integration>` block #1 named `virustotal`; sibling `<api_key>` element length **64** chars |
| Worker conf (`wazuh_worker.conf` mount) | **NO** | exactly one `<integration>` block, name = `shuffle` (not virustotal) |
| Host-side file `/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf` | **YES** (bind-mount source of the master conf) | same file content as master mount; perms §4 |
| Git working tree of `/opt/wazuh-docker` | YES on disk, **uncommitted local override** | file flagged skip-worktree (`git ls-files -v` → `S`), hides local mods from status/diff |
| Git history (any commit, any branch) | **NO** | `git log --all -S'<api_key>' --oneline \| wc -l` = **0** — no commit ever added/removed an api_key element; remote = upstream `wazuh/wazuh-docker`, file has 23 upstream commits, none carrying secrets |
| SOC-side repos | NO references | zero matches for the integration/api_key pattern in stack reporting paths |

Key class: 64 characters — consistent with a hex-encoded VirusTotal API key.
The second integration (`shuffle`) carries a separate 27-char token in its own
`<api_key>`; same handling rules apply.

## 3. Why it was plaintext here

Wazuh integrations read `api_key` directly from `ossec.conf` — native secret
references are ABSENT in this version (see phase42-52). Plaintext-in-conf is a
platform constraint, not an operator mistake.

## 4. Permissions before/after (container)

```
before (this morning): 644 root:root   world-readable   ← any local user/process could read
after  (applied today): 640 root:root  root-only group  ← live: stat /var/ossec/etc/ossec.conf
```

Runtime conf lives on docker volume `multi-node_master-wazuh-etc`, so the 640
mode persists across restarts/recreates. Host-side bind source remains 644
(chmod requires sudo — owner item, phase42-53 §3).

## 5. Exposure-surface diagram

```
                     ┌── exposure surface of VT api_key (value-blind view) ──┐

 [VT portal]                                  origin of key (out of scope)
     │ (paste during setup)
     ▼
 wazuh_manager.conf (host, 644 root:root) ──── OWNER ITEM: needs sudo chmod 640
     │ docker bind-mount
     ▼
 master:/wazuh-config-mount/etc/ossec.conf          ← same inode as host file
     │ entrypoint copy into volume
     ▼
 master:/var/ossec/etc/ossec.conf (640 root:root)   ← READ BY integrationsd ✅ hardened today
     │
     ├─ git worktree copy (/opt/wazuh-docker, skip-worktree) ── uncommitted;
     │    git history clean (-S count=0) ⇒ no push/clone leak path
     └─ backups (*.bak-* siblings) ── pre-VT-era, verified no <api_key> era content
```

## 6. What we deliberately did NOT look at

The key's value, prefix/suffix, entropy profile beyond length-class, the
Shuffle token's value, any `<hook_url>` content (can embed path tokens), and
any backup file body. Attestation flows to phase42-53 §5.
