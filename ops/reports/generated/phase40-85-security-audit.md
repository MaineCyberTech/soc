# Phase 40 Security Audit

**Report ID:** phase40-85-security-audit
**Phase:** 40
**Title:** SEC-40-02 — Token Hygiene Holding (Rotation P39; Newline Lesson Embedded), TLS Proxy Posture Re-proven (HSTS/XFO Live, ~5 ms Handshake), Binding-Restriction Compensating Model Documented, ossec.conf Hook Blocks Audited With Honest api_key Finding, Creds Modes Verified 600/Gitignored, Corpus Sweep Zero, Digest Evidence Captured — Residuals Ranked
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:18:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-85-security-audit.md`

---

## 1. Token Hygiene Recap

| Item | Status | Evidence |
|---|---|---|
| Credential rotation program | HOLDING at P39 state; no rotation due/overdue observed | credential-rotation-validation.sh suite unchanged since P39 run |
| `$(cat file)` newline hazard | LESSON EMBEDDED in AGENTS.md Credential Handling ("strip whitespace … intermittent 401s; lesson from phase40-41") | AGENTS.md diff live in worktree; p39-agents-ci Gate3 PASS post-edit |
| Values never enter files | RE-VERIFIED this session: all token use via env/path references only | §5 corpus sweep zero; script inspection phase40-83 §5 |

## 2. Listeners vs Expected Matrix

Reconciled against phase40-84 §2 full table: **zero unexplained listeners.** Two intended
additions (:3443 LAN-TLS mgmt, :3001→loopback frontend) and one retirement effect
(no SO listener). Enrollment ports 1514/1515 remain intentionally on 0.0.0.0 (agent
onboarding) and are password-gated — live proof of gate working:

```
wazuh-authd: ERROR: Invalid password provided by 159.203.191.209. Closing connection.
(03:05:41 + 03:05:57 today; fail-closed, no enrollment)
```

Internet-reachable authd is a known accepted exposure with the password as control;
attempts are logged and alertable.

## 3. TLS Posture (proxy live; HSTS/XFO re-verified today)

```
$ for i in 1 2 3; curl -sk -o /dev/null -w "%{time_appconnect}s" https://192.168.222.149:3443/
probe1 tls=0.004511s total=0.005949s http=200
probe2 tls=0.004049s total=0.004845s http=200
probe3 tls=0.004907s total=0.005989s http=200

$ openssl s_client → cert: CN=shuffle.mgmt (self-signed, MCT O=), valid 2026-08-26 → 2036-08-23

$ curl -skI https://192.168.222.149:3443/
HTTP/1.1 200 OK
Strict-Transport-Security: max-age=31536000        ← proxy add_header (always)
X-Frame-Options: DENY                              ← upstream Shuffle UI header
X-Frame-Options: SAMEORIGIN                        ← proxy add_header (duplicate — see F-85-03)
X-Content-Type-Options: nosniff (×2 layers)
```

Plaintext LAN path closed (frontend rebound to 127.0.0.1:3001; only :3443 serves the UI).
Cert is self-signed mgmt-CA-style — acceptable for internal mgmt plane; trust-on-first-use
documented in operator card.

## 4. Firewall-Absence Model (compensating controls)

No host firewall is enforced in this environment. Compensating model, documented as the
governing posture:

1. Management planes bind loopback only (55000 API, 9200 indexer-via-nginx auth+TLS,
   5001 backend, 3001 frontend).
2. The single LAN-exposed new surface (:3443) terminates TLS and forwards to loopback-
   reachable backend inside the bridge network.
3. Required ingestion surfaces (1514/1515) are password-gated and monitored.
4. Pre-existing host/deception surface (opencanary ports et al.) is unchanged since P31
   matrix — deception services deliberately exposed.
5. Cross-network reachability is scoped by docker bridge membership, not host rules.

Residual acceptance: any process on-host or on-LAN can reach :3443 and the deception
surface by design.

## 5. ossec.conf Integration Blocks (both nodes)

Master (`config/wazuh_cluster/wazuh_manager.conf` mounted as ossec.conf):

```
line 36  <integration><name>virustotal</name>… <group>syscheck</group>
line 343 <integration><name>shuffle</name>
         <hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-…1322</hook_url>
         <group>suricata,</group> <alert_format>json</alert_format>
