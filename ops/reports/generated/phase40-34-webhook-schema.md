# Phase 40 Webhook Event Schema — Canonical Document

**Report ID:** phase40-34-webhook-schema
**Phase:** 40
**Title:** Wazuh→Shuffle Webhook Payload Schema — Required Fields, Passthrough, Synthetic Markers, Routing-Class Derivation, Fail-Closed Rejection Rules
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:06:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-34-webhook-schema.md`

---

## 1. Purpose

Canonical schema for events crossing the Wazuh→Shuffle webhook lane (CFG-40-01).
Derived from the actual integratord payload captured on the live chain
(canary E2E-007, master ossec.log 01:28:55Z) — not from documentation.

## 2. Envelope Built by wazuh-integratord (measured)

```json
{
  "severity": 1,
  "pretext": "WAZUH Alert",
  "title":   "<rule.description>",
  "text": null,
  "rule_id": "<rule.id>",
  "timestamp": "<wazuh alert timestamp +0000>",
  "id": "<wazuh alert id>",
  "all_fields": { ...full Wazuh alert object verbatim... }
}
```

**Event id = Wazuh alert id** (`<epoch>.<sequence>`, e.g. `1787707735.1208554`).
This is the join key across: indexer doc, `/tmp/shuffle-*.alert` filename,
workflow execution payload, and IRIS-derived correlation.

## 3. Required Fields (inside `all_fields`)

| Field | Type | Role | Absence behavior |
|---|---|---|---|
| `rule.id` | string | rule identity; envelope `rule_id` | alert would not be in suricata lane without a rule |
| `rule.level` | int | severity mapping → envelope `severity` | required by decoder; level-too-low skips happen upstream of shuffle |
| `rule.groups[]` | array | **sole lane filter input** (`suricata,` group match) | no match → integratord skips (fail-closed) |
| `agent.id`, `agent.name` | string | source endpoint identity | present for agent-reported alerts |
| `id` | string | event id (§2) | always present on analysisd output |
| `timestamp` | string | ordering / SLA measurement | always present |
| `location` | string | origin file (`/var/log/suricata/eve-alert.json`) | present |
| `data.*` | object | sensor passthrough branch (`data.alert.*`, `data.flow_id`, …) | EVE alerts carry it by design |

## 4. Optional Passthrough

Everything under `data.*` is passed through verbatim — including the synthetic
marker set when present:

| Marker | Meaning |
|---|---|
| `MCT_SYNTHETIC=true` | content is synthetic; never counts as production detection |
| `MCT_TEST_ID=P40-WEBHOOK-E2E-007` | unique test-case identifier |
| `MCT_TEST_ONLY=true` | excluded from production counters/scorecards/billing per AGENTS.md isolation rule |

Downstream consumers MUST check these markers before counting anything as real.

## 5. Routing-Class Derivation

Derivation happens at the WORKFLOW layer (post-hook), not at integratord:

```
if "suricata" in all_fields.rule.groups      -> packet lane   (Class-B/packet)
elif groups contain opencanary / high-sev    -> Class-A lane  (honeypot/high-sev)
else                                          -> generic log lane (notify-only)
```

Current wiring sends only the packet lane through this hook (group `suricata,`);
Class-A OpenCanary deliveries continue via their existing path (phase40-38 §2).

## 6. Fallback / Rejection Rules (fail-closed)

1. **No group match → no send.** Measured debug evidence:
   ```
   wazuh-integratord[15315] integrator.c:240 at OS_IntegratorD(): DEBUG:
   Skipping: Group doesn't match.
   ```
   (master ossec.log, repeated 02:00:38–02:00:44Z during post-proof observation —
   non-suricata alerts correctly never reach Shuffle.)
2. **Malformed JSON → integratord logs and skips** the integration run for that
   alert; alert processing itself is NOT blocked (log-only degradation,
   consistent with phase39-37 §4 semantics).
3. **Transport failure → no queue, no retry** (integratord fires once). Failure is
   visible to the ALERT-39-01 monitor as FAILED/ABORTED; see phase40-39 §4–§6.
4. **Hook datastore miss → HTTP 404 from backend**, no workflow execution created
   ("Failed getting hook … hooks index" — the defect fixed in phase40-36 §3).

## 7. Verdict

**SCHEMA DOCUMENTED: COMPLETE — VERIFIED against a live captured payload.**
All field claims above are backed by the E2E-007 debug dump embedded in
phase40-35 §2 and phase40-37 §4.
