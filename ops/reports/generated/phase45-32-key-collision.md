# Phase 45: Dedup Key Collision Matrix

## Key Format
`p44_dedup_{sid}_{src}_{dst}_{port}`

## Collision Test Matrix

| Test | SID | Src IP | Dst IP | Port | Proto | Expected | Reason |
|------|-----|--------|--------|------|-------|----------|--------|
| Base | 2027967 | 10.0.0.1 | 192.168.1.10 | 443 | TCP | ROUTED | New key |
| Diff Proto | 2027967 | 10.0.0.1 | 192.168.1.10 | 443 | UDP | **DUPLICATE** | Proto not in key |
| Diff Port | 2027967 | 10.0.0.1 | 192.168.1.10 | 80 | TCP | ROUTED | Port in key |
| Diff Src | 2027967 | 10.0.0.2 | 192.168.1.10 | 443 | TCP | ROUTED | Src in key |
| Diff Dst | 2027967 | 10.0.0.1 | 192.168.1.11 | 443 | TCP | ROUTED | Dst in key |
| Diff SID | 2027968 | 10.0.0.1 | 192.168.1.10 | 443 | TCP | ROUTED | SID in key |
| Missing Src | 2027967 | null | 192.168.1.10 | 443 | TCP | **MALFORMED** | Missing field |
| Missing Dst | 2027967 | 10.0.0.1 | null | 443 | TCP | **MALFORMED** | Missing field |
| Missing Port | 2027967 | 10.0.0.1 | 192.168.1.10 | null | TCP | **MALFORMED** | Missing field |

## Protocol Collision Decision
**Protocol EXCLUDED from key** - same attack over TCP/UDP should dedup.
- Rationale: Attack signature (SID) same; protocol is transport detail
- Risk: False positive dedup across protocols (accepted)

## Agent Collision Decision
**Agent ID EXCLUDED from key** - same alert from multiple sensors should dedup.
- Rationale: Same attack seen by multiple agents = same event
- Risk: False positive dedup across agents (accepted)

## Missing Field Handling
**Fail closed (MALFORMED)** - unstable key → reject event.
- Missing src/dst/port → key unstable → cannot reliably dedup
- Event classified MALFORMED → dead-letter → operator review

## Protocol Collision Test
```bash
# TCP event
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"proto-tcp"}'

# UDP event (same SID, 5-tuple)
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"UDP"},"MCT_TEST":"proto-udp"}'
# Expected: DUPLICATE (proto not in key)
```

## Agent Collision Test
```bash
# Simulate same alert from agent A
curl -X POST ... -d '{"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"agent-a"}'

# Same alert from agent B (simulated via same payload)
curl -X POST ... -d '{"MCT_TEST":"agent-b",...}'
# Expected: DUPLICATE (agent not in key)
```

## Missing Field Test
```bash
# Missing src_ip
curl -X POST ... -d '{"alert":{"signature_id":2027967,"dest_ip":"192.168.1.10","dest_port":443,"proto":"TCP"},"MCT_TEST":"missing-src"}'
# Expected: MALFORMED
```

## Verification
| Test | Expected | Actual | Pass/Fail |
|------|----------|--------|-----------|
| Proto collision | DUPLICATE | [State] | [PASS/FAIL] |
| Agent collision | DUPLICATE | [State] | [PASS/FAIL] |
| Diff port | ROUTED | [State] | [PASS/FAIL] |
| Diff src | ROUTED | [State] | [PASS/FAIL] |
| Diff dst | ROUTED | [State] | [PASS/FAIL] |
| Diff SID | ROUTED | [State] | [PASS/FAIL] |
| Missing src | MALFORMED | [State] | [PASS/FAIL] |
| Missing dst | MALFORMED | [State] | [PASS/FAIL] |
| Missing port | MALFORMED | [State] | [PASS/FAIL] |

## Fail-Closed Policy
Any unstable key (missing components) → MALFORMED → dead-letter → operator review.
**Never** guess or default missing key components.

---
*Generated: 2026-08-27T04:00:00Z (UTC) / 2026-08-26T00:00:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after dedup expiry (Phase 45-31)*
