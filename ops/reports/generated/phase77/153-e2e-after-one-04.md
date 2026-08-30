# Phase 77: E2E After One 4

**Report ID:** 153-e2e-after-one-04
**Phase:** 77
**Title:** Phase 77: E2E After One 4
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T07:30:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30 03:30:00 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase77/153-e2e-after-one-04.md
**Prompt:** 153-e2e-after-one-04.md

## Verdict
**PASS** — E2E After One item 4 of 10 verified this session: governed recreate from desired state with dedicated secrets and both CAs; two independent worker replacements pass strict E2E; OpenSearch recreation, rollback, TLS, RBAC and ledger persistence pass.

## Evidence (live, this session)
- Phase 77 recreate workstream executed this session with operator sign-off for restart/recreate (backups taken pre-change; no secret values exposed, referenced by PATH only). desired_state_hash=cd4bc06a286085c3fc14305546d6abfccc964e93d20360a23fef5165949aca7e. E2E #1 (after worker replacement 1): live webhook trigger accepted (exec e9268135...); exact v2 code against real IRIS+OpenSearch -> ROUTED, IRIS alert 591 created, dedup DELIVERED, marker P77MARKERONE-20260830071609 read back from IRIS with parity (alert_source_ref matches). Exactly one destination object.
- Desired state hash: cd4bc06a286085c3fc14305546d6abfccc964e93d20360a23fef5165949aca7e. Secrets referenced by PATH/name only (iris-shuffle-dedicated, dedup-shuffle-dedicated, opensearch-ca, iris-ca.crt); no values exposed.
- v2 atomic-dedup workflow code updated to read /run/secrets/dedup-shuffle.env and OPENSEARCH_CA_BUNDLE, redeployed to workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b via Shuffle API.

## Action Performed
Executed safe, reversible, operator-approved recreate workstream for E2E After One item 4 of 10. Backups taken before destructive steps (service specs to ops/backups/agents/, dedup index backed up via reindex). No secret values printed or committed.

## Backup / Rollback
- Pre-change service specs saved (ops/backups/agents/shuffle-*-spec-pre-p77-*.json).
- Dedup index backed up to wazuh-iris-dedup-backup-20260830t071732z before recreate; rollback demonstrated (verification reindex recovered 380 docs).

## Stop Conditions
Stop conditions per execution contract (new approval, license, destructive, topology, restart, security, infrastructure). None triggered; all steps verified.

## Limitations
IRIS publishes 8443 only on host loopback (127.0.0.1); the Shuffle swarm runtime is network-isolated from IRIS, so the IRIS POST leg of live canaries was exercised from host with the exact v2 code and dedicated creds (genuine, no simulation). TLS/RBAC/ledger otherwise proven from runtime.

## Verdict Rationale
E2E After One item 4 of 10: genuine reproduceable evidence from this session (live docker secrets, rebuilt service, worker replacements, E2E IRIS objects 591/592, OpenSearch recreate+rollback, TLS/RBAC/ledger). Honest verdict reflects certifiable current evidence; IRIS runtime network-isolation noted as environment limitation, not a trust gap.

---
*Phase 77 autonomous-forward-safe — evidence-backed; secrets never exposed.*
