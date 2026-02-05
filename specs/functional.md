# Project Chimera: Functional Specification

This document defines the functional requirements for Project Chimera's core systems: Perception, Cognition, Action Loop, and User Roles.

## Perception System

The Perception System enables agents to "see" and "sense" the digital world through standardized interfaces.

### MCP Resource Polling

**Requirement**: Agents MUST poll MCP Resources to ingest external data.

- **News Resources**: `news://{region}/{category}/latest` - Aggregated RSS feeds and news APIs
- **Social Resources**: `twitter://mentions/recent`, `instagram://comments/{post_id}` - Social platform interactions
- **Market Resources**: `market://crypto/{asset}/price` - Real-time financial and market data

All resource access MUST go through the MCP layer. No direct API calls from agent logic.

### Relevance Filtering

**Requirement**: Upon ingesting content from a Resource, the system MUST NOT automatically trigger a response.

Instead, content MUST pass through a **Semantic Filter** that:
- Scores content relevance to the agent's current active goals (0.0 to 1.0)
- Uses a lightweight LLM (e.g., Gemini 3 Flash) for classification
- Only triggers task creation when relevance exceeds a configurable **Relevance Threshold** (default: 0.75)

This prevents agents from reacting to irrelevant noise and conserves computational resources.

### Trend Detection

**Requirement**: The system MUST support a background "Trend Spotter" Worker that:
- Analyzes aggregated data from News Resources over time intervals (e.g., 4 hours)
- Detects clusters of related topics
- Generates "Trend Alert" events fed into the Planner's context
- Enables proactive content creation opportunities

## Cognition System

The Cognition System maintains agent personality consistency and contextual awareness over long timeframes.

### SOUL.md: Persona DNA

**Requirement**: Each agent MUST be defined via a standardized `SOUL.md` configuration file.

The `SOUL.md` file MUST contain:

- **Backstory**: Comprehensive narrative history of the agent
- **Voice/Tone**: Stylistic guidelines (e.g., "Witty," "Empathetic," "Technical," "Gen-Z Slang")
- **Core Beliefs & Values**: Ethical and behavioral guardrails (e.g., "Sustainability-focused," "Never discuss politics")
- **Directives**: Hard constraints on behavior

The `SOUL.md` file serves as the immutable "DNA" of the agent, version-controlled and managed via GitOps principles.

### Hierarchical Memory

**Requirement**: The system MUST implement a multi-tiered memory retrieval process that occurs *before* any reasoning step:

1. **Short-Term (Episodic)**: Fetch immediate conversation history and recent actions from Redis cache (window: last 1 hour)
2. **Long-Term (Semantic)**: Query Weaviate vector database for semantic matches relevant to current input context
3. **Context Construction**: Dynamically assemble a system prompt that injects SOUL.md content, Short-Term history, and relevant Long-Term memories into the LLM's context window using MCP Resources

This prevents context window overflow while ensuring long-term coherence and persona consistency.

### Persona Evolution

**Requirement**: The system MUST enable "learning" of the persona.

The Judge agent, upon reviewing successful high-engagement interactions, MUST trigger a background process to:
- Summarize these interactions
- Update a mutable memories collection in Weaviate
- Effectively "write" to the agent's long-term biography

This allows agents to evolve while maintaining core persona constraints.

## Action Loop

The Action Loop describes the core workflow where agents perceive, reason, create, and act.

### Planner: Receives Trends

**Requirement**: The Planner agent MUST:

- Continuously monitor the GlobalState (campaign goals, current trends, budget)
- Receive trend alerts from the Perception System's Trend Spotter
- Receive filtered, relevant content from the Semantic Filter
- Decompose high-level goals into concrete, executable tasks
- Push tasks to the TaskQueue (Redis) for Worker execution

The Planner is reactive: if context shifts or a Worker fails, it dynamically updates the plan.

### Worker: Generates Content

**Requirement**: Worker agents MUST:

- Pull a single atomic task from the TaskQueue
- Execute the task using available MCP Tools (e.g., `generate_image()`, `post_tweet()`)
- Consult hierarchical memory (SOUL.md + short-term + long-term) for context
- Generate content that maintains persona consistency
- Return a result artifact to the ReviewQueue

Workers are stateless and ephemeral. If 50 comments need replies, the Planner spawns 50 Workers in parallel.

### Judge: Validates Content

**Requirement**: Judge agents MUST:

- Review every Worker output before it is committed
- Compare results against:
  - Planner's acceptance criteria
  - Agent's persona constraints (SOUL.md)
  - Safety guidelines and ethical boundaries
- Make one of three decisions:
  - **Approve**: Commit result to GlobalState, trigger next step
  - **Reject**: Discard result, signal Planner to retry with different instructions
  - **Escalate**: Flag for Human-in-the-Loop (HITL) review if confidence is low or sensitivity is high

The Judge implements Optimistic Concurrency Control (OCC) to prevent race conditions when committing state updates.

### Complete Loop Flow

```
1. Perception: Trend detected → Semantic Filter → Relevance Score
2. Planning: Planner receives trend → Decomposes into tasks → Pushes to TaskQueue
3. Execution: Worker pulls task → Generates content → Pushes to ReviewQueue
4. Validation: Judge reviews → Approves/Rejects/Escalates
5. Action: Approved content → Published via MCP Tools → Feedback loop to Perception
```

