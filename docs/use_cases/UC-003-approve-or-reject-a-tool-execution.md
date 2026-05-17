# UC-003 Approve or Reject a Tool Execution

## Overview

- **ID:** UC-003
- **Name:** Approve or Reject a Tool Execution
- **Primary Actor:** Developer
- **Goal:** Decide whether a tool the agent wants to run is allowed to execute.
- **Status:** Implemented

## Preconditions

- A turn is in progress and the agent has requested a tool call (UC-002).
- The active agent profile does not bypass tool permissions for this tool.

## Main Success Scenario

1. The system determines the permission required for the requested tool call.
2. The system shows the developer what the tool will do (command, file path, or arguments).
3. The developer approves the call.
4. The system runs the tool and returns its result to the agent.
5. The system records the call as agreed in session statistics.

## Alternative Flows

- **A1 — Developer rejects (from step 3):** The system skips the tool, reports the rejection to the agent, and records the call as rejected.
- **A2 — Approve permanently (from step 3):** The developer chooses to always allow this kind of call; the system records the choice so future matching calls are auto-approved (BR-009).
- **A3 — Auto-approved by profile (from step 1):** When the active profile auto-approves the tool (for example `plan` for read-only tools, `accept-edits` for edits, or `auto-approve` for all), the system skips the prompt and runs the tool directly.
- **A4 — Tool fails (from step 4):** The system captures the error, reports it to the agent, and records the call as failed.

## Postconditions

- **Success:** The tool ran (or was deliberately skipped) and the outcome is recorded in statistics.
- **Failure:** The tool error is surfaced to the agent so it can adapt.

## Business Rules

- **BR-008:** Agent profiles carry a safety level (`safe`, `neutral`, `destructive`, `yolo`) and per-tool permission overrides (`always`, `never`, `ask`).
- **BR-009:** A permanent approval persists the developer's allow decision so equivalent future calls run without a prompt.
- **BR-010:** The `plan` profile may only write inside the plans directory; writes elsewhere are denied.
