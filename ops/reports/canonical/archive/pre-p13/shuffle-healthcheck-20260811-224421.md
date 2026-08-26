# Shuffle Healthcheck - 20260811-224421

## Result: PASS

## Containers
shufflehealthcheck_1-1-0.1.dr52469o3tntawly2awcf9agw   Up 17 minutes
shufflehealthcheck_1-1-0.2.d17gpv3w04rthj591b6quof90   Up 17 minutes
shuffle-frontend                                       Up Less than a second
shuffle-backend                                        Up 27 hours
multi-node-wazuh.worker-1                              Up 15 hours
iriswebapp_worker                                      Up 30 hours
shuffle-opensearch                                     Up 30 hours
shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu            Up 31 hours
shuffle-ai_1-1-0.2.l9q5gqeb2e3h00s7wplgbicmh           Up 31 hours
shuffle-ai_1-1-0.1.whc24zfb3p6bh11uos7nd2gtn           Up 31 hours
shuffle-tools_1-2-0.1.i6u3ar5426cvcz0s7l5ui87fv        Up 31 hours
shuffle-tools_1-2-0.2.kzdhcpks03riy3di5frm0z0zw        Up 31 hours
shuffle-subflow_1-1-0.2.mvo2tgew5vya8scicsj47dw9k      Up 31 hours
shuffle-subflow_1-1-0.1.6mfiowuvnmnlwotzn1k4dca6l      Up 31 hours
shuffle-orborus                                        Up 31 hours

## Network membership (mct-security)
- shufflehealthcheck_1-1-0.1.dr52469o3tntawly2awcf9agw: ingress mct-security shuffle_swarm_executions 
- shufflehealthcheck_1-1-0.2.d17gpv3w04rthj591b6quof90: ingress mct-security shuffle_swarm_executions 
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
