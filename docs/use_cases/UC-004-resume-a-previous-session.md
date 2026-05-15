# UC-004: Resume a Previous Session

## Overview

- **ID**: UC-004
- **Name**: Resume a Previous Session
- **Primary Actor**: Developer
- **Goal**: Continue a coding conversation that was started earlier, with the full message history, todo list, and metadata intact.
- **Status**: Implemented

## Preconditions

- At least one prior session has been recorded under the Vibe home directory's `logs/` tree (or the configured `session_logging.save_dir`).
- The developer is either at a fresh CLI invocation (`vibe --resume`, `vibe -c`) or inside an active session (`/resume`).

## Main Success Scenario

1. Developer invokes a resume command: `vibe -c` (or `--continue`) to pick up the most recent session for the current working directory, `vibe --resume` to open a picker, `vibe --resume <session_id>` to resume a known session, or `/resume` from inside an active session.
2. System scans the session log directories, loads valid sessions, and (when filtering by working directory) keeps only sessions whose recorded working directory matches the current one.
3. If the developer chose `--continue`, system selects the most recent matching session automatically; otherwise system displays a picker showing each session's title, working directory, start time, and short ID.
4. Developer selects the session to resume (or, in `--continue`, the selection is implicit).
5. System loads the metadata and replays the persisted messages into the conversation, restoring the active model, agent profile, and todo list.
6. System opens a new session log entry that links back to the resumed session as its parent, preserving the resumed history under the new session ID.
7. System hands control to the developer at the prompt, who continues the conversation in UC-002.

## Alternative Flows

- **A1**: Trigger at step 2 — No valid sessions are found. System reports that there is nothing to resume and exits (or returns to the prompt in the slash-command flow).
- **A2**: Trigger at step 3 — Developer cancels the picker. System exits (or returns to the prompt) without loading any session.
- **A3**: Trigger at step 1 — The supplied session ID does not resolve to any saved session. System reports the missing session and exits with a non-zero status.
- **A4**: Triggered by the developer at any time inside an active session — Developer invokes `/rename <new title>`. System updates the saved session's title in `meta.json` and marks the title source as `manual`.

## Postconditions

- **Success**: The current process is running an interactive conversation that contains every persisted message from the chosen session, plus any new turns since the resume; the new session's metadata records the parent session ID.
- **Failure**: No session is opened; the previous state on disk is unchanged.

## Business Rules

- **BR-021**: A session is considered resumable only when its directory contains both `meta.json` and a non-empty `messages.jsonl`.
- **BR-022**: `--continue` filters resumable sessions by the current working directory; `--resume` without an ID does not filter by working directory.
- **BR-023**: Resuming a session creates a new session ID and records the original session ID as the new session's `parent_session_id`; the original session remains untouched on disk.
