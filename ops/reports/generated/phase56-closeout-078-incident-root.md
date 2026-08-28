# Phase 56 Closeout: Incident Root Cause

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
078-incident-root — docker cp ownership/mode change evidence.

## Task
Document the root cause of the Wazuh outage: the `docker cp` ownership/mode change to ossec.conf.

## Evidence
- EB §8 (Incident A): a `docker cp` from host set config owner to host uid 1000 → wazuh user could not read → `wazuh-db ERROR (1226) Error reading XML file 'etc/ossec.conf'` → Wazuh outage.
- EB §8 (Incident B, related): Wazuh container recreate reset in-volume config to default (webhook_eb937a37, placeholder) — separate but reinforcing root cause class (config source not durable).
- Preventive (EB §8): any config edit must chown wazuh:wazuh + chmod 640 and be mirrored to the host bind source.

## Method
READ-ONLY-INSPECTION (root-cause evidence from EB §8).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No docker cp / config edit performed — respected (would re-introduce the defect).
- No host reboot / service deletion — respected.

## Limitations
The specific docker cp command/invoker is recorded as the causal action in EB §8; this report verifies the root-cause chain rather than re-enacting it.

## Verdict
DONE — root cause confirmed: docker cp set ossec.conf owner to host uid 1000, making it unreadable by wazuh user (wazuh-db ERROR 1226), causing the outage; preventive chown/chmod + host-bind mirror gate added (EB §8).
