# UC-005: Resume a Previous Session

## Overview

- **ID:** UC-005
- **Name:** Resume a Previous Session
- **Primary Actor:** Developer
- **Goal:** Continue a past conversation with its full history instead of starting over.
- **Status:** Implemented

## Preconditions

- API access is configured (see UC-001).
- Session logging is enabled in the configuration.
- At least one past session has been recorded.

## Main Success Scenario

1. The developer asks to resume work, either by continuing the most recent session, naming a specific session, or browsing past sessions.
2. The system locates the requested session — the latest one for the current directory, the one matching the given identifier, or the one chosen from the picker.
3. The system loads the saved conversation history.
4. The system restores the conversation, its identifier, its lineage, and any scheduled recurring prompts.
5. The system opens the session so the developer can continue from where it left off.

## Alternative Flows

- **A1 — Browse and choose a session.** Trigger: the developer asks to resume without naming a session. The system presents a picker of past sessions and the developer selects one.
- **A2 — No matching session found.** Trigger: at step 2 no session matches the request. The system reports that no session was found and exits.
- **A3 — Session logging disabled.** Trigger: continuation is requested but session logging is turned off. The system reports that logging must be enabled and exits.
- **A4 — Session fails to load.** Trigger: the saved session is corrupt or unreadable. The system reports the failure and exits.
- **A5 — Rename the current session.** Trigger: during a session the developer requests a rename. The system updates the session title and marks it as manually set.

## Postconditions

- **Success:** The prior conversation is loaded into an active session and the developer can continue it.
- **Failure:** No session is resumed and, except for A5, Vibe exits.

## Business Rules

- **BR-013:** Continuing or resuming a session requires session logging to be enabled.
- **BR-014:** A manually set session title must not be empty.
