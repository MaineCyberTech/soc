# Phase 22 Performance, Capacity, Retention, and Efficiency Audit

Date: 2026-08-22

## 1. RAM / swap / disk

| Resource | Value | Trend | Status |
|---|---|---|---|
| Memory | 11.0 GB / 15.5 GB (71%) | stable | OK |
| Swap | 5,269M / 8,191M (**64%**) | up (49% -> 64%) | **WARN - worsening** |
| Root disk | **86%** (126.5 GB / 154.6 GB) | up (75% -> 76% -> 86%) | **WARN - high** |

## 2. Docker memory

- Indexers 3x ~1.3-1.6GB; shuffle-opensearch 1.33GB; elastiflow 826MB; master 624MB; worker 282MB.
- Indexers + shuffle-opensearch = ~5.7GB of 15.5GB.

## 3. Index / archive / flow growth (post-noise-fixes)

- Today (08-22): alerts 7,611 docs (15.3MB); archives 218K docs (220MB) - vs 2M+/day during floods.
- ElastiFlow: 8.3M flow docs (2.4GB); ~423K unknown-subnet flows/24h still flowing.
- 014 EID7 flood: throttled at analysis (rule-11) - archive impact bounded but agent-side still emitting.
- Retention now ENFORCED (archives-14d attached this phase; alerts 30d; flow 14d).

## 4. Snapshots / backups

- Snapshots fresh; backup storage growth ~2.4GB/day for archives pre-fix; expect reduction with 14d deletes.

## 5. Proxmox / VM202

- pve222 API token missing (401) - capacity visibility degraded (R6).
- Thin pool report stale (08-19); historical .149 pool was 87.84% WARN - reconcile.

## 6. Efficiency findings

- Duplicate backup crons waste cycles (de-duplicate).
- rule-11 throttle is a control but hides signal - proper fix is 014 tuning.
- Zeek noise fixes delivered ~99.9% alert reduction (417K -> 316/day).

## Verdict

Disk (86%) and swap (64%) are the top capacity risks. Retention enforcement + noise fixes
bounded index growth; disk relief needs review (archives deletes at 14d will help from ~09-05).

## Files
- `ops/reports/phase22-performance-capacity-audit.md` (this), `phase22-low-resource-action-plan.md`

## No secrets