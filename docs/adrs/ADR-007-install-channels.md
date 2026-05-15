# ADR-007: Install channels — `curl | bash`, `uv tool install`, `pip install`

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

Vibe is distributed to developers on Linux, macOS, and (best-effort)
Windows. The README documents three channels:

1. `curl -LsSf https://mistral.ai/vibe/install.sh | bash` — recommended
   one-liner (`README.md:30-34`).
2. `uv tool install mistral-vibe` (`README.md:48-52`).
3. `pip install mistral-vibe` (`README.md:54-58`).

A Nix flake (`flake.nix`) and a PyInstaller spec for `vibe-acp`
(`vibe-acp.spec`) also exist. The install script is tested at
`tests/test_install_script.py`.

## Decision

Ship to PyPI, advertise `uv` as the preferred install path, and provide
a `curl | bash` wrapper that bootstraps `uv` if missing. Build a
PyInstaller binary for `vibe-acp` so editor extensions can bundle it.

## Status notes

**[OPEN — Q3.9.1]** — security-conscious users dislike `curl | bash`;
whether the team has weighed this against a signed binary distribution
is unrecorded.

## Consequences

Positive:

- Single one-liner for new users.
- `uv` users get a fast, isolated tool install.
- Editor authors can embed `vibe-acp` without forcing users to install
  Python.

Negative:

- `curl | bash` is a known supply-chain risk (a compromised CDN can ship
  malicious code).
- Three channels means three things to keep in sync; the install script
  test (`tests/test_install_script.py`) is a partial mitigation.
- PyInstaller binaries are large and platform-specific.

## Alternatives and Pugh Matrix

| Criterion | curl + uv + pip (chosen) | Brew / apt / dnf only | Signed binaries only | PyPI only |
|---|---|---|---|---|
| First-run friction | +1 | 0 | -1 | 0 |
| Supply-chain risk | -1 | +1 | +1 | 0 |
| Editor-bundling story | +1 | 0 | +1 | -1 |
| Maintenance burden | -1 | -1 | 0 | +1 |
| Reach across platforms | +1 | -1 | 0 | +1 |
| Total | ? | ? | ? | ? |
