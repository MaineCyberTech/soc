#!/bin/sh
# Ensure Shuffle action-execution containers keep the mounts required to reach
# IRIS and shuffle-opensearch with valid internal CAs:
#   - IRIS scoped key + IRIS CA (for the IRIS POST)
#   - OpenSearch CA bundle + single OpenSearch CA (for the dedup ledger writes)
# The augmentation is applied directly to the running Swarm service specs (it is
# NOT part of any repo compose), so this guard re-applies it idempotently if a
# future redeploy / update strips it.
#
# Dev-only workaround for the Docker bridge anomaly that blocks direct container->
# container reachability to IRIS / OpenSearch from Swarm tasks, and for the
# execute_python runtime (shuffle-tools) lacking the OpenSearch CA.
set +e

ENV_SRC=/opt/mct-security-stack/ops/backups/agents/iris-shuffle.env
CA_SRC=/opt/mct-security-stack/ops/backups/tls/20260828T234243Z/ca.crt
BUNDLE_SRC=/opt/mct-security-stack/ops/backups/tls/ca-bundle.pem
OS_CA_SRC=/opt/mct-security-stack/data/opensearch-tls/ca/ca.pem

ENV_TGT=/run/secrets/iris-shuffle.env
CA_TGT=/run/secrets/iris-ca.crt
BUNDLE_TGT=/opt/mct/security/ca-bundle.pem
OS_CA_TGT=/opt/mct/security/opensearch-ca.pem

NEED_HOSTS="iriswebapp_nginx:172.20.0.1 shuffle-opensearch:172.20.0.1"

# Services that execute workflow actions (execute_python runs in shuffle-tools).
SERVICES="shuffle-workers shuffle-tools shuffle-subflow shuffle-ai"

for SERVICE in $SERVICES; do
  if ! docker service inspect "$SERVICE" >/dev/null 2>&1; then
    echo "$(date -u +%FT%TZ) $SERVICE not found; skipping"
    continue
  fi

  SPEC=$(docker service inspect --format '{{json .Spec.TaskTemplate.ContainerSpec}}' "$SERVICE" 2>/dev/null)
  UPDATE_ARGS=""

  for h in $NEED_HOSTS; do
    host="${h%%:*}"; ip="${h##*:}"
    if ! printf '%s' "$SPEC" | grep -q "$ip $host"; then
      UPDATE_ARGS="$UPDATE_ARGS --host-add $h"
    fi
  done

  # bind mounts (match by source)
  check_add() {
    src="$1"; tgt="$2"
    if ! printf '%s' "$SPEC" | grep -q "\"Source\":\"$src\""; then
      UPDATE_ARGS="$UPDATE_ARGS --mount-add type=bind,source=$src,target=$tgt,readonly"
    fi
  }
  check_add "$ENV_SRC"    "$ENV_TGT"
  check_add "$CA_SRC"     "$CA_TGT"
  check_add "$BUNDLE_SRC" "$BUNDLE_TGT"
  # Single OpenSearch CA (used by the dedup ledger PUT in the workflow python).
  check_add "$OS_CA_SRC"  "$OS_CA_TGT"

  if [ -z "$UPDATE_ARGS" ]; then
    echo "$(date -u +%FT%TZ) $SERVICE already has required mounts; nothing to do"
    continue
  fi

  echo "$(date -u +%FT%TZ) Augmenting $SERVICE:$UPDATE_ARGS"
  # shellcheck disable=SC2086
  docker service update --detach=false $UPDATE_ARGS "$SERVICE" >/dev/null 2>&1
  echo "$(date -u +%FT%TZ) $SERVICE augmentation applied"
done
