# UC-002: Converse with the Coding Assistant

## Overview

- **ID**: UC-002
- **Name**: Converse with the Coding Assistant
- **Primary Actor**: Developer
- **Goal**: Carry out a coding task by having a multi-turn conversation with the assistant, which can read and modify files, run shell commands, search the web, and delegate to subagents on the developer's behalf.
- **Status**: Implemented

## Preconditions

- A valid API key for the active provider is available (see UC-001).
- The current working directory has been trusted (see UC-006), or the developer started Vibe with `--trust` for one-shot trust, or the directory contains no trust-relevant files.
- The harness has loaded the active agent profile, the active model, and the discoverable skills, tools, and MCP servers.

## Main Success Scenario

1. Developer launches Vibe interactively in a working directory.
2. System opens the terminal UI, shows the active model, agent profile, and any active project-context files, and waits for input.
3. Developer types a request in natural language (optionally referencing files with `@path`, or escaping into a shell command with `!command`) and submits the message.
4. System sends the conversation, the available tool definitions, and the system prompt to the Mistral AI Platform and streams the assistant's response.
5. When the assistant requests a tool call, system displays the tool name and arguments, and either runs it directly (if the active agent or the tool's permission policy allows it) or asks the developer to approve, deny, or always-approve the call.
6. System runs each approved tool call, returns the result to the assistant, and repeats the request/response loop until the assistant produces a final message with no further tool calls.
7. Developer reads the assistant's reply, optionally inspects file changes through the diff display, and either replies with a follow-up or accepts the result.
8. After every assistant turn, system runs any configured post-turn hooks and may inject their output back into the conversation.
9. System appends every message and tool result to the persisted session log inside the Vibe home directory.

## Alternative Flows

- **A1**: Trigger at step 5 — Developer denies a tool call. System reports the denial to the assistant as a tool error and continues the loop so the assistant can adapt.
- **A2**: Trigger at step 5 — Tool execution fails (non-zero exit, timeout, file not found, etc.). System returns the failure message to the assistant, which decides whether to retry or change approach.
- **A3**: Trigger at step 4 — Conversation has grown past the model's auto-compact threshold. System pauses, summarizes earlier turns into a single message using the compaction model, and resumes (see UC-003).
- **A4**: Trigger at step 4 — The Mistral AI Platform returns an authentication or quota error. System surfaces the error to the developer and aborts the turn without losing the conversation.
- **A5**: Trigger at step 6 — Assistant invokes the Task tool to delegate sub-work to a subagent. System spawns a new session running the named subagent profile, runs it to completion in isolation, and returns its final report as the tool result.
- **A6**: Trigger at any step in 4–6 — Developer presses Escape to interrupt. System cancels the in-flight model call or tool call, returns control to the prompt, and leaves the conversation in a consistent state.
- **A7**: Trigger at step 5 — Active agent profile is `plan` and the assistant has invoked the exit-plan-mode tool. System shows the proposed plan to the developer and asks whether to switch to an editing-capable agent and proceed.

## Postconditions

- **Success**: The conversation has progressed by at least one exchange; any approved file modifications are written to disk; the session log on disk contains every message and tool call from the turn.
- **Failure**: The current turn is aborted but the session, conversation history, and any earlier file changes remain intact and resumable.

## Business Rules

- **BR-006**: Every tool call runs through a permission check; only tools whose permission policy is auto-allow for the active agent run without prompting.
- **BR-007**: The `bash` tool, the `write_file` tool, and the `search_replace` tool always require explicit approval under the `default` agent, never require approval under the `auto-approve` agent, and never run under the `plan` agent.
- **BR-008**: Reading `.env` files and files matching configured sensitive patterns is blocked by the `read_file` and `grep` tools regardless of approval.
- **BR-009**: Tool results that exceed the per-tool output budget are truncated before being sent back to the model.
- **BR-010**: When the cumulative input-token count of the conversation reaches the active model's `auto_compact_threshold`, the system automatically compacts the conversation before the next turn.
- **BR-011**: All assistant messages, tool calls, and tool results are appended to `messages.jsonl` inside the session directory; metadata is written to `meta.json`.
- **BR-012**: A post-agent-turn hook runs only when its `type` matches `post_agent_turn`, its `command` is non-empty, and the operation completes within its `timeout` (default 30 seconds).
- **BR-013**: An interrupted turn (Escape, Ctrl+C) must roll back to a coherent message boundary; partial assistant messages are discarded from the persisted log.
- **BR-014**: The `task` tool may only invoke profiles whose `agent_type` is `subagent`.
- **BR-015**: Project-context files (`AGENTS.md`, `CLAUDE.md`, and similar) are loaded into the system prompt only when the working directory is trusted.
