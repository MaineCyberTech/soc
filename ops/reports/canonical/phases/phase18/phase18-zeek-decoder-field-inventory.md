# Phase 18 Zeek Decoder Field Inventory

Date: 2026-08-17

## Status: DECODER EXTENDED + FIELDS VERIFIED

## Actual fields (verified via logtest + archives)

| Field | Sample value | Source |
|---|---|---|
| zeek.ts | 1786944699.809369 | prematch regex |
| zeek.uid | CcY51d48a71Q86Yxc | prematch regex |
| zeek.orig_h | 10.10.202.1 | child decoder |
| zeek.orig_p | 44872 | child decoder (digits) |
| zeek.resp_h | 255.255.255.255 | child decoder |
| zeek.resp_p | 10001 | child decoder (digits) |
| zeek.proto | udp | child decoder |

## Why not the json decoder

- Generic json decoder created data.id object colliding with archives top-level
  id keyword -> docs rejected. zeek.* namespace avoids collision.

## Why owlh rules failed

- Ruleset 0635-owlh-zeek_rules.xml matches bro_engine (owlh field); our decoder
  emits zeek.* - never matched. Fixed by extending decoder to zeek.* fields.

## What's NOT extracted (in full_log only)

- conn_state, orig/resp bytes, missed_bytes, community_id, vlan, MAC OUIs.
  Available via full_log match if needed (backlog).

## Files

- integrations/security-onion/phase18-zeek-field-map.md (created)

## No secrets
