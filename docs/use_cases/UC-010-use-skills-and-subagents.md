# UC-010 Use Skills and Subagents

## Overview

- **ID**: UC-010
- **Name**: Use Skills and Subagents
- **Primary Actor**: Developer
- **Goal**: Let the assistant draw on reusable skill instructions and delegate focused work to subagents.
- **Status**: Implemented

## Preconditions

- A session is running.
- Skills are available as builtins or in a configured skill directory.

## Main Success Scenario

1. The developer asks for something that matches a skill, or invokes a skill as a slash command.
2. The system loads the skill's instructions and supporting files.
3. The assistant follows the skill's guidance to complete the task.
4. For a large or independent sub-task, the assistant delegates it to a subagent.
5. The subagent runs its own bounded conversation with a restricted tool set and returns a result.
6. The system folds the subagent's result back into the main conversation.

## Alternative Flows

- **A1 — Skill not found** (step 2): the named skill does not exist; the system reports this and continues without it.
- **A2 — Subagent turn limit reached** (step 5): the subagent reaches its turn limit; the system returns the partial result and marks it incomplete.
- **A3 — Hooks fire** (step 3): a configured hook is bound to a lifecycle event; the system runs the hook and applies its outcome.

## Postconditions

- **Success**: The skill or subagent has contributed its result to the conversation.
- **Failure**: The task continues without the skill or subagent; the gap is reported.

## Business Rules

- **BR-017**: A subagent runs with its own agent profile and only the tools that profile allows.
- **BR-018**: A skill is identified by a lowercase, hyphenated name and declares what it does and when to use it.
