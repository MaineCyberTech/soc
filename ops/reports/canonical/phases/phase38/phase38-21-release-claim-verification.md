# Phase 38-21 — Release Claim Verification

**Report ID:** phase38-21-release-claim-verification
**Phase:** 38
**Title:** Phase 38-21 — Release Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-21-release-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:30 UTC
**Scope:** Verify tag/release/asset/hash/manifest/image-pins/docs-ref claims for v1.3.0 against live evidence.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | Release tag `v1.3.0` exists | **VERIFIED** | `git tag -l` output |
| 2 | HEAD is `7bd3b82` | **VERIFIED** | `git log --oneline -3` output |
| 3 | GitHub release asset published for v1.3.0 | **UNVERIFIED** | `gh` CLI not installed on host |
| 4 | Bundle sha256 = `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` | **VERIFIED** | `sha256sum` recomputed, matches byte-for-byte |
| 5 | Release manifest records 2040 files / 9.9M | **VERIFIED (recorded)** | `/opt/mct-security-stack/release-manifest.json`; archive size on disk 10348557 B ≈ 9.9M |
| 6 | Image pins updated in P36 (digest refs) | **VERIFIED** | compose files + CI gate exit 0 |
| 7 | Docs reference v1.3.0 + bundle hash | **VERIFIED** | README.md:7,158; RELEASE-NOTES.md:102 |

---

## Evidence Detail

### 1–2. Tags and HEAD
```
$ cd /opt/mct-security-stack && git tag -l | tail -5
v1.0.0
v1.1.0
v1.2.0
v1.3.0

$ git log --oneline -3
7bd3b82 Phase 37: 82 reports, workflow exports, Shuffle hardening plan, field resolution design
b7c2f18 Phase 36 update: Shuffle auth resolved, frontend exposed, decoder fix applied, ...
b529e3b Phase 36: ISM policy attachment, Shuffle investigation, field cardinality fix, ...
```
Tag `v1.3.0` exists; working HEAD matches the claimed `7bd3b82`. **VERIFIED.**

### 3. GitHub release
```
$ gh release view v1.3.0
gh not available
```
The `gh` CLI is not installed on this host, so publication of the release/asset to a remote forge could not be confirmed from here. The tag exists locally; remote publication remains an operator assertion. **UNVERIFIED** (not contradicted).

### 4–5. Asset hash and manifest
```
$ ls /opt/mct-security-stack/data/releases/   # empty
$ find /home/user/mct-security-releases/ /opt/mct-security-stack-backups/releases/
mct-security-stack-release-20260824-203124.tar.gz  (10348557 bytes, Aug 24 20:31)

$ sha256sum /home/user/mct-security-releases/mct-security-stack-release-20260824-203124.tar.gz
da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c  ...20260824-203124.tar.gz
```
Recomputed digest equals the claimed `da72bde4...` exactly, and equals `sha256` inside `/opt/mct-security-stack/release-manifest.json` (created 2026-08-24T20:31:24, `file_count: 2040`, exclusions include `.git`, `creds.env`, keys/pems/archives). A copy also exists under `/opt/mct-security-stack-backups/releases/v1.3.0`. No standalone `.sha256` sidecar file was found anywhere (`find . -name "*.sha256"` → empty); provenance relies solely on the embedded manifest field. **VERIFIED** for the artifact on this host; note absence of detached signature/sidecar.

### 6. Image pins
```
$ grep -n "image:" compose/docker-compose.shuffle.yml
17:    image: ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f...
34:    image: ghcr.io/shuffle/shuffle-backend@sha256:d4a5d2bf...
66:    image: ghcr.io/shuffle/shuffle-orborus@sha256:5c300bcb...

$ bash ops/scripts/p29-image-ci-gate.sh ; echo exit=$?
EXCEPTION (documented): opensearchproject/opensearch:3.2.0
EXCEPTION (documented): alpine:3.20
EXCEPTION (documented): postgres:16-alpine
EXCEPTION (documented): redis:7-alpine
EXCEPTION (documented): velociraptor:latest
exit=0
```
Three Shuffle services pinned by digest; the immutable-ref gate passes with five documented exceptions (tag-pinned base images recorded as accepted exceptions). Other compose files carry 0–1 digest refs each (gate treats them consistently). **VERIFIED** that pins were updated and enforced; mutable-tag exceptions remain by design, so "fully pinned everywhere" would be **PARTIAL** — as stated, "8 refs updated P36" is consistent with observed content.

### 7. Documentation references
```
$ grep -n "v1.3.0" README.md RELEASE-NOTES.md
README.md:7: ... Current release: v1.3.0 (2026-08-24).
README.md:158: v1.3.0 (2026-08-24): image digest pinning + CI gates, ... bundle sha256 da72bde4
RELEASE-NOTES.md:102: ## v1.3.0 (2026-08-24) - Immutable Packaging + Consolidation + DR Readiness
```
Docs match the verified tag, date, and hash. **VERIFIED.**

---

## Verification Commands Used
```bash
cd /opt/mct-security-stack && git tag -l | tail -5
git log --oneline -3
gh release view v1.3.0 || echo "gh not available"
find . -name "*.sha256" | head -5
cat release-manifest.json
ls -la /home/user/mct-security-releases/
sha256sum /home/user/mct-security-releases/mct-security-stack-release-20260824-203124.tar.gz
grep -n "image:" compose/docker-compose.shuffle.yml
bash ops/scripts/p29-image-ci-gate.sh
grep -n "v1.3.0" README.md RELEASE-NOTES.md
```

## Summary
Release identity chain (tag → HEAD → local artifact → recomputed sha256 → manifest → docs) is internally consistent and **VERIFIED** at every hop reachable from this host. Remote release publication is **UNVERIFIED** (no `gh`). Image pinning claims hold with documented exceptions.

## No secrets
