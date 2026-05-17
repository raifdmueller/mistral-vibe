# UC-005 Run a Shell Command Directly

## Overview

- **ID:** UC-005
- **Name:** Run a Shell Command Directly
- **Primary Actor:** Developer
- **Goal:** Execute a shell command immediately without involving the agent.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).

## Main Success Scenario

1. The developer types an input prefixed with `!` followed by a shell command.
2. The system recognizes the prefix and bypasses the agent.
3. The system runs the command in the session's shell environment.
4. The system shows the command output in the transcript.
5. The developer returns to the normal prompt.

## Alternative Flows

- **A1 — Command fails (from step 3):** The system shows the non-zero exit status and error output; the session continues.

## Postconditions

- **Success:** The command ran and its output is visible; the conversation with the agent is unchanged.
- **Failure:** The command error is shown; the session continues.

## Business Rules

- **BR-013:** An input starting with `!` is treated as a direct shell command and never sent to the model.
