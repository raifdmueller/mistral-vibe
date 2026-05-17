# UC-014 Run the Agent Non-Interactively

## Overview

- **ID:** UC-014
- **Name:** Run the Agent Non-Interactively
- **Primary Actor:** Automation
- **Supporting Actor:** LLM Provider
- **Goal:** Run a single prompt to completion without a human at the keyboard, and capture the result.
- **Status:** Implemented

## Preconditions

- Mistral Vibe is installed and a usable credential is available without interactive onboarding.

## Main Success Scenario

1. The Automation runs Mistral Vibe in programmatic mode with a prompt, optionally setting limits on turns, cost, and which tools are enabled.
2. The system selects the auto-approve agent mode so no action waits for human approval.
3. The system runs the agent loop (UC-003), running tool actions automatically.
4. The system stops when the agent produces a final answer.
5. The system writes the result in the requested output format — plain text, a single JSON document, or one JSON line per message — and exits.

## Alternative Flows

- **A1 — Prompt supplied on standard input (diverges at step 1):** The prompt is piped in rather than passed as an argument; the system reads it from standard input.
- **A2 — Turn limit reached (diverges at step 3):** The run reaches the configured maximum number of turns; the system stops and reports the result so far.
- **A3 — Cost limit reached (diverges at step 3):** The run's cost exceeds the configured maximum; the system interrupts the run and reports the result so far.
- **A4 — Restricted tool set (diverges at step 1):** The Automation listed specific enabled tools; the system disables every tool not on the list.
- **A5 — No usable credential (diverges at step 1):** The system cannot run onboarding non-interactively; it prints how to set the credential and exits with an error.

## Postconditions

- **Success:** The result was written in the requested format and the process exited.
- **Failure:** An error was reported on the error stream and the process exited with a non-zero status.

## Business Rules

- **BR-033:** Programmatic mode auto-approves every tool action.
- **BR-034:** A programmatic run stops when it reaches the configured maximum number of turns or maximum cost.
- **BR-035:** In programmatic mode, naming enabled tools disables every tool not named.
