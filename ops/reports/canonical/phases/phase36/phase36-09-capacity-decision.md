# Phase 36: Capacity Decision

Date: 2026-08-25

## Classification: **DEGRADING** (wave stalled, policy not attached)

## Evidence
- Disk: 85% (LOW WATERMARK ACTIVE)
- ISM wave: NOT executing (policy not attached)
- Growth: ~1GB/day
- Time to 90%: ~10 days at current rate
- Potential relief: ~7.9GB if policy attached and wave runs

## Trajectory
- Without fix: 85% → 90% in ~10 days → **CRITICAL**
- With fix: 85% → 76% post-wave → **STABLE** for ~45 days

## Short-term controls (no watermark manipulation)
1. Attach ISM policy to archive indices
2. Observe deletion wave
3. Monitor daily
4. If wave doesn't run by 08-31: escalate

## Do NOT
- Raise watermarks to hide pressure
- Manually delete indices
- Change allocation settings

## Decision: FIX REQUIRED — attach ISM policy

## No secrets
