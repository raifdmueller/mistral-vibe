# UC-015 Schedule a Recurring Prompt

## Overview

- **ID**: UC-015
- **Name**: Schedule a Recurring Prompt
- **Primary Actor**: Developer
- **Goal**: Have Vibe run a prompt automatically on a recurring interval.
- **Status**: Implemented

## Preconditions

- An interactive session is running.

## Main Success Scenario

1. The developer issues the loop command with an interval and a prompt.
2. The system registers the recurring prompt and confirms the schedule.
3. When the interval elapses, the system runs the prompt as a normal turn.
4. The system shows the result of each scheduled run.

## Alternative Flows

- **A1 — List scheduled loops** (step 1): the developer asks to list loops; the system shows all registered recurring prompts and their identifiers.
- **A2 — Cancel a loop** (step 1): the developer cancels a loop by identifier, or cancels all; the system removes the matching schedules.
- **A3 — Invalid interval** (step 2): the interval cannot be parsed; the system rejects the command and explains the expected format.

## Postconditions

- **Success**: The recurring prompt is registered and runs on schedule until cancelled.
- **Failure**: No schedule is created and the error is reported.

## Business Rules

- **BR-023**: A scheduled loop runs until it is explicitly cancelled or the session ends.
