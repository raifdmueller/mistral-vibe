# UC-009 Connect MCP Servers and Connectors

## Overview

- **ID:** UC-009
- **Name:** Connect MCP Servers and Connectors
- **Primary Actor:** Developer
- **Supporting Actor:** MCP Server
- **Goal:** Extend the agent with extra tools provided by external MCP servers and connectors.
- **Status:** Implemented

## Preconditions

- An MCP server is reachable, either as a local process or an HTTP endpoint.

## Main Success Scenario

1. The Developer declares an MCP server in configuration, giving it a short alias and how to reach it.
2. The system starts or connects to the server within the configured startup timeout.
3. The system discovers the tools the server offers and prefixes their names with the server's alias.
4. The system makes those tools available to the agent alongside the built-in tools.
5. The Developer asks the system to show MCP servers and connectors and inspects the available tools.

## Alternative Flows

- **A1 — Server fails to start or times out (diverges at step 2):** The system reports the failure and continues without that server's tools.
- **A2 — Server is disabled (diverges at step 3):** The server is marked disabled in configuration; the system discovers its tools but hides them from the agent.
- **A3 — Some tools are disabled (diverges at step 4):** Specific tool names are listed as disabled for the server; the system hides only those tools.
- **A4 — Tool call times out (diverges at step 4):** A tool call exceeds the per-tool timeout; the system returns a timeout result to the agent.

## Postconditions

- **Success:** The agent can use the enabled tools from connected MCP servers and connectors.
- **Failure:** The server's tools are unavailable; the rest of the session is unaffected.

## Business Rules

- **BR-022:** MCP tool names are prefixed with the server's alias to keep them unique.
- **BR-023:** A disabled MCP server's tools are discovered but hidden from the agent.
- **BR-024:** Each MCP server has a startup timeout and a per-tool execution timeout.
