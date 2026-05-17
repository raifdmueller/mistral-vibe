# UC-007 Select Model and Thinking Level

## Overview

- **ID:** UC-007
- **Name:** Select Model and Thinking Level
- **Primary Actor:** Developer
- **Goal:** Choose which model the agent uses and how much reasoning effort it applies.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).
- At least one model is configured.

## Main Success Scenario

1. The developer opens the model picker with the `/model` command.
2. The system lists the configured models.
3. The developer selects a model.
4. The system makes that model active and updates pricing used for cost estimates.
5. The developer optionally opens the thinking picker with `/thinking`.
6. The developer selects a thinking level.
7. The system applies the thinking level to subsequent turns.

## Alternative Flows

- **A1 — Model change resets context state (from step 4):** Context-related statistics are reset while cumulative session totals are preserved.

## Postconditions

- **Success:** The chosen model and thinking level apply to the next turn.
- **Failure:** The prior model and thinking level remain active.

## Business Rules

- **BR-016:** Each model carries its own thinking level, temperature, and auto-compact threshold.
- **BR-017:** Changing the model mid-session recomputes cost estimates with the new pricing for all accumulated tokens.
