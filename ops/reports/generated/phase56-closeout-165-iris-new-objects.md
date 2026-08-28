# Phase 56 Closeout: Read New Closeout Objects

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
165-iris-new-objects — Read the new closeout objects (markers and tags).

## Task
Identify and read back the IRIS objects created during the Phase 56 closeout rerun, and confirm their synthetic markers and tags.

## Evidence
- EB §5: genuine closeout rerun ROUTED via live webhook 736b7410, producing objects 72 and 73. These are the new closeout objects.
- EB §4: objects 72 and 73 — title "P53 Packet Routing", tags `source:suricata,class:A,test:true`, customer=1, source=suricata. Synthetic isolation CONFIRMED by stored-object state.
- EB §2: live webhook 736b7410-ed6a-52af-b369-89dbef6386cb (`suricata-eve-in`) on workflow e133a645 is the only live intake; ROUTED verified via it.
- Overlay (AGENTS-P56-CLOSEOUT-OVERLAY): synthetic objects must be labeled and excluded from production downstream consumers.

## Method
READ-ONLY-INSPECTION (value-blind). New-object identity from EB §5; tag confirmation from EB §4. No new object created here.

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No secret value exposure — respected.
- No GET against Shuffle webhook — respected.
- No production routing / trigger-start — respected.

## Limitations
This report identifies closeout-created objects via EB §5 reference rather than a fresh live enumeration. Tag values are read from EB §4 read-back, not re-queried.

## Verdict
DONE — new closeout objects are 72 and 73 (EB §5), both confirmed with synthetic tags `source:suricata,class:A,test:true`, customer=1, source=suricata per EB §4.
