# UC-020 Receive Update Notifications

## Overview

- **ID:** UC-020
- **Name:** Receive Update Notifications
- **Primary Actor:** Developer
- **Secondary Actor:** Mistral Platform
- **Goal:** Learn when a newer version of Vibe is available and what changed.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).
- Update checking is enabled in the configuration.

## Main Success Scenario

1. On session start, the system checks for a newer release from the update source (package index or release feed).
2. The system caches the result so it does not check on every launch.
3. If a newer version exists, the system shows an update notice with the new version number.
4. The system shows a "what's new" summary for the new release.

## Alternative Flows

- **A1 — Up to date (from step 3):** When no newer version exists, no notice is shown.
- **A2 — Check fails (from step 1):** A failed update check is silent; the session proceeds normally.
- **A3 — Cached result (from step 2):** When a recent check is cached, the system reuses it instead of checking again.

## Postconditions

- **Success:** The developer is informed about an available update, or nothing is shown when none exists.
- **Failure:** No notice is shown; the session is unaffected.

## Business Rules

- **BR-048:** Update check results are cached so the network is not hit on every launch.
- **BR-049:** A failed update check never blocks or interrupts the session.