line 338/339 Zeek Class A integrations DISABLED-BY-GUARDRAIL comments intact
```

Worker carries its matching shuffle block (line ~314) — parity confirmed.

**Honest api_key finding (corrects the earlier "placeholder" assumption):**

```
virustotal api_key: len=64  NON-placeholder
shuffle    api_key: len=27 NON-placeholder
```

Both values are real credentials present in `wazuh_manager.conf` (mode **644 root-owned**,
outside this repo). Risk framing: Shuffle hook authentication is dominated by the UUID in
the hook_url; the api_key value is secondary. Residual risks R-listed in §10
(unauthenticated-from-LAN hook if UUID leaks; config file readable by local users).
No secret values printed here or elsewhere.

## 6. Credential File Modes (recheck)

```
-rw------- user user /opt/mct-security-stack/config/shuffle-api-key     (600) ✓ gitignored (.gitignore:35)
-rw------- user user /opt/wazuh-docker/multi-node/ops/creds.env         (600) ✓ outside repo
-rw------- user user /opt/mct-security-stack/ops/backups/misp-api-key.txt (600) ✓
```

## 7. Report-Corpus Secret Scan (new phase40 files)

p38 Gate4 over generated corpus: **files_with_hits=0 / lines=0** (pre-write run over 97
files); post-write receipt in phase40-82 §7 extends to the nine new audit reports:
**0 files, 0 lines.** High-confidence canonical sweep: 0 tree-wide.

## 8. Image Digest Evidence

```
ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f0822cb081822bd2fa6c633080553bdd4313aed2c4bdce75b87e82836
running digest matches compose pin exactly (post-recreate verification today)
nginx:1.27-alpine (tls-proxy): NOT digest-pinned → violation logged phase40-83 §9
pin-set coverage: 8 services pinned (tenzir, opencanary, syslog-ng, flow-relay,
shuffle-backend/frontend/orborus/worker)
```

## 9. Rules / Licenses / Provenance / Synthetic Isolation / Supply Chain

- **Rules:** custom `local_rules.xml` + `local_decoder.xml` mounted read-only from
  repo-config into both managers (canary rule 86601 lineage); no unreviewed external
  rule drops. Licenses: stack is OSS (Wazuh GPLv2, Shuffle, Iris CE, OpenSearch Apache-2);
  Greenbone community feed usage within license class — noted, no action.
- **Provenance honesty:** rebuilt-labeled v1.3.0 asset remains clearly labeled rebuilt
  (sha256 65f794a7…) pending published-original retrieval — custody PARTIAL carried open.
- **Synthetic isolation through chain:** E2E-007 markers (`MCT_SYNTHETIC=true`,
  `MCT_TEST_ID=P40-WEBHOOK-E2E-007`, `MCT_TEST_ONLY=true`) visible at hop-2 payload and
  hop-9 IRIS row content per phase40-37 §4; IRIS rows 40–42 notify-only Class A titles;
  production counters/cases untouched. Re-verified live today: rows still present with
  Class-A template titles.
- **Supply-chain notes:** digest-pinned core set (8); remaining floats are classified
  feed/versioned exceptions; new unpinned nginx logged for P41 pinning.

## 10. Residual Risks (ranked)

| Rank | ID-ish | Risk | Disposition |
|---|---|---|---|
| 1 | R-SEC-40-A | Shuffle hook accepts unauthenticated posts from anyone on mct-security/LAN path holding the webhook UUID | ACCEPTED for now; candidate = shared-secret check at workflow head (P41 design note) |
| 2 | R-SEC-40-B | Real api_key values in mode-644 manager conf readable by local users | Owner Wazuh-config; chmod/chown hardening backlog item |
| 3 | R-SEC-40-C | authd internet-reachable (password-gated) | Accepted+monitored; revisit if attempt volume grows |
| 4 | R-SEC-40-D | Self-signed TLS on :3443 (TOFU) | Acceptable mgmt-plane; distribute CA if formalized |
| 5 | R-SEC-40-E | Duplicate XFO headers (DENY upstream vs SAMEORIGIN proxy) | Cosmetic-policy overlap; P41 cleanup |

## 11. Verdict

**SEC AUDIT: PASS WITH RESIDUALS.** No new exploitable regression introduced this phase;
exposure model is explicit, evidenced, and honestly risk-listed including the corrected
api_key reality.
