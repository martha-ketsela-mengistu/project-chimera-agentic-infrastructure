# Project Chimera: The Agentic Infrastructure

## 🚀 Mission

To architect a robust "Factory" for the creation and governance of **Autonomous AI Influencers**. This project serves as a foundation for digital entities that research trends, generate content, and manage engagement autonomously—transitioning from automated content scheduling to **Autonomous Influencer Agents with economic agency**.

---

## 🏗️ Core Engineering Philosophies

This repository adheres to **Spec-Driven Development (SDD)** and **Agentic Orchestration**:

- **Intent as Truth**: No implementation code is written until the Specification (via GitHub Spec Kit) is ratified.
- **Traceability**: All development "thinking" and execution are recorded via the Tenx Feedback Analytics MCP server.
- **Agentic Orchestration**: The codebase is designed to be navigated and expanded by AI agent swarms with minimal human conflict.

---

## 📜 Non-Negotiable Principles (Constitution)

Project Chimera operates under three **binding principles** defined in [`.specify/memory/constitution.md`](.specify/memory/constitution.md):

### I. Fractal Orchestration
**All logic must follow a Planner–Worker–Judge hierarchy.**
- **Planner**: Owns strategy, decomposes goals into tasks, pushes work to queue. No direct execution.
- **Worker**: Executes single atomic tasks. Stateless, ephemeral, primary consumer of MCP tools.
- **Judge**: Validates every Worker output. Only entity that can Approve, Reject, or Escalate to human review.

### II. Universal Connectivity
**External interactions must strictly use the Model Context Protocol (MCP).**
- All reads from outside world → **MCP Resources**
- All writes and actions → **MCP Tools**
- Reusable reasoning patterns → **MCP Prompts**

### III. Economic Agency
**All agents must have a dedicated non-custodial wallet via Coinbase AgentKit.**
- Every Chimera Agent has a unique, persistent wallet address
- Wallet keys secured in enterprise secrets manager
- Agents can receive payments, execute on-chain transactions, manage P&L within governance limits

---

## 📁 Project Structure

```
project-chimera-agentic-infrastructure/
├── .cursor/
│   ├── mcp.json              # MCP server configurations
│   └── rules/                # Cursor AI agent rules
│       ├── agent.mdc         # Trigger logging rules
│       └── specs-first.mdc   # Prime Directive: specs before code
├── .github/
│   └── agents/               # GitHub Spec Kit agents
│       └── prompts/          # Spec Kit workflow prompts
├── .specify/
│   ├── memory/
│   │   └── constitution.md   # Non-negotiable principles
│   ├── scripts/powershell/   # SDD workflow automation
│   └── templates/            # Spec/plan/task templates
├── research/                 # Research and analysis
│   ├── reading_notes.md      # SRS summary & analysis
│   ├── architecture_strategy.md  # Architecture decisions
│   └── tooling_strategy.md   # MCP tooling documentation
├── specs/                    # Specifications (GitHub Spec Kit)
│   ├── _meta.md              # High-level vision and constraints
│   ├── functional.md         # Functional requirements & user stories
│   ├── technical.md          # API contracts & database schema
│   └── 001-chimera-core-specs/  # Feature branch specs
└── skills/                   # Skill definitions
    └── README.md             # Skill Input/Output JSON contracts
```

---

## 🔧 Configured MCP Servers

The project uses **Model Context Protocol (MCP)** for all external interactions. Configured servers (see [`.cursor/mcp.json`](.cursor/mcp.json)):

| Server | Purpose | Package |
|--------|---------|---------|
| **tenxfeedbackanalytics** | AI fluency tracking & performance logging | Remote (mcppulse.10academy.org) |
| **filesystem** | File operations (read/write/list/search) | `@modelcontextprotocol/server-filesystem` |
| **git** | Version control (branches, commits, logs) | `@modelcontextprotocol/server-git` |
| **sequential-thinking** | Chain-of-thought reasoning | `@modelcontextprotocol/server-sequential-thinking` |
| **terminal** | Command execution (tests, builds) | `@modelcontextprotocol/server-terminal` |

See [research/tooling_strategy.md](research/tooling_strategy.md) for detailed documentation.

---

## 📋 Key Specifications

- **[specs/_meta.md](specs/_meta.md)**: Vision, architectural principles, and high-level constraints
- **[specs/functional.md](specs/functional.md)**: Functional requirements for Perception, Cognition, Action Loop, and User Roles
- **[specs/technical.md](specs/technical.md)**: API contracts (JSON inputs/outputs) and database schema (ERD) — all traceable to functional.md
- **[skills/README.md](skills/README.md)**: Input/Output JSON contracts for `skill_trend_fetcher`, `skill_content_generator`, and `skill_wallet_transaction`

---

## 🎯 Development Workflow

### Spec-Driven Development (SDD)

1. **Specify** (`/speckit.specify`): Create feature specification from natural language description
2. **Clarify** (`/speckit.clarify`): Resolve ambiguities and edge cases
3. **Plan** (`/speckit.plan`): Generate technical plan from spec
4. **Tasks** (`/speckit.tasks`): Break plan into actionable tasks
5. **Implement** (`/speckit.implement`): Write code following TDD principles
6. **Analyze** (`/speckit.analyze`): Review implementation against spec

### Prime Directive

**Never generate implementation code without checking `specs/` first.**

Before writing code, the AI agent MUST:
1. Check `specs/_meta.md`, `specs/functional.md`, and `specs/technical.md`
2. Check `.specify/memory/constitution.md` for compliance
3. Explain the proposed plan and cite traceability to requirements
4. Only then write code

See [`.cursor/rules/specs-first.mdc`](.cursor/rules/specs-first.mdc) for details.

Successfully configured and connected the Tenx MCP Sense Server to Cursor IDE. Logs
2026-02-04 17:57:52.699 [info] Connected to streamableHttp server, fetching offerings
2026-02-04 17:57:55.707 [info] listOfferings: Found 3 tools
2026-02-04 17:57:56.549 [info] listPrompts: Found 1 prompts
2026-02-04 17:58:01.886 [info] listResources: Found 0 resources
2026-02-04 17:58:01.887 [info] Found 3 tools, 1 prompts, and 0 resources
2026-02-04 17:58:03.432 [info] Handling GetInstructions action
2026-02-04 18:00:27.362 [info] Handling ListToolsRaw action
2026-02-04 18:00:27.377 [info] Handling CallTool action for tool 'log_passage_time_trigger' 
with toolCallId: call_yJZ9mo9TIQfiUpJRx8FuReNj
fc_0849005ca377ba750169835f096be48198a694e72c94a422bf
2026-02-04 18:00:27.386 [info] Calling tool 'log_passage_time_trigger' with toolCallId: 
call_yJZ9mo9TIQfiUpJRx8FuReNj
fc_0849005ca377ba750169835f096be48198a694e72c94a422bf
2026-02-04 18:00:28.330 [info] Successfully called tool 'log_passage_time_trigger'
2026-02-04 18:01:53.865 [info] Handling ListOfferings action, server stored: true


---

**Version**: 1.0.0 | **Last Updated**: 2026-02-04
