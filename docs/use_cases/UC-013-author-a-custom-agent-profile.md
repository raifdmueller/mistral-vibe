# UC-013: Author a Custom Agent Profile

## Overview

| Field | Value |
|---|---|
| **ID** | UC-013 |
| **Name** | Author a Custom Agent Profile |
| **Primary Actor** | Developer |
| **Goal** | Create a reusable agent persona tailored to a specific task (e.g. red-teaming, documentation, theorem proving) that bundles a system prompt, model choice, and tool permissions. |
| **Status** | Implemented |

## Preconditions

- Vibe is installed and a working user-level home directory exists.

## Main Success Scenario

1. The developer creates a TOML file in the user-level agents directory, naming it after the agent (kebab-case stem).
2. The developer declares the agent's display name, description, safety level, and any of: `system_prompt_id`, `active_model`, `providers`, `models`, `tools`, `enabled_tools`, `base_disabled`, and `bypass_tool_permissions`.
3. The developer optionally creates a matching prompt markdown file under the user-level prompts directory and references it via `system_prompt_id`.
4. The developer starts Vibe with the `--agent` flag, naming the new profile.
5. The system discovers the file and loads it as an agent profile.
6. The system validates the profile by applying it against the base configuration.
7. The system activates the profile for the session.

## Alternative Flows

### A1 — Profile fails to load

Trigger: At step 5, the TOML file fails to parse or fails validation against the configuration schema.

1. The system logs a warning and excludes the profile from the available set.
2. If the developer specified that profile via `--agent`, the system reports that it was not found and exits.

### A2 — Same name as a built-in profile

Trigger: At step 5, the file's stem matches a built-in profile name (e.g. `default.toml`).

1. The system loads the custom profile and uses it instead of the built-in one of that name.

### A3 — Profile placed in the project-level agents directory

Trigger: At step 1, the developer places the file inside the project's local agents directory.

1. The profile is discovered only when the project folder is trusted (see UC-002).

### A4 — Profile is marked as a subagent

Trigger: At step 2, the developer sets `agent_type = "subagent"`.

1. The profile is registered as a subagent and is available via the `task` tool but cannot be activated as the primary agent.

### A5 — Discover and switch from inside an active session

Trigger: At step 4, the developer instead reloads the running session via the `/reload` slash command.

1. The system rescans the agents directories and refreshes the available profile set.
2. The developer then switches to the new profile per UC-005.

## Postconditions

- **Success**: The custom profile is available for selection in subsequent sessions; activating it applies all of its overrides on top of the base configuration.
- **Failure**: The profile is not loaded and is unavailable to the developer.

## Business Rules

- **BR-049**: Agent profile files are discovered from the configured `agent_paths`, the project-level agents directory, and the user-level agents directory; project-level files require a trusted folder.
- **BR-050**: A profile's `safety` field must be one of `safe`, `neutral`, `destructive`, `yolo`.
- **BR-051**: A profile's `agent_type` must be either `agent` (primary, selectable) or `subagent` (delegate-only).
- **BR-052**: A profile referencing a custom `system_prompt_id` requires a matching markdown file under the user-level prompts directory; otherwise startup fails with `MissingPromptFileError`.
- **BR-053**: A profile may declare its own `providers` and `models` to override the defaults (this is how the built-in `lean` profile pins a specialised model).
