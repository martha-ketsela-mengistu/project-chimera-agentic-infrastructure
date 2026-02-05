# Project Chimera: Technical Specification

This document defines **API Contracts** (JSON inputs/outputs for agents) and the **Database Schema** (ERD for video metadata). Every component is traceable to [functional.md](functional.md).

---

## Traceability Overview

| Technical Component | functional.md Traceability |
|--------------------|---------------------------|
| Trend Alert (API) | FR-PERCEPTION-003, Trend Spotter; Agent story "fetch trends" |
| Semantic Filter Result (API) | FR-PERCEPTION-002; Agent story "filter content for relevance" |
| Agent Task (API) | FR-ACTION-001, FR-ACTION-002; Planner/Worker flow |
| Worker Result (API) | FR-ACTION-002, FR-ACTION-003; Worker → Judge |
| Judge Decision (API) | FR-ACTION-003, FR-ACTION-004; Judge validation |
| Campaign Goal (API) | FR-USER-001; Network Operator user story |
| HITL Review Item (API) | FR-USER-002, FR-USER-003; Human Reviewer, Escalation Criteria |
| Memory Context (API) | FR-COGNITION-002; Hierarchical memory, Agent story "access hierarchical memory" |
| Video Metadata Schema | FR-ACTION-002, FR-ACTION-003; Worker generates / Judge validates multimodal content |

---

## 1. API Contracts

All payloads are JSON. Each contract lists the functional requirement(s) it implements.

---

### 1.1 Trend Alert (Perception → Planner)

**Traceability:** [functional.md](functional.md) — **FR-PERCEPTION-003** (Trend Spotter), "As an Agent (Planner), I need to receive trends."

Produced by the Trend Spotter Worker; consumed by the Planner.

**Input** (to Planner; output of Trend Spotter):

```json
{
  "event_id": "uuid-v4",
  "event_type": "trend_alert",
  "source": "trend_spotter",
  "created_at": "ISO8601",
  "agent_id": "string",
  "campaign_id": "string",
  "trend": {
    "topics": ["string"],
    "cluster_id": "string",
    "time_window_start": "ISO8601",
    "time_window_end": "ISO8601",
    "signal_strength": 0.0,
    "sample_resource_uris": ["news://region/category/latest"]
  }
}
```

**Output:** Planner consumes this and produces **Agent Task** (see 1.3). No direct response payload for Trend Alert.

---

### 1.2 Semantic Filter Result (Perception → Planner)

**Traceability:** [functional.md](functional.md) — **FR-PERCEPTION-002** (Semantic Filter), "As an Agent, I need to filter content for relevance."

Produced after scoring ingested resource content; only results above Relevance Threshold trigger task creation.

**Input** (ingested content; internal to filter):

- Raw content from MCP Resources (news, social, market). Structure is resource-specific.

**Output** (to Planner when relevance ≥ threshold):

```json
{
  "filter_result_id": "uuid-v4",
  "resource_uri": "string",
  "content_summary": "string",
  "relevance_score": 0.0,
  "agent_id": "string",
  "goal_context": "string",
  "created_at": "ISO8601",
  "above_threshold": true
}
```

**Traceability:** Drives task creation per **FR-ACTION-001** (Planner decomposes goals into tasks).

---

### 1.3 Agent Task (Planner → Worker)

**Traceability:** [functional.md](functional.md) — **FR-ACTION-001**, **FR-ACTION-002**; Action Loop "Planner receives trend → Decomposes into tasks → Pushes to TaskQueue"; "As an Agent (Worker), I need to generate content."

Planner pushes to TaskQueue; Worker pulls one task at a time.

**Input** (Worker receives this from queue):

```json
{
  "task_id": "uuid-v4",
  "task_type": "generate_content | reply_comment | execute_transaction",
  "priority": "high | medium | low",
  "status": "pending",
  "created_at": "ISO8601",
  "context": {
    "goal_description": "string",
    "persona_constraints": ["string"],
    "required_resources": ["mcp://..."],
    "campaign_id": "string",
    "agent_id": "string"
  },
  "acceptance_criteria": {
    "min_confidence": 0.0,
    "content_type": "text | image | video",
    "platform": "string"
  }
}
```

**Output:** Worker produces **Worker Result** (see 1.4).

---

### 1.4 Worker Result (Worker → Judge)

**Traceability:** [functional.md](functional.md) — **FR-ACTION-002** (Worker executes task), **FR-ACTION-003** (Judge validates); "As an Agent (Judge), I need to validate Worker outputs."

Worker pushes to ReviewQueue; Judge consumes.

**Input** (Judge receives):

