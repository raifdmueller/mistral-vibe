# UC-013: Execute Prompt Non-Interactively

## Overview

- **ID**: UC-013
- **Name**: Execute Prompt Non-Interactively
- **Primary Actor**: Programmatic Caller
- **Goal**: Run a single Vibe request from a shell script, a CI job, or another automation — no TUI, no prompts — and receive the assistant's final answer on standard output.
- **Status**: Implemented

## Preconditions

- A valid API key for the active provider is set in the environment.
- The current working directory is either already trusted, intentionally untrusted (no project-context files will be loaded), or the caller has passed `--trust` to grant ephemeral trust for this invocation.

## Main Success Scenario

1. Programmatic caller invokes `vibe -p "<prompt>"`, optionally also passing `--max-turns`, `--max-price`, `--enabled-tools`, `--agent`, `--output`, `--workdir`, and `--trust`.
2. System loads configuration, applies any `VIBE_*` environment overrides, and selects the active model.
3. System resolves the active agent: if `--agent` is given it wins, otherwise the agent falls back to `auto-approve` (regardless of `default_agent`).
4. System loads tools, optionally narrowed to those matching `--enabled-tools`; all remaining tools run without prompting under `auto-approve`.
5. System sends the prompt as the first user message and runs the model/tool loop (UC-002 main scenario), suppressing all interactive UI.
6. System enforces budget limits: it counts assistant turns against `--max-turns` and the accumulated dollar cost against `--max-price`, terminating the loop as soon as either is exceeded.
7. When the assistant emits a final message with no further tool calls (or a budget is hit), system writes output to standard output in the format chosen by `--output`: `text` (default, human-readable), `json` (all messages, returned at end), or `streaming` (newline-delimited JSON per message).
8. System exits with status 0 on success and a non-zero status if a budget was exceeded, the model returned an error, or the caller was not authorized.

## Alternative Flows

- **A1**: Trigger at step 6 — `--max-turns` exceeded. System emits a final message indicating the limit was hit and exits with a non-zero status.
- **A2**: Trigger at step 6 — `--max-price` exceeded. System aborts the in-flight call, emits an error message, and exits with a non-zero status.
- **A3**: Trigger at step 4 — `--enabled-tools` excludes a tool that the assistant tries to call. System returns a tool-not-available error to the assistant, which adapts or finishes.
- **A4**: Trigger at step 1 — `--workdir` points to a non-existent directory. System reports the error and exits with a non-zero status without contacting the model.
- **A5**: Trigger at step 1 — Working directory needs trust and `--trust` was not passed. System trusts implicitly for programmatic mode but does not write to `trusted-folders.toml`, and project-context files are loaded.

## Postconditions

- **Success**: The assistant's final answer (and intermediate messages when in JSON formats) is on stdout; any file modifications requested by the assistant are persisted; the process has exited with status 0.
- **Failure**: A non-zero exit status indicates a budget breach, an authentication problem, or an unrecoverable model error; partial output may already be on stdout (especially in `streaming` mode).

## Business Rules

- **BR-051**: Programmatic mode forces `--agent auto-approve` when `--agent` is not specified, regardless of the `default_agent` setting.
- **BR-052**: Under `auto-approve`, every tool runs without prompting; the developer's interactive permission prompts are not available.
- **BR-053**: `--max-turns` and `--max-price` apply only when `-p` is passed; they are ignored in interactive mode.
- **BR-054**: Output format `json` buffers every message until the end; `streaming` emits each message as a JSON line as it is produced; `text` emits only the final assistant message body.
- **BR-055**: `--enabled-tools` accepts exact names, glob patterns (`bash*`), and regular expressions prefixed with `re:`.
