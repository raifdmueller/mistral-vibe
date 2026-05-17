# UC-007 Manage Conversation Context

## Overview

- **ID:** UC-007
- **Name:** Manage Conversation Context
- **Primary Actor:** Developer
- **Goal:** Keep the conversation within useful limits — shrink it, undo part of it, or clear it — without ending the session.
- **Status:** Implemented

## Preconditions

- An interactive session is running with a conversation in progress.

## Main Success Scenario

1. The Developer asks to compact the conversation, optionally giving guidance for the summary.
2. The system summarizes the conversation so far into a compact form.
3. The system replaces the older history with the summary and keeps the session running.
4. The system reports the reduced context size to the Developer.

## Alternative Flows

- **A1 — Automatic compaction (diverges at step 1):** Token usage crosses the model's auto-compact threshold during a turn; the system compacts the conversation on its own and continues.
- **A2 — Clear the conversation (diverges at step 1):** The Developer asks to clear history; the system discards the conversation and starts an empty one in the same session.
- **A3 — Rewind the conversation (diverges at step 1):** The Developer asks to rewind; the system shows earlier messages, the Developer picks one, and the system discards every message after that point so the Developer can take a different path.

## Postconditions

- **Success:** The conversation has been compacted, cleared, or rewound; the session is still running.
- **Failure:** The conversation is unchanged and the Developer was told why.

## Business Rules

- **BR-017:** The conversation is compacted automatically when token usage crosses the active model's auto-compact threshold.
- **BR-018:** Rewinding discards every message after the selected point.
