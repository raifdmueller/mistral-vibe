# UC-001: Configure Vibe with API Key

## Overview

| Field | Value |
|---|---|
| **ID** | UC-001 |
| **Name** | Configure Vibe with API Key |
| **Primary Actor** | Developer |
| **Goal** | Make Vibe usable on the local machine by supplying credentials for an LLM provider. |
| **Status** | Implemented |

## Preconditions

- Vibe is installed on the developer's machine.
- The developer holds an API key from a supported LLM provider (e.g. Mistral).

## Main Success Scenario

1. The developer starts Vibe for the first time (or runs the dedicated setup command).
2. The system detects that no API key is available for the configured default provider.
3. The system creates the user configuration directory with a default configuration file if neither exists yet.
4. The system shows a welcome screen and asks the developer to enter the API key.
5. The developer enters the API key.
6. The system stores the API key in the user-level environment file.
7. The system reports that setup is complete and exits (or continues into the interactive session).

## Alternative Flows

### A1 — API key already present in environment

Trigger: At step 2, the API key is already exported in the shell environment or present in the user environment file.

1. The system skips the onboarding screen and proceeds directly to its normal startup.

### A2 — Developer cancels the onboarding

Trigger: At step 5, the developer presses Escape or closes the dialog.

1. The system shows a cancellation message and exits with a non-zero status.

### A3 — Saving the API key fails

Trigger: At step 6, the system cannot write to the environment file (permission denied, read-only filesystem).

1. The system warns the developer that the key was not persisted and is set for the current session only.
2. The system continues into the interactive session.

### A4 — Provider configured with invalid environment variable name

Trigger: At step 6, the provider configuration declares a malformed `api_key_env_var`.

1. The system warns that the key was not saved.
2. The system exits with a non-zero status.

## Postconditions

- **Success**: The API key is set for the current process and (on most paths) persisted in the user-level environment file. Subsequent invocations of Vibe pick up the key automatically.
- **Failure**: No key is persisted. The next invocation will trigger the onboarding flow again unless the developer supplies the key by other means.

## Business Rules

- **BR-001**: The user configuration directory defaults to `~/.vibe/` but is overridden by the `VIBE_HOME` environment variable when set.
- **BR-002**: A provider's API key environment variable name is governed by its `api_key_env_var` setting; the default Mistral provider uses `MISTRAL_API_KEY`.
- **BR-003**: Environment variables take precedence over the persisted environment file when both are set.
- **BR-004**: The onboarding flow only persists the API key to the user-level environment file, never to the main TOML configuration.
