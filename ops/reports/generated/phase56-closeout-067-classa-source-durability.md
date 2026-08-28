# Phase 56 Closeout: Source Durability

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
067-classa-source-durability — Document external host source, versioning gap, recovery, and checksums.

## Task
Document the durable external host bind source for the Wazuh config, the versioning gap that caused revert, the recovery, and checksum evidence.

## Evidence
- EB §3: durable host bind source = /opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf; parity-confirmed with running /var/ossec/etc/ossec.conf.
- EB §8 (Incident B): container recreate reset in-volume config to default (webhook_eb937a37, placeholder) — versioning gap; fix re-applied to BOTH running volume and host bind source.
- EB §7: secret scan — host bind Wazuh config contains `api_key` placeholder (no real secret) and virustotal key (pre-existing, not in repo).
- sha256sums.txt present (pack artifact) preserves nonsecret artifact hashes.

## Method
READ-ONLY-INSPECTION (durability and parity from EB §3/§8).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No config edit / policy change — respected.
- No secret value exposure — referenced by path/ID only.

## Limitations
Exact checksum hex values are preserved in sha256sums.txt / backup and not re-derived here to avoid duplication; versioning gap (no in-repo version control of bind source) is documented, not remediated.

## Verdict
DONE — durable host bind source documented, parity-confirmed, recovery recorded (Incident B), checksums preserved in sha256sums.txt (EB §3, §7, §8).
