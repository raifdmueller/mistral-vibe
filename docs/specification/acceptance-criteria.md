# Acceptance Criteria — Gherkin Scenarios

> Gherkin-formatted scenarios derived from the seventeen use cases in
> `docs/use_cases/`. Each scenario lists its source use case (UC-ID) and,
> where applicable, the business rule(s) (BR-ID) it covers.
> Covers Q2.1 acceptance criteria from the question tree.

## Feature: API key onboarding (UC-001)

```gherkin
Scenario: First-time setup persists the API key
  Given Vibe is not yet configured
  And the developer holds a valid API key
  When the developer launches Vibe in interactive mode
  Then the system creates the user configuration directory
  And the system shows the welcome screen
  When the developer enters the API key
  Then the system writes the key to ~/.vibe/.env
  And the system shows a "Setup complete" message
  # Covers BR-001..BR-004

Scenario: API key already exported is reused without prompt
  Given the environment variable MISTRAL_API_KEY is exported
  When the developer launches Vibe
  Then the system does not show the welcome screen
  And the system starts the interactive session directly
  # Covers UC-001 A1, BR-003

Scenario: Onboarding cancellation exits cleanly
  Given Vibe is not yet configured
  When the developer launches Vibe
  And the developer cancels the welcome screen with Escape
  Then the system exits with a non-zero status
  And the system prints "Setup cancelled. See you next time!"
  # Covers UC-001 A2

Scenario: Saving the API key fails due to permission denied
  Given the developer enters an API key in the welcome screen
  And ~/.vibe/.env cannot be written
  Then the system warns that the key was not persisted
  And the system continues with the key set for this process only
  # Covers UC-001 A3
```

## Feature: Folder trust (UC-002)

```gherkin
Scenario: First launch in a new project asks for trust
  Given the developer is in a directory that contains .vibe/
  And neither the directory nor its ancestors carry a trust decision
  When the developer launches Vibe in interactive mode
  Then the system shows the trust dialog listing detected files
  When the developer chooses "Trust"
  Then the system adds the directory to trusted_folders.toml
  And the system loads any project-level instructions
  # Covers BR-005, BR-006

Scenario: Ancestor decision is inherited
  Given the directory /home/dev is already trusted
  When the developer launches Vibe from /home/dev/some-project
  Then the system skips the trust dialog
  And the system proceeds with the inherited decision
  # Covers UC-002 A2, BR-005

Scenario: --trust flag grants session-only trust
  When the developer launches Vibe with --trust
  Then the system trusts the directory for the current session only
  And the system does NOT write to trusted_folders.toml
  # Covers UC-002 A4, BR-008

Scenario: Home directory is never subject to the trust dialog
  Given the working directory is the developer's home directory
  When the developer launches Vibe
  Then the system skips the trust check entirely
  # Covers UC-002 A3, BR-007
```

## Feature: Interactive coding conversation (UC-003)

```gherkin
Scenario: A simple prompt is answered with no tool calls
  Given an interactive session is open
  When the developer enters "What is the entry point?"
  Then the system records the prompt in the transcript
  And the system sends the prompt to the LLM provider
  And the system displays the assistant's text reply
  # Covers BR-010

Scenario: A multi-tool turn alternates LLM and tool execution
  Given an interactive session is open
  When the developer asks for a refactor that touches two files
  Then the assistant requests read_file twice
  And the system shows each tool result before continuing
  And the assistant then requests search_replace
  And the system displays the final summary after the loop exits
  # Covers UC-003 main success scenario

Scenario: Escape interrupts the in-flight turn
  Given the assistant is running a tool call
  When the developer presses Escape
  Then the system cancels the tool execution
  And the system records the interruption in the transcript
  And the chat input returns to ready state
  # Covers UC-003 A1

Scenario: Auto-compact triggers before exceeding the context window
  Given the running context size is 195_000 tokens
  And auto_compact_threshold is 200_000
  When the developer enters another prompt
  Then the system runs compaction before the next LLM request
  And the system emits the "vibe.auto_compact_triggered" telemetry event
  # Covers UC-003 A4, BR-012

Scenario: A line starting with ! runs in the shell
  Given the chat input has focus
  When the developer types "!ls -l"
  Then the system runs "ls -l" in the shell directly
  And the system does not send the line to the LLM
  # Covers UC-003 A6

Scenario: Slash command is dispatched before reaching the LLM
  When the developer types "/status"
  Then the system shows session statistics
  And the system does not send the line to the LLM
  # Covers UC-003 A7
```

