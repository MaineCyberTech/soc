# Phase 53: Trigger Schema

**Prompt:** 052-trigger-schema
**Generated (UTC):** 2026-08-27T20:07:40Z
**Operator (EDT):** 2026-08-27T16:07:40-0400
**Verdict:** DONE

## Summary
Compare the packet trigger (suricata-eve-in) schema with the working Class-A trigger. Both are
WEBHOOK-type triggers in the same org; differences are name, bound workflow, and custom_url param.

## Evidence
- E1: suricata-eve-in — id 736b7410-ed6a-52af-b369-89dbef6386cb, type WEBHOOK, wf e133a645-..., custom_url="p39-suricata-test", status=running.
- E2: wazuh-high-severity — id eb937a37-5244-46dc-95ff-62ad4c681322, type WEBHOOK, wf eb937a37-..., no custom_url override, status=running.
- E3: both share org 264c0502-9136-4cfc-938b-390b97b861b8; both in OpenSearch `hooks` index with running=True.
- E4: workflow e133a645 has exactly 1 action (execute_python) + 1 WEBHOOK trigger; eb937a37 has 2 actions (Shuffle Tools + HTTP).

## Backup / Rollback
N/A (read-only comparison).

## Stop conditions (BLOCKED only)
None.

## Limitations
Schema fields beyond name/type/bound-workflow/custom_url not diffed field-by-field (no need; both valid WEBHOOKs).

## Verdict rationale
Both triggers confirmed WEBHOOK type, same org, running; differences enumerated. DONE.
