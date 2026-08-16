# RAM Risk Acceptance for Client Pilot

Date: 2026-08-15

## Status: RISK RESOLVED (RAM expanded + validated)

- VM101 balloon was capping guest at 10G despite 16G allocation.
- Balloon raised to 16G (live + persisted); guest now sees 15.9G.
- Post-ram-health-validation.sh: PASS.
- Swap draining (5.2G -> 4.9G and falling).

## Remaining consideration (not a blocker)

- PVE host .187 at 30G/31G - no headroom for further VM growth without host
  RAM addition. The production host now has 7G available inside VM101, which is
  adequate for the Linux-only first client pilot.
- If a second client or Windows workloads are added, host RAM expansion
  (16-32G) should be revisited.

## Client launch impact

- **RAM condition: MET** - no longer a blocker for first-client Linux pilot.

## Acceptance record

- Accepted 2026-08-15: 16G VM101 with 7G available is sufficient for pilot;
  host-level RAM expansion deferred unless workload grows.

## No secrets

No secret values printed.
