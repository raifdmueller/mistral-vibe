# UC-004: Run a Coding Task Non-Interactively

## Overview

- **ID:** UC-004
- **Name:** Run a Coding Task Non-Interactively
- **Primary Actor:** Automation Script
- **Goal:** Run a single coding task end-to-end without human interaction and collect the result, for use in scripts and pipelines.
- **Status:** Implemented

## Preconditions

- API access is configured (see UC-001).
- Vibe is invoked in programmatic mode with a prompt supplied as an argument or piped on standard input.

## Main Success Scenario

1. The automation script invokes Vibe in programmatic mode with a task prompt.
2. The system selects an auto-approving agent so no human approval is needed.
3. The system sends the prompt to the model and lets the agent run its tool actions automatically.
4. The agent works through the task, running tools and producing output.
5. The system formats the conversation output in the requested format (plain text, a single JSON document, or one JSON record per message).
6. The agent completes the task and the system prints the final response.
7. Vibe exits with a success status.

## Alternative Flows

- **A1 — No prompt provided.** Trigger: programmatic mode is requested but neither an argument nor piped input supplies a prompt. The system prints an error and exits with a failure status.
- **A2 — Turn limit reached.** Trigger: the agent reaches the configured maximum number of turns. The system stops the session, reports the limit, and exits with a failure status.
- **A3 — Cost limit reached.** Trigger: the accumulated cost exceeds the configured maximum price. The system interrupts the session, reports the limit, and exits with a failure status.
- **A4 — Restricted tool set.** Trigger: the invocation enables only specific tools. The system disables all other tools for the run.
- **A5 — Continuation of a prior session.** Trigger: the invocation also requests continuing or resuming a session. The system loads the prior conversation before running the prompt (see UC-005).
- **A6 — Runtime error.** Trigger: the agent encounters an unrecoverable error. The system prints the error and exits with a failure status.

## Postconditions

- **Success:** The task output is printed in the requested format and Vibe exits successfully.
- **Failure:** An error is printed and Vibe exits with a non-zero status.

## Business Rules

- **BR-010:** In programmatic mode, when no agent is specified the auto-approving agent is used, and the configured default agent is ignored.
- **BR-011:** In programmatic mode, the interactive question tool and the plan-mode tool are disabled.
- **BR-012:** When a maximum turn count or maximum cost is set, the session is interrupted as soon as either limit is exceeded.