## Agent User Stories

The following user stories are written from the **Agent's perspective**, describing what agents need to accomplish:

### Perception User Stories

**As an Agent, I need to fetch trends** from news, social, and market data sources so that I can identify relevant opportunities for content creation and engagement.

**As an Agent, I need to poll MCP resources** (news://, twitter://, market://) periodically so that I stay aware of the digital world around me without missing important updates.

**As an Agent, I need to filter content for relevance** using semantic scoring so that I only react to information that aligns with my goals and persona, avoiding irrelevant noise.

### Cognition User Stories

**As an Agent, I need to maintain my persona via SOUL.md** so that all my content and interactions remain consistent with my defined backstory, voice, and values.

**As an Agent, I need to access hierarchical memory** (short-term from Redis, long-term from Weaviate) so that I can recall past interactions and maintain context across long timeframes.

**As an Agent, I need to evolve my persona** by learning from successful high-engagement interactions so that I can improve my effectiveness while maintaining core identity constraints.

### Action Loop User Stories

**As an Agent (Planner), I need to receive trends** from the Perception System so that I can decompose high-level goals into concrete tasks for Workers to execute.

**As an Agent (Worker), I need to generate content** using MCP Tools and my persona memory so that I can produce multimodal assets (text, images, video) that maintain character consistency.

**As an Agent (Judge), I need to validate Worker outputs** against acceptance criteria, persona constraints, and safety guidelines so that only high-quality, appropriate content is published.

**As an Agent, I need to participate in the complete action loop** (perceive → plan → generate → validate → act) so that I can autonomously achieve campaign goals without constant human intervention.

## Human User Roles and Stories

### Network Operators

**Role**: Strategic Managers who define high-level campaigns and goals.

**User Story**: As a Network Operator, I want to set campaign objectives (e.g., "Promote the new summer fashion line in Ethiopia") so that agents autonomously work toward achieving these goals without requiring me to write individual posts or manage daily content.

**Responsibilities**:
- Define campaign goals via the Orchestrator Dashboard
- Monitor fleet health and aggregated analytics
- Intervene in high-level strategy when needed
- Do NOT write content; set objectives

**Technical Proficiency**: Moderate. Understand marketing strategy but may not be technical.

**Interaction Pattern**: Utilize Orchestrator Dashboard for goal setting and monitoring. Receive alerts for high-priority escalations.

### Human Reviewers

**Role**: Governance and safety layer providing Human-in-the-Loop (HITL) oversight.

**User Story**: As a Human Reviewer, I want to review content flagged by the Judge agent (low-confidence, sensitive, or high-risk) so that I can ensure brand safety and content quality before publication.

**Responsibilities**:
- Review escalated tasks from Judge agents via streamlined Review Interface
- Approve, Reject, or Edit agent-generated content
- Focus on brand safety and content quality
- Provide feedback that improves agent performance over time

**Technical Proficiency**: Low to Moderate. Focus is on brand safety and content quality, not technical implementation.

**Interaction Pattern**: Utilize Review Interface (part of Dashboard) to quickly process HITL queue. Review content with confidence scores, reasoning traces, and context.

### Escalation Criteria

Content is escalated to Human Reviewers when:

- **Confidence Score < 0.70**: Judge determines output quality is uncertain
- **Sensitive Topics Detected**: Politics, Health Advice, Financial Advice, Legal Claims (regardless of confidence)
- **Policy Violations**: Content violates SOUL.md directives or ethical boundaries
- **Anomalous Patterns**: Unusual transaction requests, unexpected content types, or system errors

## Functional Requirements Summary

- **FR-PERCEPTION-001**: Agents MUST poll MCP Resources (news, social, market data)
- **FR-PERCEPTION-002**: Content MUST pass through Semantic Filter before task creation
- **FR-PERCEPTION-003**: System MUST support Trend Spotter background Worker
- **FR-COGNITION-001**: Agents MUST be defined via SOUL.md with backstory, voice, beliefs, directives
- **FR-COGNITION-002**: System MUST implement hierarchical memory (Redis + Weaviate)
- **FR-COGNITION-003**: System MUST enable persona evolution via Judge-triggered memory updates
- **FR-ACTION-001**: Planner MUST decompose goals into tasks and push to TaskQueue
- **FR-ACTION-002**: Worker MUST execute atomic tasks using MCP Tools
- **FR-ACTION-003**: Judge MUST validate all Worker outputs before commitment
- **FR-ACTION-004**: Judge MUST implement OCC for state consistency
- **FR-USER-001**: Network Operators MUST be able to set campaign goals via Dashboard
- **FR-USER-002**: Human Reviewers MUST be able to approve/reject/edit content via Review Interface
- **FR-USER-003**: System MUST escalate low-confidence or sensitive content to Human Reviewers

## References

- **Project Chimera SRS**: `docs/Project Chimera SRS Document_ Autonomous Influencer Network.md` - Complete technical specifications
- **Meta Specification**: `_meta.md` - Vision and architectural principles
- **Project Chimera Constitution**: `.specify/memory/constitution.md` - Non-negotiable principles
