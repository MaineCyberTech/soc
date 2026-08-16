# Resource Trend - 20260811-070615

## Host
```
               total        used        free      shared  buff/cache   available
Mem:           9.3Gi       8.4Gi       216Mi       8.8Mi       1.2Gi       977Mi
Swap:          8.0Gi       4.4Gi       3.6Gi

/dev/sda1        99G   73G   22G  77% /

 07:06:15 up 2 days, 25 min,  4 users,  load average: 1.84, 0.94, 0.86
```

## Top container memory (docker stats, one-shot)
```
wazuh-cloudflared                                      31.75MiB / 11.64GiB   0.27%     0.16%
tenzir-node                                            251.6MiB / 11.64GiB   2.11%     5.03%
shufflehealthcheck_1-1-0.2.xniyr9kh21jv8xy8f3ma23i60   7.836MiB / 11.64GiB   0.07%     0.00%
shufflehealthcheck_1-1-0.1.3sqtj8aqnyhcxxzvfm2ihk7t6   2.105MiB / 11.64GiB   0.02%     0.01%
shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu            17.39MiB / 11.64GiB   0.15%     0.00%
shuffle-tools_1-2-0.2.kzdhcpks03riy3di5frm0z0zw        13.41MiB / 11.64GiB   0.11%     0.01%
shuffle-tools_1-2-0.1.i6u3ar5426cvcz0s7l5ui87fv        15.62MiB / 11.64GiB   0.13%     0.01%
shuffle-subflow_1-1-0.2.mvo2tgew5vya8scicsj47dw9k      1.293MiB / 11.64GiB   0.01%     0.02%
shuffle-subflow_1-1-0.1.6mfiowuvnmnlwotzn1k4dca6l      8.418MiB / 11.64GiB   0.07%     0.00%
shuffle-orborus                                        13.49MiB / 384MiB     3.51%     0.00%
shuffle-opensearch                                     1.172GiB / 1.5GiB     78.11%    4.01%
shuffle-frontend                                       4.922MiB / 256MiB     1.92%     0.00%
shuffle-backend                                        52.13MiB / 768MiB     6.79%     5.14%
shuffle-ai_1-1-0.2.l9q5gqeb2e3h00s7wplgbicmh           1.223MiB / 11.64GiB   0.01%     0.01%
shuffle-ai_1-1-0.1.whc24zfb3p6bh11uos7nd2gtn           1.293MiB / 11.64GiB   0.01%     0.01%
security-onion                                         8.887MiB / 11.64GiB   0.07%     0.62%
portainer                                              34.05MiB / 11.64GiB   0.29%     0.00%
multi-node-wazuh3.indexer-1                            1.25GiB / 11.64GiB    10.74%    1.09%
multi-node-wazuh2.indexer-1                            1.203GiB / 11.64GiB   10.33%    1.23%
multi-node-wazuh1.indexer-1                            1.338GiB / 11.64GiB   11.49%    1.40%
```

## Swap pressure
```
SwapCached:        65684 kB
SwapTotal:       8388604 kB
SwapFree:        3827752 kB
```
