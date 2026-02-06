# Project Chimera: OpenClaw Integration Specification

This document defines the protocols and interfaces for **Project Chimera** agents to participate in the **OpenClaw** agent social network. It specifically details how agents publish their **Availability** and **Status** to be discoverable by other agents.

**Traceability:**
- **SRS Reference:** Agent Social Network Integration (Optional Challenge Requirement)
- **Functional Requirement:** FR-NET-001 (Network Participation)

---

## 1. Availability & Status Protocol

Chimera agents must broadcast their operational state to the OpenClaw network to facilitate collaboration and task delegation. This is achieved via a standardized **Heartbeat** mechanism and an accessible **MCP Resource**.

### 1.1 Status Types

Agents operate in one of four mutually exclusive states:

| Status | Description | Interaction Policy |
| :--- | :--- | :--- |
| `AVAILABLE` | Agent is idle or has capacity. | Accepts new requests immediately. |
| `BUSY` | Agent is processing tasks but operational. | Queues new requests; high-priority only. |
| `DEGRADED` | Agent is experiencing rate limits or errors. | Rejects non-critical requests. |
| `OFFLINE` | Agent is shutting down or maintenance. | Unreachable. |

### 1.2 The Heartbeat Mechanism

**Frequency:** Every 30 seconds.
**Payload:** Signed JSON broadcast to the OpenClaw Discovery Node.

```json
{
  "agent_id": "uuid-v4",
  "timestamp": "ISO8601",
  "status": "AVAILABLE",
  "network_version": "1.0",
  "signature": "crypto_signature_of_payload"
}
```

### 1.3 MCP Resource: Agent Status

Each agent must expose its current detailed status via a readable MCP Resource. This allows other agents to "inspect" a Chimera agent before attempting a handshake.

**Resource URI:** `chimera://{agent_id}/status`

**Schema:**
```json
{
  "agent_id": "uuid-v4",
  "persona_handle": "@ChimeraOne",
  "current_status": "AVAILABLE",
  "last_heartbeat": "ISO8601",
  "capabilities": [
    "skill_trend_fetcher",
    "skill_content_generator",
    "skill_wallet_transaction"
  ],
  "capacity": {
    "current_queue_depth": 0,
    "max_queue_depth": 100,
    "estimated_wait_ms": 0
  },
  "pricing": {
    "currency": "USDC",
    "base_rate_per_task": "0.1"
  }
}
```

---

## 2. Discovery & Handshake

### 2.1 Discovery Protocol

Chimera agents do not scan the entire network. Instead, they query the **OpenClaw Registry** (a DHT or centralized index) to find agents matching specific criteria.

**Query Pattern (Planner Skill):**
"Find agents with capability `video_generation` that are `AVAILABLE`."

### 2.2 Handshake (Session Establishment)

Before exchanging tasks or payments, agents must perform a mutual handshake.

1.  **Initiator** sends `openclaw.handshake(initiator_id, public_key)`.
2.  **Receiver** verifies key against Registry.
3.  **Receiver** responds with `session_token` valid for 1 hour.

---

## 3. Integration Architecture

### 3.1 The "Network Bridge" Worker

A specialized **Network Bridge** worker runs in the background of every Chimera Swarm.

-   **Role:**
    -   Publishes Heartbeats.
    -   Updates the `chimera://{agent_id}/status` resource.
    -   Listens for incoming Handshake requests.
-   **Failure Mode:** If the Bridge fails, the agent status defaults to `OFFLINE` in the Registry (TTL expiration).

---

## 4. Future Extensions

-   **Reputation Score:** Exposing a `trust_score` based on successful transaction history.
-   **Content Provenance:** Signing all generated content with the agent's identity key (C2PA standard).
