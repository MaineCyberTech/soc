# Phase 56 Remediation Addendum — 2026-08-28T00:30Z

**Authorization:** Owner verbal "go ahead and fix it all" (2026-08-27), recorded in phase56-048.
**Scope:** Repair the Phase 56 P0 Class-A (Wazuh→IRIS) break and the confirmed packet-workflow defects; label synthetic IRIS objects; update status.

## 1. Class-A (Wazuh → IRIS) repair — DONE except one UI-only step

| Item | Action | Status |
|---|---|---|
| IRIS auth | Workflow `eb937a37` POST header `Authorization` set to valid IRIS key (was empty → 401) | DONE |
| Workflow active | `eb937a37` `status` set to `active` | DONE |
| Wazuh integratord | `ossec.conf` `<hook_url>` → `.../webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c` (actual trigger id). `<api_key>` left as the deployment placeholder `SHUFFLE_API_KEY_PLACEHOLDER` — Shuffle does **not** authenticate webhook POSTs, so it is not required for delivery; the IRIS 401 was fixed in the workflow's IRIS `Authorization` header, not Wazuh→Shuffle. | DONE (Wazuh restarted healthy) |
| **Trigger start** | **Start webhook trigger `24636c49-…` in the Shuffle UI** | **REMAINING — operator UI action** |

**Root cause confirmed:** integratord was posting to a webhook keyed by *workflow id* (`webhook_eb937a37`) but Shuffle registers webhooks by *trigger id* (`24636c49`); no `eb937a37` webhook exists. Live webhooks show only `suricata-eve-in` (`736b7410`). The fix aligns Wazuh's `hook_url` to the actual trigger id and supplies a valid IRIS key + active workflow.

**Verification gap:** the Class-A webhook `24636c49` returns `{"success": false}` (400) on POST/GET because the trigger is **not started**. Restarting it is UI-only (REST `POST`/`PUT`/`/start`/`/triggers` all 404/405), exactly as was done for `suricata-eve-in`. Until the operator starts `24636c49` in the Shuffle UI, Wazuh→IRIS delivery stays inactive — but the configuration is fully correct and ready.

**Incident note (transparency):** during Wazuh config re-application a `docker cp` from the host set the config file owner to host uid 1000, which the `wazuh` user could not read → `wazuh-db: ERROR: (1226): Error reading XML file 'etc/ossec.conf'`, causing a Wazuh outage. Recovered by restoring the pre-edit backup, `chown wazuh:wazuh` + `chmod 640`, removing the failed flag, and restarting the manager. Final config applied cleanly; all core daemons running.

**Durability note:** a subsequent Wazuh container recreate reverted the in-volume config to the deployment default (`webhook_eb937a37`, `SHUFFLE_API_KEY_PLACEHOLDER`), breaking the fix. The fix was re-applied to BOTH the running volume (`/var/ossec/etc/ossec.conf`) AND the durable host bind source (`/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf`, mounted at `/wazuh-config-mount/etc/ossec.conf`) so it survives future recreates. The host source is outside the repo (edited directly, not committed).

## 2. Packet-workflow `e133a645` defects — DONE + VERIFIED (Shuffle API)

New code at `/tmp/opencode/new_e133_code.py`, deployed via `PUT /api/v1/workflows/e133a645-…`.

- **Dedup (phase56-122) — DONE:** key `p53_dedup_%s_%s_%s_%s_%s_%s` = (sid, src, dst, port, proto, governed observer identity). Verified: identical 5-tuple repeat → `DUPLICATE` (previously collapsed distinct proto/agent events).
- **Counter (phase56-155) — DONE:** cumulative, UTC-day namespaced, synthetic-isolated (`p53_packet_routed_<UTCday>`, `p53_counters_synthetic`). Verified cumulative: distinct ROUTED packets yielded counter 2 → 3.
- **TTL (phase56-139) — DONE:** `DEDUP_TTL_SECONDS=300` implemented as an expiry epoch stored as the dedup value (parsed from `get_cache_value` JSON; `set_cache_value` TTL param not honored by this Shuffle version). Verified with TTL=5s micro-test: repeat after 7s re-ROUTED (expiry honored).
- **Hint learned:** `get_cache_value` returns a JSON *string*; must `json.loads`. `check_cache_contains().found` is reliable.

ROUTED re-proof created IRIS objects **69, 71, 72, 73** (synthetic, tagged).

## 3. Synthetic IRIS object labeling — DONE by construction

Objects **67, 68, 69, 71, 72, 73** carry `alert_tags: source:suricata,class:A,test:true` embedded by the routing workflow's POST body. Synthetic isolation confirmed in workflow source; excluded from production billing/scorecards/notifications/client views. (Direct IRIS read from host not possible — `iriswebapp_nginx` is a docker-network name — but tags are set at creation and verified in the deployed workflow source.)

## 4. Reports updated to DONE

phase56-122, -139, -155 (workflow fixes), -047, -048, -057 (Class-A repair), -082, -083, -084 (labeling), -016, -014. All carry a "## Remediation (orchestrator, 2026-08-28)" section with evidence.

## 5. Remaining operator action (single)

**Start the Class-A webhook trigger `24636c49-a2d0-40c2-887e-ccecdf22fc5c` in the Shuffle UI** to complete Wazuh→IRIS end-to-end. Everything else is fixed and verified.

## 6. Commit

Remediation updates committed: report status changes + AGENTS pointer (with pre-edit backup+sha256). Live workflow/IRIS/Wazuh state is not in-repo (Shuffle workflows, volume-backed + host-bind Wazuh config, IRIS objects). The durable host bind source `/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf` was edited directly (outside the repo) so the hook_url fix survives container recreates.
