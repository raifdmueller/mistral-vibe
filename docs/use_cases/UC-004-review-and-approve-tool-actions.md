# UC-004 Review and Approve Tool Actions

## Overview

- **ID:** UC-004
- **Name:** Review and Approve Tool Actions
- **Primary Actor:** Developer
- **Goal:** Decide whether the agent may carry out an action that changes the system, before it happens.
- **Status:** Implemented

## Preconditions

- An interactive session is running and the agent has requested a tool action during a turn (UC-003).
- The active agent mode does not bypass tool permissions.

## Main Success Scenario

1. The agent requests an action that requires approval — running a shell command, writing or editing a file.
2. The system pauses the turn and shows the Developer what the action will do, including the command or the proposed file change.
3. The Developer approves the action for this occurrence.
4. The system runs the action and returns the result to the agent.
5. The turn continues (UC-003).

## Alternative Flows

- **A1 — Developer approves for the rest of the session (diverges at step 3):** The system remembers the decision for matching actions and does not ask again this session.
- **A2 — Developer approves permanently (diverges at step 3):** The system records the permission in configuration so matching actions are auto-approved in future sessions.
- **A3 — Developer rejects the action (diverges at step 3):** The system tells the agent the action was declined; the agent chooses another approach.
- **A4 — Action is already covered by a rule (diverges at step 2):** A prior session or permanent decision already permits the action; the system runs it without prompting.
- **A5 — Agent mode bypasses permissions (diverges at step 1):** The active mode auto-approves tool actions; the system runs the action without prompting.

## Postconditions

- **Success:** The action ran with the Developer's consent, and any standing permission has been recorded.
- **Failure:** The action was declined and not run; the agent was informed.

## Business Rules

- **BR-009:** Actions that change files or run shell commands require explicit approval unless the active agent mode bypasses tool permissions.
- **BR-010:** An approval can be granted for one occurrence, for the current session, or permanently.
- **BR-011:** In plan mode, file-writing actions may only target the plans directory.
