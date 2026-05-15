# UC-011: Invoke a User Skill

## Overview

| Field | Value |
|---|---|
| **ID** | UC-011 |
| **Name** | Invoke a User Skill |
| **Primary Actor** | Developer |
| **Goal** | Inject a reusable prompt template (a "skill") into the conversation as a slash command, optionally with arguments, instead of typing the underlying instruction every time. |
| **Status** | Implemented |

## Preconditions

- The working directory's trust state allows project-level skills to be loaded (see UC-002), or the skill is installed at the user level.
- The skill is discovered: its directory contains a metadata file and its metadata declares it as user-invocable.

## Main Success Scenario

1. The developer types `/` in the chat input.
2. The system shows an autocompletion menu including all user-invocable skills.
3. The developer selects the skill and (optionally) types arguments after the slash command.
4. The system reads the skill's prompt body from disk.
5. The system prepends the prompt body (and any arguments) to the next message sent to the LLM.
6. The conversation continues per UC-003.

## Alternative Flows

### A1 — Skill disabled by configuration

Trigger: At step 2, the skill matches the `disabled_skills` pattern or fails to match an `enabled_skills` allowlist.

1. The system hides the skill from the autocompletion menu and from the catalogue exposed to the assistant.

### A2 — Skill not user-invocable

Trigger: At step 2, the skill's metadata sets `user-invocable = false`.

1. The system does not show the skill in the slash command menu; the assistant may still invoke it via the dedicated skill tool.

### A3 — Skill invoked by the assistant via the skill tool

Trigger: During UC-003, the assistant calls the skill tool with a skill name.

1. The system locates the skill (regardless of the user-invocable flag).
2. The system returns the skill's prompt content to the assistant as the tool result, with any pre-approved tool permissions applied.

### A4 — Skill discovery fails

Trigger: At step 4, the skill directory is missing or the metadata file fails validation.

1. The system logs the issue and excludes the skill from the catalogue.

## Postconditions

- **Success**: The skill's content is incorporated into the next assistant turn; any `allowed-tools` declared by the skill are added to the session's approved set for that turn.
- **Failure**: The skill is not loaded; the conversation continues without it.

## Business Rules

- **BR-040**: Skills are discovered from (in order) the configured `skill_paths`, project-level `.agents/skills/`, project-level `.vibe/skills/`, and the user-level `~/.vibe/skills/` directory.
- **BR-041**: A skill's metadata must include a `name` (lowercase, hyphen-separated, max 64 characters) and a `description` (max 1024 characters); other fields are optional.
- **BR-042**: Project-level skills are loaded only from trusted folders (UC-002).
- **BR-043**: The `allowed-tools` metadata field declares tools that are pre-approved for the duration of the skill's invocation; this is an experimental feature.
