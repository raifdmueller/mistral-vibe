# UC-008: Extend Vibe with Skills

## Overview

- **ID:** UC-008
- **Name:** Extend Vibe with Skills
- **Primary Actor:** Developer
- **Goal:** Add reusable, packaged capabilities to Vibe and invoke them as custom slash commands.
- **Status:** Implemented

## Preconditions

- API access is configured (see UC-001).
- For project-local skills, the project directory is trusted (see UC-002).

## Main Success Scenario

1. The developer places a skill definition in a discoverable location — a custom skill path, the standard skills directory, the project skills directory, or the global skills directory.
2. The system discovers the skill on startup and validates its declared metadata.
3. The system registers the skill, and if it is marked invocable adds it to the slash command menu.
4. The developer invokes the skill's slash command during a session.
5. The system loads the skill's instructions and provides them to the agent, along with any tools the skill pre-approves.
6. The agent carries out the skill's behavior and returns the result.

## Alternative Flows

- **A1 — Skill disabled by configuration.** Trigger: the skill matches a disable pattern, or an explicit enable list excludes it. The system does not register the skill.
- **A2 — Invalid skill metadata.** Trigger: at step 2 the skill's metadata fails validation. The system skips the skill and does not register it.
- **A3 — Non-invocable skill.** Trigger: the skill is not marked invocable. The system registers it for the agent's use but omits it from the slash command menu.
- **A4 — Project skill in an untrusted folder.** Trigger: the skill lives in a project directory that is not trusted. The system does not load it.

## Postconditions

- **Success:** Valid, enabled skills are available to the agent, and invocable ones appear as slash commands.
- **Failure:** Invalid or disabled skills are not registered.

## Business Rules

- **BR-018:** A skill name must be 1-64 characters of lowercase letters, numbers, and hyphens.
- **BR-019:** A skill appears as a slash command only when it is marked user-invocable.
- **BR-020:** Skills located in project directories are loaded only when the project directory is trusted.
