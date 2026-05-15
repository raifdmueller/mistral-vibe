# UC-009: Rewind the Conversation

## Overview

| Field | Value |
|---|---|
| **ID** | UC-009 |
| **Name** | Rewind the Conversation |
| **Primary Actor** | Developer |
| **Goal** | Step back to an earlier point in the conversation, discarding the assistant's turns after that point, so the developer can re-prompt with a different instruction. |
| **Status** | Implemented |

## Preconditions

- An interactive session is in progress and contains at least one prior user message.

## Main Success Scenario

1. The developer enters rewind mode via the `/rewind` slash command or the rewind keyboard shortcut.
2. The system shows the previous user messages in the transcript as selectable anchors.
3. The developer navigates to the message they want to rewind to.
4. The developer confirms the selection.
5. The system truncates the conversation so the selected user message becomes the most recent one.
6. The system updates the on-disk session log to reflect the truncation.
7. The system returns the input prompt to the developer for a fresh follow-up.

## Alternative Flows

### A1 — Developer cancels rewind

Trigger: At step 3 or 4, the developer presses Escape.

1. The system leaves rewind mode without changing the transcript.

### A2 — No earlier user messages available

Trigger: At step 1, the session has no previous user messages.

1. The system reports that there is nothing to rewind to.

### A3 — Tool side effects on the workspace cannot be undone

Trigger: At step 5, the truncated turns included tool calls that wrote to files or ran shell commands.

1. The system rewinds the conversation only; it does not roll back filesystem changes.
2. The system surfaces this caveat in the rewind confirmation message.

## Postconditions

- **Success**: The session transcript is truncated at the chosen anchor; the persisted message log reflects the new length.
- **Failure**: The transcript is unchanged.

## Business Rules

- **BR-035**: Rewind operates on the conversation history only; it does not reverse external side effects such as file edits, shell commands, or web requests.
- **BR-036**: After a rewind, the next assistant turn is generated from the truncated context as if the discarded turns had never happened.
