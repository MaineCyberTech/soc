# Canarytokens: Hosted vs Self-Hosted

## Hosted (canarytokens.org)

- Create token via web UI/API (account required).
- Webhook delivery (POST to URL) - compatible with Shuffle.
- Token types: URL, file, DNS, AWS keys, docx/xlsx, QR.
- Data leaves MCT stack (token metadata on canarytokens).

## Self-hosted (canarytokens-docker)

- Run docker-compose canarytokens stack (nginx + frontend + app + redis).
- Placement: VM103 (loaded) or test Proxmox host (blocked).
- Full control; tokens stay internal.
- Requires DNS/frontend config + maintenance.

## Decision (2026-08-15)

Hosted first (fast validation). Self-hosted if client data residency required.

## First token plan

- Type: document (fake-backup-credentials.txt) or URL (fake-admin).
- Webhook: Shuffle wazuh-high-severity trigger.
- Validate: touch -> Shuffle run -> IRIS.
