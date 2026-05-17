# UC-011 Schedule a Recurring Prompt

## Overview

- **ID:** UC-011
- **Name:** Schedule a Recurring Prompt
- **Primary Actor:** Developer
- **Goal:** Have the agent run the same prompt automatically at a fixed interval.
- **Status:** Implemented

## Preconditions

- An interactive session is running.

## Main Success Scenario

1. The Developer schedules a loop, giving an interval and the prompt to run.
2. The system validates the interval and the prompt and records the loop with the session.
3. The system confirms the loop and its identifier.
4. When the interval elapses, the system runs the prompt as a new turn (UC-003).
5. The system repeats step 4 until the loop is cancelled.

## Alternative Flows

- **A1 — List scheduled loops (diverges at step 1):** The Developer asks to list loops; the system shows each loop with its identifier, interval, and prompt.
- **A2 — Cancel a loop (diverges at step 1):** The Developer cancels a loop by identifier, or cancels all loops; the system removes them and stops their runs.
- **A3 — Invalid interval or empty prompt (diverges at step 2):** The system rejects the request and reports the problem.
- **A4 — Session resumed with loops (diverges at step 1):** A resumed session (UC-006) restores its stored loops, which continue firing.

## Postconditions

- **Success:** The loop is recorded with the session and fires its prompt on schedule.
- **Failure:** No loop was created; the Developer was told why.

## Business Rules

- **BR-027:** A scheduled loop fires its prompt at a fixed interval until it is cancelled.
- **BR-028:** Scheduled loops are stored with the session and restored when the session resumes.
