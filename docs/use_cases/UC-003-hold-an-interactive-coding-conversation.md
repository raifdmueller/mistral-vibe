# UC-003: Hold an Interactive Coding Conversation

## Overview

| Field | Value |
|---|---|
| **ID** | UC-003 |
| **Name** | Hold an Interactive Coding Conversation |
| **Primary Actor** | Developer |
| **Goal** | Use natural-language prompts to explore and modify a project, with the agent driving file edits, shell commands, and search through a controlled set of tools. |
| **Status** | Implemented |

## Preconditions

- The working directory is trusted (see UC-002), or has no trustable files.
- An API key for the active model's provider is available.
- A session is established (a fresh session by default, or a resumed one — see UC-008).

## Main Success Scenario

1. The developer enters a prompt at the chat input.
2. The system records the prompt in the session transcript.
3. The system sends the prompt, along with the running conversation context, to the LLM provider.
4. The LLM provider returns an assistant response that may contain text and tool-call requests.
5. For each requested tool call, the system resolves the tool's permission for the current invocation and presents text output to the developer.
6. If a tool requires approval, the system pauses and follows UC-004; otherwise the tool runs immediately.
7. The system shows tool output to the developer and feeds it back to the LLM provider as additional context.
8. The system loops between LLM responses and tool executions until the assistant has no further tool calls.
9. The system displays the final assistant message and waits for the next developer prompt.
10. After the turn ends, the system runs any configured post-turn hooks and surfaces their output as notices.

## Alternative Flows

### A1 — Developer interrupts the agent

Trigger: At any point during steps 3 to 8, the developer presses Escape.

1. The system cancels the in-flight LLM request or tool execution.
2. The system records the interruption in the transcript.
3. The flow returns to step 1.

### A2 — Tool execution is denied by configuration

Trigger: At step 5, the tool's effective permission is *never* for this invocation.

1. The system reports the denial to the assistant as a tool result.
2. The flow returns to step 4 so the assistant can adjust.

### A3 — LLM request fails

Trigger: At step 4, the provider returns an error or the connection drops.

1. The system surfaces the error to the developer.
2. The flow returns to step 1 without changing the conversation state.

### A4 — Auto-compaction threshold reached

Trigger: At step 3, the running context size exceeds the configured auto-compact threshold for the active model.

1. The system summarises the older portion of the conversation using the compaction model (see UC-010).
2. The flow continues from step 3 with the compacted context.

### A5 — Bash command not on the arity-approved list

Trigger: At step 5, the assistant requests a bash command whose prefix is not on the bash allowlist.

1. The system marks the call as requiring approval and proceeds via UC-004.

### A6 — Developer types a shell escape

Trigger: At step 1, the prompt begins with `!`.

1. The system runs the rest of the line directly in the shell, outside the agent loop, and shows the output.
2. The flow returns to step 1.

### A7 — Developer issues a slash command

Trigger: At step 1, the prompt begins with `/` and matches a registered command.

1. The system dispatches to the matching handler (e.g. `/clear`, `/status`, `/help`) instead of sending the prompt to the LLM.
2. The flow returns to step 1.

## Postconditions

- **Success**: The session transcript is extended with the new turn(s); any tool side effects (files written, commands run, web pages fetched) are persisted to the workspace.
- **Failure**: No new assistant message is appended; partial tool effects may remain and are visible in the transcript.

## Business Rules

- **BR-009**: Every tool invocation is resolved against the active agent profile, the per-tool configuration, and any session-approved rules before it is executed.
- **BR-010**: The session transcript stores every user prompt, assistant reply, and tool result as a separate message with a stable identifier.
- **BR-011**: When `bypass_tool_permissions` is set on the active agent profile, tool calls execute without prompting (auto-approve and chat profiles use this).
- **BR-012**: Auto-compaction triggers when the running context exceeds the model's `auto_compact_threshold` (default 200 000 tokens).
- **BR-013**: Post-turn hooks are loaded from `hooks.toml` at the user and project level; each hook has a name, command, and timeout (default 30 s).
