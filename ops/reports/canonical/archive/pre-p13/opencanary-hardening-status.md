# OpenCanary Hardening Status - Phase 3

Date: 2026-08-11

## Validated event path (D1 drill)

- OpenCanary hit (port 9100 tcpbanner) -> syslog -> Wazuh master 514
  -> rule 121012 level 12 (Class A) -> archives + alerts
- Result: **PASS** (verified live during Phase 05; archives count 18, alert fired)
- Caveat documented: bare TCP to SSH/telnet logs nothing; tcpbanner ports log instantly.

## Files created

- `integrations/opencanary/local-canary-validation.md` - deployment detail, validation test, caveats.
- `integrations/opencanary/canary-vm-plan.md` - mct-canary01 dedicated VM plan (placement guidance).
- `integrations/opencanary/canarytokens-plan.md` - token types, placement rules, lifecycle, FP controls.
- `ops/runbooks/deception-monitoring.md` - health checks, Class A response, FP cautions.

## Status summary

| Item | Status |
|---|---|
| Local event path validation test | DONE (PASS) |
| Service ports + FP cautions documented | DONE |
| Separate canary VM plan | DONE (mct-canary01, not built) |
| Canarytokens usage plan | DONE (no tokens deployed yet) |
| Wazuh/IRIS routing for canary hits | DONE (rule 121012 Class A; IRIS template opencanary-hit) |

## Open items

- Build mct-canary01 VM (Phase 4 or client request).
- Deploy first Canarytokens set (client site on request).
- Quarterly placement review.
