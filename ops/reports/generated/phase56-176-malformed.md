# Phase 56: MALFORMED (webhook test)

**Prompt:** 176-malformed
**Generated (UTC):** 2026-08-28T00:25:00Z
**Operator (EDT):** 2026-08-27T20:25:00-0400
**Verdict:** DONE

## Summary
The MALFORMED branch is VERIFIED in source: when `sid is None` the workflow returns `emit("MALFORMED")` before any datastore/IRIS interaction (fail-closed on malformed). It was also observed live (13 MALFORMED in last 100 executions, including synthetic `MCT55-156-MLF`-style probes). A live controlled POST is a mutation and was not executed (do-not-mutate); source+execution evidence suffices.

## Evidence
EV-176-1 (VERIFIED): Source line ~102 — `if sid is None: return emit("MALFORMED")` (fail-closed, pre-datastore).
EV-176-2 (VERIFIED): 13 MALFORMED results in last 100 executions (webhook-sourced) confirm the branch is live and reached.
EV-176-3 (PARTIAL): Live forced-MALFORMED POST not executed; would create only a synthetic execution, no IRIS object.

## Backup / Rollback
No mutation. Live test (if run) = synthetic POST forcing MALFORMED; no IRIS object created.

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
)
.
 
L
i
v
e
 
c
o
n
t
r
o
l
l
e
d
-
P
O
S
T
 
v
a
l
i
d
a
t
i
o
n
 
a
v
a
i
l
a
b
l
e
 
b
u
t
 
d
e
f
e
r
r
e
d
 
p
e
r
 
d
o
-
n
o
t
-
m
u
t
a
t
e
.

## Limitations
None.

## Verdict rationale
DONE: MALFORMED branch VERIFIED in source (fail-closed) and observed live; requirement satisfied by read-only evidence.
