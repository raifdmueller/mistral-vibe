# UC-006: Select Active Model

## Overview

| Field | Value |
|---|---|
| **ID** | UC-006 |
| **Name** | Select Active Model |
| **Primary Actor** | Developer |
| **Goal** | Switch the LLM used by the assistant — for example, to use a stronger model for hard problems or a cheaper one for routine edits — and optionally adjust the thinking level. |
| **Status** | Implemented |

## Preconditions

- An interactive session is in progress.
- At least one model is configured for at least one provider with valid credentials.

## Main Success Scenario

1. The developer issues the `/model` slash command.
2. The system lists the configured models, marking the currently active one.
3. The developer selects a different model.
4. The system updates the active model alias in the running configuration.
5. The system updates token-pricing information so subsequent stats reflect the new model.
6. The system confirms the change to the developer.

## Alternative Flows

### A1 — Adjust thinking level

Trigger: At step 1, the developer instead issues the `/thinking` slash command.

1. The system shows the available thinking levels (off, low, medium, high) for the active model.
2. The developer selects a level.
3. The system updates the active model's `thinking` setting for this session.

### A2 — Selected model belongs to a provider without credentials

Trigger: At step 4, the model's provider has no API key available.

1. The system reports the missing key and the corresponding environment variable name.
2. The flow returns to step 2 without changing the active model.

## Postconditions

- **Success**: The active model alias and pricing are updated for the current session; the next LLM request uses the new model.
- **Failure**: The active model and thinking level are unchanged.

## Business Rules

- **BR-023**: Each model declares a `provider`, an `alias` (the name used in `active_model`), a temperature, optional thinking level, and per-million-token input/output prices.
- **BR-024**: Switching models mid-session keeps the existing conversation; cumulative cost estimates use the *current* model's prices for all accumulated tokens.
- **BR-025**: A separate compaction model can be configured for context summarisation independently of the active chat model.
