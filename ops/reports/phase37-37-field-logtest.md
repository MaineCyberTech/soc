# Phase 37-37: Log Test Design

**Status:** DESIGN  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Objective

Run a representative Suricata stats record through `wazuh-logtest -a` on the manager container.

## Capture Points

1. Phases decoded
2. Fields parsed
3. Rule matched (expected: 86601)
4. Errors (especially "Too many fields")
5. Total field count

## Method

- Suricata is **not running on host**; use a synthetic stats event matching the expected schema
- Execute `wazuh-logtest -a` on manager container
- Inject synthetic event and capture full output

## Synthetic Event Template

A stats event containing nested counters for: `capture`, `decode`, `flow`, `tcp`, `udp`, `http`, `app_layer`, `detect`, `iprep`, `file_store`, `drop`, `alert`, and other Suricata stats categories.

## No secrets
