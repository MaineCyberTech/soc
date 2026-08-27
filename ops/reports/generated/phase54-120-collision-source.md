# Phase 54: Source Collision

**Prompt:** 120-collision-source
**Generated (UTC):** 2026-08-27T21:28:32Z
**Operator (EDT):** 2026-08-27T17:28:32-0400
**Verdict:** DONE

## Summary
Verify the packet-routing dedup key distinguishes by source IP so two events differing only in
source are not collapsed. The workflow `suricata-packet-routing` (e133a645) builds the dedup key
from a 5-tuple that includes `src_ip`, so source is a distinctness dimension.

## Evidence
- E1 — workflow source code `/tmp/opencode/pkt_code.py` line 120: `dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port)` — `src` (src_ip) is part of the key.
- E2 — live dedup store (`org_cache-000001`, category `p53_dedup`, 37 docs) shows distinct keys per source, e.g. `p53_dedup_2027967_10.53.222.7_10.53.222.8_8443` vs `p53_dedup_2027967_10.56.52.7_10.56.52.8_8443`.
- E3 — trigger `736b7410-…` (suricata-eve-in) RUNNING, bound to workflow e133a645 (live API enumeration).

## Backup / Rollback
Read-only analysis; N/A.

## Stop conditions
None.

## Limitations
Source distinctness confirmed for the 5-tuple scheme; see 123/124 for proto/agent gaps.

## Verdict rationale
Source IP is an explicit component of the dedup key and appears distinct across live dedup entries.
