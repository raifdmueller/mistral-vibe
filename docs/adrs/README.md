# Architecture Decision Records

These ADRs follow Nygard's format (Context, Decision, Status, Consequences)
plus a Pugh matrix per the project's quality contract (`CLAUDE.md` →
*Architecture Documentation*).

All ten records carry status **Accepted (inferred)** because no stakeholder
has confirmed the original rationale. Pugh-matrix cells that require team
judgement are filled with `?` rather than guessed.

Open questions blocking promotion of these ADRs to *Accepted* are tracked
in [`../OPEN_QUESTIONS.adoc`](../OPEN_QUESTIONS.adoc), specifically
Q3.9.1 and its sub-items.

| ID | Topic |
|---|---|
| [ADR-001](ADR-001-textual-tui.md) | TUI framework: Textual |
| [ADR-002](ADR-002-uv-exclude-newer.md) | Dependency freshness policy: `[tool.uv].exclude-newer` |
| [ADR-003](ADR-003-hexagonal-ports.md) | Architectural style: hexagonal `_port.py` suffix |
| [ADR-004](ADR-004-asyncio.md) | Concurrency model: asyncio |
| [ADR-005](ADR-005-pydantic-everywhere.md) | External-data parsing: Pydantic everywhere |
| [ADR-006](ADR-006-telemetry-routing.md) | Telemetry routed through primary Mistral provider |
| [ADR-007](ADR-007-install-channels.md) | Install channels: `curl | bash`, `uv`, `pip` |
| [ADR-008](ADR-008-agent-profile-overlay.md) | Agent profiles overlay `VibeConfig` |
| [ADR-009](ADR-009-mcp-discriminated-union.md) | MCP transports as discriminated union |
| [ADR-010](ADR-010-session-log-format.md) | Session log format: JSONL + JSON metadata |
