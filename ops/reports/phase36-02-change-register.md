# Phase 36: Change Register

Date: 2026-08-25

## Gates

| Category | Gate | Status |
|---|---|---|
| Retention response | ISM policy attachment | PENDING |
| EVE changes | Suricata stats minimization | PENDING |
| Wazuh local options | decoder_order_size override | PENDING |
| Shuffle UI/workflow/routing | Workflow creation + tests | PENDING |
| Endpoint actions | 013/015 recovery | PENDING |
| /tmp cleanup | Scheduled automation | PENDING |
| Dashboards | W1/W2 enable | PENDING |
| Repo changes | Commit + push | PENDING |

## Safety constraints
- Do NOT raise disk watermarks
- Do NOT manually delete retention-managed indices
- No production Shuffle routing until native controls pass
- Synthetic events must not affect production counters
- Prefer Suricata stats minimization over field expansion

## No secrets
