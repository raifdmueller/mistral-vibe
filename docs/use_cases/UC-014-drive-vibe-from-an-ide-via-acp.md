# UC-014: Drive Vibe from an IDE via ACP

## Overview

- **ID**: UC-014
- **Name**: Drive Vibe from an IDE via ACP
- **Primary Actor**: IDE Client (Zed, JetBrains AI Assistant, Neovim avante.nvim, or any other Agent Client Protocol client)
- **Goal**: Use Mistral Vibe as the agent backend for an IDE so that the developer can chat with Vibe from inside the editor, with file-system actions reflected in the editor view.
- **Status**: Implemented

## Preconditions

- The IDE client has been configured with the `vibe acp` command (or `vibe --setup` has been run once to provision credentials, then `vibe acp` is launched by the IDE per session).
- A valid API key for the active provider is set in the environment of the spawned `vibe acp` process.
- The IDE client speaks Agent Client Protocol over stdio.

## Main Success Scenario

1. IDE client spawns the `vibe acp` process and exchanges an `initialize` handshake declaring its protocol version and capabilities.
2. System replies with its capabilities, the list of available agent profiles, and the list of registered tools.
3. IDE client opens a session by calling `new_session` (or resumes one with `load_session` / `resume_session` / `fork_session`).
4. IDE client sends a user message via `prompt`; system runs the model/tool loop (see UC-002), streaming assistant messages, tool calls, and tool results back as ACP notifications.
5. When the assistant requests a tool call that needs approval, system emits a permission request to the IDE client; the IDE shows the prompt to its user; user's selection is returned via the ACP permission-selection callback.
6. IDE client can change the active model with `set_session_model`, change the active agent with `set_session_mode`, update an individual config option with `set_config_option`, or interrupt the current turn with `cancel`.
7. When the session ends, IDE client calls `close_session`; system flushes the session log and reports usage statistics back to the client.

## Alternative Flows

- **A1**: Trigger at step 1 — IDE's protocol version is not supported. System reports an unsupported-version error and the process exits.
- **A2**: Trigger at step 4 — IDE client sends `cancel`. System interrupts the in-flight model or tool call, returns control to the prompt state, and reports the cancellation.
- **A3**: Trigger at step 3 — `resume_session` references an unknown session ID. System returns a not-found error and stays at the previous state.
- **A4**: Trigger at step 4 — Active agent profile is the `plan` profile and the assistant invokes the exit-plan-mode tool. System forwards the proposed plan to the IDE client through the same permission callback mechanism so the user can accept it.
- **A5**: Triggered by Vibe — Long-running tool result. System sends incremental tool-stream events to the IDE so it can show partial output as it accumulates.

## Postconditions

- **Success**: The IDE has received every assistant message, tool call, and tool result for the session; the session log on disk matches the conversation; any file changes are visible in the editor.
- **Failure**: The ACP session is closed by the IDE; the local session log is flushed and remains resumable through UC-004 if persisted.

## Business Rules

- **BR-056**: ACP sessions reuse the same agent profiles, tools, skills, MCP servers, and configuration as the interactive CLI; switching the agent through `set_session_mode` re-applies the profile's tool allow/deny overrides immediately.
- **BR-057**: Tool-permission requests are routed through the IDE client; if the client never returns a decision, the in-flight tool call is treated as denied after the underlying tool's timeout.
- **BR-058**: ACP-exposed tools (read-file, search-replace, bash, grep, skill, task, todo, webfetch, websearch) wrap the same core tool implementations used in interactive mode; permission, ignore-list, and disabled-tool rules are identical.
