# UC-002 Authenticate with the Mistral Platform

## Overview

- **ID:** UC-002
- **Name:** Authenticate with the Mistral Platform
- **Primary Actor:** Developer
- **Goal:** Supply a credential so the agent can call the language model behind the active model.
- **Status:** Implemented

## Preconditions

- Mistral Vibe is starting interactively, or the Developer explicitly invoked the setup step.
- No usable credential is available for the active model's provider.

## Main Success Scenario

1. The system detects that no credential is available and starts onboarding.
2. The system shows a welcome screen and offers two ways to authenticate: sign in through the browser, or paste an API key.
3. The Developer chooses to sign in through the browser.
4. The system opens the provider's sign-in page and waits for the Developer to approve the request.
5. The Developer approves the request in the browser.
6. The system receives the credential, stores it securely, and confirms authentication succeeded.
7. The system continues startup with a usable credential.

## Alternative Flows

- **A1 — Developer pastes an API key (diverges at step 3):** The Developer enters an API key directly; the system stores it and continues at step 7.
- **A2 — Provider does not support browser sign-in (diverges at step 2):** The system offers only the API-key option.
- **A3 — Browser sign-in fails or times out (diverges at step 5):** The system reports the failure and returns to step 2.
- **A4 — Non-interactive start without a credential (diverges at step 1):** The system cannot run onboarding; it prints how to set the credential and exits.

## Postconditions

- **Success:** A credential for the active model's provider is stored and available to the running session.
- **Failure:** No credential is stored; the system has returned to the choice screen or exited.

## Business Rules

- **BR-004:** The agent cannot run without a usable credential for the active model's provider.
- **BR-005:** Browser sign-in is offered only for providers that support it.
- **BR-006:** Credentials are kept in the operating system keyring or environment and are never written to the session log.
