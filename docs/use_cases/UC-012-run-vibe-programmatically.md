# UC-012 Run Vibe Programmatically

## Overview

- **ID:** UC-012
- **Name:** Run Vibe Programmatically
- **Primary Actor:** Developer
- **Goal:** Run a single prompt non-interactively — for scripting or automation — and capture the result.
- **Status:** Implemented

## Preconditions

- An API key is configured (onboarding cannot run non-interactively).

## Main Success Scenario

1. The developer runs Vibe with `--prompt`, optionally piping the prompt on standard input.
2. The system loads the configuration and selects the `auto-approve` agent unless `--agent` was given.
3. The system disables the interactive-only tools (the question tool and the plan-mode exit tool).
4. The system runs the agent loop, auto-approving tool calls, until the agent produces a final answer or a cap is hit.
5. The system writes the result in the requested output format (text, JSON, or streaming JSON) and exits with success.

## Alternative Flows

- **A1 — No prompt supplied (from step 1):** With neither a `--prompt` value nor piped input, the system prints an error and exits non-zero.
- **A2 — Turn or price cap reached (from step 4):** When `--max-turns` or `--max-price` is reached, the system stops and exits with a conversation-limit message.
- **A3 — Tool allowlist (from step 3):** With `--enabled-tools` the system enables only the listed tools (exact names, glob patterns, or `re:` regex) and disables the rest.
- **A4 — Runtime error (from step 4):** The system prints the error and exits non-zero.
- **A5 — Resume a session (from step 2):** With `--continue` or `--resume`, the prior conversation is loaded before the prompt runs (UC-009).

## Postconditions

- **Success:** The final response is printed in the chosen format and the process exits zero.
- **Failure:** An error message is printed to standard error and the process exits non-zero.

## Business Rules

- **BR-028:** In programmatic mode tool calls are auto-approved and `default_agent` is ignored.
- **BR-029:** The question tool and the plan-mode exit tool are always disabled in programmatic mode.
- **BR-030:** Output format is one of `text` (default), `json`, or `streaming`.
