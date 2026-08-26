# Phase 15 Architecture Risk Register

Date: 2026-08-16

| # | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| 1 | Velociraptor native binary vs compose duplication | MED | confusion/repro failure | Document native as source-of-truth; mark compose deprecated |
| 2 | All remote agents on worker01 | LOW | worker outage = agent analysis loss | cluster config reviewed; worker restart tested |
| 3 | OpenCanary idle 24h | LOW | undetected decoy inactivity | weekly canary check in ops run |
| 4 | Docker `latest` tags | MED | non-reproducible stack | digest pinning P15.16 |
| 5 | ES snapshot repo growth (13G) | MED | disk pressure | retention policy P15.19 |
| 6 | DR config bundle 403 | MED | config restore local-only | keys refresh (P15.22) |
| 7 | Thin pool 87.84% | MED | lab pause | weekly watch (P15.21) |
| 8 | FP suppression event proof pending | MED | suppression may not work | P15.12/13 validation |
| 9 | Canarytoken T1 blocked | LOW | deception gap | hosted account |

## No secrets
