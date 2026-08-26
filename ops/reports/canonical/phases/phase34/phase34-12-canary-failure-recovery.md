# Phase 34 Canary Failure and Recovery

Date: 2026-08-25

## Failure scenarios
| Scenario | Behavior | Recovery |
|---|---|---|
| Workflow unavailable | Alert suppressed, state logged | Auto-retry next cycle |
| Datastore failure | Guardrail blocks routing | Operator notified |
| Malformed input | Rejected, metrics recorded | No route/case created |
| Kill switch triggered | All canary routing disabled | Manual re-enable |
| Daily limit reached | Alerts suppressed | Counter resets next day |

## Guardrail independence
- External guardrail (zeek-classa-guardrail.sh) operational regardless of Shuffle state
- Provides fail-safe when native controls unavailable

## No secrets
