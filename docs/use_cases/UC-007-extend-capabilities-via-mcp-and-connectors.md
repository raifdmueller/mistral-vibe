# UC-007: Extend Capabilities via MCP and Connectors

## Overview

- **ID**: UC-007
- **Name**: Extend Capabilities via MCP and Connectors
- **Primary Actor**: Developer
- **Goal**: Make external tools available to the assistant by registering an MCP server (over stdio, HTTP, or streamable HTTP) or by enabling a hosted Mistral connector, then inspect what is now usable.
- **Status**: Implemented

## Preconditions

- The developer has configuration write access to `config.toml` in the Vibe home directory.
- For HTTP transports: the MCP server's URL is reachable and any required API token is available in an environment variable.
- For stdio transports: the configured command is on the local `PATH` or specified by absolute path.

## Main Success Scenario

1. Developer adds an entry to the `mcp_servers` list in `config.toml`, choosing a `transport` (`stdio`, `http`, or `streamable-http`) and providing the transport-specific fields (`command`/`args` for stdio, `url`/`headers` for HTTP variants).
2. Developer optionally adds an entry to the `connectors` list to enable a hosted Mistral connector by name.
3. Developer either restarts Vibe or runs `/reload` to pick up the new configuration.
4. System starts each MCP server, requests the server's tool list within the configured `startup_timeout_sec`, and registers every returned tool under a prefixed name.
5. System registers each enabled connector and pulls its current tool list from the Mistral AI Platform.
6. Developer runs `/mcp` (alias `/connectors`) to see all registered MCP servers and connectors; passing a server name lists its tools.
7. Subsequent conversation turns expose the new tools to the assistant alongside the built-in tools.

## Alternative Flows

- **A1**: Trigger at step 4 — MCP server fails to start or does not respond within `startup_timeout_sec`. System marks the server as unavailable, reports the error in `/mcp` output, and continues without its tools.
- **A2**: Trigger at step 1 — Server name contains characters outside `[a-zA-Z0-9_-]`. System normalizes the name (replacing invalid characters with `_`, trimming separators, truncating to 256 characters) before registering.
- **A3**: Trigger at step 7 — The assistant calls an MCP tool that exceeds `tool_timeout_sec`. System cancels the call, returns a timeout error to the assistant, and keeps the server registered.
- **A4**: Trigger at any time — Developer wants to silence a specific tool. Developer adds the tool's local name to `disabled_tools` under the server or connector entry; system hides that tool on next reload.
- **A5**: Trigger at step 5 — Connector tools require LLM sampling via the MCP `sampling/createMessage` protocol. System routes the sampling request back through the active model when the server's `sampling_enabled` flag is true.

## Postconditions

- **Success**: The assistant can call every tool exposed by the newly registered MCP server or connector under the name `<prefix>_<tool>`; `/mcp` reflects the live registry.
- **Failure**: The registry is unchanged; the offending server or connector is reported as failed but does not block the session.

## Business Rules

- **BR-032**: Every MCP tool is exposed to the assistant under the name `<server_name>_<tool_name>`; every connector tool under `connector_<connector_name>_<tool_name>`.
- **BR-033**: MCP server names are normalized to `[a-zA-Z0-9_-]` characters and capped at 256 characters before registration.
- **BR-034**: An MCP server's tools are filtered through the same `enabled_tools` / `disabled_tools` configuration that applies to built-in tools.
- **BR-035**: HTTP transports authenticate by reading the token from the environment variable named in `api_key_env` and inserting it into the configured `api_key_header` using `api_key_format` (default `Bearer {token}`).
