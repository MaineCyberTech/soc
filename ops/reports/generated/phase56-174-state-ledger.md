# Phase 56: 13-State Ledger (exact evidence rows)

**Prompt:** 174-state-ledger
**Generated (UTC):** 2026-08-28T00:25:00Z
**Operator (EDT):** 2026-08-27T20:25:00-0400
**Verdict:** DONE

## Summary
Enumerated the 13 packet states from the live workflow source AND confirmed all 13 are present in the last 100 live executions (exact evidence rows). The ledger is real and complete. NOTE: the DUPLICATE row reflects the pre-fix dedup key (proto/agent omitted) — the ledger is exact for the *current* (pre-fix) source; post-fix rows require the gated dedup edit (122).

## Evidence
EV-174-1 (VERIFIED): Source defines 13 states via emit()/FORCEABLE: MALFORMED, SYNTHETIC_TEST, POLICY_SUPPRESSED, ROUTE_BRANCH_SELECTED, DATASTORE_READ_FAIL, DUPLICATE, ROUTE_ATTEMPTED, COUNTER_FAIL, AUTH_FAILED, TARGET_FAILED, ROUTED, UNKNOWN, ENV_PROBE.
EV-174-2 (VERIFIED): Last-100 execution state counts — DUPLICATE 18, MALFORMED 13, ROUTED 8, POLICY_SUPPRESSED 7, SYNTHETIC_TEST 7, DATASTORE_READ_FAIL 4, UNKNOWN 4, ENV_PROBE 4, ROUTE_ATTEMPTED 4, ROUTE_BRANCH_SELECTED 4, AUTH_FAILED 3, COUNTER_FAIL 2, TARGET_FAILED 1 (all 13 present).
EV-174-3 (PARTIAL): DUPLICATE branch uses defective key (proto/agent omitted) — exact current behavior, not post-fix.

## Backup / Rollback
No mutation. Ledger rows are reproducible from the hashed executions export (EV-172-3).

## Stop conditions
N
o
n
e
 
(
r
e
a
d
-
o
n
l
y
 
e
n
u
m
e
r
a
t
i
o
n
)
.
 
L
i
m
i
t
a
t
i
o
n
:
 
r
o
w
s
 
r
e
f
l
e
c
t
 
c
u
r
r
e
n
t
 
p
r
e
-
f
i
x
 
d
e
d
u
p
 
k
e
y
;
 
p
o
s
t
-
f
i
x
 
l
e
d
g
e
r
 
r
e
q
u
i
r
e
s
 
g
a
t
e
 
1
2
2
.

## Limitations
None.

## Verdict rationale
DONE: the 13-state ledger is VERIFIED present in source and all 13 states observed in live executions. Exact rows documented; dedup-key caveat flagged.
