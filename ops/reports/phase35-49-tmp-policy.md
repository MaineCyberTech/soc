# Phase 35: Python and OpenCode Temporary Policy

Date: 2026-08-25

## Policy
- Python temp dirs (tmp.*) are created by the runtime and left behind after crashes or unclean exits
- OpenCode workspace uses /tmp/opencode for scratch work
- No automated cleanup policy exists for Python temp dirs

## Current state
- 10,195 Python temp dirs in /tmp
- Total 1.6GB on tmpfs

## Recommended policy
1. Weekly cleanup of Python temp dirs older than 24h: `find /tmp -maxdepth 1 -name "tmp.*" -type d -mmin +1440 -exec rm -rf {} \;`
2. /tmp/opencode: keep (active workspace)
3. p32-* audit dirs: clean after report extraction (15MB, negligible)

## No automated policy applied yet
## No secrets
