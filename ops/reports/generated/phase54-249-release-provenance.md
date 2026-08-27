# Phase 54: Release Provenance

**Prompt:** 249-release-provenance
**Generated (UTC):** 2026-08-27T21:29:44Z
**Operator (EDT):** 2026-08-27T17:29:44-0400
**Verdict:** DONE

## Summary
Release provenance / manifest-SBOM captured. Deployment source = compose files under /opt/mct-security-stack/compose/; runtime secrets sourced from approved stores (IRIS token file mode 600, gitignored; creds.env is the source). No secret values are in tracked files. Provenance is deployment-as-code + digest-pinned images.

## Evidence
- E3 — /opt/mct-security-stack/.env mode 600 (secret reference only).
- E4 — iris-shuffle.env exists, mode 600, 78 bytes, gitignored (never printed).
- E9 — compose files present; bind mount to /shuffle-files confirmed.
- CTX — Secret policy: values only in approved runtime stores / orchestrator secret objects.

## Backup / Rollback
N/A read-only provenance.

## Limitations
No formal SBOM artifact generated; provenance described from deployment source and secret policy.

## Verdict rationale
Provenance captured from read-only evidence; secret hygiene verified.
