# UC-011 Configure Vibe

## Overview

- **ID:** UC-011
- **Name:** Configure Vibe
- **Primary Actor:** Developer
- **Goal:** Adjust Vibe's settings — models, tools, providers, proxy, UI — and have the changes take effect.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).

## Main Success Scenario

1. The developer opens the settings editor with `/config`.
2. The system shows the editable configuration settings.
3. The developer changes one or more settings.
4. The system validates and saves the changes to the configuration file.
5. The system applies the new settings to the current session.

## Alternative Flows

- **A1 — Configure proxy and certificates (from step 1):** With `/proxy-setup` the developer sets proxy and SSL certificate settings, which the system stores and applies.
- **A2 — Reload from disk (from step 1):** With `/reload` the system re-reads configuration, agent instructions, and skills from disk and applies them without restarting.
- **A3 — Inspect data retention (from step 1):** With `/data-retention` the system displays the data retention information.
- **A4 — Show log path (from step 1):** With `/log` the system reports the path to the current interaction log file.
- **A5 — Invalid setting (from step 4):** The system rejects the invalid value and keeps the prior configuration.
- **A6 — Untrusted directory:** If the working directory is not trusted, project-level configuration files are ignored (UC-021).

## Postconditions

- **Success:** The configuration file reflects the developer's changes and the session uses them.
- **Failure:** The configuration is unchanged and an explanation is shown.

## Business Rules

- **BR-025:** Configuration is layered (built-in defaults, user, project); higher layers merge onto lower ones, each field using its declared merge strategy (replace, concat, union by key, shallow merge, or conflict).
- **BR-026:** Project-level configuration is honored only when the working directory is trusted.
- **BR-027:** Environment variables prefixed `VIBE_` override any configuration field.
