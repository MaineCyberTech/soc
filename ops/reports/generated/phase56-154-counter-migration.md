# Phase 56: Flag Migration (Do Not Interpret Old Flag as Count)

**Prompt:** 154-counter-migration
**Generated (UTC):** 2026-08-28T00:12:00Z
**Operator (EDT):** 2026-08-27T20:12:00-0400
**Verdict:** PARTIAL

## Summary
Read-only analysis of migrating the legacy `p53_packet_routed` flag into a real count, ensuring the old flag value is never interpreted as a cumulative count. The legacy value is `"1"` (constant) and must be treated as a boolean presence, not a tally. Any new atomic counter must be initialized fresh (not seeded from the flag) to avoid misrepresenting historical counts. The migration/rewrite is owned by gate **155 (counter-increment)** → BLOCKED.

## Evidence
- EV-SRC (VERIFIED): Live workflow source inspected.
- EV-CNT (VERIFIED): Legacy `set_cache_value(key="p53_packet_routed", value="1", category="p53_counters")` (line 147) — constant `"1"`, semantically a flag.
- EV-LEGACY (VERIFIED): Phase 55 carryover confirms `p53_packet_routed` historically stored `"1"` (flag), never a count. Interpreting `"1"` as "1 packet" would be a false positive if/when migrated.
- EV-MIG (UNVERIFIED): No migration code present in live source (feature absent; owned by 155).

## Backup / Rollback
Read-only. No mutations. Secret referenced by ID/path only.

## Stop conditions
Gate 155 (counter-increment) BLOCKED — not edited. No other gated action. No webhook GET.

## Limitations
No migration logic exists yet; correctness of migration (fresh init, not seeded from flag) is a design requirement for BLOCKED gate 155, not verifiable here.

## Verdict rationale
Legacy flag semantics VERIFIED (`"1"`, not a count). Migration to real count pending BLOCKED gate 155. PARTIAL.

## Evidence separation
- REST / API: EV-SRC, EV-CNT.
- Webhook: trigger metadata only.
- Wazuh integratord / sensor-origin: not implicated.
