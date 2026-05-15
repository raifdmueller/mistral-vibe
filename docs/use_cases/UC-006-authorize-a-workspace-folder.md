# UC-006: Authorize a Workspace Folder

## Overview

- **ID**: UC-006
- **Name**: Authorize a Workspace Folder
- **Primary Actor**: Developer
- **Goal**: Decide whether Mistral Vibe is allowed to honor agent-behavior files (`AGENTS.md`, `CLAUDE.md`, `.vibe/`, `.claude/`, …) that it finds in or above the current working directory, since those files can alter how the assistant interprets requests.
- **Status**: Implemented

## Preconditions

- An interactive Vibe session is being started.
- The current working directory is not the user's home directory (the home directory is exempt from the trust prompt).
- Vibe was not started with `--trust`.

## Main Success Scenario

1. System inspects the working directory for known trust-relevant files (project agent-instruction files, local config directories).
2. System walks up the directory tree looking for the nearest ancestor that is already marked trusted or untrusted in `trusted-folders.toml`.
3. If no trust decision exists for the directory or any ancestor and trust-relevant files were found, system pauses startup and shows a trust dialog listing the detected files.
4. Developer chooses an option: trust this folder permanently, do not trust it, or cancel.
5. System persists the decision into `trusted-folders.toml`: the path is added to the `trusted` or `untrusted` list.
6. If the developer chose "trust", system loads the project-context files into the system prompt and continues to UC-002; if "untrusted", system continues without loading those files.

## Alternative Flows

- **A1**: Trigger at step 2 — An ancestor of the directory is already trusted (or untrusted). System inherits that decision without prompting and proceeds.
- **A2**: Trigger at step 1 — No trust-relevant files are detected. System skips the trust prompt and continues with no project-context files loaded.
- **A3**: Trigger at step 1 — Developer launched Vibe with `--trust`. System trusts the folder for this invocation only (not persisted) and skips the prompt.
- **A4**: Trigger at step 4 — Developer cancels the dialog (Ctrl+C, Escape). System exits the CLI without starting a session and without writing to `trusted-folders.toml`.

## Postconditions

- **Success**: The working directory has a known trust state; if persisted, the state is recorded in `trusted-folders.toml`.
- **Failure**: Vibe exits without starting a session; no trust state is written.

## Business Rules

- **BR-029**: The trust prompt is shown only when (a) the working directory is not the user's home directory, (b) no ancestor has a recorded trust decision, and (c) at least one trust-relevant file is found.
- **BR-030**: A trust decision applies to the chosen directory and all its descendants; the most specific recorded ancestor wins.
- **BR-031**: Trust granted via `--trust` lives in process memory only and is never written to `trusted-folders.toml`.
