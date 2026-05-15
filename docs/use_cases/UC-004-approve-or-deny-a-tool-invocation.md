# UC-004: Approve or Deny a Tool Invocation

## Overview

| Field | Value |
|---|---|
| **ID** | UC-004 |
| **Name** | Approve or Deny a Tool Invocation |
| **Primary Actor** | Developer |
| **Goal** | Decide whether a specific tool call proposed by the assistant should run, with the option to extend that decision to similar future calls in the same session. |
| **Status** | Implemented |

## Preconditions

- An interactive session is in progress (see UC-003).
- The assistant has proposed a tool call whose effective permission is *ask* for this invocation.

## Main Success Scenario

1. The system displays the tool name and arguments that the assistant proposes to execute.
2. The system lists the scopes that approval will cover (e.g. "this exact command", "this command pattern", "this file pattern", "all paths outside the working directory").
3. The system asks the developer whether to approve the call.
4. The developer selects *Approve once*.
5. The system runs the tool, captures stdout, stderr, and exit status.
6. The system reports the result back to the assistant in UC-003.

## Alternative Flows

### A1 — Approve and remember for the session

Trigger: At step 4, the developer chooses *Always approve* for one of the offered scopes.

1. The system records an approved rule for that scope on the current session.
2. The flow continues at step 5.
3. Subsequent calls matching the same scope skip this use case and run directly.

### A2 — Approve permanently

Trigger: At step 4, the developer chooses *Always approve and persist*.

1. The system writes the approval into the persisted configuration (e.g. updates the bash allowlist or sets the tool's permission to *always*).
2. The flow continues at step 5.

### A3 — Deny once

Trigger: At step 4, the developer chooses *Deny*.

1. The system aborts the tool call and reports a denial result to the assistant.
2. The flow returns to UC-003 step 4.

### A4 — Sensitive pattern overrides permanent approval

Trigger: At step 1, the tool call matches a `sensitive_patterns` entry even though the tool's permission is *always*.

1. The system still asks for approval as if the permission were *ask*.

### A5 — File path outside the working directory

Trigger: At step 1, a file-touching tool targets a path outside the current working directory.

1. The system flags this as an "outside directory" scope so the developer can approve or deny on that basis.

## Postconditions

- **Success**: The tool call runs and its result is fed back to the conversation. If a scope was approved, future matching calls in this session (or, for permanent approvals, in all future sessions) skip the dialog.
- **Failure**: The call is reported as denied; no side effects occur.

## Business Rules

- **BR-014**: A tool can declare four scope kinds for approval: command pattern, file pattern, URL pattern, and outside-directory. The system offers only the scopes that apply to the invocation.
- **BR-015**: Session-level approvals are stored on the running session and discarded when it ends; permanent approvals are written to the user-level configuration file.
- **BR-016**: A `sensitive_patterns` match always re-asks for approval, even when the tool's permission is *always*.
- **BR-017**: A bash command on the denylist is rejected without prompting, regardless of any session approvals.
