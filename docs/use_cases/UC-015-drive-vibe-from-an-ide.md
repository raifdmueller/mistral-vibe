# UC-015 Drive Vibe from an IDE

## Overview

- **ID:** UC-015
- **Name:** Drive Vibe from an IDE
- **Primary Actor:** IDE Client
- **Goal:** Let an editor or IDE use Mistral Vibe as its coding agent over the Agent Client Protocol.
- **Status:** Implemented

## Preconditions

- Mistral Vibe's ACP mode is installed and a usable credential is available.
- The IDE Client speaks the Agent Client Protocol.

## Main Success Scenario

1. The IDE Client launches Mistral Vibe in ACP mode and starts a protocol session.
2. The system advertises its capabilities and the commands it supports.
3. The IDE Client opens a session and sends the Developer's prompt.
4. The system runs the agent loop (UC-003), reporting progress, tool calls, and results back to the IDE Client as protocol updates.
5. For actions that need approval, the system asks the IDE Client, which relays the decision from the Developer.
6. The system streams the final answer and session updates to the IDE Client.

## Alternative Flows

- **A1 — Client invokes a command (diverges at step 3):** The IDE Client invokes an advertised command — compact, reload, log, and others — and the system handles it.
- **A2 — Multiple sessions (diverges at step 3):** The IDE Client opens more than one session; the system keeps each session isolated.
- **A3 — Load or fork a session (diverges at step 3):** The IDE Client asks to load a saved session or fork the current one; the system restores or branches the conversation.
- **A4 — No usable credential (diverges at step 1):** The system reports that setup is needed and the protocol session cannot proceed.

## Postconditions

- **Success:** The IDE Client received the agent's work as protocol updates and the session state is consistent.
- **Failure:** The protocol session ended with an error reported to the IDE Client.

## Business Rules

- **BR-036:** Each ACP connection runs as an isolated session.
- **BR-037:** Actions that need approval are surfaced to the IDE Client, which relays the Developer's decision.
