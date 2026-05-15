# ADR-008: Agent profiles overlay `VibeConfig`

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

Agent profiles (default, plan, accept-edits, auto-approve, chat, explore,
lean, plus custom user TOMLs) need to change Vibe's behaviour — different
system prompt, different tool permissions, different model, different
disabled-tool list. The team chose to express each profile as a partial
`VibeConfig` overlay rather than a separate DSL.

Source: `vibe/core/agents/models.py:46-99`. The merge function is
`_deep_merge` at line 16; profile fields can override any `VibeConfig`
field, and `base_disabled` augments `disabled_tools`.

## Decision

Represent every agent profile as a TOML file whose keys map onto the same
schema as `~/.vibe/config.toml`. Apply the profile by deep-merging it on
top of the base config at load time. Reserve a small set of keys
(`display_name`, `description`, `safety`, `agent_type`, `install_required`,
`base_disabled`) for profile-level metadata.

## Status notes

**[OPEN — Q3.9.1]** — alternatives (a separate profile DSL, JSON
inheritance, class-based subclassing) and the trade-off with config
discoverability are not on record.

## Consequences

Positive:

- One schema to learn — users who know `config.toml` know how to write
  a profile.
- Profiles can override arbitrarily, including `providers` and `models`
  (the built-in `lean` profile uses this to pin a specialised model:
  `vibe/core/agents/models.py:165-200`).

Negative:

- Profiles can subtly mis-merge — list-typed fields, dict-typed fields,
  and per-tool overrides each have different merge semantics
  (`vibe/core/config/schema.py:107-150`).
- The "base_disabled" key is special-cased outside the deep-merge logic
  (lines 64-69), which is a small DSL hiding in the config overlay.
- Programmatic mode forces `auto-approve` and ignores `default_agent`
  (`BR-021`); the overlay model is not the only behaviour-controlling
  layer.

## Alternatives and Pugh Matrix

| Criterion | Config overlay (chosen) | Separate profile DSL | Class-based subclassing | Single-config flag |
|---|---|---|---|---|
| Authoring ergonomics | +1 | 0 | -1 | +1 |
| Override expressiveness | +1 | +1 | +1 | -1 |
| Schema discoverability | +1 | 0 | -1 | +1 |
| Risk of subtle mis-merge | -1 | 0 | -1 | +1 |
| Testability | 0 | 0 | -1 | +1 |
| Total | ? | ? | ? | ? |
