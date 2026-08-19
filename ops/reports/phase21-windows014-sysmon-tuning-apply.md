# Phase 21 Windows 014 Sysmon Tuning Apply

Date: 2026-08-19
Status: **BLOCKED - ENDPOINT ACCESS + APPROVAL** (014 not reachable from stack host; apply requires operator on 014).

## 1. Approval + endpoint access

- Approval: plan prepared and documented (phase21-windows014-sysmon-eid7-analysis +
  phase21-eventid7-tuning-plan); apply is approval-gated.
- Endpoint access: 014 (192.168.111.162) is NOT routable from the stack host (client network);
  no RDP/SSH/Velociraptor client action authorized this phase. **No direct apply possible.**

## 2. What was prepared (ready to apply)

- `integrations/sysmon/sysmon-mct.xml` - tuned config with targeted EventID 7 excludes.
- `integrations/sysmon/phase21-windows014-sysmon-tuning-plan.md` - apply steps.
- `integrations/sysmon/phase21-windows014-sysmon-rollback.md` - rollback.

## 3. Operator steps (to run on 014)

See `integrations/sysmon/phase21-windows014-operator-steps.md`:
copy config -> `.\Sysmon64.exe -c sysmon-mct.xml` -> verify service + agent keepalive.

## 4. Validation (SOC-side after apply)

- EventID 7 volume drop >=90%; EventID 1/10 unchanged; agent 014 buffer clean.
- Phase 21.10 before/after validation.

## 5. Decision

- Apply: **BLOCKED** (endpoint access). Handoff delivered. Re-attempt when operator has access.

## No secrets