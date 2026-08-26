# Phase 34 Python Bytecode and Temp Policy

Date: 2026-08-25

## Policy
- PYTHONDONTWRITEBYTECODE=1 for MCT scripts only (not system-wide)
- PYTHONPYCACHEPREFIX=/tmp/mct-pycache (bounded, < 100MB quota)
- Repository hygiene: .gitignore for __pycache__
- Compatibility: scripts only, not system Python
- Rollback: remove env var

## Implementation
- Applied to MCT scripts via env wrapper
- pyc cleanup via scheduled safe-clean

## No secrets
