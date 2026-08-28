# Phase 45: Packet Workflow State Schema

## State Definitions
Each packet event transitions through exactly ONE terminal state. States are mutually exclusive and collectively exhaustive.

| State | Code | Description | Metrics Category | Retention |
|-------|------|-------------|------------------|-----------|
| **MALFORMED** | `malformed` | Missing required fields (sid, src, dst, port, proto) | `packet.malformed.count` | 90 days |
| **SYNTHETIC_TEST** | `synthetic` | MCT_SYNTHETIC=true; isolated, never routed | `packet.synthetic.count` | 30 days |
| **POLICY_SUPPRESSED** | `not_allowed` | SID not in allowlist (only 2027967 permitted) | `packet.suppressed.count` | 90 days |
| **DUPLICATE** | `duplicate` | Dedup key exists in cache (300s TTL) | `packet.duplicate.count` | 30 days |
| **ROUTED** | `routed` | Successfully delivered to IRIS (HTTP 200/201) | `packet.routed.count` | 365 days |
| **TARGET_FAILED** | `target_fail` | IRIS delivery failed (HTTP != 200/201, timeout, network) | `packet.target_fail.count` | 90 days |
| **AUTH_FAILED** | `auth_fail` | IRIS auth object missing/invalid (distinct from target_fail) | `packet.auth_fail.count` | 90 days |
| **DATASTORE_FAILED** | `datastore_fail` | Cache/datastore operation failed (dedup check, counter) | `packet.datastore_fail.count` | 90 days |
| **COUNTER_FAILED** | `counter_fail` | Counter increment failed (separate from datastore) | `packet.counter_fail.count` | 90 days |
| **UNKNOWN** | `unknown` | Unclassified / logic error | `packet.unknown.count` | 30 days |

## State Transitions
```
START
  → validate_fields()
      FAIL → MALFORMED
      PASS → check_synthetic()
          TRUE → SYNTHETIC_TEST
          FALSE → check_allowlist()
              FAIL → POLICY_SUPPRESSED
              PASS → check_dedup()
                  HIT → DUPLICATE
                  MISS → increment_counter()
                      FAIL → COUNTER_FAILED
                      PASS → route_to_iris()
                          AUTH_ERROR → AUTH_FAILED
                          HTTP 200/201 → ROUTED
                          HTTP != 200/201 → TARGET_FAILED
                          NETWORK/Timeout → TARGET_FAILED
                          DATASTORE_ERROR → DATASTORE_FAILED
                          UNHANDLED → UNKNOWN
```

## Mutual Exclusivity
- Each event resolves to EXACTLY ONE terminal state
- No event can be both DUPLICATE and ROUTED
- SYNTHETIC_TEST events never reach dedup/routing logic
- POLICY_SUPPRESSED events never reach dedup/routing logic
- MALFORMED events never reach any downstream logic

## Metrics Collection
| Metric | Type | Labels | Source |
|--------|------|--------|--------|
| `packet.malformed.count` | Counter | `sid` | validate_fields() |
| `packet.synthetic.count` | Counter | `sid` | check_synthetic() |
| `packet.suppressed.count` | Counter | `sid` | check_allowlist() |
| `packet.duplicate.count` | Counter | `sid,src,dst,port` | check_dedup() |
| `packet.routed.count` | Counter | `sid,src,dst,port` | route_to_iris() success |
| `packet.target_fail.count` | Counter | `sid,http_status` | route_to_iris() failure |
| `packet.auth_fail.count` | Counter | `error_type` | auth object resolution |
| `packet.datastore_fail.count` | Counter | `operation` | cache/datastore ops |
| `packet.counter_fail.count` | Counter | `counter_name` | set_cache_value() |
| `packet.unknown.count` | Counter | `error` | catch-all |

## Dedup Key Schema
```
p44_dedup_{sid}_{src}_{dst}_{port}
```
- **TTL:** 300 seconds (5 minutes)
- **Category:** `p44_dedup`
- **Value:** `1` (presence indicator)

## Counter Schema
```
p44_packet_routed
```
- **Category:** `p44_counters`
- **Increment:** +1 per ROUTED event
- **Persistence:** Survives workflow restart (Shuffle cache)

## IRIS Payload Schema
```json
{
  "alert_title": "Suricata Packet Alert",
  "alert_source": "suricata",
  "alert_source_ref": "<sid>-<src>",
  "alert_severity_id": 6,
  "alert_customer_id": 1,
  "alert_status_id": 2,
  "alert_source_content": {
    "sid": <integer>,
    "src": "<ip>",
    "dst": "<ip>",
    "port": <integer>,
    "proto": "<TCP|UDP|ICMP|...>"
  },
  "alert_tags": "source:suricata,class:A,packet:true"
}
```

## State Machine Implementation (execute_python)
```python
# Each event returns exactly one state
result = {"state": "<ONE_OF_ABOVE>", "sid": <int>, "details": {}}
# No event produces multiple states
assert len([k for k in result if k in STATES]) == 1
```

## Validation Rules
1. **Exhaustive:** Every possible input maps to a state
2. **Exclusive:** No input maps to more than one state
3. **Deterministic:** Same input → same state (given same cache state)
3. **Observable:** Each state emits its counter metric

---
*Generated: 2026-08-27T03:40:00Z (UTC) / 2026-08-26T23:40:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
