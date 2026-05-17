# UC-009 Extend Vibe with MCP Servers

## Overview

- **ID**: UC-009
- **Name**: Extend Vibe with MCP Servers
- **Primary Actor**: Developer
- **Goal**: Add external capabilities by connecting Model Context Protocol servers and connectors.
- **Status**: Implemented

## Preconditions

- Vibe is installed and configured.

## Main Success Scenario

1. The developer adds an MCP server entry to the configuration.
2. The system connects to the server and discovers the tools it offers.
3. The developer opens the connectors view to see available servers and their tools.
4. The system lists each server, its status, and the tools it exposes.
5. The assistant may now call the server's tools during a session, subject to permissions (see UC-008).

## Alternative Flows

- **A1 — Inspect one server** (step 3): the developer names a single server; the system lists only that server's tools.
- **A2 — Connection fails** (step 2): the server cannot be reached or returns an error; the system marks it unavailable and reports the problem.
- **A3 — Connector disabled** (step 1): a connector is disabled in configuration, or some of its tools are disabled; the system hides those tools.
- **A4 — Server requests sampling** (step 5): an MCP server asks Vibe to run a model completion on its behalf; the system handles the sampling request.

## Postconditions

- **Success**: The configured servers are connected and their tools are usable by the assistant.
- **Failure**: An unreachable server is excluded and its failure is reported; other servers stay usable.

## Business Rules

- **BR-015**: A disabled connector, and any tool listed as disabled for a connector, is excluded from the assistant's available tools.
- **BR-016**: External tools are subject to the same permission checks as builtin tools.
