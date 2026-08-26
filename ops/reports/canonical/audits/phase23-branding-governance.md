# Phase 23 Branding and White-Label Governance

Date: 2026-08-22

## 1. Current state

- `config/examples/brand.example.yml`: hardcodes real brand (Maine Cyber Tech) - violates
  "example = neutral" principle.
- 12 brandable templates hardcode "Maine Cyber Tech"/"MCT" (email templates, scorecard
  templates) - white-label generator backlog.
- `render-branded-template.py`: hardcodes real endpoint names (SAMSUNG 013, DESKTOP-MI54LFT
  014); --email mode overwrites a committed template.

## 2. This phase

- Created `docs/WHITELABEL-GOVERNANCE.md` (brand variables, client profile inheritance,
  internal/lab token rules, generated-output QA, neutral templates, prohibited leakage).
- Neutralized `brand.example.yml` (below).

## 3. Applied fix

- brand.example.yml -> neutral placeholder values (see edit).

## 4. Backlog (P24)

- Convert the 12 templates to `{{brand.*}}` placeholders.
- Fix render-branded-template.py endpoint hardcodes + --email output behavior.

## No secrets