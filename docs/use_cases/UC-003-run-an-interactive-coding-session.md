# UC-003: Run an Interactive Coding Session

## Overview

- **ID:** UC-003
- **Name:** Run an Interactive Coding Session
- **Primary Actor:** Developer
- **Goal:** Work with the agent conversationally to explore and change a codebase, approving the actions the agent takes.
- **Status:** Implemented

## Preconditions

- API access is configured (see UC-001).
- The developer has started Vibe interactively in a working directory.

## Main Success Scenario

1. The developer types a request in natural language and submits it.
2. The system gathers project context (file structure and version-control status) and sends the request to the model.
3. The agent responds, and when it needs to act it proposes a tool action such as reading a file, searching the code, editing a file, or running a shell command.
4. The system pauses and asks the developer to approve the proposed action.
5. The developer approves the action.
6. The system runs the action and returns the result to the agent.
7. The agent continues, repeating steps 3-6 as needed, optionally asking the developer clarifying questions or delegating part of the work to a subagent.
8. The agent presents its final answer or summary of the changes made.
9. The developer reviews the result and either continues the conversation or ends the session.

## Alternative Flows

- **A1 — Developer rejects a proposed action.** Trigger: at step 5 the developer declines the action. The system does not run it and reports the rejection to the agent, which adjusts its approach.
- **A2 — Action is pre-approved.** Trigger: the active agent profile bypasses approval, or the tool's permission policy or allowlist already covers the action. The system runs the action without prompting (step 4 is skipped).
- **A3 — Developer interrupts the agent.** Trigger: the developer presses the interrupt key while the agent is working. The system stops the current turn and returns control to the developer.
- **A4 — Agent asks a clarifying question.** Trigger: the agent needs more information. The system presents the question with selectable options; the developer answers and the agent resumes.
- **A5 — Tool action fails.** Trigger: a tool action raises an error at step 6. The system returns the error to the agent, which reports it or tries another approach.
- **A6 — Context grows too large.** Trigger: the conversation reaches the compaction threshold. The system summarizes earlier history before continuing (see UC-006).
- **A7 — Direct shell command.** Trigger: the developer prefixes input with the shell escape character. The system runs the command directly without involving the agent.

## Postconditions

- **Success:** The requested exploration or changes are completed, approved actions are applied to the working directory, and the conversation is recorded in the session log.
- **Failure:** No unapproved action is applied; rejected or failed actions leave the working directory unchanged for that step.

## Business Rules

- **BR-006:** A tool action requires explicit developer approval unless the active agent profile bypasses permissions or the tool's permission policy or allowlist already authorizes it.
- **BR-007:** Under the read-only planning profile, file-writing actions are restricted to the plans directory.
- **BR-008:** Model aliases in the configuration must be unique.
- **BR-009:** A separate compaction model, if configured, must use the same provider as the active model.
