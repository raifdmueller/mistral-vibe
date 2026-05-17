# UC-015 Delegate Work to a Subagent

## Overview

- **ID:** UC-015
- **Name:** Delegate Work to a Subagent
- **Primary Actor:** Subagent
- **Secondary Actor:** Developer
- **Goal:** Hand a self-contained task to an independent subagent so it runs without overloading the main conversation's context.
- **Status:** Implemented

## Preconditions

- A turn is in progress (UC-002).
- A subagent profile (such as the built-in `explore` subagent) is available.

## Main Success Scenario

1. The main agent invokes the task tool with a task description and a target subagent.
2. The system starts the subagent with its own profile, tool permissions, and system prompt.
3. The subagent works through the task independently, without developer interaction.
4. The subagent produces a result.
5. The system returns the subagent's result to the main agent.
6. The main agent incorporates the result and continues the turn.

## Alternative Flows

- **A1 — Subagent fails (from step 3):** The subagent's failure is reported back to the main agent, which adapts.
- **A2 — Custom subagent (from step 2):** A profile declared as a subagent in the agents directory can be used as the delegation target.

## Postconditions

- **Success:** The subagent's result is folded into the main conversation; the subagent's intermediate context is not.
- **Failure:** The main agent is told the delegation failed and continues.

## Business Rules

- **BR-038:** Subagents run independently and never prompt the developer for input.
- **BR-039:** The built-in `explore` subagent is read-only, limited to search and file-reading tools.
- **BR-040:** Subagent profiles cannot be chosen as a session's starting agent (see BR-003).
