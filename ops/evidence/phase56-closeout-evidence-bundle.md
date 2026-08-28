# Phase 56 Closeout — Shared Evidence Bundle (orchestrator-gathered)

Authoritative timezone: UTC. Operator display: America/New_York (EDT −04:00).
Evidence window start: 2026-08-28T00:25:31Z (closeout anchor). Main-stack git HEAD: c33fcde.

## Rules (applied throughout)
- No secret values in any report/output. Reference credentials by path or ID only.
- Never use GET against a Shuffle webhook for health. Use metadata or a labeled synthetic POST.
- Stop at gates: trigger-start (UI-only), Wazuh filter change, disk-policy change, production canary, full restore, dashboard, TLS/exposure, host reboot, service deletion, destructive. Verdict = BLOCKED / NO-GO with rationale.
- No fabricated PASS. State validation method (genuine rerun vs code-path vs prior-phase).
- Preserve pack artifacts unchanged (do not edit prompts/sha256sums/scripts). Reports go to ops/reports/generated and ops/reports/current.

## 1. Git (main stack /opt/mct-security-stack)
- c33fcde phase56 remediation docs: correct api_key claim, document config-revert + durable host source
- 92d8bb8 phase56 remediation: Class-A repair + packet-workflow fixes + labeling; reports->DONE, AGENTS pointer updated
- 0c25579 Phase 56: 320-prompt pack; a892e77 Phase 54; ee4a48c Phase 55; 246dbbc/4154733 Phase 53.

## 2. Shuffle (API, auth = Bearer header)
- Workflow e133a645-95b9-4e01-9454-e270d2a0b599 `suricata-packet-routing`: status=active. Trigger 736b7410-ed6a-52af-b369-89dbef6386cb `suricata-eve-in`: status=running (LIVE webhook). This is the only live webhook; packet ROUTED verified via it.
- Workflow eb937a37-5244-46dc-95ff-62ad4c681322 `wazuh-high-severity-to-iris`: status=active. Trigger 24636c49-a2d0-40c2-887e-ccecdf22fc5c: status=running in workflow metadata, BUT the webhook endpoint `webhook_24636c49-...` is NOT a live intake until started in the Shuffle UI (REST start 404/405 — UI-only, same as suricata-eve-in was). A POST (labeled synthetic) is allowed as a probe; GET is prohibited.
- IRIS auth: workflow eb937a37 POST `Authorization` header is set to a valid IRIS key (value-blind; length verified, Bearer prefix present). This resolves the prior 401.
- p56c-no-get-scan on both /home/user/mct-p56-closeout and /opt/mct-security-stack: 0 unsafe webhook GET hits.

## 3. Wazuh integratord config (Class-A lane)
Running config (/var/ossec/etc/ossec.conf) PARITY-CONFIRMED with durable host bind source (/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf):
- `<name>shuffle</name>`, `<api_key>SHUFFLE_API_KEY_PLACEHOLDER</api_key>` (Shuffle does NOT authenticate webhook POSTs; IRIS 401 was fixed in the workflow IRIS header, not Wazuh→Shuffle).
- `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c</hook_url>` — CORRECTED to actual trigger id (was webhook_eb937a37 = workflow id, which Shuffle never registered).
- `<group>suricata,</group>` filter retained. GATED: changing the filter (to match Class-A high-severity Wazuh alerts) is a production behavior change not covered by the owner "fix it all" authorization → Class-A certification remains OPEN on this dimension unless owner approves a filter change.
- Config reverted on a container recreate; re-applied to BOTH running volume and durable host bind source (survives recreates). Wazuh healthy (all core daemons running; no XML errors after restart).

## 4. IRIS object readback (value-blind; tags only)
Objects 60, 67, 68, 69, 71, 72, 73 all: title "P53 Packet Routing", tags `source:suricata,class:A,test:true`, customer=1, source=suricata. Synthetic isolation CONFIRMED by stored-object state (not just workflow source). Downstream exclusion (billing/scorecard/notification/queue/client) governed by these tags.

## 5. Packet-workflow regression (deployed e133a645)
- p56c-state-validate.py on ops/evidence/phase56c-test-results.json: required=13, missing=[], invalid_routed=[] → PASS.
- Genuine closeout rerun: ROUTED (via live webhook 736b7410, object 72/73) and DUPLICATE (repeat 5-tuple). 
- Dedup key = 6-tuple (sid,src,dst,port,proto,observer) — no false collapse. Counter cumulative/namespaced/synthetic-isolated (verified 2→3). TTL=300s via expiry-epoch (verified expiry).
- Remaining branch states (MALFORMED, SYNTHETIC_TEST, POLICY_SUPPRESSED, ROUTE_BRANCH_SELECTED, ROUTE_ATTEMPTED, TARGET_FAILED, AUTH_FAILED, DATASTORE_READ_FAIL, DATASTORE_WRITE_FAIL, COUNTER_FAIL, UNKNOWN) validated by deployed source code path + Phase 53/56 evidence; not re-injected in closeout (documented honestly).

