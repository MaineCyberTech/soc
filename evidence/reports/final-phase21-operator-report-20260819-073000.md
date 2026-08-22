> **HISTORICAL EVIDENCE (2026-08-19).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 21 Operator Report

Date: 2026-08-19
Pack: /home/user/mct-security-19 (Repo Hygiene, Credential Cleanup, Windows Sysmon Tuning, Client Fleet Recovery, Release Refresh)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 21 delivered the Phase 20 audit follow-ups: **Phase 19/20/21 work committed and pushed**
(P21.1-P21.5 to `main`); **hardcoded credential defaults removed** from 3 scripts + runbook
redacted; **wazuh-docker public-origin clone protected** (skip-worktree/exclude) so the live
VirusTotal key + indexer password cannot be pushed; **local CI false-PASS fixed** and
**unpinned-image check extended** to wazuh-docker compose; **Windows 014 Sysmon EventID 7
analysed** (573K/24h, all standard/system paths) with a targeted-exclude tuning plan prepared
(apply blocked on endpoint access); **v1.1.0 release plan** prepared (approval-gated). macOS
015 remains blocked on Mac access. Zeek v2.2 stays clean (~0/min). 0 FAIL healthcheck; no
incidents.

## Repo hygiene and commit/release status

- 82 untracked + 1 modified -> reviewed, classified, committed in 5 logical commits
  (P21.1-P21.5) and **pushed to main** (`eba217b..HEAD`).
- Tracked operational logs untracked (`git rm --cached`) + gitignore updated.
- v1.1.0 release plan + checklist prepared; RELEASE-NOTES draft added. **Release/tag NOT
  created** - approval-gated (cleanup + CI/secret gates pass; approval is the remaining gate).

## Hardcoded credential cleanup

- 3 scripts (endpoint-count-report, client013-baseline-report, capacity-threshold-check):
  hardcoded defaults replaced with fail-fast `: "${VAR:?}"` guards + env vars. Verified working.
- phase9 credential-rotation runbook literal redacted to variable names.
- wazuh-docker repo (public origin): `wazuh_manager.conf` (VirusTotal key) + `docker-compose.yml`
  set skip-worktree; `docker-compose.override.yml` added to `.git/info/exclude`. Committed
  versions verified clean - **no secret was ever committed or pushed**.
- Added `WAZUH_WUI_PASSWORD` to local creds.env (mode 600).
- `docs/SECRET-HANDLING.md` created (inventory, rules, rotation, wazuh-docker protections).
- Secret scan re-run: PASS. My own two phase21 reports initially contained the literal
  "before" values - corrected to `<REDACTED>` and commit amended (HEAD clean).

## CI false-pass and unpinned image check

- `run-local-ci.sh` false-PASS fixed (subshell FAIL propagation via temp files; verified with
  injected broken script -> now FAILs).
- `check-unpinned-docker-images.sh` extended to scan wazuh-docker compose; `wazuh/wazuh-*`
  added to allowed baseline. 25 refs flagged, all documented in
  `phase21-unpinned-image-exceptions.md`; kept informational in CI.
- Local CI: PASS (RC 0) post-fix.

## Windows 014 Sysmon EventID 7 analysis/tuning

- **573,809 docs/24h** (flood resumed 06:00; ~75K/hr live). Top paths all standard/system
  (conhost 258K, docker.exe 168K, osqueryi 49K, powershell 35K) - no suspicious paths.
- EventID 1 (15,186/24h) and 10 (1,499/24h) healthy.
- **Tuning prepared**: `integrations/sysmon/sysmon-mct.xml` with targeted ImageLoad excludes
  for known-safe paths (preserves EventID 7 for other processes; keeps EID1/10). Rollback doc.
- **Apply BLOCKED on endpoint access** (014 not reachable; operator steps delivered).
- Before baseline captured (EID7 37,610/30min); after-validation targets defined.

## Agent 015 recovery status

- **NOT RECOVERED** - still offline (since 08-18 09:04), blocked on Mac access. Final config
  + rollback handoff refreshed. Volume/queue validation = FAIL pre-fix.

