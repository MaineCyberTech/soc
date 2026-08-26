# Phase 16 Python Wheelhouse and Tooling Cache

Date: 2026-08-16

## Status: WHEELHOUSE BUILT

## Wheelhouse: /opt/mct-cache/python-wheelhouse/

- 10 wheels: pymisp 2.5.34.2, requests 2.34.2, pyyaml 6.0.3, certifi,
  charset_normalizer, deprecated, idna, python-dateutil, six, urllib3.
- Built via: pip3 download -r requirements.txt -d /opt/mct-cache/python-wheelhouse/

## Offline install

```bash
pip3 install --no-index --find-links /opt/mct-cache/python-wheelhouse/ -r requirements.txt
```

## Core stack

- STDLIB-ONLY (verified P15) - no pip needed for core scripts.

## No secrets
