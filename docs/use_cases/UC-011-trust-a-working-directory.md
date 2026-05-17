# UC-011 Trust a Working Directory

## Overview

- **ID**: UC-011
- **Name**: Trust a Working Directory
- **Primary Actor**: Developer
- **Goal**: Decide whether Vibe may load project-local configuration and act on a given directory.
- **Status**: Implemented

## Preconditions

- The developer starts Vibe in a directory that contains project-local configuration or instruction files.

## Main Success Scenario

1. The system detects trustable files in the working directory.
2. The system checks whether the directory has a recorded trust decision.
3. If no decision exists, the system shows the developer the files it found and asks whether to trust the directory.
4. The developer confirms trust.
5. The system records the directory as trusted.
6. The system loads the project-local configuration and instructions.

## Alternative Flows

- **A1 — Already decided** (step 2): the directory already has a trust decision; the system applies it without prompting.
- **A2 — Trust declined** (step 4): the developer declines; the system records the directory as untrusted and ignores its project-local configuration.
- **A3 — One-shot trust** (step 3): the developer passes the trust flag at launch; the system trusts the directory for this run only, without recording it.
- **A4 — Home directory** (step 1): the working directory is the user's home directory; the system skips the trust check.

## Postconditions

- **Success**: The directory's trust decision is known; project-local configuration is loaded only when trusted.
- **Failure**: If the prompt cannot be shown, the system continues without applying project-local configuration.

## Business Rules

- **BR-010**: A project configuration layer is only applied when its directory is trusted.
- **BR-019**: A one-shot trust grant applies to the current invocation only and is not persisted.
