# Shuffle Healthcheck - 20260815-021530

## Result: PASS

## Containers
shufflehealthcheck_1-1-0.2.83z9myxqnqd8ffqdfxh7cpakt   Up 48 minutes
shufflehealthcheck_1-1-0.1.c95az01dxvfhtrzlil5mpcf72   Up 48 minutes
shuffle-frontend                                       Up 28 seconds
shuffle-backend                                        Up 4 days
multi-node-wazuh.worker-1                              Up 3 days
iriswebapp_worker                                      Up 4 days
shuffle-opensearch                                     Up 4 days
shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu            Up 4 days
shuffle-ai_1-1-0.2.l9q5gqeb2e3h00s7wplgbicmh           Up 4 days
shuffle-ai_1-1-0.1.whc24zfb3p6bh11uos7nd2gtn           Up 4 days
shuffle-tools_1-2-0.1.i6u3ar5426cvcz0s7l5ui87fv        Up 4 days
shuffle-tools_1-2-0.2.kzdhcpks03riy3di5frm0z0zw        Up 4 days
shuffle-subflow_1-1-0.2.mvo2tgew5vya8scicsj47dw9k      Up 4 days
shuffle-subflow_1-1-0.1.6mfiowuvnmnlwotzn1k4dca6l      Up 4 days
shuffle-orborus                                        Up 4 days

## Network membership (mct-security)
- shufflehealthcheck_1-1-0.2.83z9myxqnqd8ffqdfxh7cpakt: ingress mct-security shuffle_swarm_executions 
- shufflehealthcheck_1-1-0.1.c95az01dxvfhtrzlil5mpcf72: ingress mct-security shuffle_swarm_executions 
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
