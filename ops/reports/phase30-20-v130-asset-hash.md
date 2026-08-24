# Phase 30 v1.3.0 Asset Hash Verification

Date: 2026-08-24

## Verification

| Item | Expected | Actual | Match |
|---|---|---|---|
| Asset name | mct-security-stack-release-20260824-203124.tar.gz | same (release API) | YES |
| Asset size | 10,348,557 | 10,348,557 (release API) | YES |
| SHA-256 (local bundle) | da72bde4... | da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c | YES |
| Sensitive-file count (bundle) | 0 | 0 (build gate) | YES |
| Manifest | release-manifest-20260824-203124.json | repo root + backups mirror | YES |
| Reproducibility | deterministic bundle build | sha256 stable across builds (build script) | YES |

## No secrets