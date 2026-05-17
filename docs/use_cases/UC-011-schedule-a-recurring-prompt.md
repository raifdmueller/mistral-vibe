# UC-011: Schedule a Recurring Prompt

## Overview

- **ID:** UC-011
- **Name:** Schedule a Recurring Prompt
- **Primary Actor:** Developer
- **Goal:** Have a prompt re-submitted to the agent automatically at a fixed interval.
- **Status:** Implemented

## Preconditions

- An interactive session is in progress (see UC-003).

## Main Success Scenario

1. The developer registers a recurring prompt, giving an interval and the prompt text.
2. The system validates the interval and the prompt and records the scheduled loop in the session.
3. The system confirms the loop, reporting its identifier and interval.
4. When the interval elapses, the Scheduler submits the prompt to the agent as if the developer had typed it.
5. The agent processes the prompt and the loop continues firing at each interval.
6. The developer lists the active loops or cancels a specific loop or all loops when finished.

## Alternative Flows

- **A1 — Empty or command-like prompt.** Trigger: at step 2 the prompt is empty or begins with the slash-command character. The system rejects the loop and reports the problem.
- **A2 — Invalid interval.** Trigger: the interval cannot be parsed. The system rejects the loop and shows the expected format.
- **A3 — Loop limit reached.** Trigger: the session already has the maximum number of loops. The system rejects the new loop and reports the limit.
- **A4 — Agent busy when a loop is due.** Trigger: the agent is already working when a loop's interval elapses. The system holds the loop and fires it once the agent is free.
- **A5 — Cancel loops.** Trigger: the developer cancels a loop by identifier or cancels all loops. The system removes the matching loops and confirms.
- **A6 — Loops restored on resume.** Trigger: a session with scheduled loops is resumed (see UC-005). The system restores the loops and resumes firing them.

## Postconditions

- **Success:** The recurring prompt is recorded with the session and fires at its interval until cancelled.
- **Failure:** No loop is registered.

## Business Rules

- **BR-025:** A session may have at most 50 scheduled loops.
- **BR-026:** A loop prompt must not be empty and must not begin with the slash-command character.
- **BR-027:** A loop interval must be expressed in a parseable duration format.
