# Acceptance criteria for Mistral Vibe, derived from the Cockburn use
# cases in docs/use_cases/UC-001..UC-014. Every scenario is tagged
# with its UC ID; failure-path scenarios reference the corresponding
# A-numbered alternative flow in that spec. Open items that could not
# be derived from code are listed at the bottom of this file.

Feature: First-time setup (UC-001)

  Scenario: Visitor pastes an API key on first run
    Given Mistral Vibe is installed
    And no credential is configured for the active provider
    When the visitor launches "vibe"
    Then the system shows the onboarding welcome screen
    When the visitor advances to the credential screen
    And the visitor pastes a non-empty API key
    Then the system writes the key to "$VIBE_HOME/.env" under the
      active provider's API key environment variable
    And the system continues to the interactive session

  Scenario: Visitor cancels onboarding (UC-001 A1)
    Given the onboarding credential screen is shown
    When the visitor presses Ctrl+C
    Then the system exits without writing any credential


Feature: Conversation with the coding assistant (UC-002)

  Scenario: Developer asks a question and the assistant answers
    Given an interactive session is open in a trusted directory
    And a valid API key is configured
    When the developer submits "What does this repository do?"
    Then the system sends the conversation to the Mistral AI Platform
    And streams the assistant reply into the terminal
    And appends the user and assistant messages to "messages.jsonl"

  Scenario: Developer denies a tool call (UC-002 A1)
    Given the assistant requests a "bash" tool call
    And the active agent profile is "default"
    When the developer selects "no" at the approval prompt
    Then the system reports the denial back to the assistant
    And the conversation continues without running the command

  Scenario: Auto-compaction triggers (UC-002 A3, BR-010)
    Given the cumulative input-token count has reached
      "auto_compact_threshold"
    When the developer sends the next message
    Then the system summarises earlier turns through the compaction
      model
    And replaces the in-memory history with the summary plus the new
      message
    And records the compaction in the session log


Feature: Conversation context management (UC-003)

  Scenario: Developer compacts the conversation manually
    Given an interactive session with at least two prior turns
    When the developer runs "/compact"
    Then the system summarises the prior turns via the compaction
      model
    And keeps the developer's most recent message intact

  Scenario: Developer rewinds to an earlier message (UC-003)
    Given the session has at least three assistant turns
    When the developer runs "/rewind"
    And selects an earlier message
    Then the system restores the conversation to that point
    And restores file snapshots captured at that point when available


Feature: Resuming a previous session (UC-004)

  Scenario: Developer resumes the most recent session
    Given at least one valid prior session exists for the current
      working directory
    When the developer launches "vibe --continue"
    Then the system loads the most recent matching session
    And opens a new session that records the prior session's ID as
      its parent

  Scenario: Resume target does not exist (UC-004 A3)
    When the developer launches "vibe --resume nonexistent-id"
    Then the system reports the missing session
    And exits with a non-zero status


Feature: Configuring the active session (UC-005)

  Scenario: Developer changes the active model
    Given more than one model is registered
    When the developer runs "/model"
    And selects a model
    Then the new model is used for subsequent turns immediately

  Scenario: Reloaded configuration fails validation (UC-005 A1)
    Given the developer edited "config.toml" through "/config"
    And the resulting file contains an invalid value
    When the editor exits
    Then the system reports the validation issue
    And keeps the previous in-memory configuration active


Feature: Authorising a workspace folder (UC-006)

  Scenario: Developer trusts a new project
    Given the working directory contains an "AGENTS.md" file
    And no ancestor directory has a recorded trust decision
    When the developer launches "vibe"
    Then the system shows the trust dialog listing the detected files
    When the developer chooses "trust"
    Then the path is appended to the "trusted" list in
      "trusted-folders.toml"
    And the project-context files are loaded into the system prompt

  Scenario: Developer uses --trust for one shot (UC-006 A3)
    When the developer launches "vibe --trust" in an unfamiliar
      directory
    Then the system trusts the folder in memory only
    And does not write to "trusted-folders.toml"


Feature: Extending with MCP and connectors (UC-007)

  Scenario: New MCP server is registered
    Given the developer adds a stdio MCP server entry to "config.toml"
    When the developer runs "/reload"
    Then the system starts the server within
      "startup_timeout_sec"
    And exposes each tool as "<server_name>_<tool_name>"

  Scenario: MCP server fails to start (UC-007 A1)
    Given a configured MCP server returns no tool list within
      "startup_timeout_sec"
    When the developer runs "/mcp"
    Then the system lists the server as unavailable
    And the session continues without its tools


