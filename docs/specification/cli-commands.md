# CLI Command Specification

> System-level interface specification for the `vibe` and `vibe-acp` executables.
> Each command/flag is treated as a system use case (input → validation →
> processing → output / status code → errors). Sources cited as `file:line`.
> Covers Q2.2 from the question tree.

## 1. `vibe` — interactive and programmatic CLI

### 1.1 Synopsis

```
vibe [PROMPT] [options]
```

Source: `vibe/cli/entrypoint.py:21-128`.

### 1.2 Inputs

| Token | Type | Required | Default | Source |
|---|---|---|---|---|
| `PROMPT` | positional string | no | — | `entrypoint.py:32-37` |
| `-v`, `--version` | flag | no | — | `entrypoint.py:29-31` |
| `-p`, `--prompt TEXT` | optional value, empty const | no | absent (interactive) | `entrypoint.py:38-46` |
| `--max-turns N` | int | no | unlimited | `entrypoint.py:47-52` |
| `--max-price DOLLARS` | float | no | unlimited | `entrypoint.py:53-58` |
| `--enabled-tools TOOL` | repeatable string | no | all enabled | `entrypoint.py:59-66` |
| `--output {text,json,streaming}` | enum | no | `text` | `entrypoint.py:67-74` |
| `--agent NAME` | string | no | `default_agent` config or `auto-approve` in programmatic | `entrypoint.py:75-82` |
| `--setup` | flag | no | — | `entrypoint.py:83` |
| `--workdir DIR` | path | no | cwd | `entrypoint.py:84-89` |
| `--trust` | flag | no | — | `entrypoint.py:90-96` |
| `--teleport` | hidden flag | no | — | `entrypoint.py:97-98` |
| `-c`, `--continue` | flag | no | — | `entrypoint.py:101-105` |
| `--resume [SESSION_ID]` | flag / optional value | no | — | `entrypoint.py:106-114` |

`-c/--continue` and `--resume` are mutually exclusive
(`add_mutually_exclusive_group`, `entrypoint.py:100`).

### 1.3 Environment variables consulted

| Variable | Default | Effect |
|---|---|---|
| `VIBE_HOME` | `~/.vibe` | Root for all on-disk state. `vibe/core/paths/_vibe_home.py:22-26` |
| `LOG_LEVEL` | `WARNING` | Filter for `~/.vibe/logs/vibe.log`. `AGENTS.md:69-70` |
| `LOG_MAX_BYTES` | `10485760` | Log rotation size. `AGENTS.md:69-70` |
| `MISTRAL_API_KEY` (or per-provider key) | — | LLM credentials. `vibe/core/config/_settings.py:153` |
| `VIBE_*` | — | Override any config field. `entrypoint.py:25-27` |
| `DEBUG_MODE` | unset | When `true`, ACP entrypoint exposes a `debugpy` listener. `vibe/acp/entrypoint.py:62-74` |

### 1.4 Pre-flight processing

1. `--workdir` is resolved; if not a directory the process exits with status 1
   (`entrypoint.py:163-171`).
2. The current working directory is resolved; if it no longer exists the
   process exits with status 1 (`entrypoint.py:173-181`).
3. If `--trust` is given the cwd is added to the session-only trust list
   (`entrypoint.py:183-184`).
4. If interactive (`--prompt` absent), the trust dialog runs (UC-002).
5. The harness file manager is initialised (`init_harness_files_manager`).

### 1.5 Output and exit status

| Mode | Output channel | Format | Exit |
|---|---|---|---|
| Interactive (no `--prompt`) | TTY (Textual UI) | rich terminal | 0 on `/exit`, 130 on Ctrl+C |
| Programmatic, `--output text` | stdout | plain text reply | 0 on normal completion |
| Programmatic, `--output json` | stdout | single JSON document at end | 0 on normal completion |
| Programmatic, `--output streaming` | stdout | NDJSON, one event per line | 0 on normal completion |
| Any | stderr | warnings, errors | non-zero on failure |
| `--setup` | stdout / TTY | onboarding screen | 0 on success, 1 on save error |
| `--version` | stdout | `vibe X.Y.Z` | 0 |

### 1.6 Error conditions

| Trigger | Channel | Exit |
|---|---|---|
| Invalid `--workdir` | stderr (red) | 1 |
| cwd deleted before launch | stderr (red) | 1 |
| Trust dialog cancelled (Ctrl+C / EOF) | none | 0 |
| Programmatic max-turns or max-price reached | stderr / output | non-zero |
| Invalid `--agent NAME` | stderr | 1 |

