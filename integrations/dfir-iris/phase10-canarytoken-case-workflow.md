# Phase 10 Canarytoken Case Workflow (DFIR-IRIS)

Date: 2026-08-15

## Trigger paths (validated)

1. **OpenCanary VM (canary01)**: syslog 15140 -> Wazuh rule 121000/121007/121014 (lvl 12) -> Shuffle -> IRIS. VALIDATED (P9/P10).
2. **Local OpenCanary**: syslog 15140 -> rule 121012 -> IRIS. VALIDATED (P10).
3. **Hosted Canarytokens T1** (pending account): token hit -> webhook -> Shuffle -> IRIS.

## Case workflow

1. Alert fires (Wazuh lvl 12 canary rule).
2. Shuffle workflow creates/updates IRIS case (opencanary-hit template).
3. Triage: source (src_ip), token type, placement, touched content.
4. False positive handling: notify-only; document + close.
5. Incident: containment per incident-triage runbook.

## Evidence

- Wazuh alert: rule id, node_id, src/dst, logtype.
- Canary event JSON (full_log).
- Shuffle execution_id (e.g., afd4de3c for routing test).
- IRIS case id.

## No secrets

No secret values printed.
