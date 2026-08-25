# Phase 37-22: Packet Dedup Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Suppress duplicate Suricata packet alerts within a time window to prevent redundant routing and case creation.

## Dedup Key

```
SHA256(suricata_sid + source_ip + dest_ip + dest_port + hour_bucket)
```

- `suricata_sid`: Signature ID from Suricata alert
- `source_ip`: Source IP address
- `dest_ip`: Destination IP address
- `dest_port`: Destination port
- `hour_bucket`: Current hour truncated (e.g., `2026-08-25T12:00:00Z`)

The hour bucket ensures dedup resets every hour, allowing legitimate recurring alerts to route after the window expires.

## TTL

- **TTL:** 1 hour
- Entries older than 1 hour are expired and no longer suppress
- Hour bucket alignment ensures natural TTL without external timer

## Lookup Mechanism

- **Storage:** Shuffle datastore (`datastore_category`)
- **Write-on-first-seen:** First event with a given key is written and routed
- **Duplicate detection:** Subsequent events with same key are suppressed

## Duplicate Behavior

On duplicate detection:
1. **Suppress routing** — event is not forwarded to test group or production
2. **Increment `dup_counter`** — track total suppressions for observability
3. **Record evidence** — `dedup_key`, `first_seen`, `last_seen` stored for audit

## Failure Handling

- **Fail closed on datastore error:** If datastore read/write fails, event is NOT routed
- Prevents duplicate events from leaking through during infrastructure issues
- Operator notified on datastore failure

## Evidence Fields

| Field | Description |
|---|---|
| `dedup_key` | SHA256 hash of the dedup input |
| `first_seen` | Timestamp of first event with this key |
| `last_seen` | Timestamp of most recent event with this key |

## No secrets
