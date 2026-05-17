# UC-008 Grant Tool Permissions

## Overview

- **ID**: UC-008
- **Name**: Grant Tool Permissions
- **Primary Actor**: Developer
- **Goal**: Decide which actions the assistant may take on the developer's machine before they happen.
- **Status**: Implemented

## Preconditions

- A session is running and the assistant has requested a tool action (run a command, edit a file, fetch a URL).

## Main Success Scenario

1. The assistant requests a tool action as part of a turn.
2. The system checks the action against the permission rules for that tool.
3. If the action is not pre-approved, the system shows the developer what the assistant wants to do.
4. The developer approves or denies the action.
5. On approval, the system runs the action and returns the result to the assistant.
6. On denial, the system reports the refusal to the assistant and continues.

## Alternative Flows

- **A1 — Pre-approved action** (step 2): the action matches an allowed prefix or rule; the system runs it without prompting.
- **A2 — Always-denied action** (step 2): the action matches a deny rule; the system refuses it without prompting.
- **A3 — Permissions bypassed** (step 2): the developer has enabled permission bypass, or the auto-approve agent is active; the system runs the action without prompting.
- **A4 — Remember the choice** (step 4): the developer chooses to always allow this kind of action; the system records the rule for the rest of the session.

## Postconditions

- **Success**: The approved action has run and the assistant has its result.
- **Failure**: A denied action is not run; the assistant is told it was refused.

## Business Rules

- **BR-013**: Shell commands are matched against allow, deny, ask, and arity rules; ask rules always prompt regardless of arity approval.
- **BR-014**: When permission bypass is enabled, or the agent profile auto-approves, tool actions run without a prompt.
