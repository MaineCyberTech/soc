# Phase 56 Closeout: Persistence

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
066-classa-persistence — Reload and container recreation evidence for trigger and config.

## Task
Verify that the Class-A config fix (hook_url, IRIS auth) and trigger survive Wazuh container reload / recreation.

## Evidence
- EB §3: config reverted on a container recreate; re-applied to BOTH running volume and durable host bind source (/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf) — survives recreates.
- EB §3: Wazuh healthy after restart (all core daemons running; no XML errors).
- EB §8 (Incident B): Wazuh container recreate reset in-volume config to default; fix re-applied to BOTH running volume and durable host bind source.

## Method
READ-ONLY-INSPECTION (durability evidence from EB §3/§8; no recreate performed).

## Backup
none — read-only (verification only).

## Rollback
none — read-only.

## Stop conditions
- No service recreation / restart triggered by this report — respected.
- No host reboot — respected.

## Limitations
Recreation was not re-executed in closeout; persistence is evidenced by the dual-apply (running volume + host bind source) recorded in EB §3/§8. A future recreate would re-confirm.

## Verdict
DONE — Class-A config fix persisted to both running volume and durable host bind source, surviving recreation per EB §3 and Incident B (EB §8).
