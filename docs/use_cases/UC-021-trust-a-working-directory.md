# UC-021 Trust a Working Directory

## Overview

- **ID:** UC-021
- **Name:** Trust a Working Directory
- **Primary Actor:** Developer
- **Goal:** Decide whether Vibe may load a directory's project-level configuration, so the agent never picks up settings from an untrusted folder.
- **Status:** Implemented

## Preconditions

- Vibe is starting an interactive session in a directory other than the home directory.
- The directory contains project configuration files (for example a `.vibe` folder).

## Main Success Scenario

1. On startup, the system detects project configuration files in the working directory.
2. The system checks whether the directory's trust status is already recorded.
3. When the status is unknown, the system asks the developer whether they trust the folder.
4. The developer confirms they trust it.
5. The system records the directory as trusted for future sessions.
6. The session loads the project-level configuration.

## Alternative Flows

- **A1 — Developer declines (from step 4):** The system records the directory as untrusted and project-level configuration is ignored.
- **A2 — Already decided (from step 2):** When a trust decision already exists, the system applies it without asking.
- **A3 — Trust for this run only (from step 3):** With the `--trust` flag the system trusts the directory for this invocation only, without persisting it and without prompting.
- **A4 — Non-interactive run (from step 3):** In programmatic mode the system does not prompt; if the directory is not trusted it warns that project configuration is ignored.
- **A5 — Home directory (from step 1):** The home directory is never subject to the trust prompt.

## Postconditions

- **Success:** The directory's trust status is known and project configuration is loaded or ignored accordingly.
- **Failure:** When trust cannot be resolved, project configuration is ignored as the safe default.

## Business Rules

- **BR-050:** Project-level configuration, agents, and skills are loaded only from trusted directories.
- **BR-051:** Trust decisions are persisted across sessions unless `--trust` is used, which trusts only the current run.
- **BR-052:** The home directory is exempt from the trust check.
