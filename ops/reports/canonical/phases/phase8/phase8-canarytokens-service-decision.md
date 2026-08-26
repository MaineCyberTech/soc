# Phase 8 Canarytokens Service Decision

Date: 2026-08-15
Decision: **HOSTED (canarytokens.org) for first token - self-hosted deferred**

## Options

### Option A: Hosted (canarytokens.org)

- Pros: zero infrastructure, instant deployment, webhook delivery.
- Cons: tokens land on third-party service; data leaves stack; account needed.
- Suitability: FIRST TOKEN - fastest validation of the deception alert path.

### Option B: Self-hosted (canarytokens-docker on VM103 or test host)

- Pros: full control, stays internal.
- Cons: needs VM/container build (VM103 is loaded with MISP+Greenbone; test
  Proxmox .222 blocked), DNS/webhook config, maintenance.
- Suitability: after hosted path validated; or if client data restrictions
  require self-host.

## Recommendation

- Deploy first token via **hosted canarytokens.org** (webhook -> Shuffle
  wazuh-high-severity trigger) to validate the path.
- Revisit self-hosted if a client requires data residency.

## First token

- T1 fake-backup-credentials.txt (placeholder content only).
- Webhook: http://shuffle-frontend/api/v1/hooks/webhook_24636c49-... (Class A trigger).
- Validation: touch file -> Shuffle run -> IRIS alert.

## Status

- DECISION MADE. Deployment blocked on operator creating the canarytokens
  account (hosted) or VM access (self-hosted).
