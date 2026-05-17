# UC-002 Converse with the Coding Agent

## Overview

- **ID:** UC-002
- **Name:** Converse with the Coding Agent
- **Primary Actor:** Developer
- **Goal:** Give the agent a natural-language instruction and have it explore, modify, or explain the codebase using its tools.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).
- A model and provider are configured and reachable.

## Main Success Scenario

1. The developer types a message and submits it.
2. The system records the message and shows it in the transcript.
3. The system sends the conversation, system prompt, and available tool definitions to the Mistral Platform.
4. The system streams the assistant's reply, showing reasoning and text as it arrives.
5. If the assistant requests one or more tool calls, the system runs each tool and feeds the result back into the conversation (UC-003).
6. The system repeats steps 3-5 until the assistant produces a final answer with no further tool calls.
7. The system displays the final answer and updates session statistics (steps, tokens, cost, tokens per second).
8. The system saves the turn to the session log if session logging is enabled.

## Alternative Flows

- **A1 — Tool needs approval (from step 5):** A non-auto-approved tool triggers an approval prompt (UC-003); if rejected, the rejection is reported back to the agent.
- **A2 — Agent asks a question (from step 5):** The agent invokes the question tool and the developer answers before the turn continues (UC-004).
- **A3 — Context near the limit (from step 3):** When context tokens cross the auto-compact threshold, the system compacts the conversation before continuing (UC-008).
- **A4 — Turn or cost cap reached (from step 6):** In a capped session, the system stops after the configured maximum turns or maximum price.
- **A5 — Rate limited (from step 3):** The system reports the rate limit and lets the developer retry.
- **A6 — Context too long (from step 3):** The system reports the limit and suggests rewinding and compacting.
- **A7 — Developer interrupts (any step):** Pressing Escape interrupts the running turn and returns to the prompt.

## Postconditions

- **Success:** The conversation contains the new exchange, statistics are updated, and any file or system changes the tools made are applied.
- **Failure:** The turn is aborted; an error message is shown and the conversation is left in a consistent state.

## Business Rules

- **BR-004:** Each turn appends to a running message list; the system prompt always occupies the first slot.
- **BR-005:** The agent loop continues calling the model as long as the model returns tool calls and no cap is hit.
- **BR-006:** Session cost is a worst-case estimate computed from token counts and per-million pricing; prompt caching may make the real cost lower.
- **BR-007:** Conversation context auto-compacts when context tokens reach the active model's `auto_compact_threshold`.
