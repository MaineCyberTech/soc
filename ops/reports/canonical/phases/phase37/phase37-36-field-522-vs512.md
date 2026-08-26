# Phase 37-36: Reconciliation — 522 Fields vs 512 Limit

**Status:** COMPLETE  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Background

The "522 fields" figure was a **leaf-field approximation** obtained by counting only terminal values in a Suricata stats event.

## Explanation

The Wazuh JSON decoder counts **top-level keys**. If a stats event contains nested JSON (e.g., `"drop": {"tcp": 0, "udp": 0}`), each nesting level is counted by the decoder. This means the actual decoder field count likely **exceeds 512** due to nesting multiplication.

## Root Cause

The 522 leaf-field count underestimated the decoder-perceived field count because nesting was not accounted for.

## Proposed Resolution

- **(a)** Increase decoder_order_size to 1024, or
- **(b)** Minimize Suricata stats fields to reduce count below 512

**Option (b) preferred** — avoids higher memory per event on the analysis daemon.

## No secrets
