# Phase 10 DR Restore Evidence Checklist

Date: 2026-08-15
VM203: mct-dr-scratch01 (192.168.222.243)

## Pre-restore
- [x] VM203 reachable
- [x] VM203 disk grown 3G -> 30G (28G free)
- [x] Restore artifacts staged (config bundle, IRIS, MISP, Greenbone dumps)
- [x] Production services untouched

## Config bundle
- [x] gzip valid
- [x] Unpacked (75 files)
- [x] Compose files present (docker-compose.yml, override, cloudflare)
- [x] Config/certs/ops directories present

## IRIS dump (PostgreSQL)
- [x] gzip valid
- [x] Scratch DB created (iris_scratch)
- [x] Restored (82 public tables)
- [x] Case data verified (1 case row)
- [x] DB dropped post-test

## MISP dump (MariaDB)
- [x] gzip valid
- [x] Schema readable (113 tables)
- [x] Data statements present

## Greenbone dump (PostgreSQL)
- [x] gzip valid
- [x] Schema readable (192 tables)

## OpenSearch snapshots
- [x] Local snapshot metadata: SUCCESS (38 indices, 64 shards 0 failed)
- [x] S3 snapshot listing: 35 snapshots SUCCESS
- [x] Read path validated (status API)

## Cleanup
- [x] Scratch artifacts removed
- [x] iris_scratch dropped
- [x] VM203 disk retained (30G) for future tests

## No secrets

No secret values printed.
