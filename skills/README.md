# Project Chimera: Skills — Input/Output JSON Contracts

This document defines the **Input** and **Output** JSON contracts for three critical skills used in the Planner–Worker–Judge flow. All skills MUST be invoked via the MCP layer (constitution: Universal Connectivity). Contracts align with [specs/technical.md](../specs/technical.md) and [specs/functional.md](../specs/functional.md).

---

## 1. skill_trend_fetcher

**Purpose:** Poll MCP resources (news, social, market) and optionally run a relevance filter so the Planner receives only high-signal trend or content events.

**Traceability:** FR-PERCEPTION-001, FR-PERCEPTION-002, FR-PERCEPTION-003; Agent story "fetch trends" and "filter content for relevance."

### Input

```json
{
  "agent_id": "string",
  "campaign_id": "string",
  "resource_uris": [
    "news://{region}/{category}/latest",
    "twitter://mentions/recent",
    "market://crypto/{asset}/price"
  ],
  "goal_context": "string",
  "relevance_threshold": 0.75,
  "options": {
    "include_raw": false,
    "time_window_hours": 4
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent_id` | string | Yes | Chimera agent identifier. |
| `campaign_id` | string | Yes | Campaign this fetch is for. |
| `resource_uris` | string[] | Yes | MCP resource URIs to poll. |
| `goal_context` | string | Yes | Current goal summary for relevance scoring. |
| `relevance_threshold` | number | No | Min score (0–1) to include; default 0.75. |
| `options.include_raw` | boolean | No | If true, include raw snippets in output. |
| `options.time_window_hours` | number | No | Window for trend aggregation; default 4. |

### Output (success)

```json
{
  "success": true,
  "request_id": "uuid-v4",
  "fetched_at": "ISO8601",
  "trend_alert": {
    "event_id": "uuid-v4",
    "event_type": "trend_alert",
    "source": "skill_trend_fetcher",
    "agent_id": "string",
    "campaign_id": "string",
    "trend": {
      "topics": ["string"],
      "cluster_id": "string",
      "time_window_start": "ISO8601",
      "time_window_end": "ISO8601",
      "signal_strength": 0.0,
      "sample_resource_uris": ["string"]
    }
  },
  "filter_results": [
    {
      "filter_result_id": "uuid-v4",
      "resource_uri": "string",
      "content_summary": "string",
      "relevance_score": 0.0,
      "above_threshold": true
    }
  ]
}
```

### Output (error)

```json
{
  "success": false,
  "request_id": "uuid-v4",
  "error_code": "string",
  "message": "string",
  "details": {}
}
```

---

## 2. skill_content_generator

**Purpose:** Generate a single content artifact (text, image, or video) for a given task, using persona (SOUL.md) and hierarchical memory so output is on-brand and context-aware.

**Traceability:** FR-ACTION-002, FR-COGNITION-001, FR-COGNITION-002; Worker "generate content"; Agent story "generate content."

### Input

