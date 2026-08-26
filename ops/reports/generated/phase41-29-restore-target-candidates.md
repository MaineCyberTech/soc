# Phase 41 Restore Target Candidates — Matrix Refreshed (4 Archetypes)

**Report ID:** phase41-29-restore-target-candidates
**Phase:** 41
**Title:** RT-CAND-41-01 — Candidate Matrix Refreshed Against RESTORE-CRIT-39-01 Floors: Four Archetypes Scored On Spec Fit, Isolation, Cost, Lead-Time, Agent-Test Reachability; PRIMARY = Cloud VM 8 vCPU/32GB/300GB (Provider "could-you-confirm" Pending Owner), SECONDARY = Workstation-Hypervisor VM; Nothing Provisioned
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (matrix refreshed; recommendation recorded)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-29-restore-target-candidates.md`

---

## 1. Basis

Floors come from RESTORE-CRIT-39-01 (phase39-83 §2): ≥8 cores, ≥32GB RAM,
≥300GB SSD-class disk, isolated segment/NAT-only, docker compose ≥ current host,
root/sudo + secrets-injection path at Stage2. The current host re-measured today
at 148G total / 118G used / **84% full** — self-disqualification stands; every
candidate below is external by construction.

## 2. Candidate matrix

| Archetype | Spec fit vs floors | Isolation | Cost | Provisioning lead-time | Network reachability for agent-test | Verdict |
|-----------|--------------------|-----------|------|------------------------|-------------------------------------|---------|
| **C1 — Cloud VM** (working label "could-you-confirm": provider/account TBD pending owner confirmation) sized 8 vCPU / 32GB / 300GB SSD | EXACT by sizing order; no shared-host surprises | CLEANEST — VPC/private subnet, no prod route by default; NAT/bastion for access | On-demand hourly + egress on snapshot pull; spend ceiling set in memo | Minutes-to-hour once account/provider confirmed | Test agent reaches restored manager via VPN/bastion or same-VPC test endpoint without touching prod LAN — GOOD | **PRIMARY (recommended)** |
| **C2 — Workstation-hypervisor VM** (VirtualBox/VMware Fusion/Workstation/Proxmox on a daily-driver machine) | CONDITIONAL — needs 32GB free alongside daily use and ~300GB free SSD; verify before promising | GOOD — host-only/NAT network; never bridged to prod VLAN | $0 marginal (existing hardware) | Hours (disk space check + install media) | Same-machine or LAN test endpoint via host-only/NAT — workable for single-operator rehearsal | **SECONDARY** |
| **C3 — Spare LXC/host capacity on another box** | VERIFY-FIRST — must prove ≥32GB idle RAM + ≥300GB disk; shared-host contention risk | MEDIUM — shared kernel/bridge; misconfig risk to prod LAN must be engineered away | $0 if hardware idle | Hours incl. verification | LAN-adjacent — requires deliberate NAT/VLAN discipline to honor isolation contract | Backup option |
| **C4 — Repurposed spare-metal hypervisor** (mini-PC/old server, bare-metal hypervisor) | GOOD if hardware with 32GB exists on premises | STRONG — dedicated NIC on isolated segment | Hardware-if-owned; else purchase ⇒ cost+days | Days (imaging, hypervisor install) | Cleanest on-prem isolation story for agent-test | Keep in reserve |

## 3. Recommendation

1. **PRIMARY: C1 cloud VM at exactly the floor sizing** (8 vCPU / 32GB /
   300GB SSD). It converts an open-ended hardware question into a fixed
   checklist, gives the cleanest isolation evidence for Stage0, and its lead
   time collapses to "as soon as the owner names provider/account". The label
   `could-you-confirm` is kept deliberately: it encodes that the only missing
   input is the owner's confirmation of provider + account + spend ceiling.
2. **SECONDARY: C2 workstation-hypervisor VM** if cloud egress of snapshot data
   is unacceptable to the owner — zero cost, slightly messier spec verification.
3. C3/C4 remain documented fallbacks; neither is pursued without owner signal.

## 4. Non-goals

Nothing provisioned, nothing spent, no provider contacted. The matrix exists so
the T+35 agenda slot (phase41-19) is a decision, not a research project.
Assessment against each floor per candidate: phase41-30. Approval instrument:
phase41-31.
