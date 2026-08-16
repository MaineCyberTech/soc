# Python Tooling

Date: 2026-08-16 (Phase 15)

## Core stack scripts

- Use ONLY the Python standard library (verified) - no pip install required.
- Includes: reporting generators, health checks, MISP sync (urllib), GMP scripts (socket).

## Optional dependencies

- requirements.txt lists optional tooling (pymisp, requests, pyyaml).
- Install: `pip3 install -r requirements.txt`
- Cache: `pip download -r requirements.txt -d /opt/mct-cache/pip/`

## Rules

- New scripts MUST use stdlib when possible.
- External deps must be added to requirements.txt with version pins.

## No secrets
