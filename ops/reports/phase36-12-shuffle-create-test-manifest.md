# Phase 36: Shuffle Create + Test Manifest

Date: 2026-08-25

## Pre-requisite
- API auth: Bearer token (0c953f60-5cca-45b2-95f3-27373f4921ca)

## Test plan
| # | Test | Method | Expected |
|---|---|---|---|
| T1 | List workflows via API | GET /api/v1/workflows | 2 workflows returned |
| T2 | Get workflow details | GET /api/v1/workflows/{id} | Full config returned |
| T3 | Create test workflow | POST /api/v1/workflows | Workflow created |
| T4 | Execute test workflow | POST /api/v1/workflows/{id}/execute | Execution started |
| T5 | Check execution status | GET /api/v1/workflows/{id}/executions | Execution FINISHED |
| T6 | Delete test workflow | DELETE /api/v1/workflows/{id} | Workflow removed |

## Current status
- T1-T2: PASS (verified above)
- T3-T6: PENDING (to be executed in prompt 14)

## Safety
- Test workflow: "mct-p36-shuffle-test" (synthetic, no real routing)
- Cleanup after test

## No secrets
