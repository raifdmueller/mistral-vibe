# UC-005 Select an Agent Mode

## Overview

- **ID:** UC-005
- **Name:** Select an Agent Mode
- **Primary Actor:** Developer
- **Goal:** Choose how autonomously the agent operates — from read-only planning to fully auto-approved execution.
- **Status:** Implemented

## Preconditions

- Mistral Vibe is starting, or an interactive session is running.

## Main Success Scenario

1. The Developer names the agent mode to use, on the command line or while a session runs.
2. The system looks up the mode among the built-in modes and any custom modes defined in the agent directory.
3. The system applies the mode's settings on top of the loaded configuration — adjusting which tools are enabled and how tool permissions are handled.
4. The system reports the active mode and its safety level, and continues the session under that mode.

## Alternative Flows

- **A1 — No mode named (diverges at step 1):** The system uses the default mode from configuration.
- **A2 — Custom mode from a file (diverges at step 2):** The named mode is a custom definition; the system reads its file and applies its overrides.
- **A3 — Mode requires installation (diverges at step 3):** The mode (for example the Lean agent) is not installed; the system declines to activate it and tells the Developer to install it first.
- **A4 — Unknown mode name (diverges at step 2):** The system reports that the mode does not exist and keeps the current mode.
- **A5 — Programmatic start (diverges at step 1):** The Developer did not name a mode and started in non-interactive mode; the system selects the auto-approve mode (UC-014).

## Postconditions

- **Success:** Exactly one agent mode is active; its tool and permission settings govern the session.
- **Failure:** The requested mode was not activated; the previous mode remains in effect.

## Business Rules

- **BR-012:** Exactly one agent mode is active per session.
- **BR-013:** An agent mode that is marked install-required must be installed before it can be selected.
- **BR-014:** Each agent mode carries a safety level — safe, neutral, destructive, or yolo.
