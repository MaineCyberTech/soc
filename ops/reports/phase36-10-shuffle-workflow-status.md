# Phase 36: Shuffle Workflow Status

Date: 2026-08-25

## Existing workflows

| Workflow | ID | Actions | Trigger | Status |
|---|---|---|---|---|
| wazuh-high-severity-to-iris | eb937a37-5244-46dc-95ff-62ad4c681322 | 2 | webhook | test |
| wazuh-flow-classb-to-iris | e951db98-9a57-4328-8344-09f8b5b9a69f | 2 | none | draft |

## Both workflows: notify-only mode
- Action 1: Log received alert (Shuffle Tools 1.2.0)
- Action 2: Create DFIR-IRIS alert via HTTP (IRIS nginx:8443)

## Execution stats
- Total executions: 796 (healthchecks + manual)
- Recent: all FINISHED

## API access
- Username login: BROKEN (0 users found for "admin"; user is soc@mainecybertech.com)
- Bearer token: WORKS (apikey: 0c953f60-5cca-45b2-95f3-27373f4921ca)
- Session cookie: WORKS (dafcb7df-20a2-496f-a92e-33ef23e429b7)

## Backend status
- Container: Up 22h
- Healthcheck: RUNNING
- Datastore errors: repeated 404 for datastore_category IDs (non-blocking)

## Create workflow: NOT GATED — can proceed via API
## Route workflow: GATED — requires UI for webhook trigger configuration
## No secrets
