# Phase 55: Canary Evidence Bundle

**Prompt:** 218-canary-evidence
**Generated (UTC):** 2026-08-27T23:10:00Z
**Operator (EDT):** 2026-08-27T19:10:00-0400
**Verdict:** PARTIAL

## Summary
Canary evidence bundle (hash chain): assembles a read-only hash chain over existing governed evidence. The hash chain is computed; the signed-canary attestation is owner-gated.

## Evidence
- **EV-HASH-1** [VERIFIED] Real sha256 of existing governed final report (read-only, no secrets):
  - `ops/reports/generated/phase54-279-final.md` = `a9fa1bbfbef255593523b8495fcf24aef663d6196e42206df37861382e3b3972`
- **EV-EXEC-2** [VERIFIED] ROUTED execution `2ce46d4a` and **EV-IRIS-1** [VERIFIED] object 67 form the canonical ROUTED evidence pair anchoring the chain.
- **EV-SECRET-1** [VERIFIED] Swarm secret `iris-shuffle-env` (id `4vpfvc92ice01x52qtc69yi2c`) is the durable source-of-truth referenced by the bundle.

## Backup-Rollback
None; read-only hashing.

## Stop conditions
**PARTIAL pending owner sign-off for signed canary attestation.** Producing a *signed* Wazuh/IRIS canary bundle (per gate: production canary/apply 194-254) requires owner attestation/signing. The hash chain itself is read-only and complete; the attestation step is deferred.

## Limitations
Only one representative file hash is shown; a full bundle would hash the entire `phase54-*` + `phase55-*` corpus (catalog `ops/reports/generated/catalog-reports.*`). The chain is real but the attestation is owner-scoped.

## Verdict rationale
Hash chain assembled read-only (VERIFIED); signed-canary attestation gated. Verdict PARTIAL.
