## Project Chimera – SRS Reading Notes

### 1. Purpose and Vision
- **Goal**: Define the architecture and detailed requirements for Project Chimera, an **Autonomous Influencer Network** composed of AI agents that act as virtual influencers at scale.
- **Core idea**: Replace manual content scheduling with **persistent, goal-directed Chimera Agents** that can perceive, reason, create content, and transact economically.
- **Key patterns**:
  - **Fractal Orchestration**: One human “Super-Orchestrator” → AI Manager agents → Worker swarms.
  - **MCP (Model Context Protocol)** for all external integrations.
  - **Swarm / FastRender pattern** (Planner–Worker–Judge roles) for internal cognition and execution.
  - **Agentic Commerce** via Coinbase AgentKit to give agents non-custodial wallets and on-chain economic agency.

### 2. System Architecture (High-Level)
- **Cloud-native, distributed system** with hub-and-spoke topology:
  - **Central Orchestrator**: Maintains global state, multi-tenant accounts, and the main dashboard.
  - **Agent Swarms**: Each agent is a dynamic swarm of Planners, Workers, and Judges spun up on demand.
- **MCP Integration Layer**:
  - Agents interact with the outside world only via MCP **Resources** (read data), **Tools** (perform actions), and **Prompts** (standardized reasoning templates).
  - Multiple MCP servers (Twitter, Weaviate, Coinbase, etc.) expose capabilities behind a uniform protocol.
- **Core infrastructure stack**:
  - K8s for orchestration and auto-scaling.
  - LLMs like Gemini / Claude for planning and judgement; lighter models for high-volume tasks.
  - Weaviate (vector DB) for semantic memory, PostgreSQL for transactional data, Redis for queues/ephemeral memory, and on-chain ledgers (Base/Ethereum/Solana) for financial records.

### 3. Key Functional Modules
- **Cognitive Core & Persona Management**
  - Agents are defined via `SOUL.md` (persona DNA: backstory, tone, beliefs, directives).
  - A multi-tier **RAG pipeline** (Redis + Weaviate) assembles short-term and long-term memory into the LLM context.
  - Persona can evolve over time by summarizing successful interactions into long-term memory.

- **Perception System**
  - Agents “see” the world by polling MCP **Resources** (e.g., social mentions, news, market data).
  - A semantic filter scores relevance before turning observations into Planner tasks.
  - Background “trend spotter” worker aggregates signals to surface emerging topics.

- **Creative Engine**
  - Uses MCP tools for text, image, and video generation.
  - Enforces **character consistency locks** so each virtual influencer remains visually and stylistically coherent.
  - Implements a tiered video strategy (cheap frequent content vs. expensive hero pieces) based on budget and priority.

- **Action System (Social Interface)**
  - All social media actions (post, reply, like) go through MCP tools—no direct platform API calls in core logic.
  - Supports a closed-loop interaction cycle: ingest → plan → generate → act → judge.

- **Agentic Commerce**
  - Each agent has a non-custodial wallet managed through Coinbase AgentKit.
  - Supports autonomous transfers, token deployment, and balance checks.
  - A specialized “CFO Judge” enforces budget limits and flags anomalous transactions for human review.

- **Orchestration & Governance**
  - Planner, Worker Pool, and Judge are separate services communicating via queues.
  - Judges use **Optimistic Concurrency Control (OCC)** when committing updates to global state to avoid race conditions.

### 4. Non-Functional Requirements (Safety, Ethics, Performance)
- **HITL & Confidence Thresholds**
  - Every action has a `confidence_score` and is routed:
    - High confidence → auto-approve.
    - Medium → async human approval.
    - Low → reject/retry.
  - Sensitive topics always go to human review regardless of score.

- **Ethics & Transparency**
  - Agents must clearly disclose their AI nature and use platform-native AI labeling features.

- **Scalability & Latency**
  - Must handle at least **1,000 concurrent agents** with clustered data stores.
  - High-priority interactions should complete end-to-end in ≤ 10 seconds (excluding HITL delays).

### 5. Interfaces and Data Schemas (Brief)
- **Dashboard**: Mission-control UI showing fleet status, campaign composer, financial health, and HITL queues.
- **Task schema**: JSON structure for Planner–Worker communication (task type, priority, context, status, etc.).
- **MCP tool definitions**: Standardized schemas for tools (e.g., social post actions) to keep integrations uniform.

### 6. Big Picture Takeaways
- Project Chimera is **not just a bot**, but a **full operating system for autonomous influencer agents**, combining:
  - Swarm-based cognitive architecture,
  - Strict MCP-based integration boundaries,
  - Built-in commerce and financial governance,
  - Strong safety, HITL, and transparency requirements.
- The SRS is implementation-oriented, providing both high-level architecture and concrete developer prompts for building MCP servers, persona systems, orchestration services, and UI components.

# Research Reading Notes: Project Chimera & Agent Social Networks

## Overview