## Feature: Tool approval (UC-004)

```gherkin
Scenario: Approve once for a permission=ask tool
  Given the assistant proposes "write_file" with path "src/foo.py"
  And write_file permission is "ask"
  When the system asks for approval
  And the developer chooses "Approve once"
  Then the system runs write_file
  And the system reports the result to the assistant
  And future calls still prompt

Scenario: Approve and remember for the session
  Given the assistant proposes a bash command "ls *"
  And bash permission is "ask"
  When the developer chooses "Always approve this command pattern"
  Then the system records an approved rule on the session
  And the next "ls" call runs without prompting
  # Covers BR-014, BR-015

Scenario: Sensitive pattern downgrades an always permission
  Given write_file permission is "always"
  And ".env" is in sensitive_patterns
  When the assistant proposes write_file with path ".env"
  Then the system asks for approval anyway
  # Covers BR-016

Scenario: Bash command on denylist is rejected without prompting
  Given the bash denylist contains "rm -rf /"
  When the assistant proposes "rm -rf /"
  Then the system rejects the call
  And the system does not ask the developer
  # Covers BR-017
```

## Feature: Agent profile switching (UC-005)

```gherkin
Scenario: Shift+Tab cycles through agent profiles
  Given the active profile is "default"
  When the developer presses Shift+Tab
  Then the active profile becomes "plan"
  When the developer presses Shift+Tab
  Then the active profile becomes "accept-edits"
  # Covers BR-018

Scenario: --agent selects a custom profile at launch
  Given a file ~/.vibe/agents/redteam.toml defines an agent
  When the developer launches Vibe with "--agent redteam"
  Then the system activates the "redteam" profile
  And the system applies its overrides to the configuration
  # Covers BR-022

Scenario: Subagent cannot be the primary agent
  Given "explore" is a subagent
  When the developer launches Vibe with "--agent explore"
  Then the system reports that subagents cannot be primary
  And the system exits with a non-zero status
  # Covers UC-005 A2

Scenario: An agent that requires installation is skipped during cycling
  Given "lean" requires installation
  And "lean" is not installed
  When the developer presses Shift+Tab past it
  Then the system skips "lean" and moves to the next profile
  # Covers UC-005 A3
```

## Feature: Programmatic one-shot (UC-007)

```gherkin
Scenario: Programmatic mode runs to completion and exits 0
  When the developer runs "vibe --prompt 'summarise README'"
  Then the system uses the auto-approve profile
  And the system prints the assistant's text reply on stdout
  And the system exits with status 0
  # Covers BR-026

Scenario: Programmatic mode respects --max-price
  When the developer runs "vibe --prompt 'big task' --max-price 0.5"
  And the running cost exceeds $0.50
  Then the system interrupts the turn
  And the system exits with a non-zero status
  # Covers UC-007 A1, BR-028

Scenario: --enabled-tools restricts the tool surface
  When the developer runs "vibe -p 'list todos' --enabled-tools grep --enabled-tools read_file"
  Then the system disables all tools except grep and read_file
  # Covers BR-027

Scenario: --output streaming emits one JSON object per line
  When the developer runs "vibe -p 'hi' --output streaming"
  Then the system writes newline-delimited JSON to stdout
  And each line is a parseable JSON object
  # Covers BR-029
```

## Feature: Session resume (UC-008)

