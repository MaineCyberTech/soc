# Phase 15 Python Dependency Cache Report

Date: 2026-08-16

## Status: CORE STACK IS STDLIB-ONLY (no external pip deps)

## Findings

| Area | Deps | Verdict |
|---|---|---|
| reporting/generators | argparse, json, os, pathlib, re, ssl, sys, urllib | ALL STDLIB |
| ops/scripts/*.py | stdlib only (verified import check) | ALL STDLIB |
| MISP sync (misp-to-wazuh-cdb.py) | urllib (stdlib) | ALL STDLIB |
| GMP scripts (VM103) | socket, os, re, collections | ALL STDLIB |
| Optional tooling | pymisp, requests, pyyaml | requirements.txt (optional) |

## Cache

- Optional deps: requirements.txt created; wheelhouse via `pip download -r requirements.txt -d /opt/mct-cache/pip/`.
- Core stack: NO python cache needed (stdlib only).

## Doc

- docs/PYTHON-TOOLING.md (created)

## No secrets
