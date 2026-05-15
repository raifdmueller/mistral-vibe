# ADR-003: Architectural style — hexagonal `_port.py` suffix

- **Status:** Accepted (inferred, applied to newer modules only)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

`AGENTS.md:23` documents the convention: "Abstract interfaces use the
`_port.py` suffix (hexagonal-style ports)." The newer modules follow it
(`vibe/cli/plan_offer/ports/`, `vibe/cli/turn_summary/port.py`), but the
largest core module — `vibe/core/agent_loop.py`, 1716 lines — is not
strictly hexagonal. Backends and tools are wired by string identifiers
through `ToolManager` and `BackendFactory`, not by injected ports.

## Decision

Adopt hexagonal / ports-and-adapters where introducing new modules; do
not retroactively refactor the existing engine.

## Status notes

**[OPEN — Q3.4.1.a]** — whether hexagonal is the official target style
for the whole codebase or just for newer modules is unconfirmed. The
inferred reading of the code is "applied to newer modules only".

## Consequences

Positive:

- Test doubles are easy to inject in modules that use ports
  (`tests/stubs/Fake*` matches the convention from `AGENTS.md:25`).
- Boundaries are explicit and discoverable by filename.

Negative:

- Mixed style across the codebase — readers must know which area follows
  which convention.
- Refactoring the agent loop into ports is a separate, large effort
  **[OPEN — Q5.2.a]**.

## Alternatives and Pugh Matrix

| Criterion | Hexagonal ports (chosen) | Layered architecture | Free-form | Clean Architecture |
|---|---|---|---|---|
| Test injection | +1 | 0 | -1 | +1 |
| Discoverability of boundaries | +1 | 0 | -1 | +1 |
| Cognitive cost for newcomers | ? | ? | ? | ? |
| Refactoring cost of existing code | ? | ? | ? | ? |
| Conformance to project's stated intent | +1 | -1 | -1 | 0 |
| Total | ? | ? | ? | ? |
