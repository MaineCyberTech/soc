# Resource Efficiency Report - 20260816-070524

## Host
               total        used        free      shared  buff/cache   available
Mem:            15Gi        10Gi       200Mi        18Mi       4.7Gi       4.4Gi
Swap:          8.0Gi       3.1Gi       4.9Gi

Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       148G   93G   50G  66% /
/dev/sda1       148G   93G   50G  66% /

## Docker containers (top 10 by memory)
multi-node-wazuh2.indexer-1	1.669GiB / 9.33GiB	2.24%
multi-node-wazuh3.indexer-1	1.618GiB / 9.33GiB	0.63%
multi-node-wazuh1.indexer-1	1.534GiB / 9.33GiB	1.00%
shuffle-opensearch	1.328GiB / 1.5GiB	0.87%
elastiflow	820.6MiB / 9.33GiB	0.32%
multi-node-wazuh.worker-1	480.2MiB / 9.33GiB	9.02%
multi-node-wazuh.master-1	463.1MiB / 9.33GiB	0.85%
tenzir-node	188.4MiB / 9.33GiB	7.29%
multi-node-wazuh.dashboard-1	166.5MiB / 9.33GiB	0.21%
shuffle-backend	109MiB / 768MiB	0.00%

## Top disk consumers (/opt)
1.3G	/opt/wazuh-backups/elasticsearch/indices/joha01n3TdWZ-jyP4Gd7bQ
2.2G	/opt/wazuh-backups/elasticsearch/indices/Q_4hm85_SC2o356gTaxUHA
4.0G	/opt/wazuh-backups/elasticsearch/indices/AF3p6yWySCSXZhOTwqZe3w
4.0G	/opt/wazuh-backups/elasticsearch/indices/AF3p6yWySCSXZhOTwqZe3w/0
4.4G	/opt/mct-security-stack/ops
4.4G	/opt/mct-security-stack/ops/backups
4.4G	/opt/mct-security-stack/ops/backups/vm103
4.5G	/opt/mct-security-stack
13G	/opt/wazuh-backups
13G	/opt/wazuh-backups/elasticsearch
13G	/opt/wazuh-backups/elasticsearch/indices
18G	/opt

## ES snapshots (local repo)
13G	/opt/wazuh-backups/elasticsearch
  entries: 90
