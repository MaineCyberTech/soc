# White-Label Governance

Applies to: brandable templates, brand config, and generated client outputs.

## 1. Brand variables (single source)

- `config/examples/brand.example.yml` - must be a **neutral placeholder example**
  (no real brand). Real brand values live in local/client profile files only.
- Client profile inheritance: `config/client-profile.example.yml` pattern - each client
  supplies brand_name, legal_company_name, contact, colors, tagline.

## 2. Internal/lab token rules

- Internal docs may use the real brand (MCT/Maine Cyber Tech) - they are internal.
- Templates and generators must reference `{{brand.*}}` variables, never hardcode.

## 3. Generated-output QA

- After rendering: verify no `Maine Cyber Tech`/`MCT` leakage in client-branded outputs
  (unless the client IS MCT) and no internal paths/IPs/endpoint ids.
- `scripts/reporting/render-branded-template.py`: remove hardcoded endpoint names
  (SAMSUNG 013, DESKTOP-MI54LFT 014) - use placeholder data; never overwrite committed
  templates in --email mode (write to output dir only).

## 4. Neutral templates

- The 12 brandable templates in client-onboarding/templates/ + reporting/templates/
  hardcode real brand - backlog item: convert to `{{brand.*}}` placeholders (P24).

## 5. Prohibited leakage

- Real brand, client names, endpoint ids, internal IPs/paths in: client deliverables of
  OTHER clients, sample outputs, public docs.

## 6. Review

- `phase*-branding-governance` check at each release cycle.

## No secrets