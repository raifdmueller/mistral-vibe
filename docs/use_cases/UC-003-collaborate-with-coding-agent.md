# UC-003 Collaborate with the Coding Agent

## Overview

- **ID:** UC-003
- **Name:** Collaborate with the Coding Agent
- **Primary Actor:** Developer
- **Supporting Actor:** LLM Provider
- **Goal:** Describe a task in natural language and have the agent carry it out by reading, editing, and running code.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001) with a usable credential (UC-002).

## Main Success Scenario

1. The Developer types a request describing what they want done.
2. The system sends the conversation and the available tools to the language model.
3. The model returns a response that may include text and tool requests.
4. The system streams the model's text to the Developer as it arrives.
5. For each tool request, the system runs the tool — reading a file, editing code, running a shell command, searching the web — and feeds the result back to the model. Actions that need approval go through UC-004.
6. The system repeats steps 2–5 until the model produces a final answer with no further tool requests.
7. The system shows the final answer and updated session statistics, then waits for the next request.

## Alternative Flows

- **A1 — Developer interrupts the turn (diverges at any of steps 2–6):** The Developer cancels; the system stops the current turn, keeps the conversation so far, and returns to step 1.
- **A2 — Context window nears its limit (diverges at step 2):** Token usage crosses the model's auto-compact threshold; the system compacts the conversation (UC-007) and continues.
- **A3 — The model call fails transiently:** The system retries the request with backoff before surfacing an error.
- **A4 — The model call fails permanently (diverges at step 3):** The system reports the error and returns to step 1 without losing the conversation.
- **A5 — A tool fails (diverges at step 5):** The system returns the failure to the model, which decides how to recover.
- **A6 — Developer's request is a slash command (diverges at step 1):** The system handles it locally instead of sending it to the model — see UC-007, UC-008, and others.

## Postconditions

- **Success:** The agent has answered the request; any file or shell side effects are applied; the conversation and statistics are updated and logged.
- **Failure:** An error is reported; the conversation up to the failure is preserved.

## Business Rules

- **BR-007:** The conversation must stay within the active model's context window; crossing the model's auto-compact threshold triggers compaction.
- **BR-008:** A turn that the Developer interrupts leaves the conversation intact up to the point of interruption.
