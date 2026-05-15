# UC-015: Schedule a Recurring Prompt

## Overview

| Field | Value |
|---|---|
| **ID** | UC-015 |
| **Name** | Schedule a Recurring Prompt |
| **Primary Actor** | Developer |
| **Goal** | Have the agent re-run a prompt on a fixed interval during the current session — for example, to poll a deployment or to keep babysitting a long-running build. |
| **Status** | Implemented |

## Preconditions

- An interactive session is in progress.

## Main Success Scenario

1. The developer issues the loop slash command with an interval (e.g. `5m`) and a prompt body.
2. The system parses the interval, generates a stable loop identifier, and computes the first fire time.
3. The system stores the loop on the session metadata.
4. The system confirms the schedule to the developer.
5. When the next fire time arrives, the system feeds the prompt into the agent loop as if the developer had typed it.
6. The session processes the prompt per UC-003, then re-arms the loop for the next interval.

## Alternative Flows

### A1 — List active loops

Trigger: At step 1, the developer issues the loop list variant.

1. The system shows each loop's identifier, interval, next fire time, and prompt.

### A2 — Cancel a loop

Trigger: At step 1, the developer issues the loop cancel variant with an identifier or `all`.

1. The system removes the matching loop(s) from the session metadata.
2. The system confirms the cancellation.

### A3 — Loop fires while another turn is in progress

Trigger: At step 5, the agent is still processing a prior turn.

1. The system queues the loop's prompt until the current turn ends.

### A4 — Per-session loop limit reached

Trigger: At step 3, the session already holds the maximum number of scheduled loops.

1. The system rejects the new loop and reports the limit.

### A5 — Session ends

Trigger: At any point after step 3, the session is closed or compacted away.

1. The system discards any loops not persisted with the session metadata; resuming the session restores the loops recorded in metadata.

## Postconditions

- **Success**: The loop is recorded on the session metadata, fires at the configured interval, and survives session resumption.
- **Failure**: No loop is added.

## Business Rules

- **BR-058**: A scheduled loop has an interval of at least 30 seconds and at most several days; intervals outside this range are rejected.
- **BR-059**: A session may hold at most 50 active loops.
- **BR-060**: Each loop carries a stable identifier, an interval in seconds, the prompt text, the next fire time, and a creation timestamp.
- **BR-061**: Loops fire only while the session that owns them is active; they do not run as background daemons.