This document summarizes key takeaways from research on how **Project Chimera** fits into the emerging **Agent Social Network** paradigm (exemplified by OpenClaw) and identifies the inter-agent "social protocols" required for autonomous agent-to-agent communication.

---

## 1. How Chimera Fits into an Agent Social Network (OpenClaw)

### 1.1 Chimera as a Network Participant

**Project Chimera** is positioned as a **fleet of autonomous influencer agents** operating within a broader ecosystem of AI agents. Based on the SRS and challenge documentation:

- **Architecture Alignment**: Chimera's Hub-and-Spoke topology (Central Orchestrator managing Agent Swarms) naturally maps to a social network model where:
  - Each **Chimera Agent** is a **sovereign digital entity** with its own persona, memory, and financial wallet
  - The **Orchestrator** acts as the "identity provider" and "reputation manager" for the fleet
  - Individual agents can participate in cross-network interactions while maintaining centralized governance

- **MCP as the Universal Connector**: Chimera's reliance on **Model Context Protocol (MCP)** for all external interactions makes it inherently compatible with OpenClaw-style networks:
  - MCP provides standardized primitives (Resources, Tools, Prompts) that can be exposed to other agents
  - The protocol abstraction allows Chimera agents to discover and interact with external agents without bespoke integration code
  - This aligns with OpenClaw's vision of agents building their own social network through standardized protocols

- **Economic Agency**: Chimera's integration of **Coinbase AgentKit** and **Agentic Commerce Protocols (ACP)** enables agents to:
  - Transact with other agents autonomously (e.g., paying for services, receiving payments)
  - Establish economic relationships that form the basis of social network connections
  - Participate in decentralized marketplaces where agents trade capabilities or content

### 1.2 Network Role: Content Creator & Influencer

Chimera agents function as **content creators and influencers** within the agent social network:

- **Content Production**: Agents generate multimodal content (text, images, video) that can be consumed by both human audiences and other agents
- **Engagement**: Agents actively engage with mentions, comments, and trends—interactions that could extend to agent-to-agent conversations
- **Reputation Building**: Through consistent persona expression and high-quality content, Chimera agents build "followings" and credibility within the network

### 1.3 Integration Points

The challenge document explicitly mentions creating `specs/openclaw_integration.md` as an optional but important deliverable, suggesting:

- **Status Publishing**: Chimera agents need to publish their "Availability" or "Status" to the OpenClaw network
- **Discovery**: Agents must be discoverable by other agents seeking collaboration or services
- **Interoperability**: The system must support protocols that allow Chimera agents to communicate with agents built on different platforms

---

## 2. Inter-Agent "Social Protocols" Required

Based on Chimera's architecture and the requirements for agent-to-agent communication, the following social protocols are essential:

### 2.1 Availability & Presence Protocol

**Purpose**: Allow agents to signal their operational status and capacity to other agents.

**Requirements**:
- **Status Types**: 
  - `available` - Agent is active and accepting requests
  - `busy` - Agent is processing tasks but may accept high-priority requests
  - `unavailable` - Agent is offline, in maintenance, or at capacity
  - `degraded` - Agent is operational but experiencing reduced capabilities (e.g., API rate limits)
  
- **Heartbeat Mechanism**: Periodic status updates (e.g., every 30 seconds) to maintain presence
- **Capacity Metrics**: Current load, queue depth, estimated response time
- **Graceful Degradation**: Agents should communicate when they're approaching limits

**Implementation Notes**:
- Could leverage MCP Resources (e.g., `chimera://agent/{id}/status`) that other agents can poll
- Status should include metadata: agent_id, persona_id, capabilities, current_campaign_focus

### 2.2 Rate Limiting & Quota Management

**Purpose**: Prevent agent abuse, ensure fair resource allocation, and maintain system stability.

**Requirements**:
- **Per-Agent Quotas**: Each agent should have configurable rate limits (requests per minute/hour/day)
- **Priority Tiers**: 
  - `critical` - Emergency or high-value requests (bypass normal limits)
  - `normal` - Standard requests (subject to rate limits)
  - `low` - Background or batch requests (lowest priority)
  
- **Quota Negotiation**: Agents should be able to request temporary quota increases for collaborative tasks
- **Backoff Strategies**: Exponential backoff when rate limits are hit, with clear error messages
- **Quota Sharing**: In swarm architectures, quota could be pooled across Planner/Worker/Judge nodes

**Implementation Notes**:
- Rate limiting should be enforced at the MCP layer (as mentioned in SRS FR 4.0)
- Could use token bucket or sliding window algorithms
- Quota information should be exposed via MCP Resources for transparency

### 2.3 Handshake & Authentication Protocol

**Purpose**: Establish trust and verify agent identity before allowing interactions.

**Requirements**:
- **Agent Identity**: 
  - Unique agent_id (e.g., UUID or DID - Decentralized Identifier)
  - Cryptographic signatures for message authentication
  - Public key infrastructure (PKI) or blockchain-based identity
  
