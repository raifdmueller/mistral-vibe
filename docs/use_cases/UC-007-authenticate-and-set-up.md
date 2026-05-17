# UC-007 Authenticate and Set Up Access

## Overview

- **ID**: UC-007
- **Name**: Authenticate and Set Up Access
- **Primary Actor**: Developer
- **Goal**: Provide the credentials Vibe needs to call the model provider and related services.
- **Status**: Implemented

## Preconditions

- Vibe is installed.

## Main Success Scenario

1. The developer runs Vibe for the first time, or starts the setup flow explicitly.
2. The system detects that no usable API key is configured.
3. The system prompts the developer for an API key.
4. The developer enters the key.
5. The system stores the key securely in the operating system keyring.
6. The system confirms that access is configured and continues.

## Alternative Flows

- **A1 — Key already present** (step 2): a key is found in the environment or keyring; the system skips the prompt.
- **A2 — Setup only** (step 1): the developer runs the setup flag; the system configures the key and exits without starting a session.
- **A3 — GitHub authentication** (step 3): a feature requires GitHub access; the system runs the GitHub authentication flow and stores that credential.
- **A4 — Proxy or certificate needed**: the developer's network requires a proxy; the system collects proxy and SSL certificate settings.

## Postconditions

- **Success**: Credentials are stored securely and the model provider is reachable.
- **Failure**: No credentials are stored; the system explains what is missing.

## Business Rules

- **BR-012**: API keys are stored in the operating system keyring, not in plain configuration files.
