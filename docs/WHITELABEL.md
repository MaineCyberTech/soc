# White-Label Customization Layer

Date: 2026-08-16 (Phase 15)

## Purpose

Let the repo be reused for MCT or a future branded MSP deployment without
leaking customer/internal assumptions. Two config layers: BRAND (the MSP's own
identity) and CLIENT PROFILE (per-tenant).

## Layer 1: Brand (config/examples/brand.example.yml)

| Variable | Use |
|---|---|
| brand_name | report/service titles |
| legal_company_name | contracts, invoices |
| support_email / support_phone | templates, escalation |
| website_url | emails, reports |
| report_logo_path | report headers (assets/logo.png) |
| report_primary_color / secondary | scorecard/branding colors |
| service_package | offer/scorecard package name |

## Layer 2: Client profile (config/examples/client-profile.example.yml)

| Variable | Use |
|---|---|
| client_slug | file/prefix namespace |
| tenant_prefix | internal naming (agents, groups) |
| agent_group_prefix | Wazuh group naming (e.g. client-example-windows) |
| billing_label | invoice/scorecard |
| escalation_contacts | comm templates, IRIS |
| scan_authorized / deception_authorized | auth gates (must be true before activity) |

## Usage rules

- Templates + generators consume config (no hardcoded brand in client-facing
  output).
- config/brand.yml + config/clients/*.yml are gitignored (real values = secrets).
- Client-safe output must render from these variables only.

## Rollout

1. Fill config/brand.yml (MSP identity).
2. Per client: config/clients/<slug>.yml + signed authorization.
3. Generators (scorecard/emails) read profiles.

## Backlog

- Wire generators to config (scorecard, outreach email, billing labels).
- Tenant-prefixed Wazuh groups for future clients.

## No secrets