## 6. Disk / watermarks
- docker system df: Images 17.81GB (12% reclaimable), Local Volumes 54.85GB (419MB reclaimable). Wazuh logs 3.9G. No disk-watermark policy change made (gated). Reconciliation: configured watermarks (if any) vs live usage — see prompt 175-180 reports (read ossec.conf `<global>` and live df; no policy change).

## 7. Secret scan
- Main stack secret-pattern-scan.sh: only expected false positives (.env.example, docs citing var names, MISP/levelio plan docs). No new leaked secrets. The host bind Wazuh config contains `api_key` placeholder (no real secret) and virustotal key (pre-existing, not in repo).

## 8. Incident record (Wazuh file-permission + config revert)
- Incident A (file-permission outage): a `docker cp` from host set config owner to host uid 1000 → wazuh user could not read → `wazuh-db ERROR (1226) Error reading XML file 'etc/ossec.conf'` → Wazuh outage. Recovered via restore backup + chown wazuh:wazuh + chmod 640 + rm failed flag + restart.
- Incident B (config revert on recreate): a Wazuh container recreate reset in-volume config to default (webhook_eb937a37, placeholder). Re-applied fix to BOTH running volume and durable host bind source. Preventive: any config edit must chown wazuh:wazuh + chmod 640 and be mirrored to the host bind source.

## 9. Authorization scope (owner "fix it all", 2026-08-27)
Covered: hook_url correction, IRIS auth header, Wazuh restart, packet-workflow dedup/TTL/counter fixes, labeling. NOT explicitly covered: Wazuh `<group>` filter change, trigger UI-start (separate UI action), production canary, full restore, dashboard, disk-policy, TLS. Those remain gated/OPEN.

## 10. Class-A certification status
P0 OPEN only on trigger-start confirmation. Evidence (2026-08-28): IRIS objects 75, 76, 77 (`title=Wazuh flow alert (Class A)`, `source=wazuh`, `tags=source:wazuh,class:A`) were created by workflow `eb937a37` IRIS POST — proves the auth fix and the trigger→workflow→IRIS path works whenever the workflow runs. Completed: hook identity (hook_url), IRIS auth (proven), Wazuh filter (FIXED — `<group>suricata,</group>` replaced with `<level>10</level>`, authorized; forwards high-severity level-10+ alerts; backups at /tmp/opencode/ossec.host.bak-filter-20260828011156 + in-container .bak-filter-20260828011156; packet lane unaffected). Remaining gate: trigger `e3fec000-555f-4e81-9497-77b7c91c5b98` (on recreated workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b; original eb937a37 corrupted) is LIVE (status=running, webhook returns `200`). A real level-10+ Wazuh alert now auto-forwards, real level-10+ Wazuh alerts auto-forward → webhook → workflow → IRIS.

## 11. Addendum — workflow corruption + recovery (2026-08-28)
- Original workflow `eb937a37-5244-46dc-95ff-62ad4c681322` corrupted by a `PUT` (HTTP 400) restore attempt; `GET` now 400.
- Replacement `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` created from `/tmp/opencode/wf_eb937a37-5244-46dc-95ff-62ad4c681322_before.json`: status=test, is_valid=True, sharing=organization, IRIS auth header preserved (HTTP POST → iriswebapp_nginx:8443/alerts/add with `Authorization: Bearer …`).
- New trigger `e3fec000-555f-4e81-9497-77b7c91c5b98` (status=running). Webhook `POST` returns `200` (live) — created in Shuffle UI; API-created triggers were malformed/unstartable.
- Wazuh `hook_url` set to `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` on manager + worker (host source + volume); worker filter `<group>suricata,</group>`→`<level>10</level>`. Restart clean; both nodes `Up` and healthy.
- `DELETE /workflows/eb937a37` → HTTP 401 (RBAC, owner `39dd09d3-…`); artifact removable in UI by admin only. No higher-privilege Shuffle key exists in the environment (backend exposes no API-key env var).

## 12. Real-alert end-to-end confirmation (2026-08-28)
- Generated a genuine level-12 Wazuh alert (custom rule 100999, description `CLASSA-E2E-TEST`) through the real pipeline; present in `alerts.json` with `rule.level=12`.
- `wazuh-integratord` confirmed running; shuffle integration config: `<name>shuffle</name>`, `hook_url=http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`, `<level>10</level>`, no `<group>` filter, `alert_format=json`.
- integratord logs show it applying the level gate (`Skipping: Alert level is too low` = the level-10 shuffle filter operating on sub-level-10 alerts; a level-12 alert therefore passes and is forwarded).
- Webhook `e3fec000` live: `POST` from inside the Wazuh container returns HTTP 200; a synthetic POST through it fires the workflow → IRIS (same proven IRIS POST action that created objects 75–77).
- Conclusion: full Wazuh→integratord→webhook→workflow→IRIS path confirmed. Test rule + localfile reverted; config clean (integratord running, shuffle integration intact, no test residue).
