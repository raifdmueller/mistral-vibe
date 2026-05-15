# Product Requirements Document — Mistral Vibe

> **Provenance.** This PRD is synthesised from the Socratic Code-Theory Recovery
> Phase 1 results in [`QUESTION_TREE.adoc`](QUESTION_TREE.adoc). Every claim
> cites its source question; items the team has not yet answered are kept as
> `[OPEN — Q-ID]` markers rather than filled with assumptions.

## 1. Problem statement

**What Vibe is** *(Q1.1)*: Mistral Vibe is Mistral AI's open-source command-line
coding assistant. It exposes a conversational interface to a local codebase via
a controlled set of tools (file edit, shell, search, web fetch, todo).
Source: `README.md:20`, `pyproject.toml:4`.

**The problem it addresses** *(Q1.3, partial)*: Developers want a coding agent
that runs in their terminal, edits files in place, runs shell commands, and
integrates with their editor — without copy-pasting between a browser chat and
the project. The README lists eight concrete jobs-to-be-done (explore, edit,
shell, search, todo, ask, delegate, ACP-integrate). The relative priority of
those jobs is **[OPEN — Q1.3]**.

**Positioning against alternatives**: **[OPEN — Q1.4]** Vibe coexists with
Claude Code, Aider, Cursor, Cody, and other CLI coding agents. The deliberate
differentiator is unrecorded; circumstantial evidence (default Mistral models
at `vibe/core/config/_settings.py:439-465`, the Vibe Code teleport feature)
suggests integration with Mistral's broader platform is part of the answer.

## 2. Goals

### 2.1 Functional goals

These are the eight jobs the README and code clearly support
*(Q1.3, Q2.1, Q3.5.3)*:

| ID | Goal | Evidence |
|---|---|---|
| G-001 | Hold an interactive coding conversation in the terminal | UC-003, `vibe/core/agent_loop.py:221` |
| G-002 | Run a one-shot prompt non-interactively for scripting/CI | UC-007, `vibe/core/programmatic.py` |
| G-003 | Edit files via tools without leaving the agent | UC-003, `vibe/core/tools/builtins/{write_file,search_replace}.py` |
| G-004 | Execute shell commands in a stateful workspace | UC-003, `vibe/core/tools/builtins/bash.py` |
| G-005 | Search code (grep) and web pages (webfetch, websearch) | `vibe/core/tools/builtins/{grep,webfetch,websearch}.py` |
| G-006 | Persist, resume, rename, and rewind sessions | UC-008, UC-009, `vibe/core/session/` |
| G-007 | Be extended via skills, custom agents, and MCP servers | UC-011, UC-012, UC-013 |
| G-008 | Integrate with editors via the Agent Client Protocol | UC-016, `vibe/acp/` |

### 2.2 Quality goals

**[OPEN — Q3.1.2]** Of the implicit quality goals readable from the code
(terminal usability, permissioned safety, extensibility, performance), the
team's *top-ranked* three are unrecorded. The Phase-1 inferred candidates are
listed below; their ranking is **[OPEN]**.

| Candidate | Evidence of intent |
|---|---|
| Terminal usability (modern TUI on recommended terminals) | `vibe/cli/textual_ui/`, `README.md:240-247` |
| Permissioned safety (no surprise side-effects) | `vibe/core/tools/permissions.py`, trust folders |
| Extensibility (skills, MCP, custom agents) | UC-011, UC-012, UC-013 |
| Multi-provider portability of the agent loop | `vibe/core/llm/backend/` (Mistral, OpenAI, Anthropic, Vertex, OpenAI Responses) |

### 2.3 Non-goals

**[OPEN — Q2.5]** No formal non-goals statement exists. Inferred non-goals
that the code *behaves like*, but that the team has not confirmed:

- Vibe is not itself a coding model — it delegates to an LLM provider.
- Vibe is not a sandboxed executor — tools run with the user's privileges
  (`vibe/core/tools/builtins/bash.py`, `write_file.py`).
- Vibe is not a multi-user system — all state lives under `~/.vibe/` per user.

## 3. Personas

**Persona definition is [OPEN — Q1.2.1, Q1.2.3]**. The README addresses
"developers" generically. The available signals are:

