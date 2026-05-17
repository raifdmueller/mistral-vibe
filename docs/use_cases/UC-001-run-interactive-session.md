# UC-001 Run an Interactive Coding Session

## Overview

- **ID**: UC-001
- **Name**: Run an Interactive Coding Session
- **Primary Actor**: Developer
- **Goal**: Work on a codebase conversationally, letting the assistant read, edit, and run code through natural-language instructions.
- **Status**: Implemented

## Preconditions

- Vibe is installed and an API key is available (see UC-007).
- The developer launches Vibe from a project directory.
- The working directory is trusted, or the trust prompt has been resolved (see UC-011).

## Main Success Scenario

1. The developer starts Vibe, optionally passing an initial prompt.
2. The system loads configuration, agent instructions, and project context.
3. The system shows the welcome banner and an input prompt.
4. The developer types a request in natural language.
5. The system sends the request and conversation history to the model.
6. The model replies, optionally requesting tool actions (read a file, run a command, edit code).
7. The system runs each approved tool action and streams the result back to the model (see UC-008).
8. The system displays the assistant's response and any file changes.
9. The developer continues the conversation or ends the session.

## Alternative Flows

- **A1 — Slash command entered** (step 4): the developer types a `/` command; the system runs the command instead of sending a prompt to the model.
- **A2 — Direct shell command** (step 4): the developer prefixes input with `!`; the system runs the shell command directly and shows its output.
- **A3 — Tool action rejected** (step 7): the developer denies a tool action; the system reports the denial to the model and continues.
- **A4 — Context limit approached** (step 5): the conversation nears the auto-compact threshold; the system summarizes history before sending (see UC-004).
- **A5 — Interrupt** (step 6): the developer interrupts a running turn; the system stops the current model turn and returns to the prompt.

## Postconditions

- **Success**: The conversation and any file edits are persisted to the session log; the session can be resumed later.
- **Failure**: No partial edits are left in an inconsistent state; the error is shown and the prompt returns.

## Business Rules

- **BR-001**: Conversation history is automatically compacted when token usage reaches the auto-compact threshold (default 200,000 tokens).
- **BR-002**: A working directory must be trusted before the assistant may run tools against it.
