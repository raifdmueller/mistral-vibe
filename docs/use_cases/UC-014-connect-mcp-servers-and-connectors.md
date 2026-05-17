# UC-014 Connect MCP Servers and Connectors

## Overview

- **ID:** UC-014
- **Name:** Connect MCP Servers and Connectors
- **Primary Actor:** Developer
- **Secondary Actor:** MCP Server / Connector
- **Goal:** Make tools from external MCP servers and connectors available to the agent.
- **Status:** Implemented

## Preconditions

- One or more MCP servers or connectors are declared in the configuration.

## Main Success Scenario

1. The developer declares an MCP server (stdio, HTTP, or streamable-HTTP transport) or a connector in the configuration.
2. On session start, the system starts or connects to each server within its startup timeout.
3. The system discovers the server's tools and exposes them to the agent, prefixed with the server's alias.
4. The agent calls a discovered tool during a turn.
5. The system forwards the call to the external server and returns the result to the agent.
6. The developer inspects available servers and their tools with the `/mcp` command.

## Alternative Flows

- **A1 — Server disabled (from step 3):** A server marked disabled has its tools discovered but hidden from the agent.
- **A2 — Specific tools disabled (from step 3):** Tools named in the server's disabled-tools list are hidden while the rest remain available.
- **A3 — Startup failure (from step 2):** A server that fails to start within its startup timeout is reported and its tools are unavailable.
- **A4 — Tool timeout (from step 5):** A tool call exceeding the server's tool timeout is aborted and reported as an error.
- **A5 — Server requests a completion (from step 5):** When sampling is enabled, the MCP server may request an LLM completion, which the system fulfills.

## Postconditions

- **Success:** External tools are part of the agent's toolset and calls are routed to their servers.
- **Failure:** The affected server's tools are unavailable; other servers and built-in tools still work.

## Business Rules

- **BR-034:** Each MCP server has a short alias used to prefix its tool names; the alias is normalized to safe characters.
- **BR-035:** An MCP server may be disabled wholesale or have individual tools disabled by name.
- **BR-036:** A server can request LLM completions via sampling only when sampling is enabled for that server.
- **BR-037:** Each server has a startup timeout and a per-tool execution timeout.
