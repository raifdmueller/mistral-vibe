# UC-004 Manage Conversation Context

## Overview

- **ID**: UC-004
- **Name**: Manage Conversation Context
- **Primary Actor**: Developer
- **Goal**: Keep the conversation within useful limits by clearing, compacting, or rewinding history.
- **Status**: Implemented

## Preconditions

- An interactive session is running.

## Main Success Scenario

1. The developer decides the current context is too long or no longer useful.
2. The developer issues a context command (clear, compact, or rewind).
3. For a compact request, the system asks the model to summarize the conversation, optionally guided by instructions.
4. The system replaces the old history with the new, smaller context.
5. The system confirms the change and shows the updated state.

## Alternative Flows

- **A1 — Clear history** (step 2): the developer clears the conversation; the system discards all messages and starts an empty context.
- **A2 — Rewind to an earlier message** (step 2): the developer picks an earlier point; the system removes everything after it and restores that state.
- **A3 — Automatic compaction** (step 1): token usage crosses the auto-compact threshold; the system compacts the history without an explicit command.
- **A4 — Status request**: the developer asks for status; the system displays token usage, cost, and other session statistics without changing context.

## Postconditions

- **Success**: The conversation context reflects the requested change; session statistics are updated.
- **Failure**: The original context is left unchanged and an error is shown.

## Business Rules

- **BR-006**: Compaction summarizes the conversation using the configured compaction model, falling back to the active model when none is set.
- **BR-001**: Conversation history is automatically compacted when token usage reaches the auto-compact threshold (default 200,000 tokens).
