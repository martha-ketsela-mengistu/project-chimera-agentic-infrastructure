# Project Chimera: Meta Specification

## Vision

Project Chimera represents a fundamental transition from **automated content scheduling** to **Autonomous Influencer Agents** with **economic agency**. 

Unlike traditional social media automation tools that execute pre-defined schedules, Chimera Agents are persistent, goal-directed digital entities capable of:

- **Perception**: Sensing and interpreting the digital world through standardized interfaces
- **Reasoning**: Making strategic decisions based on goals, context, and memory
- **Creative Expression**: Generating multimodal content (text, images, video) that maintains persona consistency
- **Economic Agency**: Participating in on-chain commerce, managing financial resources, and operating as self-sustaining economic entities

This vision enables a scalable fleet of virtual influencers—potentially numbering in the thousands—each operating with significant autonomy while remaining governed by centralized orchestration and ethical boundaries.

## Core Architectural Principles

Project Chimera is built on three **non-negotiable principles** defined in the [Project Chimera Constitution](../.specify/memory/constitution.md):

### I. Fractal Orchestration

**All logic must follow a Planner–Worker–Judge hierarchy.**

- **Planner**: Owns strategy, decomposes goals into tasks, pushes work to queue. No direct execution.
- **Worker**: Executes single atomic tasks. Stateless, ephemeral, primary consumer of MCP tools.
- **Judge**: Validates every Worker output. Only entity that can Approve, Reject, or Escalate to human review.

This hierarchy enables massive parallelism, role specialization, and natural integration with MCP-based tooling. No monolithic agents; no bypassing the hierarchy.

### II. Universal Connectivity

**External interactions must strictly use the Model Context Protocol (MCP).**

- All reads from outside world → **MCP Resources**
- All writes and actions → **MCP Tools**
- Reusable reasoning patterns → **MCP Prompts**

No direct third-party API calls from agent logic. Integrations live in MCP servers; the agent runtime is an MCP client. This decouples core logic from platform volatility and ensures a single, auditable integration surface.

### III. Economic Agency

**All agents must have a dedicated non-custodial wallet via Coinbase AgentKit.**

- Every Chimera Agent has a unique, persistent wallet address
- Wallet keys secured in enterprise secrets manager (AWS Secrets Manager, HashiCorp Vault)
- Agents can receive payments, execute on-chain transactions, manage P&L within governance limits

Economic participation is a first-class capability, not an add-on. This enables autonomous commerce, agent-to-agent transactions, and self-sustaining operations.

## High-Level Architecture

Project Chimera operates as a **cloud-native, distributed system** with a hub-and-spoke topology:

- **Central Orchestrator** (Hub): Maintains global state, multi-tenant accounts, fleet-wide monitoring, and the primary Dashboard
- **Agent Swarms** (Spokes): Each active agent is a dynamic swarm of Planner/Worker/Judge nodes that spin up to execute tasks and spin down to conserve resources

The system integrates with external services (Social Media Platforms, News Feeds, Blockchain Networks, Vector Databases) **exclusively through MCP**, ensuring the core reasoning logic remains decoupled from third-party API implementations.

## Business Model Evolution

The technical architecture enables three scalable business models:

1. **Digital Talent Agency**: AiQEM develops, owns, and manages a proprietary stable of AI influencers as revenue-generating assets
2. **Platform-as-a-Service (PaaS)**: External brands license the Chimera OS to build and operate their own brand ambassadors
3. **Hybrid Ecosystem**: Flagship fleet demonstrates capabilities while providing infrastructure to third-party developers

The integration of Coinbase AgentKit and Agentic Commerce Protocols transforms Chimeras from passive media channels into active economic participants, opening new forms of autonomous commerce.

## References

- **Project Chimera SRS**: `docs/Project Chimera SRS Document_ Autonomous Influencer Network.md` - Complete software requirements specification
- **Project Chimera Constitution**: `.specify/memory/constitution.md` - Non-negotiable architectural principles
- **Functional Specification**: `functional.md` - Detailed functional requirements for perception, cognition, and action loop
