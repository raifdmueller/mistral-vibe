# Mistral Vibe Documentation

Welcome to the Mistral Vibe documentation! For basic setup, see the [main README](https://github.com/mistralai/mistral-vibe#readme).

## Available Documentation

### Setup

- **[ACP Setup](acp-setup.md)** - Setup instructions for using Mistral Vibe with various editors and IDEs that support the Agent Client Protocol.
- **[Proxy Setup](proxy-setup.md)** - Configure proxy and SSL certificate settings for corporate networks or firewalls.

### Reverse-engineered specification (AIUP)

These artifacts were recovered from the existing code base using the AI
Unified Process. They reflect *what the code does today*; items the team
has not yet confirmed are kept as `[OPEN — Q-ID]` markers.

- **[Product Requirements Document](prd.md)** — problem, goals, personas,
  scope, success criteria.
- **[Use Case Diagram](use_cases.puml)** — overview of seventeen use cases
  and their actors.
- **[Use Case Specifications](use_cases/)** — UC-001 to UC-017 in Cockburn
  fully-dressed form.
- **[Entity Model](entity_model.md)** — domain entities with a Mermaid ER
  diagram.

### CLI and data contracts

- **[CLI command specification](specification/cli-commands.md)** — flags,
  environment variables, exit codes, slash commands.
- **[Data formats](specification/data-formats.md)** — config TOML, session
  JSONL, skill front-matter, agent profile TOML, hook TOML.
- **[Acceptance criteria (Gherkin)](specification/acceptance-criteria.md)** —
  scenarios per use case.

### Architecture (arc42)

- **[arc42 architecture document](architecture/arc42.md)** — all 12 sections,
  with PlantUML and Mermaid diagrams.
- **[Architecture Decision Records](adrs/)** — ten ADRs (Status: *Accepted
  (inferred)*); Pugh matrix cells requiring team judgement are marked `?`.

### Code-theory recovery (Naur 1985)

- **[Question Tree](QUESTION_TREE.adoc)** — Phase-1 output of the Socratic
  Code-Theory Recovery workflow; 78 leaves with code evidence or routing
  metadata.
- **[Open Questions](OPEN_QUESTIONS.adoc)** — the 24 `[OPEN]` leaves grouped
  by Ask role (Product Owner, Architect, Developer, Operations).
