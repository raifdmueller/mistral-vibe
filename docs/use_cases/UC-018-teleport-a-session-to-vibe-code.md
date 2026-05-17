# UC-018 Teleport a Session to Vibe Code

## Overview

- **ID:** UC-018
- **Name:** Teleport a Session to Vibe Code
- **Primary Actor:** Developer
- **Goal:** Move the current local session to the hosted Vibe Code environment to continue it remotely.
- **Status:** Draft

## Preconditions

- The Vibe Code feature is enabled.
- The active model is a Mistral model.
- The developer's plan is eligible for teleport.
- The working directory is a Git repository.

## Main Success Scenario

1. The developer runs the `/teleport` command.
2. The system checks teleport eligibility (feature flag, Mistral model, eligible plan).
3. The system packages the session's conversation and Git state.
4. The system transfers the session to the hosted Vibe Code environment.
5. The system confirms the session is now available remotely.

## Alternative Flows

- **A1 — Not eligible (from step 2):** When any eligibility condition fails, the `/teleport` command is not offered, so the developer cannot start it.
- **A2 — Teleport error (from step 4):** The system reports the teleport error and the local session continues unchanged.
- **A3 — Teleport on start:** The session can also be teleported at startup via the `--teleport` flag.

## Postconditions

- **Success:** The session is available in the hosted Vibe Code environment.
- **Failure:** The local session is unaffected; an error is shown.

## Business Rules

- **BR-045:** Teleport is available only when the Vibe Code feature is enabled, the active model is Mistral, and the plan is teleport-eligible.

## Notes

The teleport flag is not yet exposed to end users (it is a suppressed CLI option), so this use case is documented as `Draft`. The command-availability gating is fully implemented; the end-to-end transfer flow could not be fully traced from the entry points alone.
