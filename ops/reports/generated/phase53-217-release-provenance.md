# Phase 53: Release Provenance

**Prompt:** 217-release-provenance
**Generated (UTC):** 2026-08-27T20:09:03Z
**Operator (EDT):** 2026-08-27T16:09:03-0400
**Verdict:** DONE

## Summary
Capture release provenance (manifest / SBOM if supported). The on-box release manifest provides
a signed-integrity manifest with file inventory and exclusions; a formal SBOM artifact was not
generated in this release pipeline (limitation noted).

## Evidence
- E1: `release-manifest.json` (on-box) — authoritative manifest: created 20260824-203124,
  source `/opt/mct-security-stack`, archive name, size 9.9M, file_count 2040, sensitive_files 0,
  sha256 `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c`.
- E2: Exclusions list proves provenance hygiene — `.git`, `ops/backups`, `data`, `.env`,
  `creds.env`, `client.config.yaml`, `*.key`, `*.pem`, `*.sql.gz`, `*.tar.gz`, `*.zip`,
  `*.pcap`, `*.evtx` all excluded => no secrets/PII in the release artifact.
- E3: Git tags + published v1.3.1 (github releases) provide external provenance anchor
  (see 216-release-digest evidence).

## Backup / Rollback
Manifest sha256 is the integrity/rollback reference for the release artifact.

## Limitations
No SBOM (e.g. CycloneDX/SPDX) was produced by the current pipeline; provenance is limited to
the file manifest + sha256 + exclusions. If an SBOM is required, it is a future build-step
owner item.

## Verdict rationale
Release manifest with integrity hash and exclusion hygiene confirmed; SBOM noted as not
generated. DONE (analysis, with explicit SBOM limitation).
