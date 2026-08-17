# Phase 18 Index Retention Action Plan

| # | Action | Impact | Gate |
|---|---|---|---|
| 1 | ILM alerts: hot 3d / warm 14d / delete 30d | saves ~1GB/7d | approval |
| 2 | ILM archives: hot 3d / warm 7d / delete 14d | saves ~5GB/7d | approval |
| 3 | macOS localfile removal (agent-local) | cuts 10k docs/day | operator on Mac |
| 4 | Zeek rule monitoring | adds alert signal | done (P18.03) |

## Status

- Plan only - no destructive changes applied.

## No secrets
