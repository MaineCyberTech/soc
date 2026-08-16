# MCT Security Stack - Dependency Inventory

Date: 2026-08-16 (Phase 14 audit)

## Categories

- **INCLUDED** - in repo (text/config/scripts/templates)
- **GENERATED** - produced locally at deploy time
- **OS-PKG** - installed from OS package manager
- **DOCKER** - pulled from container registry
- **EXTERNAL** - downloaded at install time
- **EXCLUDED** - not committed (licensing/size/secrets)

## Inventory

### Docker images (DOCKER)

| System | Image | Tag | Owner | Cache? |
|---|---|---|---|---|
| IRIS | dfir-iris/dfir-iris | latest* | IRIS | yes |
| MISP | ghcr.io/misp/misp-docker/misp-core | latest* | MISP | yes |
| MISP modules | ghcr.io/misp/misp-docker/misp-modules | latest* | MISP | yes |
| Shuffle | ghcr.io/shuffle/shuffle-backend | latest* | Shuffle | yes |
| Shuffle | ghcr.io/shuffle/shuffle-frontend | latest* | Shuffle | yes |
| Shuffle | ghcr.io/shuffle/shuffle-orborus | latest* | Shuffle | yes |
| Greenbone (18) | registry.community.greenbone.net/* | stable/latest | Greenbone | yes |
| Indexer | opensearchproject/opensearch | 3.2.0 | OpenSearch | yes |
| DBs | mariadb:10.11, postgres:16-alpine, redis:7-alpine | pinned | vendor | yes |

*latest tags - PIN TO DIGESTS for reproducibility (see OFFLINE-INSTALL.md).

### External downloads (EXTERNAL)

| Artifact | Source | Version | License |
|---|---|---|---|
| Wazuh agent pkg | packages.wazuh.com | 4.14.7 | GPL |
| Sysmon | download.sysinternals.com | zip (latest) | Sysinternals EULA |
| Velociraptor bin | github.com/Velocidex | v0.77.2 | AGPL |
| osquery | pkg.osquery.io | latest | Apache 2.0 |
| Windows ISO | Microsoft | - | Microsoft EULA (not vendored) |
| virtio-win ISO | Fedora | - | GPL (not vendored) |
| Debian cloud image | Debian | - | GPL (not vendored) |

### OS packages (OS-PKG)

- wazuh-agent (endpoint), osquery (optional), pip: pymisp, requests.

### Generated locally (GENERATED)

- Velociraptor client.config.yaml, Wazuh enrollment keys, reports.

### Excluded (EXCLUDED)

- .env, creds.env, client.config.yaml, backups/, data/ (live configs),
  *.pcap, *.evtx, *.sql.gz, *.key, *.pem, ISO images.

## Rules

1. Every external dependency has: owner, source, version strategy, cache decision.
2. latest tags flagged for digest pinning.
3. No proprietary binaries committed without license review.

## No secrets