```gherkin
Scenario: --continue resumes the most recent session for the cwd
  Given two valid sessions exist for the current working directory
  And session B was last modified more recently than session A
  When the developer runs "vibe --continue"
  Then the system loads session B
  And the system does not show the picker
  # Covers UC-008 A1, BR-030

Scenario: --resume with a partial ID resolves uniquely
  Given session "abc123def" exists
  When the developer runs "vibe --resume abc"
  And no other session ID starts with "abc"
  Then the system loads session abc123def
  # Covers UC-008 A2, BR-032

Scenario: A session in a different working directory is ignored
  Given session X is recorded with working_directory "/elsewhere"
  When the developer runs "vibe --continue" from "/here"
  Then the system does not list or load session X
  # Covers BR-030

Scenario: /rename updates the title and marks it manual
  Given session Y is loaded
  When the developer runs "/rename My investigation"
  Then meta.json title becomes "My investigation"
  And title_source becomes "manual"
  # Covers BR-033
```

## Feature: Rewind (UC-009)

```gherkin
Scenario: Rewind truncates the transcript and the on-disk log
  Given the conversation has 6 messages
  And messages 5 and 6 are the most recent assistant turn
  When the developer rewinds to message 4
  Then the system truncates the transcript to 4 messages
  And messages.jsonl is rewritten to 4 lines
  # Covers UC-009 main success scenario

Scenario: Rewind does not undo file writes
  Given the discarded turns wrote two files
  When the developer rewinds past those turns
  Then the conversation is truncated
  And the files remain on disk
  And the rewind confirmation surfaces this caveat
  # Covers UC-009 A3, BR-035
```

## Feature: Compaction (UC-010)

```gherkin
Scenario: /compact replaces older messages with a summary
  Given the session has 40 messages
  When the developer runs "/compact"
  Then the system sends the older messages to the compaction model
  And the system replaces them with a single summary message
  And the running context is smaller than before
  # Covers BR-038, BR-039

Scenario: Compaction never drops the latest exchange
  When the developer runs "/compact"
  Then the most recent user prompt and pending response are preserved
  # Covers BR-039
```

## Feature: Skill invocation (UC-011)

```gherkin
Scenario: /<skill> shows in the autocomplete menu
  Given a skill "code-review" with user-invocable: true exists
  When the developer types "/co"
  Then the autocompletion menu lists "/code-review"
  # Covers UC-011 main success scenario

Scenario: Skill with user-invocable: false is hidden from menu
  Given a skill "internal-helper" with user-invocable: false exists
  When the developer types "/in"
  Then the autocompletion menu does NOT list "/internal-helper"
  But the assistant can still call it via the skill tool
  # Covers UC-011 A2, BR-040

Scenario: A project-level skill is not loaded from an untrusted folder
  Given the working directory carries trust decision "untrusted"
  And the project contains .vibe/skills/secret/skill.md
  When the developer launches Vibe
  Then the system does not load the "secret" skill
  # Covers BR-042
```

## Feature: MCP server tools (UC-012)

```gherkin
Scenario: An HTTP MCP server's tools are namespaced and usable
  Given an MCP server "serena" with HTTP transport is configured
  And the server exposes tools "search" and "read"
  When Vibe starts
  Then the system registers tools "serena_search" and "serena_read"
  And the assistant may call them like built-in tools
  # Covers BR-044

Scenario: A server that fails to start does not block startup
  Given an MCP server "broken" with startup_timeout_sec=2 is configured
  And the server never responds
  When Vibe starts
  Then the system logs a warning
  And the system continues without "broken_*" tools
  # Covers UC-012 A1

Scenario: A disabled tool is hidden but its siblings remain available
  Given an MCP server "fs" exposes "read" and "write"
  And its disabled_tools list is ["write"]
  Then the system registers "fs_read" only
  # Covers UC-012 A3, BR-045
```

## Feature: Custom agent profile (UC-013)

