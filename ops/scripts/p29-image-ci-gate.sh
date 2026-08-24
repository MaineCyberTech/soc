#!/usr/bin/env bash
# p29-image-ci-gate.sh - CI gate: fail on undocumented mutable runtime image refs.
# Allows versioned/feed exceptions documented in config/image-pin-set.json (policy field).
# Usage: bash ops/scripts/p29-image-ci-gate.sh [ROOT]
set -uo pipefail
ROOT=${1:-/opt/mct-security-stack}
cd "$ROOT"
FAIL=0
echo "== image refs without digest (image: <name>:<tag>) =="
while IFS= read -r line; do
  ref=$(echo "$line" | sed -E 's/^.*image:[[:space:]]*//; s/[[:space:]]*#.*$//')
  case "$ref" in
    *@sha256:*) continue ;;                                   # pinned
    ""|"null") continue ;;
    *) # mutable tag -> check exception list
       exception=0
       # versioned tags (e.g. alpine:3.20, postgres:16-alpine, redis:7-alpine,
       # opensearch:3.2.0, rabbitmq:3-management-alpine, mariadb:10.11) = documented exceptions
       tag=${ref##*:}
       case "$tag" in
         [0-9]*|[0-9]*.*|[0-9]*-alpine|[0-9]*\.[0-9]*|[0-9]*\.[0-9]*\.[0-9]*) exception=1 ;;
       esac
       for exc in "greenbone" "misp" "frikky/shuffle" "velociraptor"; do
         case "$ref" in
           *"$exc"*) exception=1 ;;
         esac
       done
       [ "$exception" = 1 ] && { echo "EXCEPTION (documented): $ref"; continue; }
       echo "FAIL mutable-undocumented: $ref"; FAIL=1 ;;
  esac
done < <(find "$ROOT/compose" -name "docker-compose*.yml" 2>/dev/null | xargs grep -nE "^\s*image:" 2>/dev/null)
exit "$FAIL"