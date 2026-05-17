# UC-012: Integrate Vibe with an IDE

## Overview

- **ID:** UC-012
- **Name:** Integrate Vibe with an IDE
- **Primary Actor:** Code Editor
- **Goal:** Let a code editor or IDE drive Vibe's agent through the Agent Client Protocol so the developer can use Vibe inside their editor.
- **Status:** Implemented

## Preconditions

- API access is configured (see UC-001).
- The editor is configured to launch Vibe in protocol mode.

## Main Success Scenario

1. The editor launches Vibe in Agent Client Protocol mode.
2. The system initializes and establishes the protocol channel over standard input and output with the editor.
3. The editor opens a session and forwards the developer's request.
4. The system runs the agent, streaming responses, tool actions, and updates back to the editor.
5. When a tool action needs approval, the system asks the editor, which surfaces the request to the developer.
6. The editor returns the developer's decision and the system proceeds accordingly.
7. The agent completes the request and the system reports the result to the editor.

## Alternative Flows

- **A1 — Setup mode.** Trigger: the editor launches Vibe in protocol mode with the setup option. The system runs the credential setup flow (see UC-001) and exits.
- **A2 — Missing credentials.** Trigger: at step 2 no API credential is available. The system surfaces the failure to the editor so it can prompt the developer to run setup.
- **A3 — Slash command from the editor.** Trigger: the editor sends a recognized command. The system runs the corresponding command handler and returns the result.
- **A4 — Developer rejects a tool action.** Trigger: at step 6 the developer declines the action. The system skips the action and reports the rejection to the agent.

## Postconditions

- **Success:** The editor and Vibe maintain a working protocol session and the developer's requests are completed from within the editor.
- **Failure:** The protocol session does not start and the editor is informed.

## Business Rules

- No additional business rules; protocol-mode sessions follow the same rules as interactive sessions (see UC-003).