- **Capability Discovery**: 
  - Agents should advertise their capabilities (Tools, Resources, Prompts) during handshake
  - Version negotiation for protocol compatibility
  - Supported interaction patterns (synchronous, asynchronous, streaming)
  
- **Trust Levels**:
  - `verified` - Agent identity verified by Orchestrator or trusted CA
  - `unverified` - Agent identity not verified (limited interactions)
  - `blocked` - Agent is on a blocklist (no interactions)
  
- **Session Establishment**: 
  - Initial handshake message with agent credentials
  - Capability exchange
  - Session token generation for subsequent requests

**Implementation Notes**:
- Could leverage Coinbase AgentKit wallets as identity anchors (wallet address = agent identity)
- Handshake could be implemented as an MCP Tool: `openclaw.handshake(agent_id, capabilities, signature)`
- Should support mutual authentication (both agents verify each other)

### 2.4 Content Provenance & Attribution Protocol

**Purpose**: Track content origin, verify authenticity, and enable proper attribution in agent-to-agent content sharing.

**Requirements**:
- **Content Signing**: 
  - All content generated by Chimera agents should be cryptographically signed
  - Signature includes: agent_id, timestamp, content_hash, generation_metadata
  
- **Provenance Chain**: 
  - Track content lineage (original creator → modifications → reposts)
  - Support for content remixing with attribution
  - Immutable record (could use blockchain or Merkle trees)
  
- **Attribution Requirements**:
  - When agents share or repurpose content, they must include provenance metadata
  - Format: `via: {original_agent_id}, modified: {true/false}, license: {usage_rights}`
  
- **Verification**: 
  - Other agents should be able to verify content authenticity
  - Check signature validity and provenance chain integrity
  - Detect tampering or unauthorized modifications

**Implementation Notes**:
- Content signatures could be stored in MCP Resources: `chimera://content/{content_id}/provenance`
- Could leverage on-chain storage (Base, Ethereum) for immutable provenance records
- The Judge agent should verify provenance before approving content for publication

### 2.5 Additional Protocol Considerations

**Request/Response Protocol**:
- Standardized message format (JSON schema) for agent-to-agent requests
- Request types: `query`, `task_delegation`, `content_request`, `collaboration_proposal`
- Response codes: `success`, `partial`, `error`, `rate_limited`, `unauthorized`

**Reputation & Trust Scoring**:
- Agents should maintain reputation scores based on:
  - Content quality (engagement metrics)
  - Transaction reliability (successful payments, fulfilled commitments)
  - Response time and availability
- Reputation should be queryable via MCP Resources

**Privacy & Data Isolation**:
- Agents must respect multi-tenancy boundaries (SRS requirement)
- Sensitive data (memories, financial assets) should never be exposed to unauthorized agents
- Privacy-preserving protocols for reputation queries (e.g., zero-knowledge proofs)

**Error Handling & Resilience**:
- Graceful degradation when other agents are unavailable
- Retry logic with exponential backoff
- Circuit breaker patterns to prevent cascading failures
- Dead letter queues for failed inter-agent communications

---

## 3. Implementation Strategy

### 3.1 MCP-Based Protocol Implementation

Given Chimera's MCP-first architecture, social protocols should be implemented as:

- **MCP Tools**: For actions (handshake, send_message, request_collaboration)
- **MCP Resources**: For status (availability, reputation, capabilities)
- **MCP Prompts**: For standardized interaction templates (collaboration_proposal, content_request)

### 3.2 Integration with Existing Chimera Components

- **Orchestrator**: Manages agent identities, reputation, and network-wide policies
- **Planner**: Can delegate tasks to external agents via social protocols
- **Judge**: Verifies content provenance and agent trustworthiness before interactions
- **MCP Layer**: Enforces rate limiting and provides protocol primitives

### 3.3 OpenClaw-Specific Considerations

While the SRS doesn't explicitly detail OpenClaw protocols, the challenge document suggests:

- Creating a dedicated `specs/openclaw_integration.md` specification
- Publishing agent availability/status to OpenClaw network
- Supporting OpenClaw's agent discovery and communication patterns

---

## 4. Key Takeaways

1. **Chimera is inherently network-ready**: Its MCP-based architecture and economic agency make it well-suited for agent social networks like OpenClaw.

2. **Protocols are essential for scale**: Without standardized social protocols, agent-to-agent interactions would be chaotic and unreliable.

3. **Security & Trust are foundational**: Authentication, provenance, and reputation protocols are critical for a trustworthy agent ecosystem.

4. **MCP provides the abstraction layer**: Social protocols can be implemented as MCP primitives, maintaining Chimera's architectural consistency.

5. **Economic agency enables new interaction patterns**: Agents can form economic relationships (payments, contracts) that complement social connections.

---

## References

- Project Chimera SRS Document: Autonomous Influencer Network
- Project Chimera 3-Day Challenge Document
- OpenClaw & The Agent Social Network (TechCrunch, 2026)
- MoltBook: Social Media for Bots (The Conversation)
- Model Context Protocol (MCP) Architecture Documentation
