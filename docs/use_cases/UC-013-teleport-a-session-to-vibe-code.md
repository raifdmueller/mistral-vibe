# UC-013: Teleport a Session to Vibe Code

## Overview

- **ID:** UC-013
- **Name:** Teleport a Session to Vibe Code
- **Primary Actor:** Developer
- **Goal:** Move the current session to the Vibe Code cloud so the agent can continue the work remotely.
- **Status:** Implemented

## Preconditions

- API access is configured (see UC-001).
- The cloud teleport feature is enabled and the developer's plan is eligible.
- The active model is a Mistral model.
- The working directory is a git repository.

## Main Success Scenario

1. The developer requests teleport of the current session.
2. The system verifies that teleport is available for the current model and plan.
3. The system prepares the session and determines that the local repository state must be shared with the cloud.
4. The system asks the developer to approve pushing the repository state.
5. The developer approves the push.
6. The system uploads the repository state and hands the session off to the Vibe Code cloud workflow.
7. The agent continues the work remotely and the system streams progress back to the developer.

## Alternative Flows

- **A1 — Teleport not available.** Trigger: at step 2 teleport is disabled, the plan is not eligible, or the active model is not a Mistral model. The teleport command is not offered.
- **A2 — Developer declines the push.** Trigger: at step 5 the developer declines to share the repository state. The system cancels the teleport and keeps the session local.
- **A3 — Teleport error.** Trigger: the cloud handoff fails. The system reports a teleport error; in non-interactive mode Vibe exits with a failure status.

## Postconditions

- **Success:** The session is running in the Vibe Code cloud with the repository state uploaded, and progress is streamed back to the developer.
- **Failure:** The session remains local and unchanged.

## Business Rules

- **BR-028:** Teleport is offered only when the cloud feature is enabled, the developer's plan is eligible, and the active model is a Mistral model.
