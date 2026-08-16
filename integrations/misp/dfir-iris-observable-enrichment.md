# DFIR-IRIS Observable Enrichment (MISP)

Purpose: enrich IRIS case observables with MISP context at case creation and during triage.

## Flow

```text
IRIS alert/case created (from Wazuh/Shuffle)
  -> enrichment worker (or manual lookup) queries MISP for each observable
  -> result: match/no-match, event id, tags, confidence
  -> IRIS case observables annotated; tags added to case; decision made (monitor vs block)
```

## Observable types queried

- IP (srcip/dstip) -> MISP `ip-src`, `ip-dst` attributes
- Domain/hostname -> `domain`, `hostname`
- File hash -> `sha256`/`md5`
- User agent (from flow rules) -> `user-agent`

## Implementation options

1. **Manual**: analyst opens MISP GUI, searches observables, pastes results into case notes.
2. **Shuffle workflow** (`misp-ioc-enrichment`): HTTP GET to MISP API per observable; add tags to IRIS case via IRIS API.
3. **Scheduled batch**: nightly script enriches open cases' observables and updates tags (log output to report).

## Enrichment decision table

| MISP result | IRIS action |
|---|---|
| Match, confidence high, action:block | Class A, immediate notify, add block candidate |
| Match, confidence medium | Class B, analyst review, monitor |
| Match, action:monitor | Monitor, note in case |
| No match | Proceed with normal triage; candidate IOC if evidence strong |

## Failure modes

- MISP down: skip enrichment, flag case as `unverified` until enrichment completes.
- API rate limits: batch queries with delay; cache results in Shuffle variables.
- Over-matching (FP in MISP): tag `action:monitor`; do not auto-block.

## Data retention

- Enrichment results stored in IRIS case notes/observables. MISP retains events per expiry policy.
