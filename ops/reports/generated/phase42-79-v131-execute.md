# Phase 42 v1.3.1 Release Execution Record — REL-EXE-42-01

**Report ID:** phase42-79-v131-execute
**Phase:** 42
**Title:** Execution Record: Annotated Tag v1.3.1 Created From Verified Tree And PUSHED TO ORIGIN SUCCESS; On-Box Asset Built Via git archive (sha256 Recorded); MANIFEST.md Written; GitHub Release-Asset Upload BLOCKED-AWAITING-TOKEN With Exact Owner API Call Documented
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:41:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-79-v131-execute.md`

---

## 1. Execution summary (per DECISION-V131-42-01)

| Step | Outcome | Time (UTC, 2026-08-26) |
|---|---|---|
| Tree verification closeout | Commit `657991943be97c4ffe1d0525b604bf09b5d6e6ba` (CI green recorded P41) | 07:26:13Z commit date |
| Annotated tag create | SUCCESS — tag object `71701dfd356549f1c5d2e13c9a24256afa3eac8b` (tagger epoch 1787730751 ≈ 07:52:31Z) | ~07:52Z |
| Push to origin | **SUCCESS — `[new tag] v1.3.1 -> v1.3.1`** | ~07:52Z |
| On-box asset build | SUCCESS — `git archive` from tag | asset mtime 07:52:34Z |
| MANIFEST.md written | SUCCESS | manifest stamp 07:52:53Z |
| GitHub release-page publication | **BLOCKED-AWAITING-GITHUB-TOKEN** (§6) | re-verified ~09:28Z |

## 2. Tag content (annotated message summary — VERIFIED via `git cat-file -p v1.3.1`)

```
object 657991943be97c4ffe1d0525b604bf09b5d6e6ba
type commit
tag v1.3.1

v1.3.1: runtime-stabilization release

Deltas over v1.3.0 (D-register phase41-77/phase42-77):
- Archive field containment: template limit 2000 + sensor compact-stats lane
- Shuffle TLS management proxy (:3443) with pinned digest nginx
- Wazuh->Shuffle webhook integration (both nodes) + hooks datastore pattern
- merged.mg/windows-bak ownership fixes; delivery monitor + watchdog
```

Push output as observed: **`[new tag] v1.3.1 -> v1.3.1`**. Remote visibility
independently proven post-push in phase42-80 (`git ls-remote`, exit 0).

## 3. On-box asset build — VERIFIED

Command of record:

```bash
git archive --format=tar.gz --prefix=v1.3.1/ \
  -o ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz v1.3.1
```

| Property | Value |
|---|---|
| Path | `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` |
| Size | 15,558,573 bytes |
| Entries | 5,263 (top-level prefix `v1.3.1/`) |
| sha256 | `4e6c3712ba88f5ab925a2049d5d214fb55222a602c79738028ffee9a23ebf596` |

## 4. MANIFEST.md — content summary

`ops/releases/v1.3.1/MANIFEST.md` records: tag identity (annotated, from
verified tree 6579919+), asset name, full sha256, build timestamp/method
(git archive from tag), **custody class ON-BOX-TAG-BUILT**, delta summary
pointer to the D-1..D-12 register (field containment chain, TLS proxy, webhook
integration, ownership fixes, monitor+watchdog, churn gate, nosniff dedup, VT
perms, dashboards, network attachments), and publication status
(tag pushed / asset upload BLOCKED-AWAITING-GITHUB-TOKEN).

## 5. Gitignore note

The tar.gz (and the release directory's binary artifact) is **gitignored by
design**: on-box custody keeps large binaries out of the repo while the tag +
manifest carry all provenance. Custody = ON-BOX-TAG-BUILT; do not force-add.

## 6. Publication blocker — exact owner action documented

Constraint (live-reverified): `gh` binary absent, no gh config dir, no token in
environment → HTTPS API upload impossible without a token. The TAG IS PUBLIC
via the origin push; only the release page + downloadable asset await token.

Owner runbook (token-scoped `repo` contents rights suffice):

```bash
# 1. Create the release on the existing pushed tag
curl -X POST https://api.github.com/repos/MaineCyberTech/soc/releases \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d '{"tag_name":"v1.3.1","name":"v1.3.1",
       "body":"Runtime-stabilization release (D-1..D-12). See MANIFEST.md.",
       "prerelease":false}'

# 2. Upload the asset to the returned upload_url pattern
curl -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/gzip" \
  --data-binary @ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz \
  "https://uploads.github.com/repos/MaineCyberTech/soc/releases/<RELEASE_ID>/assets?name=v1.3.1-from-tag.tar.gz"

# 3. Verify published asset digest equals on-box sha256 above
```

No secret values are stored anywhere in this record; `$GITHUB_TOKEN` remains
owner-side.
