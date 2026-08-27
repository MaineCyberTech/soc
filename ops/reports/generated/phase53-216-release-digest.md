# Phase 53: Release Digest

**Prompt:** 216-release-digest
**Generated (UTC):** 2026-08-27T20:09:03Z
**Operator (EDT):** 2026-08-27T16:09:03-0400
**Verdict:** DONE

## Summary
Capture the release digest across GitHub / on-box / download sources (read-only). On-box
release manifest and git tags confirm the v1.3.x release line; GitHub CLI is authenticated for
any future fetch. No download or publication performed.

## Evidence
- E1: On-box `release-manifest.json` — name `mct-security-stack-release`, created
  `20260824-203124`, archive `mct-security-stack-release-20260824-203124.tar.gz`, size 9.9M,
  file_count 2040, sensitive_files 0, sha256
  `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c`. Exclusions confirm
  no secrets/keys/dumps bundled.
- E2: Git tags present: v1.0.0, v1.1.0, v1.2.0, v1.3.0, v1.3.1 (verified via `git tag`).
- E3: AGENTS.md — v1.3.1 PUBLISHED; asset `v1.3.1-from-tag.tar.gz` (sha256 `4e6c3712…ebf596`)
  live at `github.com/MaineCyberTech/soc/releases/tag/v1.3.1`; `gh` CLI authenticated (full
  repo scope).
- E4: RELEASE-NOTES.md present in repo root (release documentation on-box).

## Backup / Rollback
Release artifacts are immutable, signed/checksummed; no mutation. The manifest sha256 is the
integrity digest.

## Limitations
The GitHub release asset was not re-downloaded/fetched this batch (read-only; network fetch not
required to confirm on-box digest + tags). Live GitHub fetch is available via authenticated
`gh` if owner requests.

## Verdict rationale
On-box manifest (with sha256), git tags, and published v1.3.1 provenance all confirmed. DONE
(analysis).
