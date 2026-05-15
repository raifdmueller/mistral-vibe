# ADR-001: TUI framework — Textual

- **Status:** Accepted (inferred)
- **Date:** unknown (decision predates this document)
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

Vibe's interactive surface is a terminal user interface — chat input, scrolling
transcript, tool-output panel, autocompletion, debug console, agent-cycle
shortcut. The team had to choose how to render this UI.

Source signals: `pyproject.toml:53` pins `textual==8.2.4` and
`pyproject.toml:54` `textual-speedups`; the TUI implementation lives at
`vibe/cli/textual_ui/`.

## Decision

Use **Textual** (Textualize) as the TUI framework, pinned to 8.2.4. Render
markdown via a custom adapter (`vibe/cli/textual_ui/ansi_markdown.py`).

## Status notes

The rationale was not recorded in any ADR. **[OPEN — Q3.9.1]** — the team
has not confirmed which alternatives were considered, nor which quality
goal (Q3.1.2) drove the choice.

## Consequences

Positive (observed from code):

- Rich layouting, screen stack, snapshot testing via
  `pytest-textual-snapshot` (`pyproject.toml:91`).
- Cross-terminal keyboard handling (Shift+Tab agent cycling, Ctrl+G external
  editor, Alt+↑/↓ rewind navigation).

Negative (observed from code):

- A pinned exact version (`==8.2.4`) couples Vibe to one Textual release;
  upgrading requires deliberate verification.
- Modern terminal requirement: `README.md:240-247` lists "WezTerm,
  Alacritty, Ghostty, Kitty"; older terminals may have display issues.
- The convention "Textual parent classes don't use `ClassVar`" forces a
  per-file Ruff suppression in `pyproject.toml:141-143`.

## Alternatives and Pugh Matrix

3-point scale (-1 worse, 0 equal, +1 better) against quality goals.
The top-three quality goals are **[OPEN — Q3.1.2]**; cells that require
team judgement are marked `?`.

| Criterion | Textual (chosen) | Rich-only | prompt_toolkit | Web UI |
|---|---|---|---|---|
| Terminal usability | +1 | 0 | 0 | -1 |
| Implementation speed | ? | ? | ? | ? |
| Cross-terminal compatibility | 0 | +1 | +1 | n/a |
| Snapshot-testable UI | +1 | -1 | -1 | 0 |
| Accessibility | ? | ? | ? | ? |
| Total | ? | ? | ? | ? |

`?` cells must be resolved by the team before this ADR can be promoted
beyond *inferred* status.
