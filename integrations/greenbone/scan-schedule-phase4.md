# Greenbone Scan Schedule (Phase 4)

## Profiles

| Profile | Use | When |
|---|---|---|
| safe discovery | first scan of any new target | initial |
| authenticated server scan | Linux/Windows servers with svc-openvas-scan | monthly (core-infrastructure) |
| external exposed services check | internet-facing targets | monthly off-peak |
| post-remediation verification | re-scan after patch | within 5 days of remediation |
| monthly recurring scan | default cadence | 1st week |

## Schedule plan

| Task name (proposed) | Target group | Profile | Schedule | Frequency |
|---|---|---|---|---|
| MCT-core-infra-monthly | core-infrastructure | monthly recurring | 1st Mon 02:00 UTC | monthly |
| MCT-cloud-monthly | cloud | external exposed services check | client-agreed date 02:00 UTC | monthly |
| MCT-network-appliances-quarterly | network-appliances | safe discovery | 1st Sun of quarter 02:00 UTC | quarterly |
| MCT-client-like-onboarding | client-like-test | safe discovery | manual (on provision) | on-boarding |
| MCT-post-remediation | manual target | post-remediation verification | manual trigger | on demand |

## Creating schedules (gvm-cli, on VM103)

```bash
# template - schedules are created in Greenbone UI/CLI; use the scan-window-policy
# as the reference. Operator executes on mct-soc-scan VM.
gvm-cli socket --gmp-username admin --gmp-password <redacted> --xml \
  "<create_schedule><name>MCT-core-infra-monthly</name>..."
```

## Monitoring

- Alert noise from scanner IP 192.168.222.154 suppressed (OpenCanary 121099,
  UniFi scanner suppression) - expected FP during scan windows.
- Check scan results after each window: gvm report export + vulnerability-review template.

## Status

- SCHEDULE CREATED + VALIDATED 2026-08-15 (MCT-lab-weekly-sun-0600 for the lab
  target; production MCT-Weekly-Sunday-0200 also in use). See
  ops/reports/phase9-greenbone-recurring-schedule.md.
