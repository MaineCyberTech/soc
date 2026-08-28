WORKFLOW_HASH: 5f9ee8b5a5ec08c20849d0e67d767349d3cf1513e3394209a317a1585ec96cc4
{
  "workflow_as_code": false,
  "actions": [
    {
      "app_name": "Shuffle Tools",
      "app_version": "1.2.0",
      "description": "",
      "app_id": "105a94f1-725a-4cab-b085-520b4eec1f86",
      "errors": [],
      "id": "722fb255-4e6a-4d73-87f9-19c05fab1ca2",
      "is_valid": true,
      "isStartNode": true,
      "sharing": true,
      "label": "parse-eve-json",
      "public": true,
      "generated": false,
      "environment": "Shuffle",
      "name": "execute_python",
      "parameters": [
        {
          "description": "",
          "id": "",
          "name": "call",
          "example": "",
          "value": "execute_python",
          "multiline": false,
          "multiselect": false,
          "options": null,
          "action_field": "",
          "variant": "STATIC_VALUE",
          "required": false,
          "configuration": false,
          "tags": null,
          "schema": {
            "type": ""
          },
          "skip_multicheck": false,
          "custom_value": false,
          "value_replace": null,
          "unique_toggled": false,
          "error": "",
          "hidden": false
        },
        {
          "description": "",
          "id": "",
          "name": "code",
          "example": "",
          "value": "import json\nimport requests\n\n# Get execution input from full_execution\nexec_arg = self.full_execution.get('execution_argument', '{}')\ninput_data = json.loads(exec_arg)\nwebhook_data = json.loads(input_data.get('data', '{}'))\nalert = webhook_data.get('alert', {})\n\nsid = alert.get('signature_id')\nsrc = alert.get('src_ip')\ndst = alert.get('dest_ip')\nport = alert.get('dest_port')\nproto = alert.get('proto')\nsynthetic = webhook_data.get('MCT_SYNTHETIC', False)\ntimestamp = webhook_data.get('timestamp')\n\nprint(f'Parsed: sid={sid}, src={src}, dst={dst}, port={port}, proto={proto}, synthetic={synthetic}')\n\n# 1. Validate required fields\nif sid is None:\n    print('DEADLETTER-malformed: missing required fields')\n    result = {'status': 'malformed', 'sid': sid}\nelse:\n    # 2. Synthetic isolation check\n    if synthetic:\n        print(f'SINK-synthetic-logonly: SYNTHETIC sid={sid}')\n        result = {'status': 'synthetic', 'sid': sid}\n    else:\n        # 3. SID allowlist filter (only allow 2027967)\n        if sid != 2027967:\n            print(f'DEADLETTER-malformed: SID {sid} not in allowlist')\n            result = {'status': 'not_allowed', 'sid': sid}\n        else:\n            # 4. Dedup check\n            dedup_key = f'p44_dedup_{sid}_{src}_{dst}_{port}'\n            try:\n                dedup_result = self.check_cache_contains(key=dedup_key, value='1', append=False, category='p44_dedup')\n                if dedup_result.get('success', False):\n                    print(f'duplicate-suppressed-logonly: Duplicate suppressed sid={sid}')\n                    result = {'status': 'duplicate', 'sid': sid}\n                else:\n                    # 5. New event - increment counter and route to IRIS\n                    self.set_cache_value(key='p44_packet_routed', value='1', category='p44_counters')\n                    print(f'counter-routed-increment: incremented')\n                    \n                    # Route to IRIS\n                    iris_body = {\n                        'alert_title': 'P44 Packet Routing Test',\n                        'alert_source': 'suricata',\n                        'alert_source_ref': str(sid),\n                        'alert_severity_id': 6,\n                        'alert_customer_id': 1,\n                        'alert_status_id': 2,\n                        'alert_source_content': {\n                            'sid': sid,\n                            'src': src,\n                            'dst': dst,\n                            'port': port,\n                            'proto': proto\n                        },\n                        'alert_tags': 'source:suricata,class:A,test:true'\n                    }\n                    try:\n                        iris_response = requests.post(\n                            'https://iriswebapp_nginx:8443/alerts/add',\n                            json=iris_body,\n                            headers={'Authorization': 'Bearer [REDACTED-IRIS-TOKEN]', 'Content-Type': 'application/json'},\n                            verify=False,\n                            timeout=10\n                        )\n                        if iris_response.status_code == 200 or iris_response.status_code == 201:\n                            print(f'done-routed-log: Routed to IRIS sid={sid}')\n                            result = {'status': 'routed', 'sid': sid}\n                        else:\n                            print(f'DEADLETTER-target-fail: IRIS delivery failed sid={sid}, status={iris_response.status_code}')\n                            result = {'status': 'target_fail', 'sid': sid}\n                    except Exception as e:\n                        print(f'DEADLETTER-target-fail: IRIS delivery error sid={sid}, error={e}')\n                        result = {'status': 'target_fail', 'sid': sid}\n            except Exception as e:\n                print(f'DEADLETTER-target-fail: dedup check error sid={sid}, error={e}')\n                result = {'status': 'error', 'sid': sid}\n\nprint(json.dumps(result))",
          "multiline": false,
          "multiselect": false,
          "options": null,
          "action_field": "",
          "variant": "STATIC_VALUE",
          "required": false,
          "configuration": false,
          "tags": null,
          "schema": {
            "type": ""
          },
          "skip_multicheck": false,
          "custom_value": false,
          "value_replace": null,
          "unique_toggled": false,
          "error": "",
          "hidden": false
        }
      ],
      "execution_variable": {
        "description": "",
        "id": "",
        "name": "",
        "value": ""
      },
      "position": {
        "x": 100.001,
        "y": 100.001
      },
      "authentication_id": "",
      "category": "",
      "reference_url": "",
      "sub_action": false,
      "run_magic_output": false,
      "run_magic_input": false,
      "execution_delay": 0,
      "category_label": null,
      "suggestion": false,
      "parent_controlled": false,
      "source_workflow": "",
      "source_execution": ""
    }
  ],
  "branches": [
    {
      "destination_id": "722fb255-4e6a-4d73-87f9-19c05fab1ca2",
      "id": "b2dc393e-7c1e-4a87-a89c-6922e867ed61",
      "source_id": "736b7410-ed6a-52af-b369-89dbef6386cb",
      "label": "",
      "has_errors": false,
      "conditions": [],
      "decorator": false,
      "parent_controlled": false,
      "source_parent": ""
    }
  ],
  "visual_branches": null,
  "triggers": [
    {
      "app_name": "",
      "description": "Test-only webhook; NOT bound to Wazuh integration until ROUT-39-02 pass",
      "long_description": "",
      "status": "stopped",
      "app_version": "",
      "errors": null,
      "id": "736b7410-ed6a-52af-b369-89dbef6386cb",
      "is_valid": true,
      "isStartNode": true,
      "label": "suricata-eve-in",
      "small_image": "",
      "large_image": "",
      "environment": "",
      "trigger_type": "WEBHOOK",
      "name": "suricata-eve-in",
      "tags": null,
      "parameters": [
        {
          "description": "",
          "id": "",
          "name": "custom_url",
          "example": "",
          "value": "p39-suricata-test",
          "multiline": false,
          "multiselect": false,
          "options": null,
          "action_field": "",
          "variant": "",
          "required": false,
          "configuration": false,
          "tags": null,
          "schema": {
            "type": ""
          },
          "skip_multicheck": false,
          "custom_value": false,
          "value_replace": null,
          "unique_toggled": false,
          "error": "",
          "hidden": false
        }
      ],
      "position": {
        "x": 0,
        "y": 0
      },
      "priority": 0,
      "source_workflow": "",
      "execution_delay": 0,
      "app_association": {
        "name": "",
        "app_version": "",
        "id": "",
        "link": "",
        "is_valid": false,
        "generated": false,
        "downloaded": false,
        "sharing": false,
        "verified": false,
        "invalid": false,
        "activated": false,
        "tested": false,
        "hash": "",
        "private_id": "",
        "environment": "",
        "small_image": "",
        "large_image": "",
        "contact_info": {
          "name": "",
          "url": ""
        },
        "folder_mount": {
          "folder_mount": false,
          "source_folder": "",
          "destination_folder": ""
        },
        "authentication": {
          "type": "",
          "required": false,
          "parameters": null,
          "redirect_uri": "",
          "token_uri": "",
          "refresh_uri": "",
          "scope": null,
          "client_id": "",
          "client_secret": "",
          "grant_type": ""
        },
        "actions": null,
        "tags": null,
        "categories": null,
        "created": 0,
        "edited": 0,
        "last_runtime": 0,
        "versions": null,
        "loop_versions": null,
        "owner": "",
        "sharing_config": "",
        "public": false,
        "published_id": "",
        "child_ids": null,
        "reference_org": "",
        "reference_url": "",
        "action_file_path": "",
        "template": false,
        "documentation": "",
        "description": "",
        "documentation_download_url": "",
        "primary_usecases": null,
        "skipped_build": false,
        "reference_info": {
          "onprem_backup": false,
          "is_partner": false,
          "partner_contacts": "",
          "documentation_url": "",
          "github_url": "",
          "triggers": null
        },
        "blogpost": "",
        "video": "",
        "company_url": "",
        "contributors": null,
        "revision_id": "",
        "collection": ""
      },
      "parent_controlled": false,
      "replacement_for_trigger": ""
    }
  ],
  "comments": [],
  "configuration": {
    "exit_on_error": false,
    "start_from_top": false,
    "skip_notifications": false
  },
  "created": 1787717303,
  "edited": 1787800354,
  "last_runtime": 0,
  "due_date": 0,
  "errors": [
    "Trigger suricata-eve-in needs to be started"
  ],
  "id": "e133a645-95b9-4e01-9454-e270d2a0b599",
  "is_valid": true,
  "name": "suricata-packet-routing",
  "description": "Isolated Suricata packet routing (WF-39-02 import candidate - test-only, disabled by default). Dedup TTL 300s; SID allowlist 2027967 first; synthetic-tag sink; dead-letter on malformed/target-fail.",
  "start": "722fb255-4e6a-4d73-87f9-19c05fab1ca2",
  "owner": "39dd09d3-7874-46a0-8672-e7acb8827b2c",
  "sharing": "private",
  "execution_org": {
    "name": "default",
    "id": "264c0502-9136-4cfc-938b-390b97b861b8",
    "users": [],
    "role": "admin",
    "child_orgs": null,
    "region_url": "",
    "is_partner": false,
    "image": "",
    "creator_org": "",
    "branding": {
      "enable_chat": false,
      "home_url": "",
      "theme": "",
      "documentation_link": "",
      "global_user": false,
      "support_email": "",
      "logout_url": "",
      "brand_color": "",
      "brand_name": ""
    }
  },
  "org_id": "264c0502-9136-4cfc-938b-390b97b861b8",
  "workflow_variables": null,
  "execution_environment": "",
  "previously_saved": true,
  "categories": {
    "siem": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "communication": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "assets": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "cases": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "network": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "intel": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "edr": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "iam": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "ai": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "email": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    },
    "other": {
      "name": "",
      "count": 0,
      "id": "",
      "description": "",
      "large_image": ""
    }
  },
  "example_argument": "",
  "public": false,
  "default_return_value": "",
  "contact_info": {
    "name": "",
    "url": ""
  },
  "published_id": "",
  "revision_id": "",
  "usecase_ids": null,
  "input_questions": null,
  "form_control": {
    "input_markdown": "",
    "output_yields": null,
    "cleanup_actions": null,
    "form_width": 0
  },
  "blogpost": "",
  "video": "",
  "status": "test",
  "workflow_type": "",
  "generated": false,
  "hidden": false,
  "background_processing": false,
  "updated_by": "soc@mainecybertech.com",
  "validated": false,
  "validation": {
    "valid": true,
    "changed_at": 1787800398000,
    "last_valid": 1787800398000,
    "validation_ran": true,
    "notifications_created": 0,
    "environment": "Shuffle",
    "workflow_id": "",
    "execution_id": "3b21018a-a2f6-4cb4-a1d5-28a151d8270b",
    "node_id": "",
    "total_problems": 0,
    "errors": [],
    "subflow_apps": []
  },
  "parentorg_workflow": "",
  "childorg_workflow_ids": null,
  "suborg_distribution": [],
  "backup_config": {
    "onprem_backup": false,
    "upload_repo": "",
    "upload_branch": "",
    "upload_username": "",
    "upload_token": "",
    "tokens_encrypted": false
  },
  "auth_groups": null
}