```json
{
  "task_id": "uuid-v4",
  "agent_id": "string",
  "task_type": "generate_content | reply_comment",
  "context": {
    "goal_description": "string",
    "persona_constraints": ["string"],
    "required_resources": ["mcp://..."],
    "campaign_id": "string"
  },
  "acceptance_criteria": {
    "content_type": "text | image | video",
    "platform": "string",
    "min_confidence": 0.0
  },
  "memory_context": {
    "soul_summary": "string",
    "short_term_refs": ["string"],
    "long_term_refs": ["string"]
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `task_id` | string | Yes | Task identifier from Planner. |
| `agent_id` | string | Yes | Agent producing the content. |
| `task_type` | string | Yes | `generate_content` or `reply_comment`. |
| `context.goal_description` | string | Yes | High-level goal for this task. |
| `context.persona_constraints` | string[] | Yes | SOUL-derived constraints. |
| `context.required_resources` | string[] | No | MCP resources to read before generating. |
| `acceptance_criteria.content_type` | string | Yes | `text`, `image`, or `video`. |
| `acceptance_criteria.platform` | string | No | Target platform (e.g. twitter, instagram). |
| `acceptance_criteria.min_confidence` | number | No | Minimum confidence for self-score. |
| `memory_context` | object | No | Injected SOUL/short-term/long-term refs. |

### Output (success)

```json
{
  "success": true,
  "result_id": "uuid-v4",
  "task_id": "uuid-v4",
  "agent_id": "string",
  "created_at": "ISO8601",
  "artifact": {
    "content_type": "text | image | video",
    "payload_text": "string",
    "payload_media_uri": "string",
    "platform_target": "string"
  },
  "confidence_score": 0.0,
  "reasoning_trace": "string"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `artifact.payload_text` | string | Caption, script, or reply text. |
| `artifact.payload_media_uri` | string | URI for image/video asset (if any). |
| `confidence_score` | number | 0–1; used by Judge for approve/reject/escalate. |
| `reasoning_trace` | string | Brief rationale for Judge audit. |

### Output (error)

```json
{
  "success": false,
  "result_id": "uuid-v4",
  "task_id": "uuid-v4",
  "error_code": "string",
  "message": "string",
  "details": {}
}
```

---

## 3. skill_wallet_transaction

**Purpose:** Execute a single on-chain transaction (e.g. transfer, balance check) using the agent’s non-custodial wallet (Coinbase AgentKit). Subject to CFO Judge and budget governance.

**Traceability:** Constitution (Economic Agency); FR-ACTION-002 for execute_transaction tasks; SRS Agentic Commerce (non-custodial wallet, native_transfer, get_balance).

### Input

```json
{
  "task_id": "uuid-v4",
  "agent_id": "string",
  "operation": "get_balance | native_transfer | token_transfer",
  "params": {
    "asset": "ETH | USDC | string",
    "to_address": "string",
    "amount_wei_or_units": "string",
    "chain_id": "string"
  },
  "budget_check": {
    "daily_spend_key": "string",
    "max_daily_limit_units": "string"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `task_id` | string | Yes | Task identifier from Planner. |
| `agent_id` | string | Yes | Agent whose wallet is used. |
| `operation` | string | Yes | `get_balance`, `native_transfer`, or `token_transfer`. |
| `params.asset` | string | Yes | Asset symbol (e.g. ETH, USDC). |
| `params.to_address` | string | For transfer | Recipient address. |
| `params.amount_wei_or_units` | string | For transfer | Amount in wei (ETH) or token units (USDC). |
| `params.chain_id` | string | No | Chain ID; default Base. |
| `budget_check` | object | No | Keys for budget enforcement (e.g. Redis daily_spend). |

### Output (success)

```json
{
  "success": true,
  "transaction_id": "uuid-v4",
  "task_id": "uuid-v4",
  "agent_id": "string",
  "operation": "get_balance | native_transfer | token_transfer",
  "result": {
    "balance_wei_or_units": "string",
    "tx_hash": "string",
    "block_number": "string",
    "executed_at": "ISO8601"
  }
}
```

- For `get_balance`: `result` contains `balance_wei_or_units` (and optionally `balance_formatted`). `tx_hash` and `block_number` are omitted.
- For transfers: `result` contains `tx_hash`, `block_number`, `executed_at`; optional `balance_wei_or_units` for new balance.

### Output (error)

```json
{
  "success": false,
  "transaction_id": "uuid-v4",
  "task_id": "uuid-v4",
  "error_code": "budget_exceeded | insufficient_balance | invalid_address | rpc_error",
  "message": "string",
  "details": {}
}
```

---

## Summary

| Skill | Primary consumer | Output consumed by |
|-------|------------------|--------------------|
| skill_trend_fetcher | Planner (perception) | Planner → Agent Task creation |
| skill_content_generator | Worker | Judge (Worker Result) |
| skill_wallet_transaction | Worker (CFO Judge approved) | GlobalState / ledger |

All three skills MUST be exposed via MCP Tools; no direct out-of-process calls. Implementations must enforce the constitution (Fractal Orchestration, Universal Connectivity, Economic Agency).
