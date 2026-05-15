# UC-017: Teleport a Session to Vibe Code

## Overview

| Field | Value |
|---|---|
| **ID** | UC-017 |
| **Name** | Teleport a Session to Vibe Code |
| **Primary Actor** | Developer |
| **Goal** | Continue the current CLI conversation in the Vibe Code cloud workspace, so the same context can keep running while the developer steps away from the terminal. |
| **Status** | Implemented |

## Preconditions

- The developer is signed in to a Mistral account with a plan that includes Vibe Code (teleport eligibility).
- The active model is a Mistral-backed model.
- The current working directory is a git repository.
- The teleport feature flag (`vibe_code_enabled`) is on.

## Main Success Scenario

1. The developer issues the `/teleport` slash command.
2. The system checks plan eligibility and reports any blockers (no plan, ineligible model, feature flag off) if present.
3. The system inspects the git state to determine whether the local branch has unpushed commits.
4. If unpushed commits exist, the system asks the developer to approve a push to the remote.
5. The developer approves; the system pushes the branch to its remote.
6. The system authenticates to Vibe Code via browser-based sign-in, if a fresh OAuth flow is required.
7. The system packages the session metadata, conversation transcript, and git pointer and submits the workflow to Vibe Code.
8. The system waits for Vibe Code to confirm and return the workspace URL.
9. The system shows the URL and copies it to the clipboard.
10. The session continues in the cloud workspace; the local CLI session remains usable.

## Alternative Flows

### A1 — Developer declines the push

Trigger: At step 5, the developer declines.

1. The system aborts the teleport and reports that pushing is required.

### A2 — Branch not pushed at all

Trigger: At step 3, the branch has no upstream.

1. The system reports that the branch must be pushed to a remote first, and aborts.

### A3 — Plan does not allow teleport

Trigger: At step 2, the developer's plan or model is not eligible.

1. The system reports the reason and exits without offering teleport.

### A4 — OAuth flow fails

Trigger: At step 6, the developer does not complete the browser sign-in.

1. The system reports the auth failure and aborts the teleport.

### A5 — Vibe Code workflow submission fails

Trigger: At step 7 or 8, the service responds with an error or never returns a URL.

1. The system surfaces the error to the developer.
2. The system reports a telemetry event describing the failure.

### A6 — Teleport command is unavailable

Trigger: At step 1, the command is not registered because the feature flag is off, the model is non-Mistral, or the plan is not eligible.

1. The slash command does not appear in the menu; manual invocation reports that it is not available.

## Postconditions

- **Success**: A Vibe Code workspace is created and its URL is presented to the developer; the local session is unchanged.
- **Failure**: No remote workspace is created; the local session is unchanged.

## Business Rules

- **BR-066**: Teleport is available only when all of: `vibe_code_enabled` is true, the active model is provided by a Mistral backend, and the developer's plan is teleport-eligible.
- **BR-067**: Teleport refuses to run when the local branch has unpushed commits unless the developer explicitly approves the push.
- **BR-068**: The Vibe Code workflow identifier and task queue come from the configuration (`vibe_code_workflow_id`, `vibe_code_task_queue`); the API key environment variable is `MISTRAL_API_KEY` by default.
- **BR-069**: The teleport flow emits telemetry events on success, failure, and developer cancellation; these are subject to UC-003's telemetry rules.
