# Desired secret-mount/grant spec (canonical, trusted grants for the governed stack)
# Service tools (shuffle-tools) MUST mount ONLY these dedicated, service-scoped secrets:
#   iris-shuffle-dedicated  -> /run/secrets/iris-shuffle.env (IRIS_API_KEY, IRIS_BASE_URL, IRIS_CA, VERIFY_CERTS)
#   dedup-shuffle-dedicated -> /run/secrets/dedup-shuffle.env (OPENSEARCH_DEDUP_* + CA-bundle path + VERIFY_CERTS)
#   iris-ca.crt             -> /run/secrets/iris-ca.crt (IRIS CA, MCT-Internal-CA)
#   opensearch-ca           -> /opt/mct/security/ca-bundle.pem (OpenSearch CA bundle)
# Broad mixed env files (iris-shuffle-env, iris-shuffle-env-v2, iris-shuffle-env-v3) and compose .env MUST NOT be mounted.
# Trust: IRIS listener presents cert issued by MCT-Internal-CA (== iris-ca.crt); OpenSearch verified via opensearch-ca.
# Networks (governed overlays): iris-shuffle-overlay (shuffle-workers only), shuffle_swarm_executions, ingress.
