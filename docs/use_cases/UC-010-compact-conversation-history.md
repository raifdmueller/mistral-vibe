# UC-010: Compact Conversation History

## Overview

| Field | Value |
|---|---|
| **ID** | UC-010 |
| **Name** | Compact Conversation History |
| **Primary Actor** | Developer |
| **Goal** | Replace the older portion of the conversation with a generated summary so the agent stays within its context window while keeping the gist of earlier work. |
| **Status** | Implemented |

## Preconditions

- An interactive session is in progress with sufficient history to be worth summarising.

## Main Success Scenario

1. The developer issues the `/compact` slash command, optionally followed by guidance for the summary.
2. The system gathers the messages eligible for compaction (typically all but the most recent exchanges).
3. The system sends those messages to the compaction model along with the developer's guidance.
4. The compaction model returns a structured summary.
5. The system replaces the compacted messages in the running context with a single summary message.
6. The system reports how many tokens were freed and continues the session with the reduced context.

## Alternative Flows

### A1 — Automatic compaction

Trigger: During UC-003 step 3, the running context size exceeds the model's auto-compact threshold and `enable_auto_update` has not been suppressed.

1. The system runs steps 2–5 automatically before sending the next LLM request.
2. The flow continues from UC-003 step 3.

### A2 — Compaction model unavailable

Trigger: At step 3, the compaction model is not configured or its provider lacks credentials.

1. The system falls back to using the active chat model for compaction.

### A3 — Compaction fails

Trigger: At step 4, the compaction model returns an error.

1. The system surfaces the error and leaves the conversation untouched.

## Postconditions

- **Success**: The conversation context contains a summary message in place of the compacted messages; the persisted session log records the summary alongside the original messages so they remain auditable.
- **Failure**: The conversation is unchanged.

## Business Rules

- **BR-037**: Auto-compaction is governed per-model by `auto_compact_threshold`; the global default is 200 000 tokens.
- **BR-038**: The compaction model is configured separately from the chat model; when absent, the active chat model performs compaction.
- **BR-039**: Compaction never removes the most recent user prompt or its pending response.
