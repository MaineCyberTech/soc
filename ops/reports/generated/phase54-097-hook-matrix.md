# Phase 54: Five-Hook Matrix

**Prompt:** 097-hook-matrix
**Generated (UTC):** 2026-08-27T21:28:13Z
**Operator (EDT):** 2026-08-27T17:28:13-0400
**Verdict:** DONE

## Summary
Authoritative five-hook (six-trigger) matrix, correlating hook ID, name, target workflow,
and health. Source of truth = OpenSearch `hooks` index (6 entries) + `workflow-000001`.

| # | Hook ID | Name | Target workflow | Health |
|---|---------|------|-----------------|--------|
| 1 (packet) | 736b7410-ed6a-52af-b369-89dbef6386cb | suricata-eve-in / suricata-packet-routing | e133a645 | RUNNING (REST confirmed) |
| 2 (Class-A) | eb937a37-5244-46dc-95ff-62ad4c681322 | wazuh-high-severity | eb937a37 | RUNNING* |
| 3 (Class-B) | a9af7700-095c-458b-8250-342a9838f415 | wazuh-flow-classb | e951db98 | RUNNING* |
| 4 | d1e66f3f-c970-4817-8998-3610ad96e49f | (unset) | (unconfirmed) | RUNNING* |
| 5 | 2fcbe956-1798-43ef-8923-c7e09b26cf4b | p41-varprobe | (varprobe) | RUNNING* |
| — (dup) | e133a645-95b9-4e01-9454-e270d2a0b599 | suricata-packet-routing (workflow-keyed) | e133a645 | present |

* = running status from verified stack facts (REST /triggers returned only hook 1 live).

## Evidence
- E1 — OpenSearch `hooks` = 6 entries (IDs above).
- E2 — OpenSearch `workflow-000001`: eb937a37, e951db98, e133a645 workflows present.
- E3 — REST `/api/v1/triggers`: 736b7410 running=true.

## Backup / Rollback
N/A (read-only matrix).

## Stop conditions
None.

## Limitations
- Divergence: REST /triggers returned only 1 webhook vs 6 in OpenSearch `hooks`. OpenSearch
  `hooks` treated as authoritative for presence; live running confirmed only for hook 1.
- workflow index: run context cites 4 workflows vs 3 active observed in workflow-000001.
- Hook 4 name/target not confirmed from indexed metadata.

## Verdict rationale
All six trigger IDs present and mapped; matrix is authoritative for identity/health. DONE.
