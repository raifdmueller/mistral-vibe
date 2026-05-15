# UC-016: Use Vibe From an Editor via ACP

## Overview

| Field | Value |
|---|---|
| **ID** | UC-016 |
| **Name** | Use Vibe From an Editor via ACP |
| **Primary Actor** | Editor/IDE |
| **Goal** | Drive the Vibe agent from an external editor that speaks the Agent Client Protocol, so the developer interacts with the agent inside their editor's chat panel rather than the standalone CLI. |
| **Status** | Implemented |

## Preconditions

- The editor has registered the `vibe-acp` binary as an Agent Client Protocol agent.
- A valid API key is available in the environment.

## Main Success Scenario

1. The editor launches `vibe-acp` as a subprocess and opens an Agent Client Protocol channel over the process's standard input and output.
2. The system bootstraps the configuration files (creating the default user configuration and history file if missing).
3. The editor sends an initialise request describing its capabilities; the system responds with Vibe's protocol version and capabilities.
4. The editor sends a session request containing the developer's prompt and the working directory.
5. The system creates or resumes a session for that working directory and feeds the prompt to the agent loop.
6. For each assistant message and tool call, the system emits protocol notifications back to the editor.
7. When the assistant proposes a tool call requiring approval, the system asks the editor (which surfaces the dialog in its own UI); the editor returns the developer's decision.
8. The system completes the turn and returns the final response payload to the editor.

## Alternative Flows

### A1 — Editor cancels the turn

Trigger: At any point after step 4, the editor sends a cancel notification.

1. The system aborts the in-flight LLM request or tool execution.
2. The system returns a cancellation response.

### A2 — Setup invoked under ACP

Trigger: At step 1, the editor launches `vibe-acp` with the setup flag.

1. The system runs the API-key onboarding flow (UC-001) and exits.
2. The editor relaunches the agent without the setup flag for normal use.

### A3 — Debug mode requested

Trigger: At step 1, the `DEBUG_MODE` environment variable is set to `true`.

1. The system attempts to attach a debug listener on localhost; the agent then continues startup.

### A4 — Protocol error from the editor

Trigger: At any step, the editor sends a malformed message.

1. The system responds with an error reply on the protocol channel.
2. The session remains open.

## Postconditions

- **Success**: The editor and Vibe exchange the agent's responses and tool requests over the protocol; any tool side effects are applied to the workspace.
- **Failure**: The session is closed and the editor is notified.

## Business Rules

- **BR-062**: Vibe under ACP uses the protocol's permission-request mechanism for tool approval instead of presenting its own dialog.
- **BR-063**: The ACP entry point line-buffers its standard input, output, and error streams to make exchange with the editor deterministic.
- **BR-064**: Tool side-effects in ACP mode happen in the workspace described by the editor's session request, not the directory from which the agent was launched.
- **BR-065**: The standalone CLI features that rely on a Textual UI (rewind shortcuts, voice mode, slash autocompletion) are not available through ACP; the editor provides equivalents through its own UI.
