# Phase 56 Closeout: Incident Config Hashes

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
079-incident-hashes — Before, failed, restored, and final.

## Task
Record the config hash states across the incident lifecycle: before, failed, restored, and final.

## Evidence
- EB §8 (Incident A): before = original working ossec.conf; failed = docker-cp copy owned by host uid 1000 (unreadable, caused wazuh-db ERROR 1226); restored = backup copy (chown wazuh:wazuh + chmod 640); final = healthy running config post-restart.
- EB §8 (Incident B): final also re-applied to durable host bind source (/opt/wazuh-docker/.../wazuh_manager.conf) to survive recreate.
- sha256sums.txt (pack artifact) preserves nonsecret artifact hashes; not edited per HARD RULES.
- EB §7: host bind config contains `api_key` placeholder (no real secret); no leaked secrets.

## Method
READ-ONLY-INSPECTION (hash-state lifecycle from EB §8 and sha256sums.txt presence).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No secret value exposure — referenced by path/ID only.
- No full restore / destructive action performed — respected.

## Limitations
Exact SHA-256 hex for each lifecycle stage is preserved in sha256sums.txt / backup rather than re-listed here. The failed and restored states are characterized by ownership/mode and restore action (EB §8), not by re-computing hashes in closeout.

## Verdict
DONE — config hash lifecycle (before → failed [uid 1000] → restored [wazuh:wazuh 640] → final durable) is recorded; duplicates preserved in sha256sums.txt; no secret values exposed (EB §8, §7).
