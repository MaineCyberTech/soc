# Phase 22 Windows 014 Sysmon Tuning Apply

Date: 2026-08-22
Status: **BLOCKED - ENDPOINT ACCESS + APPROVAL** (no remote path to 014 this phase).

## 1. Approval + access

- Approval: plan is approval-gated; no explicit approval received for endpoint apply this phase.
- Access: unavailable (see phase22-windows014-sysmon-precheck.md). **No apply performed.**

## 2. Config to apply (when access + approval exist)

- `integrations/sysmon/phase22-windows014-applied-config.xml` (recorded copy of the targeted
  ImageLoad-exclusion config; identical policy to sysmon-mct.xml from P21).
- Preserves suspicious/non-standard ImageLoad visibility; EventID 1/10 untouched.

## 3. Operator steps (from P21, still current)

1. Hash current config: `certutil -hashfile C:\Windows\Sysmon\sysmon-config.xml SHA256`.
2. Copy `phase22-windows014-applied-config.xml` to 014.
3. `.\Sysmon64.exe -c <config>.xml` (reload; service stays running).
4. `sc query Sysmon64` + recent EventChannel events; confirm agent 014 keepalive.

## 4. Validation after apply (SOC-side)

- EventID 7 agent-side volume drop >=90% (target < 60K/day vs ~573K).
- EventID 1 + EventID 10 still flowing (agent-side; note archives may be suppressed until the
  rule-11 throttle clears after the flood stops).
- Agent buffer: no flooded/full events for 24h.
- Record command/output without secrets.

## 5. Decision

- **BLOCKED** (endpoint access + approval). Handoff delivered. Re-attempt with operator.

## No secrets