#!/bin/sh
# Ensure iriswebapp_nginx publishes 8443 on the mct-security gateway (172.20.0.1)
# so Shuffle worker tasks (Swarm tasks are isolated from bridge containers) can
# reach IRIS via the host DNAT path. Idempotent: only recreates the container if
# the gateway publish is missing (e.g. after an external recreate from the IRIS
# compose, which publishes 127.0.0.1 only). Dev-only workaround for the Docker
# bridge anomaly that blocks direct container->container reachability to IRIS.
set +e
NAME=iriswebapp_nginx
CERT=/opt/mct-security-stack/data/dfir-iris/iris-web/certificates/web_certificates

if docker inspect "$NAME" >/dev/null 2>&1 && docker port "$NAME" 2>/dev/null | grep -q '172.20.0.1:8443'; then
  echo "$(date -u +%FT%TZ) iriswebapp_nginx already published on 172.20.0.1:8443; nothing to do"
  exit 0
fi

echo "$(date -u +%FT%TZ) Recreating $NAME with gateway publish..."
docker rm -f "$NAME" >/dev/null 2>&1
docker run -d \
  --name "$NAME" \
  --network mct-security --network-alias iriswebapp_nginx --network-alias nginx \
  --restart always \
  -p 127.0.0.1:8443:8443 -p 172.20.0.1:8443:8443 \
  -v "$CERT:/www/certs/:ro" \
  -e IRIS_UPSTREAM_SERVER=app -e IRIS_UPSTREAM_PORT=8000 -e INTERFACE_HTTPS_PORT=8443 \
  -e SERVER_NAME=iris.app.dev -e CERT_FILENAME=iris_dev_cert.pem -e KEY_FILENAME=iris_dev_key.pem \
  -e IRIS_AUTHENTICATION_TYPE=local \
  ghcr.io/dfir-iris/iriswebapp_nginx:v2.4.29
docker network connect iris_backend --alias iriswebapp_nginx --alias nginx "$NAME" 2>/dev/null
docker network connect iris_frontend --alias iriswebapp_nginx --alias nginx "$NAME" 2>/dev/null
echo "$(date -u +%FT%TZ) iriswebapp_nginx recreated with gateway publish"
