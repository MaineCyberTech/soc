# Phase 37-17: Packet Workflow Architecture Decision

**Date:** 2026-08-25
**Status:** DECIDED
**Owner:** 39dd09d3

## Context

Shuffle currently has 2 workflows with 796 healthcheck executions and no real alert routing. Suricata agent 016 is producing 1,095 alerts today (rule 86601). eve.json/eve-alert.json forwarding is active. The `decoder_order_size=512` setting has been applied but errors are still accumulating (1,830 errors in 18 minutes post-restart). ISM archives hold wazuh-archives-14d data, with the oldest archive at 10.8 days. Disk is at 84% (119G/148G). Cluster is GREEN with 274 shards.

A decision is required on how to route Suricata packet alerts through Shuffle workflows.

## Options

### Option A: Extend Existing `wazuh-high-severity-to-iris` Workflow

- Add Suricata-specific branching to the existing workflow
- Leverages existing webhook, normalization, and routing logic
- Lower operational overhead (single workflow to maintain)

### Option B: Create New Dedicated `mct-suricata-packet-routing` Workflow

- Isolated workflow purpose-built for Suricata packet routing
- Independent lifecycle, versioning, and rollback
- Clean dedup schema specific to packet alerting
- Future multi-tenant support without touching production workflow
- Separate metrics and observability

## Decision

**Option B — New isolated workflow `mct-suricata-packet-routing`.**

## Rationale

1. **Isolation:** Suricata packet routing logic is independent from Wazuh high-severity alerting. Combining them creates coupling that increases blast radius of changes.
2. **Independent rollback:** A failed Suricata routing change can be rolled back without affecting Wazuh-to-IRIS alerting.
3. **No impact on existing test workflow:** The existing 2 workflows and 796 healthcheck executions remain undisturbed.
4. **Clean dedup schema:** Packet dedup keys (SID + source/dest IP + port + hour bucket) are semantically different from Wazuh rule dedup. A dedicated workflow avoids schema mixing.
5. **Future multi-tenant support:** Isolated workflow can be templated and replicated per tenant without touching production alerting.
6. **Separate metrics:** Executions, latency, failure rates, and operator workload can be measured independently.

## Risk

Slightly more maintenance overhead from maintaining an additional workflow. Mitigated by clear ownership (owner 39dd09d3) and consistent design conventions.

## No secrets
