# UC-006 Switch the Active Agent Profile

## Overview

- **ID:** UC-006
- **Name:** Switch the Active Agent Profile
- **Primary Actor:** Developer
- **Goal:** Change how much autonomy the agent has by switching to a different agent profile mid-session.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).

## Main Success Scenario

1. The developer cycles through agent profiles with the agent-switch shortcut.
2. The system shows the next profile in the rotation (`default`, `plan`, `accept-edits`, and others that are available).
3. The system applies the chosen profile's tool permissions and overrides to the active configuration.
4. The system confirms the new active profile.
5. Subsequent turns use the new profile's approval behavior.

## Alternative Flows

- **A1 — Custom profile (from step 2):** A profile defined in `~/.vibe/agents/` or the project's `.vibe/agents/` directory is included in the rotation and can be selected.
- **A2 — Install-required profile not installed (from step 2):** A profile such as `lean` appears only after it has been installed (UC-019).

## Postconditions

- **Success:** The session runs under the newly selected agent profile.
- **Failure:** The previous profile stays active.

## Business Rules

- **BR-014:** Built-in profiles are `default`, `plan`, `chat`, `accept-edits`, `auto-approve`; `explore` is a subagent profile and `lean` requires installation.
- **BR-015:** Switching a profile re-derives tool permissions by deep-merging the profile's overrides onto the base configuration; environment-level tool disables always win over a profile's enabled-tools allowlist.
