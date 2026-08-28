# IRIS Token Rotation Runbook (P58 Prompts 024-035)

## Overview
This runbook documents the procedure for rotating the underlying IRIS API key (true token rotation, not just reference migration). The current IRIS API key is used by:
- Class-A workflow (`c6b3fcd8-13e5-44a8-a818-024e4ae4422b`) - value-blind via execute_python
- Packet workflow (`e133a645-95b9-4e01-9454-e270d2a0b599`) - value-blind via execute_python
- Any other consumers of the `iris-shuffle-env` secret

## Current State
- **Current IRIS API Key**: `REDACTED_IRIS_API_KEY`
- **Secret Location**: `/shuffle-files/iris-shuffle.env` and `/run/secrets/iris-shuffle.env` (mounted in shuffle-tools)
- **Secret Name**: `iris-shuffle-env` (Docker Swarm secret, ID: 4vpfvc92ice0)
- **Workflows Using**: Class-A (`c6b3fcd8`), Packet (`e133a645`) - both use value-blind token loading

## Rotation Procedure

### Prerequisites
- Access to IRIS web UI (https://192.168.222.149:8443)
- IRIS admin credentials (stored in `/opt/wazuh-docker/multi-node/ops/creds.env` as `IRIS_API_KEY`)
- Docker Swarm access to update secret
- Shuffle access to verify workflows

### Step 1: Generate New IRIS API Key
1. Log into IRIS web UI at `https://192.168.222.149:8443` with admin credentials
2. Navigate to **Administration > Users > API Keys** (or **Administration > API Keys**)
3. Select the service account user (typically `shuffle` or `wazuh-integration`)
4. Click **Generate New API Key** or **Rotate Key**
2. Copy the new API key value immediately (it won't be shown again)

### Step 2: Update Docker Swarm Secret
```bash
# Create new secret with new key
echo "IRIS_API_KEY=<NEW_KEY>" | docker secret create iris-shuffle-env-v2 -

# Update service to use new secret (rolling update)
docker service update \
  --secret-rm iris-shuffle-env \
  --secret-add source=iris-shuffle-env-v2,target=iris-shuffle.env,mode=0400 \
  shuffle-tools
```

### Step 3: Verify Workflows
```bash
# Verify Class-A workflow still works
curl -s -X POST http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000-555f-4e81-9497-77b7c91c5b98 \
  -H 'Content-Type: application/json' \
  -d '{"test":"rotation-verify"}' -w '\nHTTP %{http_code}\n'

# Check Shuffle execution
# Should return HTTP 200 and create IRIS object
```

### Step 4: Clean Up Old Secret
```bash
# After verifying all consumers work with new key
docker secret rm iris-shuffle-env
docker secret rename iris-shuffle-env-v2 iris-shuffle-env
```

## Rollback Plan
If issues occur:
1. Revert secret: `docker service update --secret-rm iris-shuffle-env-v2 --secret-add source=iris-shuffle-env,target=iris-shuffle.env shuffle-tools`
2. Verify workflows work with old key
3. Investigate and retry

## Consumers to Verify
1. Class-A workflow (`c6b3fcd8`) - uses `execute_python` with `load_iris_token()`
2. Packet workflow (`e133a645`) - uses `execute_python` with `load_iris_token()`
3. Any other Shuffle workflows using `iris-shuffle-env`

## Notes
- The IRIS API key rotation cannot be automated via API (no admin API endpoints exposed)
- Must be done manually via IRIS web UI
- Both Class-A and Packet workflows use value-blind token loading, so they will automatically pick up the new key from the secret file after secret rotation
- No workflow changes needed - they read the secret file at runtime

## Rollback Verification
After rollback, verify:
- `curl -X POST http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000...` returns 200
- IRIS object created with new alert
- Packet workflow still processes events

---
*Generated as part of P58 prompts 024-035 rotation sequence*
EOF
cat /tmp/opencode/iris_rotation_runbook.md