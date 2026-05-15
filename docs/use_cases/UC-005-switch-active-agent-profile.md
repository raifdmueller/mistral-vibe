# UC-005: Switch Active Agent Profile

## Overview

| Field | Value |
|---|---|
| **ID** | UC-005 |
| **Name** | Switch Active Agent Profile |
| **Primary Actor** | Developer |
| **Goal** | Change the agent's safety posture and tool set mid-session (e.g. from default approval-required to read-only planning, or to auto-approve everything). |
| **Status** | Implemented |

## Preconditions

- An interactive session is in progress (see UC-003).
- At least two agent profiles are available (built-in profiles always satisfy this).

## Main Success Scenario

1. The developer presses Shift+Tab to cycle the active agent profile.
2. The system computes the next profile in the canonical order: default, plan, accept-edits, auto-approve, followed by any installed custom profiles.
3. The system applies the new profile's overrides onto the base configuration: enabled tools, per-tool permissions, system prompt, and disabled tools.
4. The system displays the new profile's name and short description.
5. The next prompt is processed under the new profile.

## Alternative Flows

### A1 — Profile selected on launch

Trigger: At step 1, the developer instead launches Vibe with the agent flag.

1. The system validates the requested profile name against the available profiles.
2. The system activates that profile before the first prompt.
3. The flow continues at step 5.

### A2 — Requested profile is a subagent

Trigger: At step 1 (or A1 step 1), the requested name refers to a profile of type *subagent* (e.g. `explore`).

1. The system rejects the selection and reports that subagents cannot be the primary agent.

### A3 — Requested profile requires installation

Trigger: At step 2, the next profile in the cycle is marked as requiring installation (e.g. `lean`) and is not currently installed.

1. The system skips that profile and moves to the following one.
2. The developer can install it explicitly via the dedicated install command.

### A4 — Requested profile is disabled by configuration

Trigger: At A1 step 1, the profile is excluded by the `enabled_agents` allowlist or the `disabled_agents` denylist.

1. The system reports that the agent is not available and exits.

## Postconditions

- **Success**: The active agent profile is updated for the running session, and all subsequent tool resolutions consult the new profile's overrides.
- **Failure**: The active profile is unchanged.

## Business Rules

- **BR-018**: Built-in primary agent profiles are `default`, `plan`, `accept-edits`, `auto-approve`. `chat`, `explore`, and `lean` are also defined but have specialised use (chat is read-only Q&A, explore is a subagent for delegation, lean requires installation).
- **BR-019**: An agent profile may declare overrides for: tool enable/disable list, per-tool permission and allowlist, system prompt id, model, providers, models, compaction model, and a `base_disabled` list that augments the global disabled tools.
- **BR-020**: An agent profile that sets `bypass_tool_permissions = true` skips all approval prompts.
- **BR-021**: Programmatic mode (UC-007) defaults to the `auto-approve` profile and ignores the `default_agent` configuration setting.
- **BR-022**: Custom profiles are loaded from `*.toml` files in the user-level agents directory and the project-level agents directory; a custom profile with the same name as a built-in overrides the built-in.
