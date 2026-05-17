# UC-013 Teleport a Session to Vibe Code

## Overview

- **ID:** UC-013
- **Name:** Teleport a Session to Vibe Code
- **Primary Actor:** Developer
- **Supporting Actor:** Vibe Code Cloud
- **Goal:** Hand the current session off to the Vibe Code cloud so it continues running remotely.
- **Status:** Implemented

## Preconditions

- An interactive session is running.
- Vibe Code is enabled, the active model is a Mistral model, and the Developer's plan is teleport-eligible.
- The working directory is a git repository.

## Main Success Scenario

1. The Developer asks to teleport the session to Vibe Code.
2. The system confirms the working directory is a git repository and gathers its state.
3. The system creates a remote workflow on Vibe Code Cloud and transfers the session to it.
4. The system reports that the session is now running remotely and how to follow it.

## Alternative Flows

- **A1 — Teleport not available (diverges at step 1):** The eligibility conditions are not met; the system does not offer the teleport command.
- **A2 — Working directory is not a git repository (diverges at step 2):** The system reports the requirement and does not teleport.
- **A3 — Remote workflow creation fails (diverges at step 3):** Vibe Code Cloud rejects or cannot start the workflow; the system reports the failure and the local session keeps running.

## Postconditions

- **Success:** The session is running on Vibe Code Cloud and the Developer knows how to follow it.
- **Failure:** No remote workflow was created; the local session is unaffected.

## Business Rules

- **BR-031:** Teleport is available only when Vibe Code is enabled, the active model is a Mistral model, and the Developer's plan is teleport-eligible.
- **BR-032:** The working directory must be a git repository to be teleported.