Feature: Using skills (UC-008)

  Scenario: Developer invokes a user-invocable skill
    Given a skill with "user_invocable: true" is discoverable
    When the developer types "/" followed by the skill name
    Then the skill's prompt is injected as the next user turn

  Scenario: Skill with invalid name is skipped (UC-008 A2)
    Given a "SKILL.md" with name "Invalid Name" is on the skill path
    When the skill registry is loaded
    Then the system logs the validation error
    And the skill is absent from the slash-command menu


Feature: Voice interaction (UC-009)

  Scenario: Developer dictates a prompt
    Given "voice_mode_enabled" is true
    When the developer presses Ctrl+R
    Then the system opens a microphone stream
    And streams audio to the Transcribe model at 16 kHz PCM
    When the developer presses any key
    Then the final transcript is submitted as the next user message


Feature: Teleport to Vibe Code (UC-010)

  Scenario: Eligible developer teleports a session
    Given the developer's plan is teleport-eligible
    And the active model belongs to the Mistral provider
    And "vibe_code_enabled" is true
    When the developer runs "/teleport"
    And confirms the upload
    Then the system packages the repository snapshot, conversation,
      and todos
    And uploads the package via the Nuage workflow client
    And opens the resulting Vibe Code URL in the default browser

  Scenario: Plan is not eligible (UC-010 A1)
    Given the developer's plan is not teleport-eligible
    When the developer runs "/teleport"
    Then the system refuses with an explanation


Feature: Scheduled recurring prompts (UC-011)

  Scenario: Developer schedules a 5 minute status check
    When the developer runs "/loop 5m /status"
    Then the system registers the loop in the current session
    And submits "/status" every five minutes
    Until the developer runs "/loop cancel" or the session ends

  Scenario: Loop interval cannot be parsed (UC-011 A2)
    When the developer runs "/loop banana check git log"
    Then the system reports the expected interval format
    And does not register the loop


Feature: Privacy and data retention (UC-012)

  Scenario: Developer disables telemetry
    Given "enable_telemetry" is true
    When the developer sets "enable_telemetry = false" in
      "config.toml"
    And runs "/reload"
    Then the system stops sending events from the next turn onward


Feature: Programmatic mode (UC-013)

  Scenario: CI script invokes a single prompt and exits
    Given a valid API key is set in the environment
    When the runner invokes 'vibe -p "summarise CHANGELOG.md"'
    Then the active agent profile falls back to "auto-approve"
    And every tool runs without prompting
    And the assistant's final message is written to stdout
    And the process exits with status 0

  Scenario: Max-turns budget is exceeded (UC-013 A1)
    Given the runner invokes 'vibe -p "long task" --max-turns 1'
    When the assistant still has work to do after one turn
    Then the system emits a budget-exceeded message
    And exits with a non-zero status

  Scenario: --workdir does not exist (UC-013 A4)
    When the runner invokes 'vibe -p "x" --workdir /no/such/dir'
    Then the system reports the missing directory
    And exits without contacting the model


Feature: Driving Vibe from an IDE via ACP (UC-014)

  Scenario: IDE opens, prompts, and closes a session
    Given the IDE spawns the "vibe-acp" process
    When the IDE calls "initialize"
    And calls "new_session"
    And calls "prompt" with a user message
    Then the system streams assistant messages, tool calls, and tool
      results back as ACP notifications
    When the IDE calls "close_session"
    Then the system flushes the session log

  Scenario: IDE cancels a running prompt (UC-014 A2)
    Given a "prompt" call is in flight
    When the IDE calls "cancel"
    Then the system interrupts the in-flight model or tool call
    And reports the cancellation


# OPEN — items deliberately not turned into Gherkin scenarios because
# the expected behaviour cannot be derived from code alone:
#
# - Performance budgets (cold start, time-to-first-token, tool-call
#   latency) — see OPEN_QUESTIONS Q4.2.
# - Behaviour when the disk fills or "messages.jsonl" is partially
#   written — see OPEN_QUESTIONS Q4.5.
# - PII / secret redaction in telemetry payloads — see Q5.6.
# - Behaviour when the Mistral datalake endpoint is unreachable —
#   see Q5.8.
# - Whether the Anthropic LLM backend is in or out of scope —
#   see Q4.3.
