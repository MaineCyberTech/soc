#!/usr/bin/env bash
# build-release-bundle.sh - build portable release bundle + manifest.
# Dry-run by default; --apply creates the tarball + manifest.
# Usage: bash scripts/ci/build-release-bundle.sh [--apply]
# Exclusions are enforced and verified (no secrets/backups/dumps/large artifacts).
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
OUT=${MCT_RELEASE_OUT:-/home/user/mct-security-releases}
TS=$(date +%Y%m%d-%H%M%S)
APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

EXCLUDES=(
  --exclude='.git'
  --exclude='ops/backups'
  --exclude='data'
  --exclude='.env'
  --exclude='.env.cloudflare'
  --exclude='ops/creds.env'
  --exclude='scripts/endpoint-deploy/client.config.yaml'
  --exclude='*.key'
  --exclude='*.pem'
  --exclude='*.sql.gz'
  --exclude='*.tar.gz'
  --exclude='*.zip'
  --exclude='*.pcap'
  --exclude='*.evtx'
  --exclude='ops/reports/shuffle-periodic-repair.log'
  --exclude='*.pyc'
)

INCLUDE=(README.md REPO-MAP.md ARCHITECTURE.md PORTABILITY.md SECURITY.md PORTS.md
  .env.example .gitignore .gitignore.example .github
  config scripts compose ops/runbooks ops/scripts ops/checklists ops/cron ops/reports
  integrations reporting/generators reporting/output reporting/queries reporting/templates
  client-onboarding service-packaging evidence checklists)

echo "== Portable release bundle build (dry-run: $([ $APPLY -eq 0 ] && echo YES || echo NO)) =="
echo "Source: $ROOT"
echo "Output: $OUT"

for p in "${INCLUDE[@]}"; do
  [ -e "$ROOT/$p" ] || echo "  [WARN] include path missing: $p"
done

# Verify no sensitive files would slip into the bundle
echo
echo "== Sensitive-file verification =="
for pat in 'creds.env' 'client.config.yaml' '\.env$' '\.key$' '\.pem$' '\.sql\.gz$' '\.pcap$' '\.evtx$'; do
  HITS=$(find "$ROOT" -path "$ROOT/.git" -prune -o -path "$ROOT/ops/backups" -prune -o -path "$ROOT/data" -prune -o -type f -print 2>/dev/null | grep -E "$pat" | wc -l)
  echo "  pattern '$pat': $HITS file(s) found (must be 0 or excluded)"
done

if [ $APPLY -eq 1 ]; then
  if ! mkdir -p "$OUT" 2>/dev/null; then
    sudo mkdir -p "$OUT" 2>/dev/null && sudo chown "$(id -u):$(id -g)" "$OUT" 2>/dev/null || { echo "ERROR: cannot create $OUT"; exit 1; }
  fi
  TARBALL="$OUT/mct-security-stack-release-$TS.tar.gz"
  tar czf "$TARBALL" "${EXCLUDES[@]}" -C "$ROOT" "${INCLUDE[@]}" 2>/dev/null
  echo "Created: $TARBALL"
  SIZE=$(du -h "$TARBALL" | cut -f1)
  FILES=$(tar tzf "$TARBALL" | wc -l)

  # Verify bundle contents contain no sensitive files
  BADLIST=$(tar tzf "$TARBALL" | grep -E 'creds\.env|client\.config\.yaml|\.env$|\.env\.cloudflare$|\.key$|\.pem$|\.sql\.gz$|\.pcap$|\.evtx$' | grep -vE '\.example|/examples/' || true)
  BAD=$(echo "$BADLIST" | grep -c . || true)
  echo "Bundle sensitive-file count: $BAD (must be 0)"
  if [ "$BAD" -ne 0 ]; then
    echo "ERROR: sensitive file leaked into bundle - removing."
    echo "$BADLIST" | while read -r f; do echo "  LEAKED: $f"; done
    rm -f "$TARBALL"
    exit 1
  fi

  # Write release manifest
  MANIFEST="$OUT/release-manifest-$TS.json"
  cat > "$MANIFEST" <<EOF
{
  "name": "mct-security-stack-release",
  "created": "$TS",
  "source": "$ROOT",
  "archive": "$(basename $TARBALL)",
  "size": "$SIZE",
  "file_count": $FILES,
  "sensitive_files": $BAD,
  "exclusions": [".git", "ops/backups", "data", ".env", "creds.env", "client.config.yaml", "*.key", "*.pem", "*.sql.gz", "*.tar.gz", "*.zip", "*.pcap", "*.evtx"],
  "sha256": "$(sha256sum "$TARBALL" | cut -d' ' -f1)"
}
EOF
  echo "Manifest: $MANIFEST"
  cp "$MANIFEST" "$ROOT/release-manifest.json"
  echo "Copied manifest to $ROOT/release-manifest.json"
else
  echo "Dry run - no bundle created. Use --apply to build."
fi