## Zeek v2.2 validation and routing decision

- **CLEAN**: 17 alerts/~75min post-v2.2 (~0/min steady); no broadcast/multicast noise.
- Class A (SSH/SMB/RDP) verified firing; decision = **MANUAL-ONLY** (auto-route gated on final
  24h window + approval). Routing plan prepared.

## Suricata follow-up

- Ingest PROVEN (1 event), network quiet. Severity 1-2 rules stay staged; routing gated.

## NetFlow scope decision

- **BLOCKED** on operator (448,520 flows/24h unconfirmed subnets, unchanged). Alerting unarmed.

## mct-portal Redis status

- **OWNER-BLOCKED** (~10K/day, rule 120537 level 3). Restore 5 after VPS fix.

## Client fleet health and billing readiness

- 013 offline (power), 015 offline (flood), 014 active (EID7 flood, tuning pending).
- **Billing NOT ready** (2/3 endpoints with issues). No invoice until fleet restored + 014 tuned.

## Greenbone authorization status

- **NOT AUTHORIZED** (unsigned). No client-scope scan.

## Monthly client ops

- Run complete: backups fresh, detections live, repo committed+pushed, scorecard draft,
  fleet + tuning status updated.

## Remaining risks

1. Windows 014 Sysmon EventID 7 flood ongoing (573K/24h) - tuning apply blocked on endpoint access.
2. macOS 015 offline (flood fix blocked on Mac access).
3. 013 offline (power).
4. NetFlow scope unconfirmed (448K/24h).
5. Redis loop owner-blocked (~10K/day).
6. v1.1.0 release pending approval (checklist ready).
7. VirusTotal key + indexer password rotation recommended (existed in on-disk tracked trees).
8. Greenbone client scan unauthorized.
9. Unpinned images (25 refs) documented, pin backlog for next release.

## Recommended Phase 22 roadmap

1. **Windows 014 Sysmon tuning apply** (operator/Velociraptor) -> before/after validation (>=90% drop, EID1/10 intact).
2. **macOS 015 fix** (operator on Mac) -> reconnect + 24h volume/queue PASS.
3. **Complete Zeek 24h clean window** -> approve Class A (SSH/SMB/RDP) IRIS routing.
4. **Release v1.1.0** (after operator approval): tag + GitHub release + fresh portable bundle.
5. **Credential rotation**: VirusTotal key + indexer password; templatize wazuh-docker compose literals to ${VAR}.
6. **NetFlow**: operator scope confirmation -> arm new-subnet alerts.
7. **013** client power check; **Greenbone** signed auth -> client scan.
8. **Pin images**: opencanary/cloudflared/misp-modules/etc. to sha256 or keep documented exceptions.

## Files added (summary)

- 40+ Phase 21 deliverables: preflight/status-review, repo hygiene (review/inventory/commit
  plan), local CI + secret scan + commit readiness, credential cleanup + secret hygiene
  validation, CI false-pass fix + unpinned-image update/exceptions, release notes + v1.1.0
  checklist + plan, Windows 014 Sysmon (analysis/eventid7-plan/tuning-plan/rollback/apply/
  operator-steps/before-after/telemetry-decision + sysmon-mct.xml), macOS 015 recovery,
  Zeek v2.2 validation/decision + Class A routing decision/plan, Suricata followup + routing
  readiness, NetFlow scope, Redis status, fleet + billing + scorecard, Greenbone auth, monthly
  ops + monthly scorecard, final report.
- Docs: `docs/SECRET-HANDLING.md`; `ops/checklists/v1-1-release-checklist.md`;
  `RELEASE-NOTES.md` (v1.1.0 draft).
- Commits P21.1-P21.5 pushed to main. No secrets pushed (verified; amended one commit to strip
  literal values from reports).

## No secrets

All reports cite paths/variable names only; no secret values printed. One cleanup note: two
Phase 21 reports initially quoted literal "before" values - corrected to `<REDACTED>` before
final commit.