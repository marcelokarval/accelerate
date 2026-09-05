# Candidate-Attributed MCP Stdio Protocol Smoke Receipt

**Timestamp:** 2026-09-04T14:02:40-04:00
**Commit:** `26488c53ec9852ae8d02adfecaf86694f50e3c8c`

## Identity & Paths
- **Candidate Release:** `/home/marcelo-karval/.local/share/plane-mcp-karval/releases/26488c53ec9852ae8d02adfecaf86694f50e3c8c/apps/mcp-servers/plane-mcp-karval`
- **Candidate Venv:** `/home/marcelo-karval/.local/share/plane-mcp-karval/venvs/26488c53ec9852ae8d02adfecaf86694f50e3c8c`
- **Launcher Before SHA256:** `57a61692b7beb0e5c9d3b9dad7b4a13d8ca027331a73eb8a3aa4c10a729ffc0c`

## Stdio JSON-RPC Execution
**Process PID:** `1801498`

### Initialize Sequence
**Request:**
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {},
    "clientInfo": {
      "name": "smoke-test",
      "version": "1.0.0"
    }
  }
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "experimental": {},
      "prompts": {
        "listChanged": false
      },
      "resources": {
        "subscribe": false,
        "listChanged": false
      },
      "tools": {
        "listChanged": true
      },
      "tasks": {
        "list": {},
        "cancel": {},
        "requests": {
          "tools": {
            "call": {}
          },
          "prompts": {
            "get": {}
          },
          "resources": {
            "read": {}
          }
        }
      }
    },
    "serverInfo": {
      "name": "plane-mcp-karval",
      "version": "1.0.0"
    },
    "instructions": "Use plane_catalog to discover the full Plane registry. Use plane_read_action for registered GET actions. Use plane_action_descriptor before any mutation and plane_mutation_action only after one explicit operation/target approval."
  }
}
```

### Tools/List Sequence
**Request:**
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list",
  "params": {}
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "tools": [
      {
        "name": "plane_catalog",
        "description": "List the bounded full Plane operation catalog.",
        "inputSchema": {
          "properties": {
            "query": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "surface": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "method": {
              "anyOf": [
                {
                  "enum": [
                    "GET",
                    "POST",
                    "PATCH",
                    "DELETE"
                  ],
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "mode": {
              "anyOf": [
                {
                  "enum": [
                    "read",
                    "descriptor"
                  ],
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "mutation": {
              "anyOf": [
                {
                  "type": "boolean"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "group": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "limit": {
              "default": 50,
              "type": "integer"
            },
            "cursor": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": false
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_action_descriptor",
        "description": "Describe a registered Plane action without calling the provider.",
        "inputSchema": {
          "properties": {
            "operation": {
              "type": "string"
            },
            "path_params": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "query": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "payload": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "idempotency_key": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "operation"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": false
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_read_action",
        "description": "Execute any registered read-only Plane GET action.",
        "inputSchema": {
          "properties": {
            "operation": {
              "type": "string"
            },
            "path_params": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "query": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "operation"
          ],
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_capture_state_catalog",
        "description": "Read a candidate state catalog; this never writes or promotes a registry.",
        "inputSchema": {
          "properties": {
            "workspace_slug": {
              "type": "string"
            },
            "project_id": {
              "type": "string"
            }
          },
          "required": [
            "workspace_slug",
            "project_id"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_validate_work_item_contract",
        "description": "Validate a governed Plane lifecycle artifact without provider calls.",
        "inputSchema": {
          "properties": {
            "document": {
              "additionalProperties": true,
              "type": "object"
            }
          },
          "required": [
            "document"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": false
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_render_lifecycle_comment",
        "description": "Render a complete START/PROGRESS/BLOCKED/REVIEW/FINISH comment.",
        "inputSchema": {
          "properties": {
            "comment": {
              "additionalProperties": true,
              "type": "object"
            },
            "output_format": {
              "default": "html",
              "enum": [
                "html",
                "markdown"
              ],
              "type": "string"
            }
          },
          "required": [
            "comment"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": false
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_add_lifecycle_comment",
        "description": "Legacy entrypoint retained only to fail closed for v2 lifecycle work.",
        "inputSchema": {
          "properties": {
            "project_id": {
              "type": "string"
            },
            "work_item_id": {
              "type": "string"
            },
            "comment": {
              "additionalProperties": true,
              "type": "object"
            },
            "approved_live_mutation": {
              "type": "boolean"
            },
            "authorization_scope": {
              "type": "string"
            },
            "authorized_workspace_slug": {
              "type": "string"
            },
            "authorized_project_id": {
              "type": "string"
            },
            "authorized_work_item_id": {
              "type": "string"
            },
            "authorization_receipt": {
              "additionalProperties": true,
              "type": "object"
            },
            "idempotency_key": {
              "type": "string"
            },
            "attempts": {
              "default": 1,
              "type": "integer"
            },
            "workspace_slug": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "project_id",
            "work_item_id",
            "comment",
            "approved_live_mutation",
            "authorization_scope",
            "authorized_workspace_slug",
            "authorized_project_id",
            "authorized_work_item_id",
            "authorization_receipt",
            "idempotency_key"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": false,
          "destructiveHint": false,
          "idempotentHint": false,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_operator_lifecycle_transition",
        "description": "Run one explicitly authorized non-atomic state/comment transition.\n\nPlane exposes no conditional state/version update. This tool therefore\nremains operator-gated, performs fresh before/after readbacks, never\nrolls state back automatically, and reports partial writes for manual\nreconciliation instead of pretending transactional atomicity.",
        "inputSchema": {
          "properties": {
            "workspace_slug": {
              "type": "string"
            },
            "project_id": {
              "type": "string"
            },
            "work_item_id": {
              "type": "string"
            },
            "expected_current_state_id": {
              "type": "string"
            },
            "expected_updated_at": {
              "type": "string"
            },
            "target_state_id": {
              "type": "string"
            },
            "comment": {
              "additionalProperties": true,
              "type": "object"
            },
            "approved_live_mutation": {
              "type": "boolean"
            },
            "approved_non_atomic_operator_transition": {
              "type": "boolean"
            },
            "authorization_basis": {
              "type": "string"
            },
            "authorized_workspace_slug": {
              "type": "string"
            },
            "authorized_project_id": {
              "type": "string"
            },
            "authorized_work_item_id": {
              "type": "string"
            },
            "idempotency_key": {
              "type": "string"
            },
            "attempts": {
              "default": 1,
              "type": "integer"
            },
            "review_comment": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "workspace_slug",
            "project_id",
            "work_item_id",
            "expected_current_state_id",
            "expected_updated_at",
            "target_state_id",
            "comment",
            "approved_live_mutation",
            "approved_non_atomic_operator_transition",
            "authorization_basis",
            "authorized_workspace_slug",
            "authorized_project_id",
            "authorized_work_item_id",
            "idempotency_key"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": false,
          "destructiveHint": true,
          "idempotentHint": false,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_reconcile_lifecycle_comment",
        "description": "Recover only a verified state PATCH whose lifecycle comment is pending.\n\nThis is intentionally narrower than a mutation action: it has no state\npayload and never calls the PATCH path.  A fresh exact authorization is\nneeded because a prior comment attempt may have had an ambiguous result.",
        "inputSchema": {
          "properties": {
            "workspace_slug": {
              "type": "string"
            },
            "project_id": {
              "type": "string"
            },
            "work_item_id": {
              "type": "string"
            },
            "target_state_id": {
              "type": "string"
            },
            "comment": {
              "additionalProperties": true,
              "type": "object"
            },
            "approved_live_mutation": {
              "type": "boolean"
            },
            "authorization_scope": {
              "type": "string"
            },
            "authorized_workspace_slug": {
              "type": "string"
            },
            "authorized_project_id": {
              "type": "string"
            },
            "authorized_work_item_id": {
              "type": "string"
            },
            "authorization_receipt": {
              "additionalProperties": true,
              "type": "object"
            },
            "idempotency_key": {
              "type": "string"
            },
            "attempts": {
              "default": 1,
              "type": "integer"
            },
            "receipt_fingerprint": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "recovery_receipt": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "prepare_recovery": {
              "default": false,
              "type": "boolean"
            }
          },
          "required": [
            "workspace_slug",
            "project_id",
            "work_item_id",
            "target_state_id",
            "comment",
            "approved_live_mutation",
            "authorization_scope",
            "authorized_workspace_slug",
            "authorized_project_id",
            "authorized_work_item_id",
            "authorization_receipt",
            "idempotency_key"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": false,
          "destructiveHint": false,
          "idempotentHint": false,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_validate_title_contract",
        "description": "Validate canonical Plane title/icon semantics without provider calls.",
        "inputSchema": {
          "properties": {
            "title": {
              "type": "string"
            },
            "labels": {
              "items": {
                "type": "string"
              },
              "type": "array"
            },
            "title_context": {
              "type": "string"
            },
            "qualifier": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "frozen_snapshot": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "title",
            "labels",
            "title_context"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": false
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_normalize_title",
        "description": "Normalize a proposed Plane title according to the semantic icon contract.",
        "inputSchema": {
          "properties": {
            "title": {
              "type": "string"
            },
            "labels": {
              "items": {
                "type": "string"
              },
              "type": "array"
            },
            "title_context": {
              "type": "string"
            },
            "qualifier": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "title",
            "labels",
            "title_context"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": false
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_prepare_issue_creation",
        "description": "Validate readiness and optionally build a non-executable mutation draft.\n\nThis read-only tool binds the exact readiness, payload, target, provider,\nand idempotency hashes.  It deliberately does not issue authorization:\nthe returned draft remains blocked until a governed authority supplies a\nseparate receipt and explicit live-mutation approval.",
        "inputSchema": {
          "properties": {
            "payload": {
              "additionalProperties": true,
              "type": "object"
            },
            "issue_readiness": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ]
            },
            "path_params": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "idempotency_key": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "payload",
            "issue_readiness"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": false
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_mutation_action",
        "description": "Execute any registered Plane mutation with strict approval and readback.",
        "inputSchema": {
          "properties": {
            "operation": {
              "type": "string"
            },
            "path_params": {
              "additionalProperties": true,
              "type": "object"
            },
            "payload": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ]
            },
            "approved_live_mutation": {
              "type": "boolean"
            },
            "authorization_receipt": {
              "additionalProperties": true,
              "type": "object"
            },
            "idempotency_key": {
              "type": "string"
            },
            "attempts": {
              "default": 1,
              "type": "integer"
            },
            "query": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "issue_readiness": {
              "anyOf": [
                {
                  "additionalProperties": true,
                  "type": "object"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "preparation_token": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "operation",
            "path_params",
            "payload",
            "approved_live_mutation",
            "authorization_receipt",
            "idempotency_key"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": false,
          "destructiveHint": true,
          "idempotentHint": false,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_reconcile_legacy_archive",
        "description": "Append read-only provider evidence for one exact legacy archive attempt.",
        "inputSchema": {
          "properties": {
            "workspace_slug": {
              "type": "string"
            },
            "project_id": {
              "type": "string"
            },
            "resource_id": {
              "type": "string"
            },
            "key_hash": {
              "type": "string"
            },
            "approved_live_reconciliation": {
              "type": "boolean"
            },
            "authorization_receipt": {
              "additionalProperties": true,
              "type": "object"
            },
            "attempts": {
              "type": "integer"
            }
          },
          "required": [
            "workspace_slug",
            "project_id",
            "resource_id",
            "key_hash",
            "approved_live_reconciliation",
            "authorization_receipt",
            "attempts"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": false,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "plane_reconcile_module_update_attempt",
        "description": "Append exact provider readback for one applied module update receipt.",
        "inputSchema": {
          "properties": {
            "workspace_slug": {
              "type": "string"
            },
            "project_id": {
              "type": "string"
            },
            "resource_id": {
              "type": "string"
            },
            "key_hash": {
              "type": "string"
            },
            "expected_payload": {
              "additionalProperties": true,
              "type": "object"
            },
            "approved_live_reconciliation": {
              "type": "boolean"
            },
            "authorization_receipt": {
              "additionalProperties": true,
              "type": "object"
            },
            "attempts": {
              "type": "integer"
            }
          },
          "required": [
            "workspace_slug",
            "project_id",
            "resource_id",
            "key_hash",
            "expected_payload",
            "approved_live_reconciliation",
            "authorization_receipt",
            "attempts"
          ],
          "type": "object"
        },
        "outputSchema": {
          "additionalProperties": true,
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": false,
          "destructiveHint": false,
          "idempotentHint": false,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "get_current_user",
        "description": "Return the current Plane user.",
        "inputSchema": {
          "properties": {},
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "list_projects",
        "description": "List projects through the documented /projects endpoint.",
        "inputSchema": {
          "properties": {
            "workspace_slug": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "cursor": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "per_page": {
              "anyOf": [
                {
                  "type": "integer"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "order_by": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "list_work_items",
        "description": "List work items in one Plane project.",
        "inputSchema": {
          "properties": {
            "project_id": {
              "type": "string"
            },
            "workspace_slug": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "cursor": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "per_page": {
              "anyOf": [
                {
                  "type": "integer"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "order_by": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "state": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "assignees": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "project_id"
          ],
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "get_work_item",
        "description": "Get one Plane work item and include its direct web URL.",
        "inputSchema": {
          "properties": {
            "project_id": {
              "type": "string"
            },
            "work_item_id": {
              "type": "string"
            },
            "workspace_slug": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "project_id",
            "work_item_id"
          ],
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      },
      {
        "name": "search_work_items",
        "description": "Search Plane work items in the workspace.",
        "inputSchema": {
          "properties": {
            "search": {
              "type": "string"
            },
            "workspace_slug": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "cursor": {
              "anyOf": [
                {
                  "type": "string"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            },
            "per_page": {
              "anyOf": [
                {
                  "type": "integer"
                },
                {
                  "type": "null"
                }
              ],
              "default": null
            }
          },
          "required": [
            "search"
          ],
          "type": "object"
        },
        "annotations": {
          "readOnlyHint": true,
          "destructiveHint": false,
          "idempotentHint": true,
          "openWorldHint": true
        },
        "_meta": {
          "_fastmcp": {
            "tags": []
          }
        }
      }
    ]
  }
}
```

### Clean Exit
Process terminated cleanly. Exit code: -15

### Residual Process Check
Verified no residual process exists for PID 1801498.

## Post-Flight Check
- **Launcher After SHA256:** `57a61692b7beb0e5c9d3b9dad7b4a13d8ca027331a73eb8a3aa4c10a729ffc0c`
- **Launcher Integrity:** UNCHANGED
