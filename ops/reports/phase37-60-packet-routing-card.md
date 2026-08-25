# Phase 37 — Packet Routing Card

**Date:** 2026-08-25

## Capture

- **Sensor:** Suricata on agent 016 (mct-packet-sensor)
- **Status:** Active
- **Alerts Today:** 1,095

## Ingest

- **Pipeline:** eve.json → Wazuh
- **Status:** Active

## Indexing

- **Target:** OpenSearch
- **Status:** Active

## Workflow

- **Status:** NOT CONFIGURED

## Test Routing

- **Status:** DESIGN ONLY

## Production Routing

- **Status:** DEFERRED

## Evidence

- Agent 016 active and capturing
- 1,095 Suricata alerts generated today
- eve.json → Wazuh ingest pipeline operational
- OpenSearch indexing confirmed

## Blockers

1. Workflow not created
2. Field errors ongoing (18,849)
3. No test volume data collected

## Ownership

- **Owner:** SOC

## Runbook

Refer to P37 prompts 17–31 for packet workflow creation, validation, dedup, counter, route, malformed handling, replay, failure, and rollback procedures.

## Summary

Suricata capture on agent 016 is active with 1,095 alerts today. eve.json → Wazuh → OpenSearch pipeline is operational. Workflow not created, routing deferred. Blockers include missing workflow, field errors, and no test volume data.

## No secrets
