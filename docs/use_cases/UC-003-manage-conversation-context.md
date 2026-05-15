# UC-003: Manage Conversation Context

## Overview

- **ID**: UC-003
- **Name**: Manage Conversation Context
- **Primary Actor**: Developer
- **Goal**: Keep the working conversation focused and within the model's context budget by clearing, compacting, rewinding, or inspecting the running session.
- **Status**: Implemented

## Preconditions

- An interactive session is in progress.
- The developer is at the input prompt (no tool call is currently executing).

## Main Success Scenario

1. Developer chooses how to manage the context: `/clear` to start fresh, `/compact` to summarize the conversation so far, `/rewind` to undo recent turns, or `/status` to inspect the running totals.
2. System validates that the chosen command is allowed in the current state (e.g. there is something to compact, there is at least one turn to rewind).
3. If the developer chose `/clear`, system discards the in-memory conversation, opens a new session log, and resets all running counters.
4. If the developer chose `/compact`, system summarizes the existing conversation through the compaction model (optionally biased by free-form instructions the developer typed after the command), replaces the in-memory conversation with the summary, and records the compaction event in the session log.
5. If the developer chose `/rewind`, system presents the recent messages, the developer picks one to rewind to, and system restores the conversation, the todo list, and any file snapshots captured at that point.
6. If the developer chose `/status`, system displays token usage, cost so far, message count, active model, active agent, and the auto-compact threshold.
7. System returns the developer to the input prompt, ready for the next message.

## Alternative Flows

- **A1**: Trigger at step 4 — Compaction model returns an error. System keeps the unaltered conversation, reports the failure to the developer, and remains at the prompt.
- **A2**: Trigger at step 5 — No file snapshot exists for the chosen rewind target. System rewinds the conversation only and warns the developer that files on disk were not restored.
- **A3**: Triggered automatically — Token usage crosses the active model's `auto_compact_threshold`. System runs the same compaction flow as in step 4 with no developer input and continues the next turn (see UC-002 A3).

## Postconditions

- **Success**: The in-memory conversation reflects the requested operation; the session log records the operation and remains the source of truth for future resumes.
- **Failure**: The conversation is unchanged and the developer is back at the prompt.

## Business Rules

- **BR-016**: `/clear` ends the current session (the existing log directory is closed) and starts a new one with its own session ID.
- **BR-017**: `/compact` preserves the developer's most recent user message and replaces all earlier turns with a single summary message produced by the compaction model.
- **BR-018**: Automatic compaction is triggered when the conversation's input-token count reaches the active model's `auto_compact_threshold` (default 200 000 tokens).
- **BR-019**: `/rewind` may restore file contents from the snapshot captured at the chosen checkpoint; if no snapshot is available, only the conversation is rewound.
- **BR-020**: `/status` displays cumulative input tokens, output tokens, cached tokens, dollar cost, and tool-call counts for the current session.
