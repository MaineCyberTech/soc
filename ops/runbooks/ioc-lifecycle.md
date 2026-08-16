# MISP IOC Lifecycle

Lifecycle states and governance for IOCs flowing from MISP into Wazuh CDB lists,
detection, and IRIS routing.

## IOC states

| State | Meaning | Detection behavior |
|---|---|---|
| candidate | Raw feed event, not yet reviewed | no alerting, enrichment only |
| analyst-reviewed | Human confirmed value/type | eligible for monitoring |
| active-monitor | Confidence medium; alert if matched | Class B route, level <= 10 |
| active-block | Confidence high; block/quarantine intent | Class A route, level 12 style |
| expired | Past expiry window; removed from CDB | none |
| false-positive | Known benign; suppressed immediately | removed from CDB, excluded from feeds |

## Confidence model

- low: enrichment only (MISP lookups on IRIS cases)
- medium: alert if matched (Class B)
- high: Class A route / level 12 style workflow

## Expiry guidance (policy suggestions - not enforced locally yet)

| IOC type | Suggested expiry |
|---|---|
| scanner IP | short-lived (e.g. 30 days) |
| confirmed C2 | longer-lived (e.g. 90 days, renew if still active) |
| client-specific IOC | case-dependent (linked to IRIS case) |
| false positive | suppress immediately |

## Flow

1. Feeds pull events into MISP (candidate).
2. Analyst reviews and tags: `confidence:low|medium|high` + `action:monitor|block`.
3. CDB export job (`misp-to-wazuh-cdb.py`) pulls `action:block` + confidence >= medium.
4. Wazuh CDB rules (121100+) alert on match.
5. Expired/false-positive IOCs removed from MISP tags (action:expire) and CDB regenerated.
6. False positives: tag `action:false-positive`; export job excludes them.

## CDB export diff process

Before/after comparison of CDB file (see misp-cdb-diff-report.sh):
- Counts of IOCs added/removed per run
- Sample of newly added values (values are IOCs, not secrets - OK to show)
- Verification that master and worker CDB files are identical

## Enforcement

- The export script only includes `action:block` + `confidence:medium|high` tags.
- Cron runs the export daily (verify in root crontab).
- No automated blocking: CDB match only routes to Class A/B workflow; actions remain manual.
