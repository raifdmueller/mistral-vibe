# UC-013 Invoke a Skill

## Overview

- **ID:** UC-013
- **Name:** Invoke a Skill
- **Primary Actor:** Developer
- **Goal:** Run a packaged skill — built-in or custom — that gives the agent extra instructions or capabilities for a task.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).
- The skill is discoverable in a built-in, user, or project skills location.

## Main Success Scenario

1. The developer types a slash command matching a user-invocable skill.
2. The system loads the skill's metadata and instructions.
3. The system makes the skill's instructions available to the agent for the current task.
4. The agent carries out the task following the skill's guidance.
5. The system shows the result.

## Alternative Flows

- **A1 — Skill invoked by the agent (from step 1):** The agent itself calls the skill tool when a task matches a skill's description, without the developer typing a slash command.
- **A2 — Skill not user-invocable (from step 1):** A skill marked non-user-invocable does not appear in the slash-command menu and can only be triggered by the agent.
- **A3 — Skill restricts tools (from step 3):** A skill that declares allowed tools limits the agent to that pre-approved set while it runs.

## Postconditions

- **Success:** The skill's instructions guided the task and the result is shown.
- **Failure:** The skill failed to load or run; an error is shown and the session continues.

## Business Rules

- **BR-031:** A skill's name is lowercase letters, numbers, and hyphens, up to 64 characters.
- **BR-032:** Only skills marked user-invocable appear in the slash-command menu.
- **BR-033:** Skills can be built-in, user-level, or project-level; project skills are honored only in trusted directories.
