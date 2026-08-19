# Phase 20 Low-Resource Action Plan

Date: 2026-08-19

## Goals

Keep the stack within current resources (16GB RAM, ~155GB root disk) while fleet grows.

## Actions (priority order)

1. **Stop the 014 Sysmon EventID 7 flood** (HIGHEST) - exclude EventID 7 in Sysmon config on
   014 (operator/Velociraptor). Saves up to ~1.6M archive docs/day when active.
2. **Complete macOS 015 fix** - bounded unified-log config (operator on Mac). Prevents return
   of ~1.4M docs/day on reconnect.
3. **Complete Zeek 24h validation** (v2.2 already ~0) - confirm no recurrence; keeps alert
   index small.
4. **Rotate/refresh PVE222_API_TOKEN** - restore capacity visibility (thin pool + VM202 watch).
5. **Reconcile thin-pool reporting node** - confirm which Proxmox node had 87.84% WARN; monitor.
6. **Indexer heap / shuffle-opensearch review** - if swap stays >50%, consider lowering
   shuffle-opensearch heap or indexer per-node heap (P17 tuning) after measurement.
7. **Retention monitoring** - confirm 14d archives/flow ISM deletes are firing; verify daily
   growth < 1GB/day after fixes 1-3.

## Watch items

- Root disk 76% and climbing - recheck after fixes; ILM deletes should offset.
- Swap 49% sustained - watch after any service additions.

## No secrets