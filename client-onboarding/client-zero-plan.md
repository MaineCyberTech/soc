# Client Zero Plan

Client Zero = internal MCT (Maine Cyber Tech) treated as the first monitored client.

## Why Client Zero

- Validate the full monitoring lifecycle on ourselves before external clients.
- Proven path: intake -> asset scope -> deployment -> monitoring -> reporting -> offboarding.
- De-risks external onboarding.

## Scope

- Client name: Maine Cyber Tech (Internal)
- Sites: MCT HQ (192.168.222.0/24), mct-portal cloud (138.197.105.82)
- In-scope assets: Wazuh host, mct-portal droplet, Security Onion, PVE, gateways
  (same as core-infrastructure monitoring group)

## Coverage (what MCT monitors)

| Capability | Status |
|---|---|
| Endpoint monitoring (Wazuh agents) | LIVE (006 docker-host, 007 mct-portal-dev, 008 securityonion) |
| Network flow analysis | LIVE (ElastiFlow, 3 exporters) |
| Deception (OpenCanary) | LIVE (local canary); mct-canary01 pending build |
| Vulnerability scanning | READY (weekly schedule created 2026-08-15) |
| Intrusion detection (SO Suricata) | LIVE (agent 008 path) |
| Case management (IRIS) | LIVE |
| Threat intel (MISP) | LIVE (CDB path validated) |

## Milestones

1. Intake form complete (client-zero-intake.md)
2. Asset scope defined (client-zero-asset-scope.md)
3. Escalation matrix defined (client-zero-escalation.md)
4. First scorecard generated (client-zero-scorecard.md)
5. Periodic review monthly

## Client-safe

- No internal secrets in any Client Zero document.
- No stack internals beyond what a client would be told.

## Status

- Plan: COMPLETE
- Intake/scope/escalation: complete (this phase)
- First scorecard: complete (Phase 5.14)