| Signal | Source | What it tells us |
|---|---|---|
| Platform support | `README.md:23-26` | Linux & macOS officially; Windows best-effort. *(Q1.2.2 ANSWERED)* |
| Recommended terminals | `README.md:240-247` | Users have a modern terminal emulator and accept TUI keybindings. |
| Default system prompt's "users complain you are too verbose" line | `vibe/core/prompts/cli.md` | Users are repeat users who give feedback. |
| Slash-command surface | `vibe/cli/commands.py:53-180` | Users are comfortable with command-driven workflows. |

A persona-segmentation pass (seniority, indie vs. enterprise, language
specialisation, security-sensitivity) **[OPEN — Q1.2.1]** is needed.

## 4. Success criteria

**Metrics**: **[OPEN — Q1.5.1, Q1.5.2]** The team has *not* declared product
KPIs. The telemetry pipeline at `vibe/core/telemetry/send.py:217-282` emits
the following events; whether they back formal KPIs or are exploratory
instrumentation is unrecorded:

| Event | Likely intent |
|---|---|
| `vibe.tool_call_finished` | Tool acceptance / rejection / failure ratio |
| `vibe.user_copied_text` | Whether the agent's output is used outside Vibe |
| `vibe.user_cancelled_action` | Where developers interrupt the agent |
| `vibe.auto_compact_triggered` | How often the context overflows |
| `vibe.slash_command_used` | Which commands matter |
| `vibe.new_session` / `vibe.session_closed` | Engagement and session length |

## 5. Scope

### 5.1 In scope (per the use cases and the code)

The seventeen use cases in `docs/use_cases/UC-001..UC-017.md` define what
Vibe does today. Briefly:

- Setup, trust, interactive and programmatic sessions, tool approval,
  agent and model switching, session resume / rewind / compaction, skills,
  MCP, custom agents, voice, scheduled loops, ACP, teleport.

### 5.2 Out of scope

**[OPEN — Q2.5]** — see section 2.3.

### 5.3 Constraints inherited from the platform

| Constraint | Source |
|---|---|
| Python 3.12 or later | `pyproject.toml:6,106,131` |
| Distributed via PyPI, install script, and PyInstaller | `pyproject.toml:75-77`, `vibe-acp.spec` |
| State under `~/.vibe/` (override with `VIBE_HOME`) | `vibe/core/paths/_vibe_home.py:24-39` |
| Apache-2.0 licensed | `LICENSE`, `pyproject.toml:9` |

## 6. Monetisation

**[OPEN — Q1.6]** The CLI is Apache-2.0. The billable component is API usage
against Mistral's hosted models (`vibe/core/config/_settings.py:439-450`) and
the Vibe Code teleport feature. The deliberate monetisation strategy and
upsell motion are not in-repo.

## 7. Privacy, compliance, accessibility

- **Telemetry** is enabled by default (`enable_telemetry: bool = True` at
  `vibe/core/config/_settings.py:511`) and posted to the Mistral datalake.
  Users can disable it. Compliance review of default-on telemetry against
  EU/US enterprise regimes is **[OPEN — Q5.5.a]**.
- **Data residency for non-Mistral providers**: **[OPEN — Q4.6.3.a]**.
- **Accessibility goals**: **[OPEN — Q4.4.2]**.
- **Internationalisation**: **[OPEN — Q4.4.3.a]** — currently English only;
  transcribe language defaults to `en` (`vibe/core/config/_settings.py:386`).

## 8. Roadmap signals

The team has not published a forward-looking roadmap document. Strategic
questions whose answers would shape the next-version PRD are tracked at
**[OPEN — Q5.9]** and reproduced here for completeness:

- A sandboxed / containerised execution mode?
- A skill marketplace?
- Multi-user / pair-programming scenarios?
- A stable embeddable Python API?

Additional forward-looking items: LLM-feature adoption policy
**[OPEN — Q2.4.1.a]**, ACP/MCP revision policy **[OPEN — Q4.3.2]**,
external-API contingency **[OPEN — Q5.3.a]**.

## 9. Open question summary

This PRD inherits **14** unresolved Product-Owner questions from
`docs/OPEN_QUESTIONS.adoc` and an additional handful that are jointly owned
with Architect / Operations. Until they are answered, this PRD is a faithful
mirror of *what the code says the product is*, not a statement of *what the
team intends the product to be*.