```json
{
  "result_id": "uuid-v4",
  "task_id": "uuid-v4",
  "worker_id": "string",
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

**Output:** Judge produces **Judge Decision** (see 1.5).

---

### 1.5 Judge Decision (Judge → GlobalState / HITL)

**Traceability:** [functional.md](functional.md) — **FR-ACTION-003**, **FR-ACTION-004**; Judge Approve/Reject/Escalate; Escalation Criteria.

**Output** (Judge produces one of):

```json
{
  "decision_id": "uuid-v4",
  "result_id": "uuid-v4",
  "task_id": "uuid-v4",
  "decision": "approve | reject | escalate",
  "state_version": "string",
  "created_at": "ISO8601",
  "reason": "string",
  "hitl_reason": "low_confidence | sensitive_topic | policy_violation | anomalous"
}
```

- **approve:** Commit to GlobalState; may trigger publish (MCP Tools) and video/metadata persistence.
- **reject:** Discard; Planner may retry (functional.md Action Loop).
- **escalate:** Create **HITL Review Item** (see 1.7); **FR-USER-002**, **FR-USER-003**.

---

### 1.6 Campaign Goal (Network Operator → Planner)

**Traceability:** [functional.md](functional.md) — **FR-USER-001**; Network Operator user story (set campaign objectives via Dashboard).

**Input** (from Dashboard / API):

```json
{
  "campaign_id": "uuid-v4",
  "goal_description": "string",
  "operator_id": "string",
  "agent_ids": ["string"],
  "budget_constraints": {},
  "created_at": "ISO8601"
}
```

**Output:** Planner uses this (with Trend Alerts and Semantic Filter results) to produce Agent Tasks. No direct response schema here; persistence aligns with **Database Schema** (Campaign, GlobalState).

---

### 1.7 HITL Review Item (Judge → Human Reviewer)

**Traceability:** [functional.md](functional.md) — **FR-USER-002**, **FR-USER-003**; Human Reviewer user story; Escalation Criteria (confidence, sensitive topics, policy, anomalies).

**Input** (Review Interface receives):

```json
{
  "review_id": "uuid-v4",
  "result_id": "uuid-v4",
  "task_id": "uuid-v4",
  "agent_id": "string",
  "escalation_reason": "low_confidence | sensitive_topic | policy_violation | anomalous",
  "artifact": { "content_type": "string", "payload_text": "string", "payload_media_uri": "string" },
  "confidence_score": 0.0,
  "reasoning_trace": "string",
  "created_at": "ISO8601",
  "status": "pending"
}
```

**Output** (Human Reviewer action):

```json
{
  "review_id": "uuid-v4",
  "action": "approve | reject | edit",
  "edited_artifact": {},
  "reviewer_id": "string",
  "reviewed_at": "ISO8601"
}
```

---

### 1.8 Memory Context (Cognition → Agent)

**Traceability:** [functional.md](functional.md) — **FR-COGNITION-001**, **FR-COGNITION-002**; SOUL.md, Hierarchical memory; "As an Agent, I need to access hierarchical memory."

Assembled before reasoning; used by Planner/Worker for context.

**Output** (context assembled for LLM / agent):

```json
{
  "agent_id": "string",
  "soul": {
    "backstory": "string",
    "voice_tone": ["string"],
    "core_beliefs": ["string"],
    "directives": ["string"]
  },
  "short_term": [
    { "timestamp": "ISO8601", "role": "user | assistant", "content": "string" }
  ],
  "long_term": [
    { "memory_id": "string", "summary": "string", "relevance_score": 0.0 }
  ],
  "assembled_at": "ISO8601"
}
```

SOUL fields align with **FR-COGNITION-001** (SOUL.md backstory, voice, beliefs, directives). Short-term/long-term align with **FR-COGNITION-002** (Redis + Weaviate).

---

## 2. Database Schema: Video Metadata (ERD)

**Traceability:** [functional.md](functional.md) — **FR-ACTION-002** (Worker generates multimodal content, including video), **FR-ACTION-003** (Judge validates before commit). Storing video metadata supports the action loop (approve → persist → publish), analytics, and character consistency (reference to agent/persona).

Entities below store **metadata** for video (and optionally image/text) assets; actual media is assumed in object storage; ERD focuses on relational metadata.

### 2.1 Entity Relationship Diagram (Mermaid)

```mermaid
erDiagram
  campaign {
    uuid campaign_id PK
    string goal_description
    string operator_id
    timestamp created_at
    timestamp updated_at
  }

  agent {
    uuid agent_id PK
    string soul_version
    string wallet_address
    timestamp created_at
  }

  asset {
    uuid asset_id PK
    uuid campaign_id FK
    uuid agent_id FK
    uuid task_id
    uuid result_id
    string content_type "video|image|text"
    string storage_uri
    string platform_target
    string status "draft|approved|published|rejected"
    float confidence_score
    timestamp created_at
    timestamp published_at
  }

  video_metadata {
    uuid asset_id PK,FK
    int duration_seconds
    string resolution
    string codec
    string character_reference_id
    string tier "tier1_daily|tier2_hero"
    json generation_params
  }

  campaign |>--o{ asset : "produces"
  agent |>--o{ asset : "owns"
  asset ||--o| video_metadata : "has"
```

### 2.2 Table Definitions (Traceability)

- **campaign** — Traceability: **FR-USER-001** (Network Operators set campaign goals). Stores high-level goals and operator reference.
- **agent** — Traceability: **FR-COGNITION-001** (SOUL.md per agent), constitution (Economic Agency: wallet). Links agent to persona and wallet.
- **asset** — Traceability: **FR-ACTION-002** (Worker generates content), **FR-ACTION-003** (Judge validates). One row per generated artifact (video/image/text); `task_id`/`result_id` link to Agent Task and Worker Result APIs; `status` reflects Judge decision and publish state.
- **video_metadata** — Traceability: **FR-ACTION-002** (Worker generates video; SRS tiered video strategy). Stores video-specific fields (duration, resolution, codec, character_reference_id for consistency, tier for cost/quality).

### 2.3 Video Metadata Fields (JSON)

Aligned with **functional.md** Action Loop and Worker content generation:

| Field | Type | Traceability |
|-------|------|--------------|
| asset_id | uuid PK, FK to asset | FR-ACTION-002, FR-ACTION-003 |
| duration_seconds | int | Video asset metadata |
| resolution | string | Video asset metadata |
| codec | string | Video asset metadata |
| character_reference_id | string | Character consistency (functional.md Creative Engine / Worker) |
| tier | enum (tier1_daily, tier2_hero) | Tiered video strategy (functional.md / SRS) |
| generation_params | json | MCP tool params for traceability |

---

## 3. References

- [functional.md](functional.md) — Functional requirements and user stories (source of traceability).
- [\_meta.md](_meta.md) — Vision and constraints.
- Project Chimera SRS — Full technical and non-functional requirements.
