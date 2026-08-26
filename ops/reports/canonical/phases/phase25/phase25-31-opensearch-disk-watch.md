# Phase 25 OpenSearch Disk Watch

Date: 2026-08-22

## 1. Node filesystem / root

- Node fs: **84.7%** used (24.2GB available on all 3 nodes). Root disk: 84%.
- Cluster: green, 266 shards, 0 unassigned.

## 2. Watermarks

| Watermark | Value | Position |
|---|---|---|
| low | 85% | node at 84.7% - **just below** |
| high | 90% | headroom 5.3pp |
| flood_stage | 95% | headroom 10.3pp |

- No watermark raise/disable (capacity remediation instead).

## 3. Read-only blocks / write path

- read_only_allow_delete blocks: **0**. Write path healthy (no rejections observed).

## 4. ISM state / retention

- archives-14d attached to 08-19..08-22 (P24) AND re-attached to 08-07..08-18 this phase
  (policy-compliant completion of the approved archives-14d window). Delete jobs will roll
  as ages cross 14d.

## 5. Projected relief

- ~14.4GB of archives indices eligible for deletion over the next week (08-07..08-18).
  Expected node fs: 84.7% -> ~76-78%.

## Verdict

- **WATCH** (at low watermark); relief in motion via approved retention. No blocks.

## No secrets