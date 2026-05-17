# UC-010 Invoke a Skill

## Overview

- **ID:** UC-010
- **Name:** Invoke a Skill
- **Primary Actor:** Developer
- **Goal:** Run a packaged, reusable workflow instead of writing the same instructions by hand.
- **Status:** Implemented

## Preconditions

- An interactive session is running.
- At least one skill — built-in or defined in a skills directory — is available.

## Main Success Scenario

1. The Developer invokes a skill by name, optionally passing arguments.
2. The system looks up the skill among the built-in skills and any skills found in the configured skill directories.
3. The system loads the skill's instructions and supplies its arguments.
4. The system runs the skill's workflow as part of the conversation, using the agent and its tools (UC-003).
5. The system returns the skill's result to the Developer.

## Alternative Flows

- **A1 — Skill chosen from the slash-command menu (diverges at step 1):** The Developer picks a skill from the menu of skills that opted into it.
- **A2 — Skill invoked by the agent (diverges at step 1):** During a turn the agent itself decides to run a skill to accomplish a sub-task.
- **A3 — Unknown skill name (diverges at step 2):** No skill matches; the system reports that the skill does not exist.
- **A4 — Skill file is malformed (diverges at step 3):** The skill definition cannot be parsed; the system reports the problem and does not run it.

## Postconditions

- **Success:** The skill ran and its outcome is part of the conversation.
- **Failure:** The skill did not run; the Developer was told why.

## Business Rules

- **BR-025:** A skill identifier uses lowercase letters, numbers, and hyphens only.
- **BR-026:** A skill appears in the slash-command menu only when it opts in.
