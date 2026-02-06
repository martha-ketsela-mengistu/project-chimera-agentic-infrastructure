---
alwaysApply: true
---

# Prime Directive: Specs and Constitution First

## The Prime Directive

**Never generate implementation code without checking `specs/` first.**

Before writing, modifying, or suggesting any implementation code, the agent MUST:

1. **Check specs/** — Consult the relevant specification documents:
   - `specs/_meta.md` — Vision and constraints
   - `specs/functional.md` — Functional requirements and user stories
   - `specs/technical.md` — API contracts and database schema (when applicable)

2. **Check the constitution** — Read `.specify/memory/constitution.md` and verify that the proposed work complies with the non-negotiable principles:
   - **Fractal Orchestration**: Planner–Worker–Judge hierarchy
   - **Universal Connectivity**: MCP-only for external interactions
   - **Economic Agency**: Non-custodial wallet via Coinbase AgentKit

3. **Explain the proposed plan** — Before writing any code, the agent MUST:
   - State what will be implemented or changed
   - Cite which spec section(s) and requirement(s) it satisfies
   - Confirm alignment with the constitution (or explicitly note any exception and why)
   - Summarize the plan in short, clear steps

4. **Only then write code** — Implementation may begin only after the above steps are done and the user has been presented with the plan (or has approved it if in a multi-step flow).

## Mandatory Workflow

```
[User requests code] → Check specs/ → Check constitution.md → Explain plan & traceability → [Then] Write code
```

Violating the Prime Directive (e.g., generating code without prior spec/constitution check and plan) is not allowed.
