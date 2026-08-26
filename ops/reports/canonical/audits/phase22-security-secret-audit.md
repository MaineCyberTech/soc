# Phase 22 Security, Secret, Dependency, and Supply-Chain Audit

Date: 2026-08-22

## 1. Secret scans — PASS (0 true positives) + coverage note
- `secret-pattern-scan.sh`: exit 0; remaining hits are vendored-JS false positives + variable
  references (verified non-secrets).
- P21 cleanup verified for the indexer literal (0 files). WUI literal: 0 in scripts; 3 legacy
  docs contain the *kibanaserver* service-account NAME (rotation tracker + phase3 reports) -
  account names are not secret values; documented as acceptable.

## 2. File permissions — PASS
- creds.env, wazuh-docker .env, .env.cloudflare, mct .env, wazuh-local.env: all 600.

## 3. wazuh-docker clone protection — PASS
- skip-worktree on wazuh_manager.conf + docker-compose.yml; override in .git/info/exclude;
  git status hides all three. **FIXED this phase**: credential-bearing backups + relay.py chmod 600.

## 4. Dependencies — PASS
- requirements.txt: pymisp/requests/pyyaml (stdlib elsewhere); IRIS vendored python LGPL-3.0
  (manifest label says GPL-3.0 - minor mismatch, backlog).

## 5. Artifact checksums / cache — PASS (manifest drift)
- velociraptor/wazuh-agent hashes verified on disk; sysmon-zip uncached (consistent);
  misp-core/greenbone-gvmd marked cached with placeholder hashes (inconsistency, backlog).
- Cache licensing: all artifacts redistributable (AGPL/GPL/BSD/MIT); no licensed media.

## 6. Git history exposure — FAIL (accepted risk)
- Both legacy credential literals exist in EVERY commit (79) of the private repo (cleaned from
  working tree; history untouched). No .env/creds/backup files ever committed (verified).
- Mitigation: rotation of live values (Phase 22.13-15) + private repo. History rewrite not
  recommended unless repo goes public.

## 7. Image classification — PASS
- R/F/V/C policy enforced; 0 runtime violations; 21 classified exceptions.

## 8. Approval gates — PASS
- Greenbone unsigned (no client scan). Zeek Class A routing approval-pending. No routing enabled.

## Verdict
PASS with documented residual items (git history literals accepted; cache manifest drift;
VT key rotation gated).

## Files
- `ops/reports/phase22-security-secret-audit.md` (this), `phase22-dependency-supply-chain-audit.md`, `phase22-approval-gate-audit.md`

## No secrets