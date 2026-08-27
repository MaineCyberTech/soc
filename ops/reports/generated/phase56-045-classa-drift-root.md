# Phase 56: Drift Root Cause

**Prompt:** 045-classa-drift-root
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Root-caused the Class-A drift reported in Phase 55 carryover. It is **NOT** a rebuild/restore
artifact; it is a configuration/API-representation mismatch plus an un-started trigger plus a
group-filter that drops all alerts. Three compounding factors:

1. **Webhook-id mismatch (primary):** Wazuh `hook_url` uses `webhook_eb937a37-5244-46dc-95ff-62ad4c681322`
   (the *workflow* id) but Shuffle registers webhooks keyed by the *trigger* id. The live
   `suricata-eve-in` webhook URL is `webhook_736b7410-…` where `736b7410` == its trigger id. The
   Class-A trigger id is `24636c49-a2d0-40c2-887e-ccecdf22fc5c`, so the correct URL would be
   `webhook_24636c49-…`. Wazuh posts to a webhook key that has no matching live trigger.
2. **Trigger not in live registry (secondary):** `GET /api/v1/triggers` lists only `suricata-eve-in`.
   The Class-A trigger `24636c49` is absent — it was never started in the UI (UI-only start, per
   AGENTS.md) or was not persisted to the live registry. The workflow's embedded trigger object
   still self-reports `status=running`, which is why the workflow definition looks "live" but the
   runtime registry disagrees (API-representation drift).
3. **Integratord group filter (tertiary):** `<group>suricata,</group>` — all sampled alerts are
   skipped ("Group doesn't match"), so even if the webhook id were correct, no alert currently
   forwards.

## Evidence
- EV-DRIFT-01 (VERIFIED): `wazuh_manager.conf:346` hook_url = `webhook_eb937a37-…` (workflow id). (Wazuh integratord layer.)
- EV-DRIFT-02 (VERIFIED): `GET /api/v1/triggers` → 1 webhook (`suricata-eve-in` 736b7410); Class-A `24636c49` absent. (REST/trigger layer.)
- EV-DRIFT-03 (VERIFIED): `suricata-eve-in` `info.url` = `webhook_736b7410-…` where id == trigger id ⇒ confirms Shuffle keys webhooks by trigger id, not workflow id. (Webhook/REST layer.)
- EV-DRIFT-04 (VERIFIED): Workflow `eb937a37` `status=test`, embedded trigger `24636c49` `status=running` (configured) but not in live registry ⇒ API-representation drift, not rebuild/restore. (REST layer.)
- EV-DRIFT-05 (VERIFIED): integratord group-skip on all sampled alerts (040). (Wazuh integratord layer.)

## Backup-Rollback
Read-only. No change. Current-state hashes recorded in 046.

## Stop conditions
Correction (align hook_url to `webhook_24636c49`, start trigger in UI, fix group filter, refresh
IRIS app auth) is owner/approval-gated: 047 (repair-plan), 048 (approval), 049 (start), 050
(align), 057 (reload). STOP — do not mutate.

## Limitations
- We did not diff against a pre-drift backup to prove no rebuild occurred; the trigger object's
  persistence in the workflow definition plus absence from the live registry is sufficient to
  classify it as API-representation/start-state drift.
- The exact moment the trigger dropped from the live registry is not reconstructed (no trigger
  history API consulted); inferred from UI-only-start design note in AGENTS.md.

## Verdict rationale
Drift root cause identified and evidenced as webhook-id mismatch + un-started/missing live trigger +
group-skip — not rebuild/restore. DONE (read-only root-cause; repair deferred).
