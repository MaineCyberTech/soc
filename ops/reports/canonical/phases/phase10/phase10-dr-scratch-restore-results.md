# Phase 10 DR Scratch Restore Results

Date: 2026-08-15
Target: VM 203 mct-dr-scratch01 (192.168.222.243) - scratch restore validation only.
Production NOT touched.

## Result: PASS (config + DB dumps validated; OpenSearch snapshot read path validated)

## Prep

- Grown VM203 root disk 3G -> 30G (28G free) to accommodate restore artifacts.
- Staged artifacts: wazuh-config bundle (145KB), iris-db dump (37KB),
  misp-db dump (151MB), greenbone-gvmd dump (1.8GB).

## Validation results

| Artifact | Test | Result |
|---|---|---|
| Wazuh config bundle | unpack + file inventory | **PASS** (75 files: compose, override, cloudflare, wazuh-local.env, config, ops) |
| IRIS dump (PostgreSQL) | **restored to scratch DB** | **PASS** (82 public tables, 1 case row) |
| MISP dump (MariaDB) | schema + data readability | **PASS** (113 tables incl. access_logs, admin_settings, allowedlist) |
| Greenbone dump (PostgreSQL) | schema readability | **PASS** (192 tables across cert/public schemas) |
| OpenSearch local snapshot | metadata + status read | **PASS** (snap-20260815-2017 SUCCESS, 38 indices, 64 shards 0 failed, restorable) |
| OpenSearch S3 snapshot | repo listing | PASS (35 snapshots, latest 2026-08-15 20:47) |

## What was NOT done (by design / safety)

- Full OpenSearch index restore to a scratch cluster (would require standing up a
  compatible OpenSearch instance; snapshot read-path validated instead).
- Any production service restore - none touched.
- MISP/Greenbone full DB restores (schema validated; same pattern as IRIS which
  was fully restored).

## Lessons learned

1. Config bundle is root-owned 0600 - stage via sudo copy before scp.
2. VM203 default disk (3G) is too small for restore tests - grow to 30G first.
3. IRIS dump is small (37KB) - ideal full-restore validation target.
4. Greenbone dump is 1.8GB - schema-only validation is pragmatic for scratch.
5. All dumps gzip-valid - backup pipeline produces readable artifacts.

## Cleanup

- iris_scratch DB dropped.
- /tmp/restore artifacts removed.
- VM203 retains the 30G disk (useful for future tests).

## No secrets

No secret values printed.
