#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; FAIL=0
while IFS= read -r f; do mode=$(git -C "$ROOT" ls-files -s -- "$f" | awk '{print $1}'); if grep -RqlF "$f" "$ROOT/ops" "$ROOT/integrations" 2>/dev/null && [ "$mode" != 100755 ]; then echo "REVIEW non-executable referenced script: $mode $f"; FAIL=1; fi; done < <(git -C "$ROOT" ls-files '*.sh')
exit "$FAIL"
