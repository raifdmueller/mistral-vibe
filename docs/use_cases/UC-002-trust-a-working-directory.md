# UC-002: Trust a Working Directory

## Overview

| Field | Value |
|---|---|
| **ID** | UC-002 |
| **Name** | Trust a Working Directory |
| **Primary Actor** | Developer |
| **Goal** | Confirm or refuse trust for project-local files that could change Vibe's behavior, so that the agent only loads project instructions and skills the developer has approved. |
| **Status** | Implemented |

## Preconditions

- Vibe is configured with a valid API key (see UC-001).
- The developer launches Vibe from a directory that has not yet been classified as trusted or untrusted, and that contains at least one project-local instruction or configuration file.

## Main Success Scenario

1. The developer launches Vibe in interactive mode from a working directory.
2. The system scans the working directory for files that would alter agent behavior (project-level instruction files, project-level configuration folders).
3. The system checks whether the directory (or any ancestor) already carries a trust decision and finds none.
4. The system presents the list of detected files to the developer and asks whether to trust this folder.
5. The developer chooses *Trust*.
6. The system records the directory as trusted in the persisted trust list.
7. The system proceeds with normal startup, loading the project-level instructions and configuration.

## Alternative Flows

### A1 — Developer declines trust

Trigger: At step 5, the developer chooses *Do not trust*.

1. The system records the directory as untrusted in the persisted trust list.
2. The system continues startup but does not load any project-level instructions, project skills, or project agent definitions.

### A2 — Trust already inherited from an ancestor

Trigger: At step 3, an ancestor directory is already on the trusted or untrusted list.

1. The system reuses the ancestor's decision and skips the trust dialog.

### A3 — Working directory is the user home directory

Trigger: At step 1, the working directory resolves to the developer's home directory.

1. The system skips the trust check entirely and proceeds with startup.

### A4 — One-shot trust via command-line flag

Trigger: At step 1, the developer launches Vibe with the trust flag.

1. The system trusts the directory for the current session only without writing to the persisted trust list.
2. The flow continues from step 7.

### A5 — Developer aborts the trust dialog

Trigger: At step 4, the developer cancels with Ctrl+C, EOF, or the dialog's quit action.

1. The system exits without recording any decision.

## Postconditions

- **Success**: The working directory has an explicit trust decision (either trusted or untrusted) persisted in the user-level trust file, or trusted for the session.
- **Failure**: No decision is recorded and Vibe is not started.

## Business Rules

- **BR-005**: Trust applies recursively; a trust decision on an ancestor directory governs all of its descendants until a closer descendant explicitly overrides it.
- **BR-006**: A "trustable file" is any project-level instruction file (`AGENTS.md`) or a project-level configuration directory (e.g. `.vibe/`).
- **BR-007**: The home directory itself is never subject to the trust dialog.
- **BR-008**: A one-shot trust declared on the command line is never written to the persisted trust list.
