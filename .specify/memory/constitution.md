# Project Chimera Constitution

## Non-Negotiable Principles

The following principles are binding for all design, implementation, and operation of Project Chimera. No feature or component may violate them.

---

### I. Fractal Orchestration

**All logic must follow a Planner–Worker–Judge hierarchy.**

- **Planner:** Owns strategy, decomposes goals into tasks, and pushes work to the queue. No direct execution of user-facing or external actions.
- **Worker:** Executes a single atomic task (content generation, API call, etc.). Stateless, ephemeral, and the primary consumer of MCP tools.
- **Judge:** Validates every Worker output against acceptance criteria, persona, and safety rules. Only the Judge may Approve, Reject, or Escalate to human review.

No bypassing this hierarchy. No "monolithic agent" that plans, executes, and judges in one step. Orchestration and scaling assume this three-role model.

---

### II. Universal Connectivity

**External interactions must strictly use the Model Context Protocol (MCP).**

- All reads from the outside world (social feeds, news, market data, memory) go through **MCP Resources**.
- All writes and actions (posting, replying, transactions, tool calls) go through **MCP Tools**.
- Reusable reasoning patterns use **MCP Prompts** where applicable.

No direct third-party API calls from Planner, Worker, or Judge logic. Integrations live in MCP servers; the agent runtime is an MCP client. This keeps the core decoupled from platform volatility and ensures a single, auditable integration surface.

---

### III. Economic Agency

**All agents must have a dedicated non-custodial wallet via Coinbase AgentKit.**

- Every Chimera Agent has a unique, persistent wallet address.
- Wallet keys are secured in an enterprise secrets manager (e.g., AWS Secrets Manager, HashiCorp Vault); keys are never logged or embedded in code.
- Agents can receive payments, execute on-chain transactions, and manage their own P&L within governance limits (e.g., CFO Judge and budget caps).

No agent operates without a wallet. Economic participation is a first-class capability, not an add-on.

---

## Governance

- This constitution supersedes conflicting local practices and one-off decisions.
- Amendments require documentation, explicit approval, and a migration plan where existing behavior is affected.
- All design docs, specs, and PRs must demonstrate compliance with these three principles.
- For day-to-day development guidance, see the project's spec and rule files (e.g., `.cursor/rules/`, `.specify/`).

**Version:** 1.0.0 | **Ratified:** 2026-02-04 | **Last Amended:** —
