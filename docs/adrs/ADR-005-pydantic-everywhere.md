# ADR-005: External-data parsing — Pydantic everywhere

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

Vibe parses many external data sources: TOML config, dotenv files, LLM
provider responses (Mistral, OpenAI Chat, OpenAI Responses, Anthropic,
Vertex), MCP messages, ACP messages, skill front-matter, agent profile
TOMLs, hook TOMLs, session metadata, telemetry payloads. The convention
documented in `AGENTS.md:46-50`:

> Parse external data via `model_validate`, `field_validator`, or
> `model_validator(mode="before")` — never ad-hoc `getattr` / `hasattr`
> walks or custom `from_sdk` constructors.
> Set `ConfigDict(extra=…)` explicitly. Use `validation_alias` (or field
> aliases) for kebab-case TOML keys.
> Discriminated unions: sibling final classes plus a shared base/mixin,
> composed with `Annotated[Union[...], Field(discriminator=...)]`.

## Decision

Use Pydantic for every external-data boundary. Use `BaseSettings` for
config (multi-source resolution). Use discriminated unions for protocol
variants (MCP transport, LLM backend).

## Status notes

**[OPEN — Q3.9.1]** — alternatives (attrs, msgspec, dataclasses +
cattrs, hand-rolled validation) and the chosen Pydantic major version
trajectory (Pydantic v2 is required by `pyproject.toml:44`) are
unrecorded.

## Consequences

Positive:

- One toolchain for all parsing, validation, serialisation.
- Discriminated unions enforce LSP-safe variants
  (`vibe/core/config/_settings.py:307-339`).
- Strict pyright cooperation (Pydantic v2's typing is strong).

Negative:

- Pydantic v2 import/setup is heavier than alternatives; affects CLI
  cold-start time.
- The "never narrow the discriminator field in a subclass" rule
  (`AGENTS.md:49`) is easy to violate and pyright-reject.

## Alternatives and Pugh Matrix

| Criterion | Pydantic v2 (chosen) | attrs + cattrs | msgspec | dataclasses + manual |
|---|---|---|---|---|
| Parsing performance | 0 | 0 | +1 | -1 |
| Strict pyright cooperation | +1 | 0 | 0 | -1 |
| Settings (multi-source config) | +1 | -1 | -1 | -1 |
| Discriminated unions ergonomics | +1 | 0 | 0 | -1 |
| Cold-start time | -1 | 0 | +1 | +1 |
| Ecosystem (`pydantic-settings`) | +1 | -1 | -1 | -1 |
| Total | ? | ? | ? | ? |
