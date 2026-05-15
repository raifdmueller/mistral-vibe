# UC-001: Complete First-Time Setup

## Overview

- **ID**: UC-001
- **Name**: Complete First-Time Setup
- **Primary Actor**: Visitor
- **Goal**: Provide an API key (or sign in through the browser) so that Mistral Vibe can talk to the Mistral AI Platform on the visitor's behalf.
- **Status**: Implemented

## Preconditions

- Mistral Vibe is installed and on the user's `PATH`.
- No usable credential is present yet: neither the configured provider's API-key environment variable nor a saved key inside the Vibe home directory's `.env` file is set.

## Main Success Scenario

1. Visitor launches Vibe, either by running the CLI for the first time or by passing `--setup` explicitly.
2. System detects that no API key is configured for the active provider and opens the onboarding screen.
3. System presents a welcome screen with a short product introduction.
4. Visitor advances to the credential entry screen.
5. Visitor chooses how to authenticate: paste an existing API key, or sign in through the browser if the active provider supports browser sign-in.
6. If the visitor pastes a key, system validates that the input is non-empty and writes it to the `.env` file inside the Vibe home directory under the provider's API-key environment variable.
7. If the visitor chooses browser sign-in, system opens the provider's console in the default browser, waits for the visitor to complete authentication, exchanges the returned authorization for an API key, and stores it in the same `.env` file.
8. System confirms the credential was saved and either exits (if `--setup` was passed) or proceeds to start the interactive session.

## Alternative Flows

- **A1**: Trigger at step 5 — Visitor cancels onboarding (Ctrl+C, Escape, or quits the dialog). System exits without writing any credential.
- **A2**: Trigger at step 7 — Browser sign-in fails or times out. System reports the failure, returns the visitor to the credential entry screen, and offers to retry or paste a key manually.
- **A3**: Trigger at step 2 — A credential is already set in the environment or in the `.env` file. System skips onboarding entirely and starts the interactive session.

## Postconditions

- **Success**: A valid API key is persisted in the Vibe home directory's `.env` file under the active provider's API-key environment variable, and is available to subsequent invocations.
- **Failure**: No credential is written. Vibe exits without starting a session.

## Business Rules

- **BR-001**: Onboarding is triggered the first time Vibe is launched without any credential for the active provider, or whenever the visitor passes `--setup`.
- **BR-002**: Credentials are stored in plain text in the Vibe home directory's `.env` file; the visitor is responsible for file-system protection of that file.
- **BR-003**: The Vibe home directory defaults to `~/.vibe` and may be overridden by the `VIBE_HOME` environment variable.
- **BR-004**: Browser sign-in is offered only when the active provider declares support for it (currently the Mistral provider).
- **BR-005**: Pasted API keys must be non-empty after trimming whitespace.
