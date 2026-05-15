# UC-012: Use MCP Server Tools

## Overview

| Field | Value |
|---|---|
| **ID** | UC-012 |
| **Name** | Use MCP Server Tools |
| **Primary Actor** | Developer |
| **Goal** | Extend Vibe with tools provided by an external Model Context Protocol server (for example, a database query tool or a knowledge-base search) and have the assistant use them like built-in tools. |
| **Status** | Implemented |

## Preconditions

- The developer has added a server entry under `mcp_servers` in the Vibe configuration, with a transport (stdio, http, or streamable-http), a name (alias used as the tool prefix), and the relevant connection details.
- Any credentials referenced by the server (e.g. an API key environment variable) are available.

## Main Success Scenario

1. The developer starts Vibe; the system reads the MCP server entries from the configuration.
2. For each enabled server, the system starts the transport (spawning the stdio process or opening the HTTP connection) within the configured startup timeout.
3. The system asks the server for its tool catalogue.
4. The system registers each tool under the qualified name `{server_alias}_{tool_name}` and merges any per-tool permission overrides.
5. The developer prompts the agent; the LLM may call a qualified MCP tool exactly like a built-in.
6. The system enforces the same permission flow as for built-in tools (see UC-004).
7. The system forwards approved calls to the MCP server with the configured tool timeout.
8. The system returns the server's response to the assistant.

## Alternative Flows

### A1 — Server fails to start

Trigger: At step 2, the server does not initialise within the startup timeout.

1. The system logs the failure and continues without that server's tools.

### A2 — Server is marked disabled

Trigger: At step 2, the server entry has `disabled = true`.

1. The system skips connection for that server; its tools are not registered.

### A3 — Individual tool disabled

Trigger: At step 4, a tool name appears in the server's `disabled_tools` list.

1. The system registers all other tools but hides that one from the catalogue.

### A4 — Server requests an LLM sampling completion

Trigger: At step 7, the server uses MCP sampling/createMessage to request its own LLM call.

1. The system honours the request only if `sampling_enabled` is set on the server entry; otherwise it returns a refusal.

### A5 — Tool call exceeds the tool timeout

Trigger: At step 7, the server has not replied within `tool_timeout_sec`.

1. The system cancels the call.
2. The system reports a timeout result to the assistant.

### A6 — Connector exposes an MCP server with its own credential flow

Trigger: At step 1, a `connectors` entry maps a third-party integration to its MCP endpoint.

1. The system applies the connector's `disabled` and `disabled_tools` overrides on top of the server's tool list.

## Postconditions

- **Success**: The MCP server's enabled tools are available to the assistant for the lifetime of the session; calls are subject to the same permission flow as built-in tools.
- **Failure**: The server contributes no tools and the assistant proceeds without them.

## Business Rules

- **BR-044**: MCP tools are namespaced by the server's alias (e.g. `serena_search` for server `serena` and tool `search`).
- **BR-045**: The server alias is normalised to alphanumeric, underscore, and hyphen characters and truncated to 256 characters.
- **BR-046**: Default startup timeout is 10 seconds; default tool timeout is 60 seconds; both are configurable per server.
- **BR-047**: HTTP transports may declare an `api_key_env`, an `api_key_header` (default `Authorization`), and an `api_key_format` (default `Bearer {token}`) to inject credentials.
- **BR-048**: Sampling is enabled by default per server but can be disabled to prevent an untrusted server from triggering LLM calls.
