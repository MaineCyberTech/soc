# Shuffle Healthcheck - 20260811-083414

## Result: PASS

## Containers
shufflehealthcheck_1-1-0.2.rn9gy32zifw1xc3acenbmrrpc   Up 7 minutes
shufflehealthcheck_1-1-0.1.kk0vldp8tzqe4fot7x9ud00iw   Up 7 minutes
shuffle-frontend                                       Up Less than a second
shuffle-backend                                        Up 13 hours
multi-node-wazuh.worker-1                              Up About an hour
iriswebapp_worker                                      Up 16 hours
shuffle-opensearch                                     Up 16 hours
shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu            Up 16 hours
shuffle-ai_1-1-0.2.l9q5gqeb2e3h00s7wplgbicmh           Up 16 hours
shuffle-ai_1-1-0.1.whc24zfb3p6bh11uos7nd2gtn           Up 16 hours
shuffle-tools_1-2-0.1.i6u3ar5426cvcz0s7l5ui87fv        Up 16 hours
shuffle-tools_1-2-0.2.kzdhcpks03riy3di5frm0z0zw        Up 16 hours
shuffle-subflow_1-1-0.2.mvo2tgew5vya8scicsj47dw9k      Up 16 hours
shuffle-subflow_1-1-0.1.6mfiowuvnmnlwotzn1k4dca6l      Up 16 hours
shuffle-orborus                                        Up 16 hours

## Network membership (mct-security)
- shufflehealthcheck_1-1-0.2.rn9gy32zifw1xc3acenbmrrpc: ingress mct-security shuffle_swarm_executions 
- shufflehealthcheck_1-1-0.1.kk0vldp8tzqe4fot7x9ud00iw: ingress mct-security shuffle_swarm_executions 
- shuffle-frontend: mct-security multi-node_default 
- shuffle-backend: mct-security 
- multi-node-wazuh.worker-1: mct-security multi-node_default 
- iriswebapp_worker: iris_backend mct-security 
- shuffle-opensearch: mct-security 
- shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu: ingress mct-security shuffle_swarm_executions 
- shuffle-ai_1-1-0.2.l9q5gqeb2e3h00s7wplgbicmh: ingress mct-security shuffle_swarm_executions 
- shuffle-ai_1-1-0.1.whc24zfb3p6bh11uos7nd2gtn: ingress mct-security shuffle_swarm_executions 
- shuffle-tools_1-2-0.1.i6u3ar5426cvcz0s7l5ui87fv: ingress mct-security shuffle_swarm_executions 
- shuffle-tools_1-2-0.2.kzdhcpks03riy3di5frm0z0zw: ingress mct-security shuffle_swarm_executions 
- shuffle-subflow_1-1-0.2.mvo2tgew5vya8scicsj47dw9k: ingress mct-security shuffle_swarm_executions 
- shuffle-subflow_1-1-0.1.6mfiowuvnmnlwotzn1k4dca6l: ingress mct-security shuffle_swarm_executions 
- shuffle-orborus: mct-security shuffle_swarm_executions tenzir-network 

## Frontend probe: HTTP 200
## DNS worker->backend: 172.20.0.5        shuffle-backend  shuffle-backend
