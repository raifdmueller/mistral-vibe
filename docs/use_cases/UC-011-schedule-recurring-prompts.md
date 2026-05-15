# UC-011: Schedule Recurring Prompts

## Overview

- **ID**: UC-011
- **Name**: Schedule Recurring Prompts
- **Primary Actor**: Developer
- **Goal**: Have a prompt (or slash command) re-submitted automatically on a fixed interval — useful for status polling, periodic checks, or babysitting a long-running task.
- **Status**: Implemented

## Preconditions

- An interactive Vibe session is in progress.
- The developer is at the input prompt (no tool call is currently executing).

## Main Success Scenario

1. Developer runs `/loop <interval> <prompt-or-command>` (for example `/loop 5m /status` or `/loop 30s check git log`).
2. System parses the interval, validates that the prompt is non-empty, and registers a scheduled loop entry in the running session.
3. System acknowledges the schedule and returns the developer to the input prompt.
4. Each time the interval elapses, system submits the registered prompt as a new user turn (UC-002 handles the rest).
5. Developer can manage running loops with `/loop list` (see registered loops) or `/loop cancel <id>` (stop a specific loop).
6. When the session ends, system stops all scheduled loops and records each loop's invocation history in the session metadata.

## Alternative Flows

- **A1**: Trigger at step 4 — Previous loop iteration is still running when the next interval elapses. System skips the new iteration and logs a warning rather than queueing it up.
- **A2**: Trigger at step 1 — Interval cannot be parsed as a duration. System reports the format expected (`<number><s|m|h>`) and does not register the loop.
- **A3**: Trigger at step 1 — Developer omits both interval and prompt. System defaults to a 10 minute interval and prompts for the message body.
- **A4**: Trigger at step 5 — Developer runs `/loop cancel` with an unknown loop ID. System reports that no such loop exists.

## Postconditions

- **Success**: A scheduled loop is registered in the session; future interval ticks fire its prompt automatically.
- **Failure**: No loop is registered; the session continues normally.

## Business Rules

- **BR-046**: Loop intervals are expressed in seconds, minutes, or hours (`s`, `m`, `h`) and must be a positive integer.
- **BR-047**: A loop iteration is skipped if the previous iteration has not yet produced a final assistant message.
- **BR-048**: Scheduled loops live only for the duration of the session and are not persisted across restarts; the list of fired iterations is recorded in the session's `meta.json` for auditing.
