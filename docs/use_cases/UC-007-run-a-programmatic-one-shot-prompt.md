# UC-007: Run a Programmatic One-Shot Prompt

## Overview

| Field | Value |
|---|---|
| **ID** | UC-007 |
| **Name** | Run a Programmatic One-Shot Prompt |
| **Primary Actor** | Developer |
| **Goal** | Drive Vibe non-interactively from a script or CI job — supply a single prompt, let the agent run to completion, and capture its output in a structured format. |
| **Status** | Implemented |

## Preconditions

- Vibe is installed and an API key is available in the environment.
- The current working directory is either trusted, or the developer passes the one-shot trust flag.

## Main Success Scenario

1. The developer runs Vibe with the prompt flag, supplying the prompt text and optional output, budget, and tool-filter flags.
2. The system parses the arguments and selects the auto-approve profile by default.
3. The system applies any tool-enable filter, disabling tools that do not match the supplied patterns.
4. The system starts a session and feeds the prompt to the agent loop.
5. The agent loop runs LLM turns and tool calls without prompting for approval.
6. The system enforces the maximum-turns and maximum-price limits if supplied, interrupting the loop when either is exceeded.
7. The system emits the final response in the chosen format: plain text (default), a JSON document, or newline-delimited streaming JSON.
8. The system exits with status 0 on a normal completion.

## Alternative Flows

### A1 — Maximum cost exceeded

Trigger: At step 6, the running session cost passes the configured maximum.

1. The system interrupts the current turn.
2. The system emits the partial output and a note that the budget was reached.
3. The system exits with a non-zero status.

### A2 — Maximum turns exceeded

Trigger: At step 6, the assistant has produced more turns than allowed.

1. The system stops the loop.
2. The system emits the partial output.
3. The system exits with a non-zero status.

### A3 — No prompt supplied

Trigger: At step 1, the prompt flag is given without text (e.g. piped input is also empty).

1. The system reads the prompt from stdin if available.
2. If stdin is also empty, the system exits with a usage error.

### A4 — Tool filter excludes every tool

Trigger: At step 3, the tool-filter patterns match no tools.

1. The agent runs without any tools; it can still reply with text but cannot execute side effects.

### A5 — Working directory not trusted and trust flag absent

Trigger: At step 1, the directory has no trust decision and the trust flag is not set.

1. The system skips the trust dialog (it is suppressed in programmatic mode) and proceeds; project-level configuration remains unloaded.

## Postconditions

- **Success**: The agent's response is emitted to stdout in the requested format. Any tool side effects (file writes, shell commands) have been applied to the workspace.
- **Failure**: A diagnostic is printed to stderr and the process exits with a non-zero status.

## Business Rules

- **BR-026**: Programmatic mode defaults to the `auto-approve` agent profile; this default cannot be changed via `default_agent` (which is interactive-only).
- **BR-027**: The tool-filter accepts exact names, glob patterns, and regular expressions prefixed with `re:`; matching is performed against the fully qualified tool name (including any MCP-server prefix).
- **BR-028**: The maximum-price ceiling is an estimate based on the active model's per-million-token prices; it does not account for caching discounts.
- **BR-029**: Output format `streaming` writes one JSON object per line; `json` buffers and emits a single document at the end; `text` emits human-readable text only.
