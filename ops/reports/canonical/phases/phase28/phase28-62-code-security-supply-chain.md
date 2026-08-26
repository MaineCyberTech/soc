# Phase 28 Code, Security, and Supply Chain Audit

Date: 2026-08-24
Tooling: p28-portability-scan.sh + CI + secret + shell/python syntax.

## Checks

| Check | Result |
|---|---|
| CI | PASS |
| Secret scan | PASS |
| Shell syntax (all .sh incl. p28 tooling) | PASS |
| Python compile | PASS (SyntaxWarnings only in vendored IRIS source, benign) |
| Live password literals | **0** (confirmed already fail-closed in scripts) |
| Tracked __pycache__ | **0** (7 removed this phase) |
| Guardrail | OK, under limit, integration enabled; exec bit 100755 |
| Image policy | documented; **8 mutable tags** locked in dependency-lock.json (pin in bundle gate) |
| Checksums/provenance | cache manifest + dependency-lock (image IDs) |
| Drift (zeek rules) | unchanged (verified prior phase); canonical reconcile documented |
| Permissions | secret stores 0600; profiles placeholder-only; velociraptor keys gitignored |

## Findings

1. Historical reports (hardcoded-brand-scan, self-contained-completeness-check) quote the
   old fallback literal - evidence only, not live; secret scan unaffected.
2. Mutable tags: mitigation = dependency-lock + bundle manifest pinning (P0#3).
3. Vendored IRIS source (gitignored deploy copy) emits Python SyntaxWarnings - benign.

## Verdict

- **PASS** with 2 watch items (mutable tags, vendored source warnings); no secrets, no
  committed artifacts, no supply-chain regressions.

## No secrets