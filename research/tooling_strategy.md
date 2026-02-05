# Tooling Strategy: MCP Servers for Project Chimera

This document describes the four core MCP (Model Context Protocol) servers configured for the project and how they support the spec-driven, test-driven workflow. Configuration lives in `.cursor/mcp.json`.

---

## 1. filesystem-mcp (The Foundation)

**What it does:** Allows the AI to list directories, read multiple files at once, and create complex folder structures.

**Why it matters:** Vital for creating the `specs/`, `skills/`, and `tests/` directories autonomously. The AI can scaffold full feature layouts, read several spec or source files in one go, and maintain consistent structure without manual file creation.

**Configuration:** `@modelcontextprotocol/server-filesystem` with the project root (or designated directories) as allowed paths.

---

## 2. git-mcp (Version Control)

**What it does:** Allows the AI to see the git log, create branches, and stage commits.

**Why it matters:** In the GitHub Spec Kit workflow, every new spec or feature should live on a separate branch. This MCP lets the AI manage that branching strategy for you—creating feature branches, staging changes, and preparing commits in line with the `001-chimera-core-specs` style workflow.

**Configuration:** `@modelcontextprotocol/server-git` with the repository path.

---

## 3. sequentialthinking-mcp (The Architect's Brain)

**What it does:** Forces the AI to use a "Chain of Thought" process, writing out its logic step-by-step before it touches the code.

**Why it matters:** This prevents "vibe coding." It ensures the AI thinks through the **Fractal Orchestration** logic (Planner–Worker–Judge) before generating a single line of Python. Aligns with the Prime Directive: check specs and constitution before implementation.

**Configuration:** `@modelcontextprotocol/server-sequential-thinking` (no extra args).

---

## 4. terminal-mcp (Execution)

**What it does:** Allows the AI to run commands like `uv sync`, `make test`, or `docker build`.

**Why it matters:** Crucial for the **TDD (Test-Driven Development)** phase, where the AI needs to run tests and see them fail before attempting a fix. Enables dependency installs, test runs, and build steps without leaving the conversation.

**Configuration:** `@modelcontextprotocol/server-terminal` with an allowlist of commands (e.g. `npm`, `node`, `npx`, `git`, `pwsh`, `powershell`, `cmd`). Extend the list as needed for `uv`, `make`, `docker`, etc.

---

## Summary

| MCP                 | Role           | Supports workflow step              |
|---------------------|----------------|-------------------------------------|
| filesystem-mcp      | Foundation     | Spec/skills/tests layout and reads  |
| git-mcp             | Version control| Branch-per-feature, commits         |
| sequentialthinking-mcp | Architect   | Plan and reason before coding       |
| terminal-mcp        | Execution      | Run tests, builds, and tooling     |

Together, these tools let the AI follow the constitution (specs first, Planner–Worker–Judge, MCP-only external I/O) and execute the Spec Kit + TDD workflow end to end.
