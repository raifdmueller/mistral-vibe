# UC-008: Use and Discover Skills

## Overview

- **ID**: UC-008
- **Name**: Use and Discover Skills
- **Primary Actor**: Developer
- **Goal**: Invoke a reusable prompt (a "skill") through the slash-command menu, or have the assistant invoke one automatically, while authoring new skills as plain Markdown files.
- **Status**: Implemented

## Preconditions

- An interactive Vibe session is in progress.
- Skill source directories exist: the built-in skill set is always loaded; `~/.vibe/skills/`, `./.vibe/skills/`, and any directories listed under `skill_paths` are scanned on session start and on `/reload`.

## Main Success Scenario

1. Developer types `/` at the prompt; system shows the slash-command menu listing every built-in command together with each user-invocable skill, filtered by typed prefix.
2. Developer selects a skill (or types the skill's full slash command); system loads the skill's prompt body from `SKILL.md`.
3. System submits the skill's prompt to the assistant as the next user turn (with any free-form arguments the developer typed after the command).
4. Assistant runs the skill the same way as any other request — see UC-002 for the tool-execution loop.
5. Optionally, the assistant itself invokes a skill by calling the `skill` tool with a skill name; system loads that skill's prompt and feeds it back to the assistant.

## Alternative Flows

- **A1**: Trigger at step 1 — A skill's metadata sets `user_invocable: false`. System hides the skill from the slash-command menu, but the assistant can still invoke it via the `skill` tool.
- **A2**: Trigger at step 2 — Skill name does not match the pattern `^[a-z0-9]+(-[a-z0-9]+)*$` or its description is empty. System logs the validation error and skips the skill.
- **A3**: Trigger at step 2 — Two skills resolve to the same name. System keeps the one discovered first (according to the configured `skill_paths` order) and reports the duplicate in the logs.
- **A4**: Trigger at any time — Developer edits a `SKILL.md` file. Skills are re-read on the next `/reload` or session start; running invocations are not affected.

## Postconditions

- **Success**: The skill's prompt has been injected into the conversation and the assistant has either completed or failed the resulting task.
- **Failure**: The skill is silently absent from the menu; nothing is injected into the conversation.

## Business Rules

- **BR-036**: A skill's identifier must match `^[a-z0-9]+(-[a-z0-9]+)*$`, be between 1 and 64 characters, and have a non-empty description (between 1 and 1024 characters).
- **BR-037**: A skill appears in the slash-command menu only when its `user_invocable` flag is `true` and it is not excluded by `disabled_skills`; the `enabled_skills` allowlist, if set, further restricts the visible skills.
- **BR-038**: A skill's `allowed_tools` (a space-delimited list) is honored as a pre-approval allowlist for tools invoked during that skill's execution.
- **BR-039**: Skill discovery searches built-in skills, then `~/.vibe/skills/`, then the project's `./.vibe/skills/`, then any explicit `skill_paths`; the first match wins for duplicate names.
