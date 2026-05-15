# Data Format Specification

> On-disk and on-wire formats Vibe reads and writes. Covers Q2.3 from the
> question tree. Authoritative sources: pydantic schemas in `vibe/core/`.

## 1. User configuration — `~/.vibe/config.toml`

Schema: `VibeConfig` at `vibe/core/config/_settings.py:498`. Top-level keys:

| Key | Type | Default | Source |
|---|---|---|---|
| `active_model` | string (model alias) | `mistral-medium-3.5` | `:499` |
| `vim_keybindings` | bool | `false` | `:500` |
| `disable_welcome_banner_animation` | bool | `false` | `:501` |
| `autocopy_to_clipboard` | bool | `true` | `:502` |
| `file_watcher_for_autocomplete` | bool | `false` | `:503` |
| `displayed_workdir` | string | `""` | `:504` |
| `context_warnings` | bool | `false` | `:505` |
| `voice_mode_enabled` | bool | `false` | `:506` |
| `narrator_enabled` | bool | `false` | `:507` |
| `active_transcribe_model` | string | `voxtral-realtime` | `:508` |
| `active_tts_model` | string | `voxtral-tts` | `:509` |
| `bypass_tool_permissions` | bool | `false` | `:510` |
| `enable_telemetry` | bool | `true` | `:511` |
| `system_prompt_id` | string | `cli` | `:512` |
| `include_commit_signature` | bool | `true` | `:513` |
| `include_model_info` | bool | `true` | `:514` |
| `include_project_context` | bool | `true` | `:515` |
| `include_prompt_detail` | bool | `true` | `:516` |
| `enable_update_checks` | bool | `true` | `:517` |
| `enable_auto_update` | bool | `true` | `:518` |
| `enable_notifications` | bool | `true` | `:519` |
| `api_timeout` | float | `720.0` | `:520` |
| `auto_compact_threshold` | int | `200_000` | `:521` |
| `providers` | list[ProviderConfig] | `DEFAULT_PROVIDERS` | `:536` |
| `models` | list[ModelConfig] | `DEFAULT_MODELS` | `:539` |
| `compaction_model` | ModelConfig \| null | null | `:540` |
| `transcribe_providers`, `transcribe_models`, `tts_providers`, `tts_models` | lists | defaults | `:542-554` |
| `project_context`, `session_logging` | sub-configs | defaults | `:556-557` |
| `tools` | dict[str, dict] | empty | `:558` |
| `tool_paths` | list[path] | builtin path | `:559` |
| `mcp_servers` | list[MCPServer] | empty | `:569` |
| `connectors` | list[ConnectorConfig] | empty | `:572` |
| `enabled_tools` / `disabled_tools` | list[str] | empty | `:577,585` |
| `agent_paths`, `enabled_agents`, `disabled_agents`, `installed_agents`, `default_agent` | lists/string | defaults | `:592-628` |
| `skill_paths`, `enabled_skills`, `disabled_skills` | lists | defaults | `:629-650` |

**Excluded from serialisation** (feature flags / experimental):

- `vibe_code_*` family (`:523-528`)
- `enable_otel`, `otel_endpoint` (`:531-532`)
- `enable_experimental_hooks` (`:534`)

### 1.1 ProviderConfig

| Key | Type | Validation | Source |
|---|---|---|---|
| `name` | string | required | `:173` |
| `api_base` | URL | required | `:174` |
| `api_key_env_var` | string | optional | `:175` |
| `browser_auth_base_url` | URL \| null | optional | `:176` |
| `browser_auth_api_base_url` | URL \| null | optional | `:177` |
| `api_style` | string | default `openai` | `:178` |
| `backend` | enum `mistral`/`generic` | default `generic` | `:179` |
| `reasoning_field_name` | string | default `reasoning_content` | `:180` |
| `project_id` | string | optional | `:181` |
| `region` | string | optional | `:182` |
| `extra_headers` | dict[str,str] | optional | `:183` |

### 1.2 ModelConfig

| Key | Type | Validation | Source |
|---|---|---|---|
| `name` | string | required | `:368` |
| `provider` | string (provider name) | required | `:369` |
| `alias` | string | required | `:370` |
| `temperature` | float | default 0.2 | `:371` |
| `input_price` | float (USD/Mtok) | default 0.0 | `:372` |
| `output_price` | float (USD/Mtok) | default 0.0 | `:373` |
| `thinking` | enum `off`/`low`/`medium`/`high` | default `off` | `:374` |
| `auto_compact_threshold` | int | default 200_000 | `:375` |

### 1.3 MCPServer (discriminated union on `transport`)

Common base `_MCPBase` (`:229-264`):

| Key | Type | Validation |
|---|---|---|
| `name` | string | normalised to `[a-zA-Z0-9_-]`, truncated to 256 chars |
| `prompt` | string \| null | optional usage hint |
| `startup_timeout_sec` | float (> 0) | default 10 |
| `tool_timeout_sec` | float (> 0) | default 60 |
| `sampling_enabled` | bool | default true |
| `disabled` | bool | default false |
| `disabled_tools` | list[str] | default empty |

For `transport = "http"` and `"streamable-http"` (`_MCPHttpFields`,
`:266-305`): `url`, `headers`, `api_key_env`, `api_key_header` (default
`Authorization`), `api_key_format` (default `Bearer {token}`).

For `transport = "stdio"` (`:315-323`): `command`, `args`, `env`, `cwd`.

### 1.4 Merge semantics across config layers

User config, project config, agent profile, and CLI flags are merged via
the `MergeStrategy` markers at `vibe/core/config/schema.py:107-150`:

| Marker | Behaviour |
|---|---|
| `WithReplaceMerge` | Higher layer overwrites |
| `WithConcatMerge` | Lists appended in layer order |
| `WithUnionMerge(merge_key=...)` | Lists merged by key, higher layer wins per-key |
| `WithShallowMerge` | Dicts shallow-merged, absent keys preserved |
| `WithConflictMerge` | Error if more than one layer provides a value |

## 2. Trusted-folder registry — `~/.vibe/trusted_folders.toml`

Schema: `vibe/core/trusted_folders.py:35-110`.

```toml
trusted = ["/abs/path/one", "/abs/path/two"]
untrusted = ["/abs/path/three"]
```

Both are lists of absolute resolved paths. The file is rewritten in full
on each `add_trusted` / `add_untrusted` call. A path appearing in
neither list yields trust decision `None` (UC-002 step 3); ancestor walk
applies (BR-005).

## 3. Session log

Each session is a directory `{session_prefix}_{timestamp}_{short_id}`
under `session_logging.save_dir` (default
`~/.vibe/logs/session/`). Source:
`vibe/core/session/session_logger.py:30-66`.

### 3.1 `meta.json`

Pydantic model `SessionMetadata` (`vibe/core/types.py:146-156`):

```json
{
  "session_id": "string (36 chars)",
  "parent_session_id": "string | null",
  "start_time": "ISO-8601 UTC",
  "end_time": "ISO-8601 UTC | null",
  "git_commit": "40-char hex | null",
  "git_branch": "string | null",
  "environment": { "<key>": "<value | null>" },
  "username": "string",
  "loops": [ /* ScheduledLoop[] */ ],
  "title": "string | null",
  "title_source": "auto | manual"
}
```

`ScheduledLoop` (`vibe/core/types.py:29-37`):

```json
{
  "id": "string",
  "interval_seconds": 0,
  "prompt": "string",
  "next_fire_at": 0.0,
  "created_at": 0.0
}
```

### 3.2 `messages.jsonl`

One `LLMMessage` per line (`vibe/core/types.py:215-260`):

```json
{
  "role": "system | user | assistant | tool",
  "content": "string | null",
  "injected": false,
  "reasoning_content": "string | null",
  "reasoning_state": ["string", "..."],
  "reasoning_signature": "string | null",
  "reasoning_message_id": "string | null",
  "tool_calls": [ /* ToolCall[] */ ],
  "name": "string | null",
  "tool_call_id": "string | null",
  "message_id": "string (36 chars)"
}
```

`ToolCall` (`vibe/core/types.py:181-188`):

```json
{
  "id": "string | null",
  "index": 0,
  "function": { "name": "string | null", "arguments": "json string | null" },
  "type": "function"
}
```

### 3.3 Validation predicate

A session directory is *valid* iff both files exist, `meta.json` is a
non-empty JSON object, and `messages.jsonl` contains at least one
parseable JSON object. `working_directory` (when supplied as filter)
must match the session's recorded environment. Source:
`vibe/core/session/session_loader.py::_is_valid_session`.

## 4. Skill format

A skill is a directory containing a single markdown file with YAML
front-matter. The directory name becomes the skill name when the
metadata omits it. Source: `vibe/core/skills/models.py:8-58`.

### 4.1 YAML front-matter (required block)

```yaml
---
name: kebab-case-name              # required, ≤64 chars, ^[a-z0-9]+(-[a-z0-9]+)*$
description: One sentence           # required, ≤1024 chars
license: MIT                        # optional
compatibility: Python 3.12+         # optional, ≤500 chars
allowed-tools: read_file grep       # optional, space-delimited list
user-invocable: true                # optional, default true
metadata:                           # optional, free-form string map
  category: review
---
```

### 4.2 Body

Everything after the closing `---` is the prompt body. It is injected
into the conversation when the skill is invoked (UC-011 step 5).

## 5. Agent profile format

TOML file in `agents/` (user-level or project-level). Source:
`vibe/core/agents/models.py:88-99`.

| Key | Type | Notes |
|---|---|---|
| `display_name` | string | default = file stem title-cased |
| `description` | string | default empty |
| `safety` | enum `safe`/`neutral`/`destructive`/`yolo` | default `neutral` |
| `agent_type` | enum `agent`/`subagent` | default `agent` |
| any `VibeConfig` field | per its schema | overlay applied via `_deep_merge` |
| `base_disabled` | list[str] | augments `disabled_tools` |

## 6. Hook configuration

File: `hooks.toml` at user or project level. Schema:
`vibe/core/hooks/models.py:19-35`.

```toml
[[hooks]]
name = "lint"
type = "post_agent_turn"
command = "uv run ruff check ."
timeout = 30.0
description = "Lint after every agent turn"
```

`command` must be non-empty; `type` is currently only `post_agent_turn`.

## 7. Environment file — `~/.vibe/.env`

Standard dotenv format. Loaded via `load_dotenv_values`
(`vibe/core/config/_settings.py:57-66`). Environment variables already
present take precedence. The `.env` file is intended to hold API keys
and other secrets only; general configuration belongs in `config.toml`.

## 8. History file — `~/.vibe/vibehistory`

Plain-text history of input lines, one per line. Created on first run
with the seed line `Hello Vibe!\n` (`vibe/acp/entrypoint.py:51-58`).

## 9. Cache file — `~/.vibe/cache.toml`

Implementation detail of `vibe/cli/cache.py` (e.g. update-notifier
state). Not part of the user-facing contract; format may change between
releases.
