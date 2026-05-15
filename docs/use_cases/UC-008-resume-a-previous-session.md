# UC-008: Resume a Previous Session

## Overview

| Field | Value |
|---|---|
| **ID** | UC-008 |
| **Name** | Resume a Previous Session |
| **Primary Actor** | Developer |
| **Goal** | Pick up an earlier conversation where it left off, with the prior context intact, instead of starting from scratch. |
| **Status** | Implemented |

## Preconditions

- Session logging is enabled and at least one valid session exists on disk for the current working directory.

## Main Success Scenario

1. The developer launches Vibe with the resume flag (without a session identifier) or types the `/resume` slash command.
2. The system scans the session log directory for valid sessions in the current working directory.
3. The system shows a picker listing those sessions with their title, start time, and a preview of the first prompt.
4. The developer selects a session.
5. The system loads the session metadata and message log into memory.
6. The system continues the conversation in the loaded session.

## Alternative Flows

### A1 — Resume the most recent session directly

Trigger: At step 1, the developer instead uses the continue flag.

1. The system picks the most recently modified valid session for the current working directory.
2. The flow continues at step 5 without showing a picker.

### A2 — Resume a specific session by ID

Trigger: At step 1, the developer supplies a session identifier (possibly a short prefix).

1. The system searches the session log directory for a matching session.
2. If exactly one matches, the flow continues at step 5.
3. If multiple match, the system reports an ambiguous match and exits.

### A3 — No matching session

Trigger: At step 2 or A2 step 1, no valid session is found.

1. The system reports that no sessions are available for this directory.
2. The system exits without starting an interactive session.

### A4 — Rename the current session

Trigger: During an active session, the developer issues the `/rename` slash command with a new title.

1. The system updates the session title in the persisted metadata and marks the title as manually set.

### A5 — Session log directory missing

Trigger: At step 2, the configured session log directory does not exist.

1. The system reports that no sessions are available.
2. The system continues to start a fresh session.

## Postconditions

- **Success**: The resumed session is the active one; new turns are appended to its message log and reflected in its metadata.
- **Failure**: No session is loaded; Vibe either exits or starts a new empty session, depending on the trigger.

## Business Rules

- **BR-030**: A session is *valid* only if both its metadata file and its message log exist, contain at least one message, and match the current working directory.
- **BR-031**: Sessions are stored under the configured `session_logging.save_dir` in directories named `{session_prefix}_{timestamp}_{short_id}`.
- **BR-032**: A short session identifier is a stable suffix of the full session identifier; the resume command accepts it as a prefix match.
- **BR-033**: A session's title defaults to an auto-generated value (`title_source = "auto"`) and is replaced with a manual value (`title_source = "manual"`) when renamed.
- **BR-034**: The continue flag and the resume flag are mutually exclusive on the command line.
