# Phase 23 OpenSearch Disk and Watermark Preflight

Date: 2026-08-22

## 1. Root disk

- `/dev/sda1`: 148GB total, **119GB used (85%)**, 23GB available.
- Breakdown: Docker ~74GB (images 18GB, volumes 56GB - ES/elastiflow data stores),
  /opt 29GB (wazuh-backups snapshots 23GB, mct-security-stack 5.4GB), /swapfile 8.1GB,
  system ~8GB.

## 2. Node filesystem / shard allocation

- All 3 nodes: 158.3GB fs, 24.2GB available (84.7% used) - node fs mirrors root.
- Cluster green; 266 active shards, 0 unassigned; no shard allocation constraints active.

## 3. Watermarks (defaults)

| Watermark | Value |
|---|---|
| low | 85% |
| high | 90% |
| flood_stage | 95% |

- **Node at 84.7% = AT the low watermark.** Crossing 85% constrains new shard allocation;
  90% stops relocations; 95% triggers flood-stage (write blocks).
- Policy: do NOT raise/disable watermarks as a substitute for capacity remediation.

## 4. Read-only / write health

- read_only_allow_delete blocks: **0 indices**; cluster write health normal (no rejections observed).

## 5. ISM state / snapshots

- ISM: archives-14d attached (held); alerts 30d; flow 14d.
- FS snapshot repo: 42 snapshots (08-15..08-22, 5h cadence + daily) = **policy-compliant 7-day
  window** (~23GB). S3 repo: 30d retention, fresh (0047).

## 6. Verdict

- **WATCH**: disk at low-watermark threshold; no write impact yet. Relief plan required (23.16)
  with approved, in-policy actions only.

## No secrets