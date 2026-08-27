# Phase 56: Monitor Execution Path

**Prompt:** 234-os-monitor-path
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Identified the supported network path the OpenSearch monitor must use.

## Evidence
- EV-OS-MON-1 (VERIFIED): The Phase 55 monitoring gap ("Empty reply from 127.0.0.1:9200") is explained: `127.0.0.1:9200` is the **Wazuh indexer** (plaintext disabled → empty reply; https → 401), NOT the Shuffle datastore. A monitor must not target loopback:9200 for Shuffle OS.
- EV-OS-MON-2 (VERIFIED): The supported path to the Shuffle OpenSearch is the `mct-security` overlay — in-network as `http://shuffle-opensearch:9200`, or from the host (transiently) as `http://172.20.0.8:9200` (both return HTTP 200, anonymous).
- EV-OS-MON-3 (PARTIAL): For durable host-side monitoring, the container IP is dynamic; the supported pattern is an in-network monitor container/task on the `mct-security` overlay (same approach as `shuffle-tools` which reaches `shuffle-opensearch:9200` successfully) rather than a hardcoded host IP.

## Backup/Rollback
Read-only analysis; no changes.

## Stop conditions
None for analysis. Actually re-pointing/reconfiguring the monitor target is a change (see 235, DEFERRED) and was NOT executed here.

## Limitations
This report recommends the supported path; enacting it is gated (235).

## Verdict rationale
Supported monitor path identified (overlay `shuffle-opensearch:9200`; loopback:9200 is the wrong/Wazuh cluster). DONE (analysis); enactment deferred to 235.
