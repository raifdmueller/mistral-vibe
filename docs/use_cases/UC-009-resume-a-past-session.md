# UC-009 Resume a Past Session

## Overview

- **ID:** UC-009
- **Name:** Resume a Past Session
- **Primary Actor:** Developer
- **Goal:** Continue a previously saved conversation instead of starting fresh.
- **Status:** Implemented

## Preconditions

- Session logging is enabled in the configuration.
- At least one saved session exists for the working directory (for `--continue`) or by id (for `--resume`).

## Main Success Scenario

1. The developer starts Vibe with `--continue`, `--resume`, or uses the `/resume` command.
2. The system locates the session: the most recent one for the current directory, a session by id, or via an interactive picker.
3. The system loads the saved messages and metadata.
4. The system restores the conversation, excluding the stored system prompt, and reattaches the original session id.
5. The interactive prompt opens with the restored conversation ready to continue.

## Alternative Flows

- **A1 — Session logging disabled (from step 1):** The system reports that logging is disabled and exits.
- **A2 — No session found (from step 2):** The system reports that no matching session exists and exits.
- **A3 — Load failure (from step 3):** The system reports the load error and exits.
- **A4 — Interactive picker (from step 2):** With `--resume` and no id, or with `/resume`, the system shows a picker of past sessions for the developer to choose from.

## Postconditions

- **Success:** The session continues with its prior history and a continuous session id.
- **Failure:** No session is resumed; an explanatory message is shown.

## Business Rules

- **BR-021:** Resuming requires session logging to be enabled.
- **BR-022:** `--continue` selects the latest session for the current working directory; `--resume` selects a session by id or via picker.
- **BR-023:** The stored system prompt is dropped on resume so the current configuration's system prompt is used.
