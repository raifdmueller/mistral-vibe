# UC-001 Start an Interactive Coding Session

## Overview

- **ID:** UC-001
- **Name:** Start an Interactive Coding Session
- **Primary Actor:** Developer
- **Goal:** Open Mistral Vibe in a working directory and reach a ready-to-use chat interface.
- **Status:** Implemented

## Preconditions

- Mistral Vibe is installed and runnable from a terminal.
- The Developer is positioned in (or names) the directory they want to work in.

## Main Success Scenario

1. The Developer launches Mistral Vibe, optionally with a starting prompt and a working directory.
2. The system checks whether the working directory contains files that can change the agent's behaviour (project instructions, local configuration).
3. The system finds no recorded trust decision for this directory and asks the Developer whether the directory should be trusted.
4. The Developer trusts the directory.
5. The system records the trust decision and loads project and user configuration.
6. The system confirms a usable API key is available for the active model.
7. The system opens the interactive chat interface, shows the welcome banner, and waits for the Developer's first prompt.

## Alternative Flows

- **A1 — Directory has no behaviour files (diverges at step 2):** The system skips the trust prompt and continues at step 5.
- **A2 — Directory already has a trust decision (diverges at step 3):** The system reuses the recorded decision and continues at step 5.
- **A3 — Developer declines trust (diverges at step 4):** The system records the directory as untrusted, loads only built-in defaults, and continues at step 6.
- **A4 — Trust decision skipped for this run only (diverges at step 3):** The Developer started with the trust-for-session option; the system trusts the directory for this run without recording it, and continues at step 5.
- **A5 — No API key available (diverges at step 6):** The system starts onboarding — see UC-002 — and resumes at step 7 once a key is supplied.
- **A6 — Working directory does not exist (diverges at step 1):** The system reports the error and exits.

## Postconditions

- **Success:** An interactive session is running; configuration, project instructions, and skills are loaded; a trust decision exists for the directory (unless trusted for the run only).
- **Failure:** The system has exited with an explanatory message and no session was started.

## Business Rules

- **BR-001:** A working directory that contains files able to change the agent's behaviour must carry an explicit trust decision before the agent runs in it.
- **BR-002:** The user's home directory is never subject to the trust prompt.
- **BR-003:** A trust decision is remembered per directory unless it was granted for a single run only.
