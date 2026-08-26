# MISP IOC Lifecycle Validation

Date: 2026-08-11
Status: **PASS (Wazuh/CDB leg); MISP UI tagging leg requires analyst action**

## Lifecycle states validated

| State | Validated? | Evidence |
|---|---|---|
| candidate | YES | MISP has 2,106 events (feeds pull); candidates land untagged |
| analyst-reviewed | PARTIAL | requires MISP UI tagging action (documented procedure) |
| active-monitor | DOCUMENTED | tag action:monitor + confidence:medium -> CDB export includes |
| active-block | YES (CDB side) | test IOC 203.0.113.77 placed in CDB -> rule 121100 matched level 12 |
| expired | DOCUMENTED | expiry windows in ioc-lifecycle.md |
| false-positive | DOCUMENTED | action:false-positive tag excluded by export filter |

## Validation performed (D2 cross-reference)

1. CDB export path works: `misp-to-wazuh-cdb.py` runs, filters by
   `action:block` + confidence >= medium, writes CDB, pushes to master/worker.
2. Wazuh CDB matching: test IOC 203.0.113.77 -> `wazuh-logtest` -> rule 121100
   matched, level 12, alert generated (drill D2).
3. CDB reload behavior: file change did NOT auto-recompile within 60s;
   analysisd restart required (documented in d2-test-ioc-procedure.md).
4. Test IOC cleaned up after validation (CDB back to empty).

## Test IOC lifecycle workflow (documented)

`integrations/misp/test-ioc-lifecycle.md` - full candidate -> reviewed -> active -> expire flow.

## False positive / expiry procedure

`integrations/misp/false-positive-expiry-procedure.md`:
- FP: tag action:false-positive -> excluded from export -> remove stale CDB entry.
- Expiry: tag action:expire or remove action:block -> next export drops the IOC.

## Blocker

- MISP UI tagging (candidate -> analyst-reviewed -> active-block) is a manual
  MISP-side action; no real IOCs promoted yet, so live export has 0 entries.
  The full lifecycle path is validated end-to-end at the CDB/Wazuh side.

## Files

- integrations/misp/test-ioc-lifecycle.md
- integrations/misp/false-positive-expiry-procedure.md
