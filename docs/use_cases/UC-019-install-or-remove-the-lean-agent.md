# UC-019 Install or Remove the Lean Agent

## Overview

- **ID:** UC-019
- **Name:** Install or Remove the Lean Agent
- **Primary Actor:** Developer
- **Goal:** Add or remove the specialized Lean 4 agent so it is available (or not) in the agent rotation.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).

## Main Success Scenario

1. The developer runs the `/leanstall` command.
2. The system installs the Lean 4 agent and records it among the installed agents.
3. The system confirms the installation.
4. The Lean agent is now selectable in the agent rotation (UC-006).

## Alternative Flows

- **A1 — Uninstall (from step 1):** With `/unleanstall` the system removes the Lean agent and it no longer appears in the rotation.
- **A2 — Already installed / not installed (from step 2):** The system reports that no action was needed.

## Postconditions

- **Success:** The Lean agent's installed state matches the developer's choice.
- **Failure:** The installed-agent set is unchanged; an explanation is shown.

## Business Rules

- **BR-046:** The Lean agent requires explicit installation before it can be selected; install-required agents are hidden until installed.
- **BR-047:** The Lean agent uses its own model, provider, system prompt, and a longer shell command timeout.
