# Greenbone Scan Target Groups

Defined target groups with profile, window, and safety notes. Scanner host:
mct-soc-scan VM (192.168.222.154), Greenbone CE stack (20 containers).

## Groups

| Group | Members | Profile (initial) | Window | Notes |
|---|---|---|---|---|
| core-infrastructure | Wazuh host 192.168.222.149, Security Onion 192.168.222.116, Proxmox 192.168.222.187, VM 103 (scanner, exclude self) | safe discovery -> authenticated server scan (later) | Monthly, 02:00-04:00 UTC | MCT internal; authenticated scan needs svc account, reviewed separately |
| cloud | mct-portal droplet 138.197.105.82 | external exposed services check | Monthly, off-peak (client agreed) | Notify client before first scan; do not scan without recorded authorization |
| network-appliances | UniFi gateways: Zen 192.168.222.1, SKK 23.150.201.36, LBM-Dock 23.150.201.165 | safe discovery only | Quarterly, 02:00-04:00 | Gateways are production appliances; non-invasive only; expect admin alerts |
| client-like | future test/client endpoints | safe discovery | As provisioned | Not yet defined; add per client onboarding |

## Scanner host

- The mct-soc-scan VM (192.168.222.154) hosts MISP + Greenbone - exclude it
  from scan targets (scanning the scanner causes noisy self-results).
- Greenbone CE runs 20 containers on the VM; keep VM resources in mind.

## Known-good source

- Scan source is 192.168.222.154. Wazuh rules suppress this scanner IP as FP
  (rule 121099 for OpenCanary; UniFi scanner suppression similar).

## Authorization

- MCT internal assets: authorized by default.
- Client-owned IPs (SKK, LBM-Dock, mct-portal droplet): documented client
  authorization required before scanning; record in the report/case.
