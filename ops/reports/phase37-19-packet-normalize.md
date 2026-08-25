# Phase 37-19: Packet Normalization Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Normalize raw Suricata/Wazuh packet alert fields into a consistent schema for downstream routing, dedup, metrics, and storage.

## Normalized Fields

| Field | Source | Fallback |
|---|---|---|
| `wazuh_rule_id` | `rule.id` | `0` |
| `wazuh_rule_desc` | `rule.description` | `"unknown"` |
| `suricata_sid` | `alert.signature_id` | `0` |
| `suricata_signature` | `alert.signature` | `"unknown"` |
| `agent_id` | `agent.id` | `"unknown"` |
| `agent_name` | `agent.name` | `"unknown"` |
| `source_ip` | `src_ip` / `source.ip` | `"0.0.0.0"` |
| `dest_ip` | `dest_ip` / `destination.ip` | `"0.0.0.0"` |
| `source_port` | `src_port` / `source.port` | `0` |
| `dest_port` | `dest_port` / `destination.port` | `0` |
| `protocol` | `proto` / `network.protocol` | `"unknown"` |
| `severity` | `alert.severity` (mapped) | `"unknown"` |
| `category` | `alert.category` / `event.category` | `"unknown"` |
| `timestamp` | `@timestamp` / `timestamp` | current ISO8601 |
| `is_synthetic` | Computed | `false` |
| `test_id` | If test event | `null` |
| `tenant` | If available | `"default"` |
| `routing_class` | Computed from SID allowlist | `"production"` |

## Timestamp Handling

- Extract from `@timestamp` or `timestamp` field
- Normalize to ISO8601 (`2026-08-25T12:34:56.789Z`)
- Fallback to current system time if missing

## Severity Mapping

| Suricata Priority | Normalized Severity |
|---|---|
| 1 | `critical` |
| 2 | `high` |
| 3 | `medium` |
| 4 | `low` |
| Unknown | `unknown` |

## Fallback Rules

All fallbacks use safe defaults:
- Strings: `"unknown"`
- Integers: `0`
- IPs: `"0.0.0.0"`
- Timestamp: current ISO8601
- Booleans: `false`

## No secrets
