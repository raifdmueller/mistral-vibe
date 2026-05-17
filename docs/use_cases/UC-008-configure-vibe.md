# UC-008 Configure Vibe

## Overview

- **ID:** UC-008
- **Name:** Configure Vibe
- **Primary Actor:** Developer
- **Goal:** Adjust how Mistral Vibe behaves — active model, thinking level, models and providers, and other settings.
- **Status:** Implemented

## Preconditions

- Mistral Vibe is installed; an interactive session is running, or the Developer is editing configuration files directly.

## Main Success Scenario

1. The Developer opens the settings view or asks to change the active model or thinking level.
2. The system shows the current settings and the available choices.
3. The Developer selects a new value.
4. The system validates the change and applies it to the running session.
5. The system writes the change to the user configuration so it persists.

## Alternative Flows

- **A1 — Edit configuration files directly (diverges at step 1):** The Developer edits a user or project configuration file outside the session; on the next start or reload, the system reads and merges the layers.
- **A2 — Reload configuration (diverges at step 1):** The Developer asks to reload; the system re-reads configuration, agent instructions, and skills from disk and applies them.
- **A3 — Environment-variable override (diverges at step 4):** A `VIBE_*` environment variable overrides the field; the system uses the environment value.
- **A4 — Invalid value (diverges at step 4):** The chosen value fails validation; the system rejects it and keeps the previous value.
- **A5 — Configure proxy and certificates (diverges at step 1):** The Developer opens proxy setup and sets proxy or certificate options; the system stores them for outbound connections.
- **A6 — Conflicting layers (diverges at step 1):** Two layers both set a conflict-merge field; the system reports the conflict and refuses to load until it is resolved.

## Postconditions

- **Success:** The setting is in effect for the session and, where applicable, persisted for future sessions.
- **Failure:** The setting is unchanged; the Developer was told why.

## Business Rules

- **BR-019:** Configuration is layered — built-in defaults, then user, then project — and higher layers override lower ones according to each field's merge strategy.
- **BR-020:** Any configuration field can be overridden by a matching `VIBE_*` environment variable.
- **BR-021:** A field marked conflict-merge may be set by at most one layer.
