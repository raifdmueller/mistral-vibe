# UC-007: Customize Session Settings

## Overview

- **ID:** UC-007
- **Name:** Customize Session Settings
- **Primary Actor:** Developer
- **Goal:** Adjust how Vibe behaves — the active model, reasoning effort, agent profile, network settings, and other configuration — without leaving the session.
- **Status:** Implemented

## Preconditions

- An interactive session is in progress (see UC-003).

## Main Success Scenario

1. The developer opens a settings action: editing configuration, selecting a model, choosing a reasoning level, switching the agent profile, or configuring proxy and certificate settings.
2. The system shows the relevant options and the current values.
3. The developer changes a value.
4. The system applies the change to the running session and persists it to the configuration where applicable.
5. The system confirms the change and the session continues with the new settings.

## Alternative Flows

- **A1 — Switch agent profile.** Trigger: the developer cycles the agent profile. The system applies the new profile's permissions and behavior to the current session.
- **A2 — Reload from disk.** Trigger: the developer requests a reload. The system re-reads the configuration, project instructions, and skills from disk and applies them.
- **A3 — Install an optional agent.** Trigger: the developer requests installation of an opt-in built-in agent. The system installs it and makes it selectable; an uninstall action reverses this.
- **A4 — Invalid configuration value.** Trigger: a changed value fails validation. The system rejects the change and reports the problem, leaving the previous value in effect.

## Postconditions

- **Success:** The chosen settings are applied to the running session and persisted where applicable.
- **Failure:** The settings are unchanged.

## Business Rules

- **BR-016:** The configured default agent applies only to interactive sessions; programmatic mode ignores it.
- **BR-017:** An opt-in built-in agent must be explicitly installed before it can be selected.
