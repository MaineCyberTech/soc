#!/bin/sh
# Ensure the Shuffle worker Swarm service (shuffle-workers) keeps the extra_hosts
# and secret bind-mounts required to reach IRIS (iriswebapp_nginx on the mct-security
# gateway) and shuffle-opensearch. The augmentation is applied directly to the running
# Swarm service spec (it is NOT part of any repo compose), so this guard re-applies it
# idempotently if a future redeploy / update strips it.
#
# Dev-only workaround for the Docker bridge anomaly that blocks direct container->
# container reachability to IRIS from Swarm worker tasks.
set +e

SERVICE=shuffle-workers
NEED_HOSTS="iriswebapp_nginx:172.20.0.1 shuffle-opensearch:172.20.0.1"
ENV_SRC=/opt/mct-security-stack/ops/backups/agents/iris-shuffle.env
CA_SRC=/opt/mct-security-stack/ops/backups/tls/20260828T234243Z/ca.crt
ENV_TGT=/run/secrets/iris-shuffle.env
CA_TGT=/run/secrets/iris-ca.crt

if ! docker service inspect "$SERVICE" >/dev/null 2>&1; then
  echo "$(date -u +%FT%TZ) $SERVICE not found; cannot augment (recreate the service first). NO-OP."
  exit 0
fi

# Compact JSON (no whitespace) so subsequent pattern matches are exact.
SPEC=$(docker service inspect --format '{{json .Spec.TaskTemplate.ContainerSpec}}' "$SERVICE" 2>/dev/null)
UPDATE_ARGS=""

# extra_hosts (inspect stores them as "ip hostname"; check both forms)
for h in $NEED_HOSTS; do
  host="${h%%:*}"; ip="${h##*:}"
  if ! printf '%s' "$SPEC" | grep -q "$ip $host"; then
    UPDATE_ARGS="$UPDATE_ARGS --host-add $h"
  fi
done

# bind mounts (match by source + target)
if ! printf '%s' "$SPEC" | grep -q "\"Source\":\"$ENV_SRC\"";
then
  UPDATE_ARGS="$UPDATE_ARGS --mount-add type=bind,source=$ENV_SRC,target=$ENV_TGT,readonly"
fi
if ! printf '%s' "$SPEC" | grep -q "\"Source\":\"$CA_SRC\"";
then
  UPDATE_ARGS="$UPDATE_ARGS --mount-add type=bind,source=$CA_SRC,target=$CA_TGT,readonly"
fi

if [ -z "$UPDATE_ARGS" ]; then
  echo "$(date -u +%FT%TZ) $SERVICE already has required extra_hosts + secret mounts; nothing to do"
  exit 0
fi

echo "$(date -u +%FT%TZ) Augmenting $SERVICE:$UPDATE_ARGS"
# shellcheck disable=SC2086
docker service update --detach=false $UPDATE_ARGS "$SERVICE" >/dev/null 2>&1
echo "$(date -u +%FT%TZ) $SERVICE augmentation applied"
