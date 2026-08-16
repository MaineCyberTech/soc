# Self-Contained Stack Policy

Date: 2026-08-16 (Phase 15)

## Principle

The repo is self-contained for everything legal and practical (text, config,
scripts, templates, docs). External artifacts are classified and documented;
nothing is silently pulled.

## Classification legend

| Class | Meaning |
|---|---|
| INCLUDED | committed in repo |
| TEMPLATE | committed as example/placeholder |
| GENERATED | produced locally at deploy |
| EXTERNAL-CACHE | downloaded once, cached internally (checksummed) |
| EXTERNAL-LICENSED | cannot be committed (EULA/licensing), documented acquisition |
| SECRET | protected values on host, never committed |
| OPS-DATA | operational backups excluded from repo |

## Current status (Phase 15)

- Repo text artifacts: 1,391 files - fully included.
- External pulls: docker images (cacheable), endpoint packages (cacheable),
  ISO media (licensed/external).
- Actions in flight: requirements.txt, digest pinning, checksums, cache plan.

## Rules

1. No new script may pull an undocumented artifact.
2. Every external artifact has an entry in repo-artifact-cache-manifest.json.
3. No licensed binary committed without review.
4. Client data never committed.

## No secrets
