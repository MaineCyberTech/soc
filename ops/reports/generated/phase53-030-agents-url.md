# Phase 53: URL and Command Audit

**Prompt:** 030-agents-url
**Generated (UTC):** 2026-08-27T20:08Z
**Operator (EDT):** 2026-08-27T16:08-0400
**Verdict:** DONE

## Summary
Validate URL/command examples in AGENTS.md, especially the indexer auth example, for correct formatting and no secret exposure.

## Evidence
- E1: AGENTS.md line 132 — indexer auth pattern: `curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" https://127.0.0.1:9200/…` — uses a `${VAR}` placeholder, no inlined credential; `-sk` matches the documented pattern.
- E2: AGENTS.md line 109 — mentions `shuffler.io` only as a warning ("NOT the shuffler.io default shown in info.url"); no live credential or secret in the URL; the recommended target is the local `:3443` TLS URL.
- E3: No `http(s)://` URL in AGENTS.md embeds a token, query secret, or non-loopback sensitive host beyond the `.149` interface note (which is a local host address, not a secret).
- E4: `secret-pattern-scan.sh` — AGENTS.md 0 hits.

## Backup / Rollback
N/A.

## Stop conditions (BLOCKED only)
None.

## Limitations
Examples are documentation; not executed.

## Verdict rationale
All URLs/commands are placeholder-safe and secret-free; formatting is consistent with the Credential Handling section.