## 2. `vibe-acp` — Agent Client Protocol bridge

### 2.1 Synopsis

```
vibe-acp [options]
```

Source: `vibe/acp/entrypoint.py:32-39`.

### 2.2 Inputs

| Token | Type | Required | Default |
|---|---|---|---|
| `-v`, `--version` | flag | no | — |
| `--setup` | flag | no | — |

All other interaction happens over JSON-RPC on stdin/stdout per ACP 0.9.0
(`pyproject.toml:31`).

### 2.3 Pre-flight processing

1. Stdin, stdout, stderr are reconfigured for line buffering
   (`vibe/acp/entrypoint.py:21-23`).
2. If `DEBUG_MODE=true`, a `debugpy` listener is opened on
   `localhost:5678` (`entrypoint.py:62-74`).
3. The harness file manager is initialised; the default user config file
   and `vibehistory` file are created if absent
   (`entrypoint.py:42-58`).

### 2.4 Protocol

The contract is **the ACP 0.9.0 specification**, not redefined here. Vibe
implements the agent side; tool approval is delegated to the client via
ACP's permission-request mechanism (UC-016, BR-062).

### 2.5 Exit status

| Trigger | Exit |
|---|---|
| ACP channel closed by client | 0 |
| `--setup` finished successfully | 0 |
| `--setup` failed (save error) | 1 |
| Unrecoverable protocol error | non-zero |

## 3. Slash commands (in-session)

### 3.1 Catalogue

Built-in commands and their handlers, from
`vibe/cli/commands.py::_build_commands` (`vibe/cli/commands.py:53-180`):

| Command | Aliases | Description | Handler |
|---|---|---|---|
| `/help` | — | Show help | `_show_help` |
| `/config` | — | Edit config settings | `_show_config` |
| `/model` | — | Select active model | `_show_model` |
| `/thinking` | — | Select thinking level | `_show_thinking` |
| `/reload` | — | Reload configuration, agent instructions, skills | `_reload_config` |
| `/clear` | — | Clear conversation history | `_clear_history` |
| `/copy` | — | Copy the last agent message to the clipboard | `_copy_last_agent_message` |
| `/log` | — | Show path to current interaction log file | `_show_log_path` |
| `/debug` | — | Toggle debug console | `action_toggle_debug_console` |
| `/compact` | — | Compact conversation history; takes optional guidance | `_compact_history` |
| `/exit` | — | Exit the application | `_exit_app` |
| `/status` | — | Display agent statistics | `_show_status` |
| `/teleport` | — | Teleport session to Vibe Code (conditional availability) | `_teleport_command` |
| `/proxy-setup` | — | Configure proxy and SSL settings | `_show_proxy_setup` |
| `/resume`, `/continue` | both aliases | Browse and resume past sessions | `_show_session_picker` |
| `/rename` | — | Rename the current session | `_rename_session` |
| `/mcp`, `/connectors` | both aliases | List MCP servers / connectors | `_show_mcp` |
| `/voice` | — | Configure voice settings | `_show_voice_settings` |
| `/leanstall` | — | Install the Lean 4 agent | `_install_lean` |
| `/unleanstall` | — | Uninstall the Lean 4 agent | `_uninstall_lean` |
| `/rewind` | — | Rewind to a previous message | `_start_rewind_mode` |
| `/loop` | — | Schedule a recurring prompt; `/loop list`; `/loop cancel <id\|all>` | `_loop_command` |
| `/data-retention` | — | Show data retention information | `_show_data_retention` |

User-supplied skills register additional `/<skill-name>` commands when
their metadata declares `user-invocable: true`
(`vibe/core/skills/models.py:38-42`).

### 3.2 Command parsing

Match is case-insensitive, on the first whitespace-separated token of the
input (`vibe/cli/commands.py::parse_command`). Lookup is by exact alias
match against `_alias_map`. Unknown slash strings are forwarded to the
agent as a normal prompt.

### 3.3 Conditional availability

`/teleport` is only registered when *all* of the following hold
(`vibe/cli/commands.py:14-25`):

- `vibe_code_enabled` is true (default true, excluded from serialised
  config — `vibe/core/config/_settings.py:523`);
- the active model is provided by a Mistral backend;
- the developer's plan is teleport-eligible (resolved by the plan offer
  gateway).

Otherwise the command is hidden from the help text and the autocompletion
menu.
