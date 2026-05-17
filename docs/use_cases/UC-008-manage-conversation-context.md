# UC-008 Manage Conversation Context

## Overview

- **ID:** UC-008
- **Name:** Manage Conversation Context
- **Primary Actor:** Developer
- **Goal:** Keep the conversation within the model's context window by compacting, clearing, or rewinding it.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).

## Main Success Scenario

1. The developer asks to compact the conversation with `/compact`, optionally adding instructions for the summary.
2. The system asks the model to summarize the conversation so far.
3. The system replaces the older messages with the summary, keeping the system prompt.
4. The system reports the context tokens before and after.
5. The conversation continues with the reduced context.

## Alternative Flows

- **A1 — Clear the conversation (from step 1):** With `/clear` the system discards the conversation history and starts a fresh exchange, keeping the system prompt.
- **A2 — Rewind to an earlier message (from step 1):** With `/rewind` or the rewind shortcuts the developer selects an earlier point; the system removes everything after it, restoring that earlier state.
- **A3 — Automatic compaction:** When context tokens cross the active model's auto-compact threshold during a turn, the system compacts automatically without an explicit command (BR-007).

## Postconditions

- **Success:** The conversation context is smaller or reset; cumulative session statistics are preserved where applicable.
- **Failure:** The conversation is left unchanged.

## Business Rules

- **BR-018:** Compaction summarizes the conversation into a single message and preserves the system prompt as the first message.
- **BR-019:** Clearing the conversation removes history but keeps the system prompt.
- **BR-020:** Rewinding removes all messages after the chosen point and may roll back associated file state.
