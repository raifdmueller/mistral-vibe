# UC-004 Answer an Agent Question

## Overview

- **ID:** UC-004
- **Name:** Answer an Agent Question
- **Primary Actor:** Developer
- **Goal:** Give the agent clarifying input it needs before it can continue a task.
- **Status:** Implemented

## Preconditions

- A turn is in progress (UC-002).
- The session is interactive (the question tool is disabled in programmatic mode).

## Main Success Scenario

1. The agent invokes the question tool with one or more questions, each with two to four labelled options.
2. The system displays the questions, one tab per question, each option with its description.
3. The developer selects an option for each question.
4. The system returns the chosen answers to the agent.
5. The agent resumes the task using the answers.

## Alternative Flows

- **A1 — Free-text answer (from step 3):** The developer picks the automatic "Other" option and types a free-text response, which is returned instead of a labelled option.
- **A2 — Developer cancels (from step 3):** The developer dismisses the dialog; the agent is told the question was not answered and continues without the input.

## Postconditions

- **Success:** The agent has the developer's answers and continues the turn.
- **Failure:** The agent proceeds without the requested input.

## Business Rules

- **BR-011:** Each question offers two to four options plus an automatic free-text "Other" option.
- **BR-012:** The question tool is unavailable in programmatic mode.
