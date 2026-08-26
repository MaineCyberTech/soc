# Phase 39 Restore Target Criteria — Minimum Spec Independent of PVE

**Report ID:** phase39-83-restore-target-criteria
**Phase:** 39
**Title:** RESTORE-CRIT-39-01 — Minimum Target: 8 Cores / 32GB RAM / 300GB SSD / Isolated Segment / Version-Matched Docker; Current 148G LXC Host Disqualifies Itself; External Target REQUIRED
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** COMPLETE (criteria defined; no target provisioned yet)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-83-restore-target-criteria.md`

---

## 1. Why a spec independent of PVE

The rehearsal target must satisfy the workload, not match the hypervisor. Any
provider (ProxmVE/LXC, cloud VM, bare workstation) is acceptable if it meets §2.

## 2. Minimum target spec

| Requirement | Floor | Rationale |
|---|---|---|
| CPU | ≥8 cores | 3 indexers + manager + worker + integrations concurrently |
| RAM | ≥32GB | indexer heap trio alone ~8–12GB; Shuffle + Tenzir + canary stack |
| Disk | ≥300GB SSD-class | current host uses 119G of 148G and is 84% full; restore needs headroom for snapshot expansion + working space |
| Network | isolated segment/VLAN or NAT-only bridge | never routable to prod LAN |
| Runtime | docker + docker compose versions ≥ current host's (`docker compose` v2 line) | compose files are version-sensitive |
| Access | root/sudo + `creds.env` + `.env` availability at Stage2 | secrets injection step |
| Hypervisor independence | none required | any virtualization meeting above |

## 3. Data-safety contract

1. NEVER attach the target to production networks/storage (no prod VLAN, no
   shared NFS/LVM volumes).
2. Never point restored containers' published ports onto the LAN.
3. Snapshot/clone the target before each stage so failed stages roll back by reclone.
4. No production credentials beyond read-only restore material leave the vault.

## 4. Cleanup contract

Teardown = compose down -v → delete extracted tree → delete imported images →
delete target VM/disk if ephemeral → confirm zero residual indexes in any shared
registry. Written as PLAN-DR-39-01 Stage6.

## 5. Candidate targets (generic tradeoffs)

| Candidate | Fit | Tradeoff |
|---|---|---|
| Spare LXC/host capacity on another box | good if idle | must verify 32GB free RAM + 300G disk; shared-host risk |
| Cloud VM (spot/on-demand) | clean isolation, exact sizing | egress cost pulling snapshots; data leaves premises |
| Workstation hypervisor (VirtualBox/VMware/Proxmox on spare hardware) | fully local, cheap | operator babysits resources; slower disks common |

## 6. Current host disqualification (measured)

```
/dev/sda1 148G total, 119G used, 24G avail, 84% full   (df -h /, Aug-25)
```

A 148G LXC with 24G free cannot hold a 300GB-spec restore. **External target is
REQUIRED**; rehearsing on this host would also contaminate the system under test.

## 7. Approval checklist

- [ ] Target provisioned to §2 floors
- [ ] Isolation verified (no prod route)
- [ ] Docker/compose versions recorded and matching
- [ ] creds.env/.env transfer path agreed
- [ ] Pre-stage clone capability confirmed
- [ ] Owner sign-off logged (Stage0 gate)
