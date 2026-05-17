# UC-017 Schedule a Recurring Prompt

## Overview

- **ID:** UC-017
- **Name:** Schedule a Recurring Prompt
- **Primary Actor:** Developer
- **Secondary Actor:** Scheduler
- **Goal:** Have a prompt run automatically at a fixed interval during the session.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).

## Main Success Scenario

1. The developer runs `/loop` with an interval and a prompt.
2. The system records a scheduled loop with the interval, the prompt, a creation time, and the next fire time.
3. When the next fire time arrives, the scheduler submits the prompt as a turn (UC-002).
4. The system reschedules the loop's next fire time by the interval.
5. The loop keeps firing for the life of the session.

## Alternative Flows

- **A1 — List loops (from step 1):** With `/loop list` the system shows all scheduled loops.
- **A2 — Cancel a loop (from step 1):** With `/loop cancel <id>` or `/loop cancel all` the system removes the chosen loop or every loop.
- **A3 — Turn already running (from step 3):** If a turn is in progress when a loop fires, the loop prompt waits until the agent is idle.

## Postconditions

- **Success:** The scheduled loop is recorded in the session metadata and fires on its interval.
- **Failure:** No loop is created; an explanation is shown.

## Business Rules

- **BR-043:** A scheduled loop carries an id, an interval in seconds, a prompt, a creation time, and a next fire time.
- **BR-044:** Scheduled loops are stored in the session metadata so they are visible across the session's lifetime.
