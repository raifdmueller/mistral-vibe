# UC-010: Teleport Session to Vibe Code

## Overview

- **ID**: UC-010
- **Name**: Teleport Session to Vibe Code
- **Primary Actor**: Developer
- **Goal**: Hand off the current local Vibe session — conversation history, working-tree state, and todo list — to a cloud-hosted Vibe Code workflow so that work can continue from a browser.
- **Status**: Implemented

## Preconditions

- The developer's plan is eligible for teleport (their account's `plan_info` reports `is_teleport_eligible`).
- The active model is a Mistral-provided model.
- The `vibe_code_enabled` configuration flag is true and the Mistral API key is set.
- The current working directory is a Git repository (clean working tree is preferred but not required).

## Main Success Scenario

1. Developer invokes `/teleport`.
2. System verifies the eligibility preconditions and, if any check fails, refuses with an explanation.
3. System asks the developer for confirmation, summarizing what will be uploaded (repository snapshot, conversation, todos).
4. System packages the repository state (compressed tarball excluding ignored files) together with the session transcript and todo list.
5. System uploads the package to the Vibe Code workflow service through the Nuage workflow client and receives a workflow ID.
6. System opens the Vibe Code URL for that workflow in the developer's browser.
7. System subscribes to the workflow's event stream and forwards status updates back to the developer in the CLI until the workflow reports ready.
8. Developer continues the conversation in Vibe Code; the local CLI session ends after teleport.

## Alternative Flows

- **A1**: Trigger at step 2 — Plan is not eligible (the developer's plan does not include Vibe Code). System reports the ineligibility and offers a link to upgrade.
- **A2**: Trigger at step 2 — Active model is not a Mistral model. System refuses and asks the developer to switch models first (UC-005).
- **A3**: Trigger at step 5 — Upload to the workflow service fails. System reports the error, keeps the local session open, and offers a retry.
- **A4**: Trigger at step 3 — Developer cancels at the confirmation prompt. System aborts the teleport and returns to the local prompt.

## Postconditions

- **Success**: A Vibe Code workflow has been started with the session's state and is open in the developer's browser; the local CLI session is closed.
- **Failure**: No workflow is started; the local session continues normally.

## Business Rules

- **BR-043**: Teleport is offered only when all three are true: the user's plan is teleport-eligible, the active model belongs to the Mistral provider, and `vibe_code_enabled` is true.
- **BR-044**: The session payload sent to the workflow service excludes paths matched by the repository's `.gitignore` and by Vibe's own ignore list.
- **BR-045**: The workflow ID and Vibe Code URL are emitted as telemetry events (`teleport_*`) only when `enable_telemetry` is true.
