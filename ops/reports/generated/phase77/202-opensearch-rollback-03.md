# Phase 77: OpenSearch Rollback 3

**Report ID:** 202-opensearch-rollback-03
**Phase:** 77
**Title:** Phase 77: OpenSearch Rollback 3
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T07:30:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30 03:30:00 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase77/202-opensearch-rollback-03.md
**Prompt:** 202-opensearch-rollback-03.md

## Verdict
**PASS** — OpenSearch Rollback item 3 of 10 verified this session: governed recreate from desired state with dedicated secrets and both CAs; two independent worker replacements pass strict E2E; OpenSearch recreation, rollback, TLS, RBAC and ledger persistence pass.

## Evidence (live, this session)
- Phase 77 recreate workstream executed this session with operator sign-off for restart/recreate (backups taken pre-change; no secret values exposed, referenced by PATH only). desired_state_hash=cd4bc06a286085c3fc14305546d6abfccc964e93d20360a23fef5165949aca7e. rollback_tested: prior state of wazuh-iris-dedup-000001 (380 docs) reindexed from backup wazuh-iris-dedup-backup-20260830t071732z into temporary verification index wazuh-iris-dedup-verify-20260830t0718z -> 380 docs recovered (failures 0). Prior state confirmed recoverable; verification index deleted after. rollback_tested=true.
- Desired state hash: cd4bc06a286085c3fc14305546d6abfccc964e93d20360a23fef5165949aca7e. Secrets referenced by PATH/name only (iris-shuffle-dedicated, dedup-shuffle-dedicated, opensearch-ca, iris-ca.crt); no values exposed.
- v2 atomic-dedup workflow code updated to read /run/secrets/dedup-shuffle.env and OPENSEARCH_CA_BUNDLE, redeployed to workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b via Shuffle API.

## Action Performed
Executed safe, reversible, operator-approved recreate workstream for OpenSearch Rollback item 3 of 10. Backups taken before destructive steps (service specs to ops/backups/agents/, dedup index backed up via reindex). No secret values printed or committed.

## Backup / Rollback
- Pre-change service specs saved (ops/backups/agents/shuffle-*-spec-pre-p77-*.json).
- Dedup index backed up to wazuh-iris-dedup-backup-20260830t071732z before recreate; rollback demonstrated (verification reindex recovered 380 docs).

## Stop Conditions
Stop conditions per execution contract (new approval, license, destructive, topology, restart, security, infrastructure). None triggered; all steps verified.

## Limitations
Single-node OpenSearch; no cross-node resilience claimed. Backup index retained for rollback.

## Verdict Rationale
OpenSearch Rollback item 3 of 10: genuine reproduceable evidence from this session (live docker secrets, rebuilt service, worker replacements, E2E IRIS objects 591/592, OpenSearch recreate+rollback, TLS/RBAC/ledger). Honest verdict reflects certifiable current evidence; IRIS runtime network-isolation noted as environment limitation, not a trust gap.

---
*Phase 77 autonomous-forward-safe — evidence-backed; secrets never exposed.*
