# UC-006: Manage Conversation Context

## Overview

- **ID:** UC-006
- **Name:** Manage Conversation Context
- **Primary Actor:** Developer
- **Goal:** Keep the conversation focused and within model limits by clearing, summarizing, or rewinding history.
- **Status:** Implemented

## Preconditions

- An interactive session is in progress (see UC-003).

## Main Success Scenario

1. The developer decides the conversation history needs to be managed.
2. The developer chooses an action: clear the history, compact it into a summary, or rewind to an earlier message.
3. For a clear, the system discards the conversation and starts fresh.
4. For a compaction, the system summarizes the earlier conversation — optionally guided by instructions from the developer — and replaces the detailed history with the summary.
5. For a rewind, the system returns the conversation to the selected earlier message and discards everything after it.
6. The system continues the session with the adjusted context.

## Alternative Flows

- **A1 — Automatic compaction.** Trigger: the conversation reaches the configured token threshold during a turn. The system compacts the history automatically before continuing.
- **A2 — Rewind cancelled.** Trigger: the developer opens the rewind view but dismisses it without selecting a message. The system leaves the conversation unchanged.
- **A3 — Compaction guided by instructions.** Trigger: the developer supplies instructions with the compaction request. The system uses them to shape the summary.

## Postconditions

- **Success:** The conversation context reflects the chosen action — empty, summarized, or rewound — and the session continues.
- **Failure:** The conversation is left unchanged.

## Business Rules

- **BR-015:** When the conversation reaches the configured token threshold, the system compacts the history automatically.
