# Phase 36: 85% Disk Incident Record

Date: 2026-08-25

## First observation
- P31 (2026-08-24): Disk first observed at 84%
- P35 (2026-08-25 18:07Z): Disk at 85% — LOW WATERMARK ACTIVE

## Current state
- Filesystem: /dev/sda1 (root + data, single partition)
- Size: 148G total, 120G used, 23G available
- Usage: 85%
- Watermark: OpenSearch LOW WATERMARK ACTIVE (85% threshold)

## Root vs data
- Single partition (/dev/sda1) holds everything: OS, Docker, Wazuh, Shuffle, IRIS, data

## Low-watermark behavior
- OpenSearch low watermark: 85% (default)
- Effect: No new shards allocated to this node
- Current: All 274 shards allocated (pre-watermark state)

## Writes
- Archive index 08-25 growing (~486MB today)
- Daily growth: ~500MB-1GB

## Growth rate
- Alert indices: ~50-60MB/day
- Archive indices: ~500MB-3.8GB/day (varies)

## Expected wave
- 08-15 archives: 1.8GB (day 11, should have been deleted)
- Root cause: ISM policy NOT attached to indices
- Relief if deleted: ~7.9GB (08-15..18)

## Response
- No watermark manipulation
- No manual index deletion
- ISM policy attachment fix required (prompts 04-08)

## Thresholds
- P0: >= 90% — immediate investigation
- P1: >= 85% — current (LOW WATERMARK)
- Target: < 80% post-wave

## Owner: soc@mainecybertech.com

## No secrets
