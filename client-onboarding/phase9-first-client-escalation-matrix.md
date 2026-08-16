# Phase 9 First Client Escalation Matrix

## Triage levels

| Level | Description | Examples | Response time (business hours) |
|---|---|---|---|
| L1 - Info | No impact | Service banner detections, low-severity | Next business day |
| L2 - Watch | Suspicious, no confirmed impact | Failed logins, unusual process | 4h |
| L3 - High | Confirmed suspicious/impacted | Malware, lateral movement, exfil | 1h |
| L4 - Critical | Active compromise / outage | Ransomware, account takeover | **Immediate (15 min)** |

## Escalation path

1. L1/L2: SOC analyst -> alert in Wazuh/IRIS -> monthly scorecard.
2. L3: analyst -> on-call engineer -> client IT contact (email + phone).
3. L4: on-call engineer -> client leadership -> MCT owner.
4. Every L3/L4 gets an IRIS case + post-incident summary.

## Client contacts

| Role | Name | Contact | Method |
|---|---|---|---|
| Client IT lead | ______________ | ______________ | email/phone |
| Client exec | ______________ | ______________ | email |
| MCT on-call | ______________ | ______________ | phone |

## Escalation SLA

- L4 notification within 15 min of confirmed detection.
- L3 within 60 min.
- All escalations logged in IRIS (case notes).

## No secrets

No secret values printed.
