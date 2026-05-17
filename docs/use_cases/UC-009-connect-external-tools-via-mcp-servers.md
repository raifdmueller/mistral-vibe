# UC-009: Connect External Tools via MCP Servers

## Overview

- **ID:** UC-009
- **Name:** Connect External Tools via MCP Servers
- **Primary Actor:** Developer
- **Goal:** Extend the agent with tools provided by external Model Context Protocol servers and connectors.
- **Status:** Implemented

## Preconditions

- API access is configured (see UC-001).
- One or more MCP servers are declared in the configuration.

## Main Success Scenario

1. The developer declares an MCP server in the configuration, specifying its transport and connection details.
2. The system connects to each declared server on startup and discovers the tools it offers.
3. The system registers the discovered tools, naming each with the server's alias as a prefix.
4. The developer reviews the available MCP servers and connectors and inspects a server's tools.
5. During a session the agent uses an MCP tool, subject to the same approval policy as built-in tools.
6. The system runs the tool through the server and returns the result to the agent.

## Alternative Flows

- **A1 — Server disabled.** Trigger: a server is marked disabled. The system still discovers its tools but hides them from the agent.
- **A2 — Selected tools disabled.** Trigger: a server lists specific tools to disable. The system hides those tools while keeping the rest.
- **A3 — Server fails to start.** Trigger: a server does not start or initialize within its startup timeout. The system reports the failure and continues without that server's tools.
- **A4 — Tool execution times out.** Trigger: an MCP tool exceeds its execution timeout. The system aborts the call and returns a timeout error to the agent.
- **A5 — Server requests a model completion.** Trigger: a server with sampling enabled requests a completion. The system services the request through the active model.

## Postconditions

- **Success:** Tools from connected, enabled MCP servers are available to the agent and can be executed.
- **Failure:** Tools from failed or disabled servers are unavailable; the session continues without them.

## Business Rules

- **BR-021:** An MCP server alias is normalized to letters, numbers, underscores, and hyphens, and truncated to 256 characters.
- **BR-022:** An MCP server must use one of the supported transports: HTTP, streamable HTTP, or standard input/output.
- **BR-023:** An MCP server's startup timeout and tool execution timeout must each be greater than zero.
