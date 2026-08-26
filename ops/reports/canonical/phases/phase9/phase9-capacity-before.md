# Phase 9 Capacity Before - 2026-08-15 20:13

## Production host

| Item | Before value | Assessment |
|---|---|---|
| Root disk | 148G total, 91G used (**63-64%**), 52G free | Adequate (Phase 8 was 92% - improved after resize) |
| /opt/wazuh-backups | 12G (elasticsearch local snapshots, 86 files / 63 indices) | Growth driver |
| OpenSearch indices | ~9.1G total (elastiflow 1.3G, archives ~4.2G, alerts ~1.6G) | Normal growth |
| Docker images | 17.7G (169 images, 31 active) | Stable |
| Docker volumes | 41.6G (39 volumes) | Largest consumer |
| Memory | 8.3G/9.3G used, 395M free, 1.0G available | **Tight** |
| Swap | 5.9G/8G used (74%) | **High - pressure** |
| Netdata | running (203M) | Normal |

## Top memory consumers

| Process | Memory |
|---|---|
| wazuh-indexer x3 | ~1.2G each (~3.7G total) |
| shuffle-opensearch | 1.36G/1.5G limit (near cap) |
| flowcoll (elastiflow) | 681M |
| opencode (this session) | 667M |
| tenzir-node | 216M |
| master/worker/dashboard | ~470M combined |

## Proxmox .222 test host

| Item | Before value | Assessment |
|---|---|---|
| Thin pool | 64.19G, **88%** used | **High risk** (Windows Update filled it twice -> io-error) |
| PVE root | 39G, 41% used | OK |
| VM 201 disk | 59.6% of 80G (~48G real) | Windows Update downloads consumed space; cache cleared, updates disabled |
| Other VM disks | 202: 90%, 204: 47%, 205: 41%, 203: 36% | Normal |

## Snapshot/S3 state

- Local OpenSearch snapshots: 12G, working
- S3 snapshots (do-spaces repo): 34, all SUCCESS (latest 15:47)
- DR S3 config bundle: **FAILING (403 SignatureDoesNotMatch)** - stale keys in creds.env (see below)

## Findings

1. **Thin pool .222 at 88%** - near the 95% critical threshold; Windows Update is disabled on the guest (C: has 41G free after cache clear), but pool headroom is only ~7.7G.
2. **DR S3 bundle failing** - dr-s3-bundle.sh uses DO_SPACES_* keys from creds.env which produce 403; the working S3 path (OpenSearch repo snapshots) uses the indexer's own keystore creds. Config/cert DR backup to S3 is broken.
3. **Swap 74%** - memory headroom is thin; VM101 RAM expansion (to 16-24G) recommended before first client launch.
4. **Wazuh config backup empty archives** - cron produces 45-byte archives (CWD issue); covered in P9.08.

## No secrets

No secret values printed.
