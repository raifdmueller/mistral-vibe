# UC-005: Configure the Active Session

## Overview

- **ID**: UC-005
- **Name**: Configure the Active Session
- **Primary Actor**: Developer
- **Goal**: Change the model, reasoning level, agent profile, or other configuration that the current Vibe session uses, either persistently (config file) or for the running session only.
- **Status**: Implemented

## Preconditions

- An interactive session is in progress (or the developer launched Vibe with `--setup` to edit configuration without running a session).
- The Vibe home directory exists; `config.toml` is loadable (an empty or missing file uses built-in defaults).

## Main Success Scenario

1. Developer chooses a configuration command: `/model` to change the active model, `/thinking` to change the reasoning level, `/config` to edit the on-disk configuration, or `/reload` to re-read configuration, agent instructions, and skills from disk.
2. System validates that the command is allowed (e.g. `/model` requires more than one configured model).
3. For `/model` or `/thinking`, system displays the available choices and the developer selects one; the change applies immediately to the current session.
4. For `/config`, system opens the on-disk `config.toml` in the developer's editor and waits for the editor to exit.
5. After the editor exits, system reloads the configuration, reports any validation errors, and rolls back to the previous in-memory configuration if validation fails.
6. For `/reload`, system re-reads `config.toml`, the project and user `AGENTS.md` overlays, the agent profiles, the skill set, and the tool registry without restarting the process.
7. System confirms the change in the UI and returns to the input prompt.

## Alternative Flows

- **A1**: Trigger at step 5 — Reloaded configuration fails validation (unknown field, invalid value, missing required field). System reports the issue, keeps the previous configuration active, and returns to the prompt.
- **A2**: Trigger at step 1 — Developer passes `--agent <name>` on the command line. System applies the named agent profile for the duration of the invocation, overriding the `default_agent` setting.
- **A3**: Trigger at step 3 — Selected model is not registered with any provider. System reports the error and keeps the previous model active.
- **A4**: Trigger at step 1 — Developer sets an environment variable with the `VIBE_` prefix (for example `VIBE_ACTIVE_MODEL`). System applies it as a configuration override on next start without touching `config.toml`.

## Postconditions

- **Success**: The active model, thinking level, or agent profile reflects the developer's choice; any persisted changes are saved to `config.toml`.
- **Failure**: The previous configuration remains active; the session continues without disruption.

## Business Rules

- **BR-024**: Configuration values resolve in this order, highest priority first: `VIBE_*` environment variables, `config.toml` in the Vibe home directory, built-in defaults.
- **BR-025**: The active model name must match the `alias` of one entry in `models`; that entry's `provider` must match the `name` of one entry in `providers`.
- **BR-026**: Thinking level must be one of `off`, `low`, `medium`, `high`, `max`; the model decides whether reasoning is actually emitted.
- **BR-027**: In programmatic mode, `default_agent` is ignored and the active profile falls back to `auto-approve` unless `--agent` is given.
- **BR-028**: `/reload` reloads configuration files, agent profiles, skills, and tool registry, but it does not change the active model or restart the conversation.
