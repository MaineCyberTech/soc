# Acceptance Test Template

Use for every integration route and every deployment acceptance.

## Test metadata

- Date: <YYYY-MM-DD>
- Tester: <name>
- Route: <source> -> <destination> (contract file: <path>)
- Build/version under test: <compose file / commit / service version>

## Preconditions

- [ ] Wazuh stack healthy (healthcheck)
- [ ] Relevant services deployed
- [ ] Credentials available via env (not printed)

## Test steps

1. <step>
2. <step>
3. <step>

## Expected outcome

- <expected behavior 1>
- <expected behavior 2>

## Actual outcome

- <result 1>
- <result 2>

## Pass/Fail

- [ ] PASS
- [ ] FAIL (attach failure details + reopening bug reference)

## Anomalies

- <any FPs, noise, unexpected behavior>

## Evidence

- <log file, HTTP code, screenshot reference — no secrets>
