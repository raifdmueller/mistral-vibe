# UC-010 Rename a Session

## Overview

- **ID:** UC-010
- **Name:** Rename a Session
- **Primary Actor:** Developer
- **Goal:** Give the current session a meaningful title so it is easy to find later.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).
- Session logging is enabled so the title can be persisted.

## Main Success Scenario

1. The developer runs the `/rename` command and provides a title.
2. The system stores the title in the session metadata and marks it as manually set.
3. The system confirms the new title.

## Alternative Flows

- **A1 — Automatic title:** When the developer does not rename a session, the system may derive a title automatically and mark its source as automatic.

## Postconditions

- **Success:** The session metadata carries the chosen title with a manual title source.
- **Failure:** The session keeps its previous (often automatic) title.

## Business Rules

- **BR-024:** A session title has a source of either `auto` or `manual`; renaming sets it to `manual`.
