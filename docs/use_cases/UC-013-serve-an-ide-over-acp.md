# UC-013 Serve an IDE over ACP

## Overview

- **ID**: UC-013
- **Name**: Serve an IDE over ACP
- **Primary Actor**: IDE / ACP Client
- **Goal**: Let an editor or IDE drive Vibe as a coding agent through the Agent Client Protocol.
- **Status**: Implemented

## Preconditions

- Vibe is installed and an API key is available.
- An ACP-capable client launches Vibe in agent mode.

## Main Success Scenario

1. The IDE starts Vibe as an ACP agent over a standard input/output channel.
2. The system establishes an ACP session for the client.
3. The IDE sends a user prompt for that session.
4. The system runs the agent loop, requesting tool actions as needed.
5. The system streams session updates — assistant text, tool calls, file changes — back to the IDE.
6. The IDE displays the updates and may approve tool actions or send further prompts.

## Alternative Flows

- **A1 — Tool permission request** (step 4): a tool action needs approval; the system forwards the permission request to the IDE and waits for its decision.
- **A2 — Slash command from the IDE** (step 3): the IDE sends a registered ACP command; the system runs the command instead of a model prompt.
- **A3 — Session error** (step 4): an unrecoverable error occurs; the system reports it to the IDE through the protocol and ends the turn.

## Postconditions

- **Success**: The IDE receives a complete stream of session updates and the conversation state is consistent.
- **Failure**: The IDE is notified of the error through the protocol; the session can continue or be closed.

## Business Rules

- **BR-021**: In ACP mode tool permission decisions are delegated to the connected client rather than a terminal prompt.
