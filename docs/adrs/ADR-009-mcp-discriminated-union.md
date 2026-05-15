# ADR-009: MCP transports modelled as a discriminated union

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

The Model Context Protocol supports multiple transports: stdio (spawned
process talking JSON-RPC over pipes), HTTP, and streamable-HTTP (HTTP
with SSE). The fields a server needs depend on its transport — an stdio
server has `command`/`args`, an HTTP server has `url`/`headers`.

`AGENTS.md:49-50` documents the Pydantic pattern the team adopted:

> Discriminated unions (e.g. MCP `transport`): use sibling final
> classes plus a shared base/mixin, and compose with
> `Annotated[Union[...], Field(discriminator=...)]`. Never narrow the
> discriminator field in a subclass — it violates LSP and pyright will
> reject it.

Source: `vibe/core/config/_settings.py:229-339`.

## Decision

Express MCP transport variants as sibling final classes (`MCPHttp`,
`MCPStreamableHttp`, `MCPStdio`) sharing a base mixin (`_MCPBase`) and a
fields mixin per family (`_MCPHttpFields`). Compose with
`Annotated[Union[...], Field(discriminator="transport")]`. Never narrow
the `transport` literal in a subclass.

## Status notes

**[OPEN — Q3.9.1]** — alternatives (subclass-per-variant, tagged-union
manual parsing, schema-less dicts) and the rule on LSP violations are
documented in AGENTS.md but not in an ADR with explicit trade-offs.

## Consequences

Positive:

- Pydantic statically narrows the type after parsing.
- New transports can be added with a single sibling class.
- Pyright catches LSP violations at the source.

Negative:

- Every transport-specific field needs a mixin to avoid duplication.
- The `transport: Literal["http"]` field in each subclass must stay
  literal — easy to break accidentally.

## Alternatives and Pugh Matrix

| Criterion | Discriminated union (chosen) | Subclass per variant | Manual `if/elif` parsing | Schema-less dict |
|---|---|---|---|---|
| Type narrowing after parsing | +1 | 0 | -1 | -1 |
| Extensibility | +1 | 0 | -1 | +1 |
| Pyright strictness | +1 | -1 | -1 | -1 |
| Authoring ergonomics | 0 | -1 | -1 | +1 |
| Risk of LSP violation | -1 | -1 | 0 | n/a |
| Total | ? | ? | ? | ? |
