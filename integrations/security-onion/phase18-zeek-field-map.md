# Phase 18 Zeek Field Map (current decoder)

Date: 2026-08-17

| Purpose | Field | Type | Notes |
|---|---|---|---|
| timestamp | zeek.ts | float | log stream ts |
| connection id | zeek.uid | string | Zeek UID |
| source IP | zeek.orig_h | string | client/initiator |
| source port | zeek.orig_p | integer | |
| destination IP | zeek.resp_h | string | responder |
| destination port | zeek.resp_p | integer | |
| protocol | zeek.proto | string | tcp/udp/icmp |
| conn_state | (full_log) | string | S0/ESTAB/etc - not extracted |
| bytes | (full_log) | int | not extracted |

## Rule usage

- Rules match <field name="zeek.orig_h">, zeek.resp_p, zeek.proto etc.
- High-value patterns: external resp_h + unusual resp_p, proto scan patterns.

## No secrets
