# UC-012: Review Privacy and Data Retention

## Overview

- **ID**: UC-012
- **Name**: Review Privacy and Data Retention
- **Primary Actor**: Developer
- **Goal**: See what data Mistral Vibe collects locally and remotely, find the relevant retention policy, and control telemetry on the developer's machine.
- **Status**: Implemented

## Preconditions

- An interactive Vibe session is in progress (or the developer can open `config.toml` directly).

## Main Success Scenario

1. Developer runs `/data-retention`.
2. System displays a summary of where data is stored (the Vibe home directory and its `logs/` subdirectory), what telemetry events are emitted, and a link to the Mistral privacy console.
3. System reports the current value of `enable_telemetry` and `session_logging.enabled`.
4. Developer optionally edits `config.toml` (UC-005) to flip `enable_telemetry` to `false` or `session_logging.enabled` to `false` and runs `/reload`.
5. System confirms the new value and stops sending telemetry events (or stops writing session logs) from the next turn onward.

## Alternative Flows

- **A1**: Trigger at step 4 — Developer sets `session_logging.enabled` to `false`. System keeps the in-memory conversation but does not write to disk; resume features will not show this session afterwards.
- **A2**: Trigger at step 4 — Developer deletes individual session directories under `logs/` by hand. System no longer offers those sessions for resume on the next start.

## Postconditions

- **Success**: The developer has seen the current data-retention configuration and any chosen changes are in effect.
- **Failure**: Nothing is changed.

## Business Rules

- **BR-049**: Telemetry is opt-out (`enable_telemetry` defaults to `true`); when set to `false`, no events are sent to the Mistral datalake API.
- **BR-050**: Session logging is opt-out (`session_logging.enabled` defaults to `true`); when `false`, no `meta.json` or `messages.jsonl` is written and resume features cannot find the session afterwards.
