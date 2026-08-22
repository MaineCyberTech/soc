# Client Artifact Governance

Applies to: `reporting/output/client/` and all client-facing deliverables.

## Classification

| Class | Rule |
|---|---|
| CLIENT-SAFE | Deliverable-ready; MUST carry `Classification: CLIENT CONFIDENTIAL - do not redistribute.` header; no internal paths/IPs/workstreams |
| INTERNAL-ONLY | Blockers, workstreams, endpoint identifiers (013/014/015), internal paths/IPs -> MUST live in `reporting/output/internal/` |
| TEMPLATE | Rendering source in `reporting/templates/`; never delivered raw |
| SAMPLE/SYNTHETIC | Clearly labeled sample data |
| AUTHORIZATION REQUIRED | Scan/vuln content -> gated on signed authorization |
| HISTORICAL EVIDENCE | Immutable records; banners applied; do not edit - addendum only |

## Rules

1. Client deliveries are rendered from templates with a client profile (brand variables) at
   delivery time - never shipped from internal working files.
2. Scorecard-progress and ops summaries stay in `reporting/output/internal/`.
3. Endpoint identifiers, internal IPs, stack paths, and operator blockers NEVER appear in
   client deliverables.
4. Classification header is mandatory on every client artifact (checked at review).
5. Review (`phase*-client-safe-output-audit.md`) before any send.

## Checks

- Leak scan (grep for `192.168.`, `/opt/`, `/home/`, endpoint ids) on client/ dir at each phase.
- Header presence check on all client/*.md.

## No secrets