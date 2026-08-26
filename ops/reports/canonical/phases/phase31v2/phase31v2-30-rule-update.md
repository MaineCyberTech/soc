# Phase 31v2 Rule Update Process

Date: 2026-08-24
- Ruleset versioned in repo (mct-alerts.rules); update path: edit -> config gate (suricata
  -T + rule load) -> FP/volume review -> deploy to /etc/suricata/rules -> restart -> drift
  check. No automatic rule downloads (no ET subs needed). Guardrail protects routing.

## No secrets
