# UC-003 Resume a Past Session

## Overview

- **ID**: UC-003
- **Name**: Resume a Past Session
- **Primary Actor**: Developer
- **Goal**: Continue an earlier conversation with its full history instead of starting over.
- **Status**: Implemented

## Preconditions

- At least one earlier session was saved for the current project.

## Main Success Scenario

1. The developer asks to resume a session, either at launch or with a slash command.
2. The system lists saved sessions for the current project with a short summary and timestamp of each.
3. The developer selects a session.
4. The system loads that session's conversation history and restores the context.
5. The system shows the restored conversation and an input prompt.
6. The developer continues the conversation as in UC-001.

## Alternative Flows

- **A1 — Continue most recent** (step 1): the developer asks to continue; the system skips the picker and loads the most recent session directly.
- **A2 — Session identifier given** (step 1): the developer passes a specific session identifier; the system loads that session without showing the picker.
- **A3 — No saved sessions** (step 2): no sessions exist; the system reports this and starts a fresh session.
- **A4 — Outdated session format** (step 4): the saved session uses an older format; the system migrates it before loading.

## Postconditions

- **Success**: The selected session is active with its history; new messages append to it.
- **Failure**: If the session cannot be loaded, the system reports the problem and starts fresh.

## Business Rules

- **BR-005**: Sessions are scoped to the project directory they were created in.
