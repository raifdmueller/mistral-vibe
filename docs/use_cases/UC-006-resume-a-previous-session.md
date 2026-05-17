# UC-006 Resume a Previous Session

## Overview

- **ID:** UC-006
- **Name:** Resume a Previous Session
- **Primary Actor:** Developer
- **Goal:** Continue an earlier conversation with its full history, instead of starting over.
- **Status:** Implemented

## Preconditions

- At least one earlier session was saved by the system.

## Main Success Scenario

1. The Developer asks to resume a session, either at startup or while a session runs.
2. The system lists the saved sessions with their titles and timestamps.
3. The Developer picks a session.
4. The system loads that session's stored messages and metadata.
5. The system restores the conversation, its statistics, and any scheduled prompts, and continues the session.

## Alternative Flows

- **A1 — Continue the most recent session (diverges at step 2):** The Developer asked to continue; the system selects the most recent saved session and goes to step 4.
- **A2 — Resume by session identifier (diverges at step 2):** The Developer supplied an identifier; the system finds the matching session and goes to step 4.
- **A3 — No saved sessions exist (diverges at step 2):** The system reports that there is nothing to resume and starts a fresh session.
- **A4 — Session is invalid or corrupted (diverges at step 4):** The stored files are missing or unreadable; the system reports the problem and returns to step 2.
- **A5 — Rename a session (diverges at step 3):** Instead of resuming, the Developer renames the chosen session; the system stores the new title, marks it as manually set, and returns to step 2.

## Postconditions

- **Success:** The chosen conversation is loaded and active, with history and scheduled prompts restored.
- **Failure:** No session was resumed; a fresh session is running or the picker is still shown.

## Business Rules

- **BR-015:** A session can be resumed only if it has stored metadata and at least one message.
- **BR-016:** A title set by the Developer is marked as manually set and is not overwritten by automatic titling.
