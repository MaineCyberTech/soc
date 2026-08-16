# Resource Efficiency Report - 20260816-063347

## Host
               total        used        free      shared  buff/cache   available
Mem:            15Gi        10Gi       1.0Gi        23Mi       3.9Gi       4.4Gi
Swap:          8.0Gi       3.0Gi       5.0Gi

Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       148G   92G   50G  65% /
/dev/sda1       148G   92G   50G  65% /

## Docker containers (top 10 by memory)
multi-node-wazuh2.indexer-1	1.83GiB / 9.33GiB	64.70%
multi-node-wazuh3.indexer-1	1.819GiB / 9.33GiB	4.69%
multi-node-wazuh1.indexer-1	1.785GiB / 9.33GiB	4.55%
shuffle-opensearch	1.336GiB / 1.5GiB	0.65%
elastiflow	829.6MiB / 9.33GiB	0.54%
multi-node-wazuh.master-1	521.7MiB / 9.33GiB	8.42%
multi-node-wazuh.worker-1	470.5MiB / 9.33GiB	2.41%
tenzir-node	206.1MiB / 9.33GiB	8.28%
multi-node-wazuh.dashboard-1	163.5MiB / 9.33GiB	0.02%
shuffle-backend	109.9MiB / 768MiB	0.00%

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
