# UC-001 Start a Coding Session

## Overview

- **ID:** UC-001
- **Name:** Start a Coding Session
- **Primary Actor:** Developer
- **Goal:** Launch Vibe in a project directory and reach an interactive prompt ready to receive instructions.
- **Status:** Implemented

## Preconditions

- Vibe is installed and on the developer's PATH.
- An API key is available, or the developer is willing to complete the onboarding flow.

## Main Success Scenario

1. The developer runs Vibe from a project directory, optionally passing an opening prompt.
2. The system loads environment values and ensures a default configuration file and command history file exist (BR-001).
3. The system loads the configuration, choosing the agent profile from the `--agent` flag or the configured default agent.
4. If the working directory is not yet trusted and contains project configuration files, the system asks the developer whether to trust it (UC-021).
5. The system starts the interactive terminal interface, deferring heavy initialization so the prompt appears quickly.
6. The system displays a welcome banner and an empty input prompt.
7. If an opening prompt was supplied, the system submits it as the first turn (UC-002).

## Alternative Flows

- **A1 — API key missing (from step 3):** If no API key is configured and the session is interactive, the system runs the onboarding flow to collect and save the key, then continues. If the session is non-interactive, the system prints an error and exits.
- **A2 — Invalid system prompt id (from step 3):** The system prints the invalid id and exits.
- **A3 — Working directory deleted (from step 1):** If the current directory no longer exists, the system prints guidance and exits.
- **A4 — Resume requested (from step 5):** If `--continue` or `--resume` was passed, the system loads the prior session before showing the prompt (UC-009).

## Postconditions

- **Success:** An interactive session is running with a loaded configuration, a selected agent profile, and a new session id.
- **Failure:** The process exits with a non-zero status and an explanatory message; no session is started.

## Business Rules

- **BR-001:** On first run, the system creates a default config file and a history file seeded with a greeting line.
- **BR-002:** In interactive mode the agent profile defaults to the `default_agent` config setting; with `--prompt` it defaults to `auto-approve` and `default_agent` is ignored.
- **BR-003:** Subagent profiles (such as `explore`) cannot be selected as the session's starting agent.
