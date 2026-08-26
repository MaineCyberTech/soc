# Phase 35: Canary Volume and Quality Plan

Date: 2026-08-25

## Observation window
- **Duration**: Current observation window = since canary chain (18:15Z)
- **Rule 86601 alerts today**: 2 (1 synthetic canary + 1 real SPAN)
- **Total agent 016 alerts today**: 1,056

## Route/execution/suppression counters
- **Routes**: 0 (Shuffle-native routing not yet implemented)
- **Executions**: 0
- **Suppressions**: 0
- **Malformed**: 0
- **Failures**: 0

## FP review
- Both rule 86601 alerts are true positives:
  - SID 2027967: ET MALWARE LiLocked ransomware (synthetic, marked)
  - SID 2210038: SURICATA STREAM FIN out of window (real SPAN)

## Operator effort
- Monitoring: passive (no active response required)
- Investigation: ~30min total for canary E2E proof

## Route limit
- Not applicable (no routing configured)
- Recommended: 20/day once production routing is enabled

## Stop conditions
1. Disk >= 90%: Investigate immediately
2. False positive rate > 5%: Review and tune rules
3. Alert volume spike > 3x baseline: Investigate
4. Shuffle failure: External guardrail active, investigate within 4h

## Review ownership
- Operator: soc@mainecybertech.com
- Review date: Phase 36

## No secrets
