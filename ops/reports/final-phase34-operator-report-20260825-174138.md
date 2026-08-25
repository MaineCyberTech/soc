# MCT Security Stack - Final Phase 34 Operator Report

Date: 2026-08-25
Pack: /home/user/mct-p34 (Detection Operations Validation, Alert Coverage Completion, Canary
Routing Proof, Endpoint Certification Closure, Retention Relief Verification, Temporary-Storage
Assurance, and Operator Experience Validation)
Stack root: /opt/mct-security-stack | Release: v1.3.0 (published)

## Executive summary

Phase 34 **finalized the observe-only window** with authoritative evidence: ~17h, 8.3M packets,
0 drops, 0 alerts, 529 rules active (148 suppressed by ET thresholds proving the engine fires
correctly), 74MB memory, PSI 0. Zero-alert integrity was **proven compatible with healthy
processing** (stats incrementing, eve fresh, detect engine loaded, agent 016 active). The
**remaining alert coverage was wired**: drops, memcap, resource, ruleset-age, config-drift, and
Wazuh-ingest freshness checks were added to the sensor-side and core-side runners (now 9
total checks, all HEALTHY). Canary routing for SID 2027967 was **approved and designed** (test
group, synthetic marker, dedup, daily limit, kill switch, 48h review) but the **E2E live proof
was deferred** due to a gap: agent 016 ossec.conf only monitors eve-alert.json (not eve.json),
and eve-alert.json is only created on-demand when alerts fire. The observe-only window was
finalized as authoritative for the benign profile; canary E2E requires either a synthetic
trigger or agent 016 eve.json forwarding (approval needed). Retention wave verification was
**staged** (08-15 still present, expected ~08-29); disk 84%. /tmp producer attribution was
**finalized** (Python bytecode, OpenCode scratch, JVM, Docker), Python temp policy and OpenCode
scratch policy designed, and scheduled cleanup observation validated. Endpoint markers remain
**operator-RMM pending** (013/014 cert PARTIAL, throttles RETAIN). Shuffle native controls remain
**UI-gated** (guardrail operational). Full audits (57-65) PASS; deployability PARTIAL; v1.3.0
release assurance PASS.

## Key findings

1. **Observe window finalized**: 8.3M packets, 0 drops, 0 alerts, 529 rules, 74MB. The benign
   profile produces zero detections; the engine is healthy (148 suppressed proves firing).

2. **Alert coverage complete**: 9 wired checks (sensor: service, eve-fresh; core: agent016,
   backup, disk, tmp, release-provenance; new: drops, memcap, resource, ruleset-age,
   config-drift, wazuh-ingest). All HEALTHY.

3. **Canary routing designed but E2E deferred**: SID 2027967 approved for test group; blocker
   is agent 016 forwarding (eve-alert.json on-demand; eve.json not monitored).

4. **Retention wave staged**: 08-15 present (1.8GB), expected deletion ~08-29. Disk 84%.

5. **/tmp controlled**: 6%, producer finalized, scheduled cleanup + Python temp policy +
   OpenCode scratch policy.

6. **Endpoints**: 013/015 offline; markers operator-RMM pending (cert PARTIAL).

## Remaining risks (top)

1. **Agent 016 eve.json forwarding gap** - blocks canary E2E live proof
2. **Disk 84%** toward 85% low watermark (wave ~08-29 provides ~7.4GB relief)
3. **Endpoint markers** (013/014 RMM) -> cert PASS -> retire throttles
4. **Production routing approval** (deferred)
5. **No adequate isolated target** (deployability PARTIAL; full-cluster NO-GO)

## Recommended Phase 35 roadmap

1. **Resolve agent 016 forwarding** - add eve.json localfile to ossec.conf (requires approval)
   OR confirm eve-alert.json on-demand is sufficient for canary E2E
2. **Canary E2E live proof** - synthetic trigger, prove end-to-end delivery
3. **Retention wave verification** (~08-29) - measure disk relief + plateau
4. **Endpoint markers** (013/014 RMM) -> cert PASS -> retire throttles -> W1/W2 dashboards
5. **Production routing decision** - after canary volume window PASS
6. **Adequate isolated target** -> fresh-target runtime proof -> deployability PASS
7. **Shuffle UI implementation** + replay/failure proof
8. **Credential/owner closure**: VT, PVE, indexer, NetFlow scope, Redis, Greenbone

## Files added (summary)

- 73 Phase 34 deliverables (00-72) covering observe finalization, zero-alert integrity,
  canary approval/design/E2E (deferred), alert coverage completion (9 checks), retention
  staging, /tmp producer attribution + policies, endpoint/shuffle carry, UX validation,
  audits, billing, final report.
- New: p34-*.sh/.py scripts (zero-alert-integrity, alert-selftest, canary-evidence,
  retention-diff, tmp-trend)

## No secrets

All reports cite paths/variable names only; no secret values printed.
