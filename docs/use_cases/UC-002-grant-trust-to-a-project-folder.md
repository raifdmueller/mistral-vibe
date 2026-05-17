# UC-002: Grant Trust to a Project Folder

## Overview

- **ID:** UC-002
- **Name:** Grant Trust to a Project Folder
- **Primary Actor:** Developer
- **Goal:** Decide whether a project directory is allowed to influence the agent through its local configuration, instructions, and skills.
- **Status:** Implemented

## Preconditions

- The developer starts Vibe interactively in a directory other than their home directory.
- The directory contains files that can change the agent's behavior, such as project instructions or a local configuration folder.
- No trust decision has yet been recorded for the directory or any of its parents.

## Main Success Scenario

1. The developer starts Vibe in a project directory.
2. The system detects behavior-modifying files in the directory.
3. The system shows the developer which files were found and asks whether the directory is trusted.
4. The developer confirms that the directory is trusted.
5. The system records the directory as trusted for future sessions.
6. The system loads the project's local configuration, instructions, and skills and continues into the session.

## Alternative Flows

- **A1 — Developer declines trust.** Trigger: at step 4 the developer marks the directory as untrusted. The system records the decision and starts the session while ignoring the project's local configuration and skills.
- **A2 — Developer dismisses the dialog.** Trigger: the developer closes the trust dialog without choosing. The system exits without recording a decision.
- **A3 — Trust granted for one invocation only.** Trigger: the developer starts Vibe with the temporary-trust option. The system trusts the directory for the current run without recording a persistent decision and skips the dialog.
- **A4 — Non-interactive run without a trust decision.** Trigger: Vibe runs non-interactively in an untrusted directory. The system prints a warning that project configuration will be ignored and continues.

## Postconditions

- **Success:** The directory has a persisted trust state, and project configuration is loaded only if it was trusted.
- **Failure:** No trust decision is recorded and, in A2, Vibe does not start.

## Business Rules

- **BR-003:** The home directory is never subject to the trust prompt.
- **BR-004:** The trust prompt is shown only when the directory contains behavior-modifying files and no trust decision exists for it or an ancestor.
- **BR-005:** A directory's local configuration, project instructions, and project skills are loaded only when the directory is trusted.
