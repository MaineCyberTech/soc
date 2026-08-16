# Shuffle Webhook Smoke Test - 20260811-082923

Mode: --dry-run

## Result: DRY-RUN (no webhook called)

To run a live safe test:
  SHUFFLE_WEBHOOK_URL=http://127.0.0.1:3001/api/v1/hooks/webhook_<id> \\
    /opt/mct-security-stack/ops/scripts/shuffle-webhook-smoke-test.sh

Payload would be: {"source":"shuffle-webhook-smoke-test","rule_id":"121000","rule_level":12,"rule_description":"safe smoke test","agent_name":"smoke","srcip":"203.0.113.99","timestamp":"20260811-082923"}
