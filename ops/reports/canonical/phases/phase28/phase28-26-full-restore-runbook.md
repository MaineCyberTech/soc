# Phase 28 Full Restore Runbook

Date: 2026-08-24
Status: **RUNBOOK - EXECUTION REQUIRES APPROVED ISOLATED TARGET** (no production restore).

## Ordered procedure (scratch target)

1. Stand up scratch cluster per 24 (verified version/plugins match 23).
2. Register repository (FS mount or S3 nyc3) pointing at the snapshot source.
3. Snapshot verify: `/_snapshot/<repo>/_all` -> list; pick target snapshot.
4. Restore (indices-first, global state excluded):
   - `POST /_snapshot/<repo>/<snap>/_restore` body: indices list (or *, minus
     .opendistro_security), include_global_state=false, include_aliases=false,
     rename_pattern/replacement if scratch-namespacing, wait_for_completion=true.
5. Re-create required aliases/templates deliberately (elastiflow rollover, .kibana).
6. Validation:
   - `_cluster/health` green; shard counts match source; per-index doc counts vs snapshot;
     cross-index search; dashboard index present.
7. Application reconnect: point Wazuh/IRIS/dashboard at scratch (temporary env) OR validate
   data-only (recommended first drill).
8. Security handling: admin bootstrap on scratch; confirm login; do NOT restore prod
   security hashes.
9. Rollback: tear down scratch (24 teardown). Production untouched throughout.
10. Cleanup: confirm snapshot repo files never manually deleted; API-only (research notes).

## Not executed

- No isolated target + no approval -> runbook only (acceptance #4: no overstated evidence).

## No secrets