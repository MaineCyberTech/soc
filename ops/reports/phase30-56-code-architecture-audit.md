# Phase 30 Code Architecture Audit

Date: 2026-08-24

## Boundaries / layering

- Clear separation: ops/ (operations + CI), scripts/endpoint-deploy (client installers),
  integrations/ (per-vendor), reporting/ (generators + output), config/ (declarative state).
- Compose projects: multi-node (Wazuh), mct-security-stack (aux), iris-web, portainer,
  shuffle (swarm).

## Coupling / source-of-truth

- One canonical source per component (canonical map 33); duplicates redirected
  (reporting/generators deprecated; scorecard generators canonical = ops/scripts).
- Env abstraction: ${VAR} refs; profiles + schema; secrets 0600 stores.

## Findings

1. Vendored IRIS (data/dfir-iris nested git, gitignored) - acceptable deployable copy,
   pinned upstream; not a repo component.
2. Runtime drift (running containers predate compose pins) - reconciled P29/P30.
3. Dead/generated: reporting/generators duplicate .py (deprecated), pycache (untracked).
4. Error handling: scripts fail-closed (guardrail, installers); traps limited - noted.

## Verdict

- **PASS** (architecture sound; drift items accepted/reconciled).

## No secrets