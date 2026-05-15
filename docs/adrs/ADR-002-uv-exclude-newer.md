# ADR-002: Dependency freshness policy — `[tool.uv].exclude-newer`

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

Vibe pins runtime dependencies and constrains transitive upgrades via:

```toml
[tool.uv]
exclude-newer = "7 days"
exclude-newer-package = { agent-client-protocol = false, mistralai = false }
```

Source: `pyproject.toml:81-83`. In addition, two strategic deps are pinned
exactly: `mistralai==2.4.4`, `agent-client-protocol==0.9.0`
(`pyproject.toml:31, 43`).

## Decision

Adopt a *seven-day quarantine* on transitive dependency upgrades, except
for `agent-client-protocol` and `mistralai` which are allowed to update
immediately. Pin the two protocol-defining deps exactly.

## Status notes

**[OPEN — Q3.9.1]** — rationale, e.g. whether seven days reflects a CI
soak time, a security policy, or coincidence, is unrecorded.

## Consequences

Positive (observed):

- Avoids being broken by a same-day bad release on a transitive dep.
- Lets the team adopt new `mistralai` and `agent-client-protocol`
  versions immediately, since those define Vibe's protocol surface.

Negative (observed):

- Security patches on transitive deps are delayed by up to seven days
  unless explicitly fast-tracked.
- Reproducibility depends on `uv.lock` (which is checked in:
  `uv.lock`, 339247 bytes).

## Alternatives and Pugh Matrix

| Criterion | exclude-newer 7d (chosen) | Pin every dep exactly | Pip with floating versions | Renovate auto-PRs |
|---|---|---|---|---|
| Avoids day-0 bad releases | +1 | +1 | -1 | 0 |
| Speed of security patching | 0 | -1 | +1 | +1 |
| Reproducibility | +1 | +1 | -1 | 0 |
| Maintenance burden | ? | -1 | +1 | ? |
| Compatibility w/ protocol-defining deps | +1 | 0 | +1 | ? |
| Total | ? | ? | ? | ? |
