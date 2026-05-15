# ADR-004: Concurrency model — asyncio

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

The agent loop must interleave network I/O (LLM provider, MCP servers,
telemetry), local I/O (file reads/writes, shell subprocesses), TUI
rendering (Textual is event-loop based), and ACP message handling on
stdin/stdout. `AGENTS.md:51-54` documents the choice:

> `asyncio` is the orchestration runtime in the agent loop and tool
> execution. Use `asyncio.create_task` + queues for concurrent work,
> not blanket `gather`.
> Use `anyio.Path` for file I/O on async paths.
> Streaming surfaces return `AsyncGenerator[Event, None]`, not coroutines.
> HTTP via `httpx.AsyncClient`; mock with `respx` in tests.

## Decision

Use `asyncio` as the single orchestration runtime. Adopt `anyio` for
file paths so paths remain backend-agnostic. Use `httpx.AsyncClient` for
HTTP and `respx` for tests. Tool execution exposes
`AsyncGenerator[Event, None]` so progress can be streamed.

## Status notes

**[OPEN — Q3.9.1]** — alternatives considered (threads, trio, anyio's
trio backend, processes) are not on record.

## Consequences

Positive:

- Textual integrates natively with asyncio.
- Streaming progress to the UI fits the generator model.
- Test mocking is uniform (`respx`).

Negative:

- Blocking calls (sounddevice for audio, subprocess for bash) must be
  wrapped carefully to avoid event-loop stalls.
- Async-everywhere has a learning-curve cost; `AGENTS.md:51` discourages
  "blanket `gather`" — implying the team has been bitten by it.

## Alternatives and Pugh Matrix

| Criterion | asyncio (chosen) | Threads + queues | trio | Process pool |
|---|---|---|---|---|
| Textual integration | +1 | -1 | 0 | -1 |
| HTTP streaming | +1 | 0 | +1 | -1 |
| Subprocess interaction | 0 | +1 | 0 | +1 |
| Cancellation semantics | ? | -1 | +1 | 0 |
| Ecosystem (httpx, anyio, mcp lib) | +1 | 0 | +1 | -1 |
| Total | ? | ? | ? | ? |
