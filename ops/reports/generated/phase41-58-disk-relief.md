# Phase 41 Disk Relief — Zero Until Wave, Honestly

**Report ID:** phase41-58-disk-relief
**Phase:** 41
**Title:** DISK-41-01 — Disk Relief Status Re-Measured Live (83–84%, 24–25G Avail): Growth Model Updated With Compact-Stats Effect (Archive Pri/Day Collapsed ~1GB→~190MB Post-Containment), Relief Still ZERO Until The Aug-29 Wave Deletes ~14GB Replicated Over Its First Week — Projection Unchanged At ~15GB/Week Post-Wave
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:27:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-58-disk-relief.md`

---

## 1. Current disk (live reads)

```
05:14:14Z  df -h / → /dev/sda1 148G total 118G used 24G avail 84%
05:19:xxZ  df -h / → /dev/sda1 148G total 118G used 25G avail 83%
           inodes 7% used (627,659 / 9,822,208)
/tmp       du -sh → 1.6G total; largest item p32-tmp-audit dir 15M (long tail of ~1.1M tmpfiles)
```

Allocation context unchanged since P39/P40 audits: archives are the dominant
elastic consumer; snapshots live on fs repo + DO Spaces (s3 offload), not root.

## 2. Growth model updated with compact-stats effect

Daily archive primary-store sizes (live `_cat indices`, this run):

```
08.15=932.4  08.16=649.9  08.17≈1229  08.18≈1024  08.19≈1946  08.20=622.4
08.21=627.4  08.22=357.2  08.23=49.1  08.24=69.8  08.25=284.8  08.26(partial)=206.4  [MB pri]
```

The stats-containment applied in P41 (phase41-10/-15 arc) is visible in the data:
pre-containment days ran ~0.6–1.9 GB/day pri; post-containment full days
(08.22–08.25) average **≈190 MB/day pri ≈380 MB/day replicated**. Archive/day
shrinks slightly-to-materially, exactly as designed.

## 3. Relief status: ZERO until wave — stated honestly

No disk relief has occurred yet and none should be claimed. The containment only
bends the growth curve; actual bytes return when ISM starts deleting:

| Event (UTC) | Relief realized |
|-------------|-----------------|
| Now → Aug-29 21:00 | **0 bytes** (curve flattening only) |
| Aug-29/30: 08.15 exits | −1.8gb store |
| First week post-wave (08.15–08.21 exit sequentially) | Σ pri ≈ 7.03GB × 2 replication ≈ **−14.1GB ≈ the projected ~15GB over week post-wave** |

## 4. Projection

Projection stands unchanged: **~15GB returned across the first week post-wave**
(≈10% of the filesystem), after which steady-state settles near
ingest-rate × 14d retention (~5–6GB replicated footprint at current post-containment
rates). No action required before then; low watermark (85%) headroom is ~7.8G
(phase41-59), comfortably spanning the 3.7-day wait.
