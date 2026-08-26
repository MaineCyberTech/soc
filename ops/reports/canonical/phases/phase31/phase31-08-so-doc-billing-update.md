# Phase 31 SO Doc and Billing Update

Date: 2026-08-24
Status: **UPDATED**.

## Documentation

- Architecture/stack overview: SO packet scanning marked **RETIRED**; replaced by the packet
  visibility decision (22) + device telemetry (20).
- Product scope + risk statements updated (SO outage residual risk documented; compensating
  telemetry = NetFlow, endpoint logs).
- Runbooks/scorecards: agent 008 shown as retired.

## Billing

- Service coverage reflects retirement: raw packet scanning no longer billed; compensating
  visibility (NetFlow + endpoint) retained. Updated in billing (74).

## No secrets