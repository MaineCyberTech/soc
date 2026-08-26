# Phase 30 Endpoint Management Audit

Date: 2026-08-24

## Agents / groups

- 013 SAMSUNG (transient offline; EID1 76, EID7 39/24h), 014 DESKTOP-MI54LFT (active;
  EID1 150, EID7 0), 015 Julians-Air (active, certified), 012 pilot (active), 008 SO
  (disconnected - VM down), 006/007/011 (active infra/client).

## Sysmon / macOS / enrollment / policy

- Sysmon 15.21 (schema 4.91) policy BCA0EB applied; EID7 collapse proven (58.8K/1h -> 39/24h).
- Markers: **operator RMM pending** (013/014) - certification PARTIAL; throttles RETAIN.
- 015 macOS bounded/certified. Enrollment via install-wazuh-*.sh (idempotent).

## RMM / privacy / billing

- Level.io/RMM-safe scripts (no-arg). Privacy: 4104 gated. Billing: 3/3 coverage.

## Findings

- Markers + PS4104 pilot + throttle retirement require operator endpoint action (RMM).

## Verdict

- **PARTIAL** (telemetry strong; markers pending operator).

## No secrets