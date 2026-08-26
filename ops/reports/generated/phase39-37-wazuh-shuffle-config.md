# Phase 39 Wazuh→Shuffle Integration Configuration of Record — CFG-39-01

**Report ID:** phase39-37-wazuh-shuffle-config  
**Phase:** 39  
**Title:** Current ossec.conf Integration State, Canonical Shuffle Target Design, Prerequisites and Rollback — DESIGNED-NOT-APPLIED  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** DEFERRED (owner gate: webhook creation requires UI action)  
**Record ID:** CFG-39-01  
**Author:** opencode/ox-alpha  
**Owner:** MCT SOC (automation: opencode/ox-alpha)  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-37-wazuh-shuffle-config.md`

---

## 1. Current State (verified live)

```
$ grep -n "integration" /opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf
35:  <!-- VirusTotal integration: hash-check FIM changes (files added/modified) -->
36:  <integration>            ← VirusTotal (syscheck), ACTIVE
41:  </integration>
89:  <!-- Osquery integration -->
338: <!-- DISABLED BY GUARDRAIL: Zeek Class A integration (kill switch) -->
342: <!-- <integration> … </integration> -->   ← commented out (P25 kill-switch pattern)
```

**No `<name>shuffle</name>` integration block exists.** Wazuh currently sends nothing
to Shuffle automatically; all P39 deliveries were API-triggered. Corroborating estate
fact: workflow `eb937a37…` carries only a legacy trigger object
(`id 24636c49-a2d0-40c2-887e-ccecdf22fc5c`, `is_valid=false`, no parameters) matching
the disabled Zeek-era hook URL — an unbound stub, not an active webhook.

## 2. Canonical Target Design

```xml
<integration>
  <name>shuffle</name>
  <api_key>[REDACTED-SHUFFLE-TOKEN]</api_key>
  <hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_$WORKFLOW</hook_url>
  <rule_id>86601, 2027967</rule_id>   <!-- Suricata lane + canary; plus high-sev group allowlist at enablement -->
  <alert_format>json</alert_format>
</integration>
```

Design notes:
- `hook_url` targets shuffle-backend on the shared mct-security bridge (Wazuh manager
  is a member; resolution verified healthy in phase39-30 §3).
- `webhook_$WORKFLOW` becomes concrete only after the workflow gains a real webhook
  trigger (§3).
- rule_id allowlist starts narrow (canary sid 2027967 family first) consistent with
  the estate's canary-first rollout pattern.
- Secret policy: token injected from protected env at provisioning time; **never
  committed in any file** — this document deliberately carries the placeholder only.

## 3. Prerequisite — Create Webhook Trigger on Workflow `eb937a37…`

UI path (documented for operator):
1. Shuffle → Workflows → `wazuh-high-severity-to-iris`.
2. Add Trigger → **Webhook**.
3. Copy generated hook id (`webhook_<uuid>`); set workflow status as required by runbook.
4. Save; verify hook responds 200 to a synthetic POST.

API alternative: none reliable — creation endpoints are auth-gated for user keys
(see WF-39-02 evidence: `POST /api/v1/workflows` → 401 while GET succeeds with the
same admin key). UI action is the owner gate.

## 4. Failure Semantics

Wazuh `integrationsd` behavior with an unreachable/failing hook: retries per internal
schedule, logs failures to `ossec.log`/integrations log; alert processing is NOT
blocked (log-only degradation). Shuffle-side drops are visible via ALERT-39-01 outcome
monitoring.

## 5. Backup Plan (pre-apply)

```bash
cp /opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf \
   ops/backups/ossec-manager-pre-shuffle-integration-$(date -u +%Y%m%dT%H%M%SZ).conf
ops/scripts/shuffle-workflow-export.sh    # fresh workflow snapshot incl. new trigger
sha256sum both artifacts → ops/evidence ledger
```

## 6. Apply Procedure (when ungated)

1. Insert block (§2) with concrete webhook URL + env-sourced api_key.
2. Restart wazuh-manager container(s) (`docker compose restart wazuh.manager`).
3. Verify: `grep shuffle ossec.log` shows integrationsd enabled; send canary test
   event; confirm execution appears (execution_source=webhook) and IRIS row lands.

## 7. Rollback

Remove the `<integration>` block; restart managers. Workflow/hook may remain (harmless,
unfed). No datastore or IRIS changes involved.

## Verdict

**CFG-39-01: DESIGNED-NOT-APPLIED.** Config surface fully specified; blocked solely on
webhook-trigger creation (UI-gated owner action), which is precondition (c) of
ROUT-39-01.
