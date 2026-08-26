# Shuffle Healthcheck - 20260811-040205

## Result: FAIL

## Containers
shufflehealthcheck_1-1-0.1.kesmi14ixxzv3xejzrioagspx   Up 35 minutes
shufflehealthcheck_1-1-0.2.bhmh400qfx75fher3dhpr768d   Up 35 minutes
shuffle-frontend                                       Up 3 seconds
shuffle-backend                                        Up 9 hours
multi-node-wazuh.worker-1                              Up 6 hours
iriswebapp_worker                                      Up 12 hours
shuffle-opensearch                                     Up 12 hours
shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu            Up 12 hours
shuffle-ai_1-1-0.2.l9q5gqeb2e3h00s7wplgbicmh           Up 12 hours
shuffle-ai_1-1-0.1.whc24zfb3p6bh11uos7nd2gtn           Up 12 hours
shuffle-tools_1-2-0.1.i6u3ar5426cvcz0s7l5ui87fv        Up 12 hours
shuffle-tools_1-2-0.2.kzdhcpks03riy3di5frm0z0zw        Up 12 hours
shuffle-subflow_1-1-0.2.mvo2tgew5vya8scicsj47dw9k      Up 12 hours
shuffle-subflow_1-1-0.1.6mfiowuvnmnlwotzn1k4dca6l      Up 12 hours
shuffle-orborus                                        Up 12 hours

## Network membership (mct-security)
- shufflehealthcheck_1-1-0.1.kesmi14ixxzv3xejzrioagspx: ingress mct-security shuffle_swarm_executions 
- shufflehealthcheck_1-1-0.2.bhmh400qfx75fher3dhpr768d: ingress mct-security shuffle_swarm_executions 
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
