# UC-002 Run a One-Shot Prompt

## Overview

- **ID**: UC-002
- **Name**: Run a One-Shot Prompt
- **Primary Actor**: Developer (or Automation Script)
- **Goal**: Send a single prompt non-interactively, get the result, and exit — suitable for scripts and CI.
- **Status**: Implemented

## Preconditions

- An API key is available.
- The caller passes the prompt on the command line or via standard input.

## Main Success Scenario

1. The actor runs Vibe in programmatic mode with a prompt.
2. The system loads configuration without an interactive UI.
3. The system selects the auto-approve agent so no human confirmation is needed.
4. The system sends the prompt to the model and runs the requested tool actions automatically.
5. The model produces a final answer.
6. The system prints the answer in the requested output format (text, JSON, or streaming JSON).
7. The system exits.

## Alternative Flows

- **A1 — Prompt from standard input** (step 1): no prompt argument is given; the system reads the prompt from piped standard input.
- **A2 — Turn limit reached** (step 4): the run reaches the maximum number of assistant turns; the system stops and returns the partial result.
- **A3 — Cost limit reached** (step 4): accumulated cost exceeds the maximum price; the system interrupts the run and returns what it has.
- **A4 — Restricted tool set** (step 4): the caller passed an explicit enabled-tools list; the system disables every other tool for the run.

## Postconditions

- **Success**: The answer is written to standard output and the process exits with a success code.
- **Failure**: An error message is written and the process exits with a non-zero code.

## Business Rules

- **BR-003**: In programmatic mode all tool actions are auto-approved and the configured default agent is ignored.
- **BR-004**: A run stops when it reaches the configured maximum number of turns or the maximum price, whichever comes first.
