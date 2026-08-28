# Phase 46: Live Input Probe

## Purpose
Document what happens when a live event arrives at the hook while stopped vs. started.

## Findings

### While Stopped
- Hook returns `"Hook ID not valid"`
- No workflow execution triggered
- Event is discarded at the hook ingress layer

### While Started
- Hook accepts POST request
- Workflow execution is triggered
- Execution argument: raw POST body passed as JSON string
- Access pattern: `self.full_execution.get('execution_argument', '{}')`

### Execution Argument Flow
1. POST body arrives at hook endpoint
2. Shuffle wraps raw body as execution argument
3. execute_python node accesses via `self.full_execution.get('execution_argument', '{}')`
4. JSON parsed and fields extracted for IRIS delivery

## Verification
- [x] Stopped state behavior documented (4xx, no execution)
- [x] Started state behavior documented (200, triggers workflow)
- [x] Execution argument access pattern confirmed
- [x] Raw POST body as JSON string noted
- [ ] Live started-state test pending trigger activation

---
*Generated: 2026-08-27T06:19:00Z (UTC) / 2026-08-27T02:19:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
