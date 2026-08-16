# Noise Triage Runbook

Purpose: cut alert volume without losing real detections. Measure -> classify -> tune -> verify.

## 1. Measure

```bash
/opt/mct-security-stack/ops/scripts/alert-volume-by-rule.sh 24
```

Review `ops/reports/alert-volume-by-rule-<ts>.md`. Save a baseline before ANY tuning.

## 2. Classify (Class A/B/C/D)

Use `integrations/wazuh/classification-matrix.md`. Common noise:

- UniFi roaming/churn/kick (120520, 120527, 120509-120532) -> Class C
- Routine WAN/LAN drops (120501, 120518) -> Class C
- mctportal benign (Caddy ACME, Sentry init) -> Class D
- Flow generic records -> Class D
- osquery inventory -> Class D

## 3. Tune (preferred order)

1. **Route change first** (monitor/workflow level) - no Wazuh restart needed.
2. **List suppression** - add known MACs to `etc/lists/known-devices` (unblocks 120527).
3. **Rule level change last** - only with backup + logtest + analysisd restart on both nodes.

## 4. Verify

- Before/after counts in `ops/reports/noise-tuning-plan.md`.
- Confirm no Class A/B alerts were dropped.
- Run full-stack-healthcheck + smoke test after any rule change.

## Escalation

Suspected false negative (missed attack): open IRIS case, restore rule, re-measure.
Never tune a rule to level 0 unless it is provably benign and archived.
