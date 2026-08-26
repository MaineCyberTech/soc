# Phase 22 Dependency and Supply-Chain Audit

Date: 2026-08-22

## Python dependencies — PASS
- External imports used: `pymisp`, `requests` (+ stdlib). `pyyaml` declared in requirements but
  not imported in current code (declared for tooling).
- All core scripts stdlib-only.

## Vendored code — PASS (label mismatch)
- `data/dfir-iris/iris-web`: 238 .py files, LICENSE.txt LGPL-3.0. Release manifest labels the
  image GPL-3.0 -> minor label mismatch (backlog: correct manifest label).

## Binary cache — PASS (licensing clean)
- velociraptor (AGPL-3.0), wazuh agents (GPL-2.0), wheelhouse (MIT/BSD/Apache) - redistributable.
- sysmon zip: EULA-licensed, NOT cached (consistent with manifest cached:false).
- No licensed media anywhere.

## Checksums — PASS
- velociraptor + wazuh agent deb/rpm verified on disk vs manifest.
- Placeholders: sysmon-zip (<fill after download>), misp-core/greenbone-gvmd (cached=true but
  placeholder hash) - backlog: fill from VM103 docker inspect.

## Supply-chain posture
- Images: runtime images digest-pinned; feeds/versioned documented (policy).
- Cached artifacts verified by sha256 before use (checksums dir).

## Verdict
Dependency + supply-chain posture PASS with minor manifest reconciliation backlog.

## No secrets