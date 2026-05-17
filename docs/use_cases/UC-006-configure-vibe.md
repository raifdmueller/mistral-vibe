# UC-006 Configure Vibe

## Overview

- **ID**: UC-006
- **Name**: Configure Vibe
- **Primary Actor**: Developer
- **Goal**: Adjust Vibe's behavior — models, providers, UI, telemetry, tools — to suit the developer's environment.
- **Status**: Implemented

## Preconditions

- Vibe is installed.

## Main Success Scenario

1. The developer opens the configuration view with a slash command.
2. The system shows current settings, layered from defaults, the home configuration, and the project configuration.
3. The developer changes a setting.
4. The system validates the change against the configuration schema.
5. The system writes the change to the appropriate configuration file.
6. The system applies the change to the running session where possible.

## Alternative Flows

- **A1 — Environment variable override** (step 2): a `VIBE_*` environment variable is set; the system applies it over the file value for the run.
- **A2 — Reload from disk** (step 1): the developer reloads configuration; the system re-reads configuration, agent instructions, and skills from disk.
- **A3 — Invalid value** (step 4): the change fails schema validation; the system rejects it and keeps the previous value.
- **A4 — First run bootstrap**: no configuration files exist; the system creates default configuration files before continuing.

## Postconditions

- **Success**: The configuration file reflects the change and is valid against the schema.
- **Failure**: The configuration file is unchanged and the error is reported.

## Business Rules

- **BR-009**: Configuration is layered — built-in defaults, then the home configuration, then the project configuration — with later layers overriding earlier ones.
- **BR-010**: A project configuration layer is only applied when its directory is trusted.
- **BR-011**: Any configuration field can be overridden for a single run by a matching `VIBE_*` environment variable.