```gherkin
Scenario: A new TOML file in ~/.vibe/agents is discovered
  Given the developer creates ~/.vibe/agents/docwriter.toml
  When the developer runs "vibe --agent docwriter"
  Then the system loads and activates the docwriter profile
  # Covers BR-049

Scenario: A custom profile overrides a built-in of the same name
  Given the developer creates ~/.vibe/agents/default.toml
  When the developer runs Vibe with the default profile
  Then the system uses the custom default.toml instead of the built-in
  # Covers UC-013 A2

Scenario: A profile referencing a missing prompt fails fast
  Given docwriter.toml sets system_prompt_id = "docwriter"
  And no ~/.vibe/prompts/docwriter.md exists
  When the developer runs "vibe --agent docwriter"
  Then the system raises MissingPromptFileError
  And the system exits with a non-zero status
  # Covers BR-052
```

## Feature: Voice input (UC-014)

```gherkin
Scenario: Recording is captured and transcribed
  Given voice mode is on
  When the developer presses Ctrl+R and speaks
  And the developer presses a key to stop recording
  Then the system streams audio to the transcribe provider
  And the transcription appears in the chat input
  # Covers BR-055

Scenario: Microphone unavailable disables voice mode
  Given no audio input device is available
  When the developer presses Ctrl+R
  Then the system reports the failure
  And the system turns voice mode off
  # Covers UC-014 A2
```

## Feature: Scheduled loops (UC-015)

```gherkin
Scenario: A loop is scheduled and fires once per interval
  When the developer runs "/loop 30s check tests"
  Then the system stores the loop on the session metadata
  And after 30 seconds the system feeds "check tests" as a prompt
  And after another 30 seconds it fires again
  # Covers BR-060, BR-061

Scenario: Interval below the floor is rejected
  When the developer runs "/loop 5s ..."
  Then the system rejects the loop
  And the system reports the minimum interval is 30 seconds
  # Covers BR-058

Scenario: Per-session loop limit is enforced
  Given the session already has 50 active loops
  When the developer runs "/loop 1m another"
  Then the system rejects the new loop
  And the system reports the limit
  # Covers BR-059
```

## Feature: ACP integration (UC-016)

```gherkin
Scenario: Editor obtains a turn over the ACP channel
  Given an editor has launched "vibe-acp" as a subprocess
  When the editor sends an initialise request
  Then the system responds with the Vibe protocol version
  When the editor sends a turn with a prompt
  Then the system runs the agent loop
  And the system emits assistant messages and tool calls as notifications
  # Covers UC-016 main success scenario

Scenario: Editor cancellation aborts the in-flight turn
  Given a turn is in progress
  When the editor sends a cancel notification
  Then the system aborts the LLM request or tool execution
  And the system returns a cancellation response
  # Covers UC-016 A1

Scenario: Tool approval is delegated to the editor
  Given the assistant proposes "bash" with permission "ask"
  When the editor receives the permission request
  And the editor returns "approved"
  Then the system runs the tool
  # Covers BR-062
```

## Feature: Teleport to Vibe Code (UC-017)

```gherkin
Scenario: Teleport command is hidden when ineligible
  Given vibe_code_enabled is true
  But the active model is provided by a non-Mistral backend
  When the developer types "/"
  Then "/teleport" does NOT appear in the autocomplete menu
  # Covers BR-066

Scenario: Teleport refuses to run with unpushed commits unless approved
  Given the local branch is 3 commits ahead of its remote
  When the developer runs "/teleport"
  Then the system asks to push the commits first
  When the developer declines
  Then the system aborts teleport
  # Covers BR-067, UC-017 A1

Scenario: A successful teleport prints the workspace URL
  Given the developer is signed in to Vibe Code
  And the branch is fully pushed
  When the developer runs "/teleport"
  Then the system submits the workflow
  And the system shows the workspace URL
  And the system copies the URL to the clipboard
  # Covers UC-017 main success scenario
```
