# Phase 24 Windows Dashboard (W1/W2) and PowerShell Readiness

Date: 2026-08-22
Status: **REFRESHED - DEPLOYMENT GATED on endpoint noise control**.

## 1. W1/W2 dashboard status

- W1 (Windows events dashboard) / W2 (Sysmon dashboard) remain **staged** (query/saved-search
  definitions exist in integrations/sysmon backlog docs; no live dashboard deployment).
- Reason: alert/archive signal is suppressed by the EID7 throttle on 014 (and now flooding on
  013) - dashboards would show throttled/incomplete data.

## 2. PowerShell ScriptBlockLogging / D-rules

- **PREPARED only**; enable after endpoint noise is controlled (per pack guidance).
- Gating: 013 + 014 EID7 tuned (>=99% drop) + throttle retired -> then enable
  ScriptBlockLogging via group policy + D-rule detections (backlog).

## 3. Decision

- **NOT READY to deploy** - endpoint noise must be controlled first (C1). Status refreshed;
  no partial deployment.

## No secrets