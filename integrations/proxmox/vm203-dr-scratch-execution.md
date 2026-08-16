# VM203 DR Scratch Execution (Phase 10)

## Host

- PVE: 192.168.222.222 (test lab), VM 203, mct-dr-scratch01, .243
- 2 cores, 4GB RAM, 30G disk (grown from 3G on 2026-08-15)
- OS: Debian 13, cloud-init, user mct / mct_lab key

## Purpose

- Non-production scratch validation of DR restore artifacts.
- NEVER restore to production from this VM.

## Restore source artifacts (staged from production host)

| Artifact | Source path | Size |
|---|---|---|
| Config bundle | /opt/wazuh-backups/wazuh-config-<ts>.tar.gz | 145KB |
| IRIS dump | /opt/mct-security-stack/ops/backups/iris-db-<ts>.sql.gz | 37KB |
| MISP dump | /opt/mct-security-stack/ops/backups/vm103/misp-db-<ts>.sql.gz | 151MB |
| Greenbone dump | /opt/mct-security-stack/ops/backups/vm103/greenbone-gvmd-<ts>.sql.gz | 1.8GB |

## Procedure (validated 2026-08-15)

1. Grow disk: `qm resize 203 scsi0 30G` (PVE) + `growpart`/`resize2fs` (guest).
2. Stage artifacts to /tmp/restore (config bundle via sudo copy for 0600 perms).
3. Config: `tar -xzf` + inventory.
4. IRIS: `gunzip | psql` into scratch DB -> verify tables/cases -> drop.
5. MISP/Greenbone: schema readability via gunzip | grep CREATE TABLE.
6. OpenSearch: snapshot metadata/status via repo API (read path).
7. Cleanup /tmp/restore.

## Next (Phase 11 candidates)

- Full OpenSearch index restore to a scratch OpenSearch instance.
- Full MISP + Greenbone restores (postgres/mariadb now installed on VM203).

## No secrets

No secret values printed.
