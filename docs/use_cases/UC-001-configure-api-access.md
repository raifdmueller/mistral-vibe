# UC-001: Configure API Access

## Overview

- **ID:** UC-001
- **Name:** Configure API Access
- **Primary Actor:** Developer
- **Goal:** Provide and store the credentials Vibe needs to reach a model provider so the agent can run.
- **Status:** Implemented

## Preconditions

- Vibe is installed and runnable from the command line.
- The developer has, or can obtain, an account with a supported model provider.

## Main Success Scenario

1. The developer starts Vibe, or runs it explicitly in setup mode.
2. The system detects that no credentials are available for the active provider and opens the onboarding flow.
3. The system shows a welcome screen and explains that an API key is required.
4. The developer chooses how to authenticate: signing in through the browser, or entering an API key directly.
5. The developer completes the chosen method and supplies the credential.
6. The system stores the credential in the user's environment file for future sessions.
7. The system confirms that setup is complete and Vibe is ready to use.

## Alternative Flows

- **A1 — Developer cancels setup.** Trigger: the developer dismisses the onboarding flow at step 4 or 5. The system reports that setup was cancelled and exits without storing a credential.
- **A2 — Provider configured with an invalid credential variable name.** Trigger: at step 6 the provider's credential variable name is not a valid environment variable name. The system warns that the key could not be saved, keeps it for the current session only, and asks the developer to fix the provider configuration.
- **A3 — Credential file cannot be written.** Trigger: at step 6 the environment file cannot be saved. The system warns that the credential is set for the current session only and tells the developer where to set it manually.
- **A4 — Browser sign-in unavailable.** Trigger: at step 4 the active provider does not support browser sign-in. The system offers only direct key entry.
- **A5 — Non-interactive invocation without credentials.** Trigger: Vibe is started non-interactively and no credential is available. The system prints an error explaining how to set the credential and exits.

## Postconditions

- **Success:** A valid credential is available to the active provider, persisted in the user environment file (or, in A2/A3, for the current session only).
- **Failure:** No credential is stored and Vibe does not start a session.

## Business Rules

- **BR-001:** Each provider declares the environment variable that holds its API key; a session cannot start unless that variable is set for the active provider.
- **BR-002:** The configured system prompt identifier must match a built-in prompt or a markdown file in a known prompt directory, otherwise Vibe refuses to start.
