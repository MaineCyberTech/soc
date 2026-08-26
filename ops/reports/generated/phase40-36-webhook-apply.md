# Phase 40 Webhook Apply Record — APP-40-01

**Report ID:** phase40-36-webhook-apply
**Phase:** 40
**Title:** Apply Record APP-40-01 — Three-Defect Fix Chain, Command Chronology, Restarts, Validation Gates, Result ACTIVE
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:09:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Record ID:** APP-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-36-webhook-apply.md`

---

## 1. Scope and Approval Basis

Applies CFG-39-01's design as realized CFG-40-01 during the operator-directed live
session of **2026-08-26 00:56–01:45Z** (Phase 40 webhook arc). Register note: the
field-arc change register tracks this lane as adjacent G40-04 (PENDING, "certification
owned by SOAR arc"); formal sign-off line remains open at the corpus commit gate.
Rollback path existed BEFORE enablement (phase39-37 §7 → phase40-35 §8), satisfying
the AGENTS.md native-control + rollback requirement.

## 2. Three-Defect Discovery Chain (chronological)

### Defect 1 — Trigger node invalid
Workflow `eb937a37…` carried webhook trigger `24636c49…` with `is_valid=False`,
`status=''`. **Fix:** set running/valid via workflow PUT. Hook endpoint still failed;
shuffle-backend log during ops window:

```
Failed getting hook … 404 hooks index
```

### Defect 2 — Missing hooks datastore doc
Shuffle resolves hook URLs through the `hooks` index; a UI save normally creates the
doc. **Fix:** registered directly:

```
PUT shuffle-opensearch hooks/_doc/eb937a37-5244-46dc-95ff-62ad4c681322
```
cloning structure from existing hook doc `d1e66f3f…` (fields: start=24636c49 trigger
id, status=running, type=webhook, owner=soc@mainecybertech.com, workflows, org_id,
version fields). Result — FIRST WEBHOOK EXECUTION:

```
{"success": true, "execution_id": "f28cb7e2…"}   -> IRIS alert 40 @ 00:57:16Z
```

### Defect 3 — Manager-side DNS isolation
ossec.conf integration added to master (replacing the stale commented block whose URL
was WRONG: `webhook_24636c49` = trigger-node-id instead of workflow-id). Manual fire
failed with `NameResolutionError shuffle-backend`: manager container on
`multi-node_default` could not resolve mct-security names. **Fix** (mirrors P39 IRIS
fix pattern):

```bash
docker network connect mct-security multi-node-wazuh.master-1
```

Manual fire then worked (HTTP 200, exec `46b8fe3d`, IRIS alert 41 @ 01:12:34Z).

## 3. Defects 4–5 — Cluster Routing and Filter Semantics

- **Defect 4:** injected canaries E2E-001..003 landed in WORKER alerts.json (agent 016
  reports via worker pre-restart) while master integratord saw nothing. Cluster
  insight: each node runs its own analysisd/integratord for its agents. **Fix:**
  identical integration block added to WORKER ossec.conf (worker already attached to
  mct-security).
- **Defect 5:** `<rule_id>86601</rule_id>` did not match in this build (debug:
  `Skipping: Group doesn't match.` despite rule_id present; level-too-low skips were
  VirusTotal). **Fix:** replaced filters with `<group>suricata,</group>` on BOTH
  nodes → integratord FIRED for canary E2E-007.

## 4. Command Chronology (abridged, secrets-free)

| t (UTC) | Action |
|---|---|
| ~00:56 | Trigger validity PUT (`is_valid=true`, status running) |
| ~00:57 | hooks doc PUT; hook POST probe → exec f28cb7e2 → IRIS 40 |
| ~00:58–01:03 | master ossec.conf integration block added; backup `.bak-pre-shuffle-p40` taken container-side after host-side perm-denial |
| 01:03:41 | master restart #1 → `Enabling integration for: 'shuffle'` |
| ~01:05–01:12 | DNS failure observed on manual fire; `docker network connect mct-security multi-node-wazuh.master-1`; MANUAL-FIRE-2 → exec 46b8fe3d → IRIS 41 |
| 01:14:23 | master restart #2 (config iteration) |
| 01:19:44 | worker restart #1 (worker block added) |
| ~01:20–01:26 | rule_id filter proven non-matching; group filter applied both nodes |
| 01:26:21 | master restart #3 |
| 01:28:19 | master + worker final restarts |
| 01:28:55 | canary E2E-007 fired through full chain → IRIS 42 |

## 5. Validation Gates

1. **XML parse caveat:** multiple `<ossec_config>` roots are legal in ossec.conf;
   a single-file ElementTree parse false-alarms here — validated via Wazuh's own
   config test + clean daemon startup instead (documented, accepted method).
2. **Enabling-integration lines captured** at every restart:

```
master 2026/08/26 01:03:41 wazuh-integratord: INFO: Enabling integration for: 'shuffle'.
master 2026/08/26 01:14:23 wazuh-integratord: INFO: Enabling integration for: 'shuffle'.
worker 2026/08/26 01:19:44 wazuh-integratord: INFO: Enabling integration for: 'shuffle'.
master 2026/08/26 01:26:21 wazuh-integratord[13028] integrator.c:143 … 'shuffle'.
master+worker 2026/08/26 01:28:19 wazuh-integratord[15315] integrator.c:143 … 'shuffle'.
```

3. **Sync md5 check:** master `/var/ossec/etc/ossec.conf` ==
   `/wazuh-config-mount/etc/ossec.conf` == md5 `6de1e19907739482004ad40b182318c6`.
4. **Functional gate:** E2E-007 debug shows file write + send (phase40-37 §4);
   all restarts clean.

## 6. Result

**APPLY RESULT: ACTIVE on both nodes.** Five defects found and fixed in-session;
chain recovered after each fix without manual replay of earlier stages.
