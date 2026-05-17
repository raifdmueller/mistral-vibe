# UC-005 Switch Model and Agent

## Overview

- **ID**: UC-005
- **Name**: Switch Model and Agent
- **Primary Actor**: Developer
- **Goal**: Choose which model, thinking level, and agent profile the assistant uses for the work at hand.
- **Status**: Implemented

## Preconditions

- A session is running and at least one model is configured.

## Main Success Scenario

1. The developer issues a model, thinking, or agent command.
2. The system shows the available choices with their descriptions.
3. The developer selects an option.
4. The system applies the selection to the running session.
5. Subsequent prompts use the newly selected model, thinking level, or agent.

## Alternative Flows

- **A1 — Agent chosen at launch** (step 1): the developer passes an agent name on the command line; the system uses that agent from the start.
- **A2 — Custom agent profile** (step 2): a custom agent profile exists on disk; the system includes it among the choices.
- **A3 — Thinking level change** (step 1): the developer adjusts the thinking level; the system changes how much reasoning the model performs before answering.

## Postconditions

- **Success**: The session uses the chosen model, thinking level, or agent for following turns.
- **Failure**: The previous selection stays in effect and an error is shown.

## Business Rules

- **BR-007**: Builtin agent profiles include default, plan, accept-edits, auto-approve, explore, and lean; an agent profile defines its allowed tools and system prompt.
- **BR-008**: In interactive mode the active agent defaults to the configured default agent; the explicit launch argument overrides it.
