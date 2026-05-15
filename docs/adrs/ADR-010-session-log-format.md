# ADR-010: Session log format — JSONL + JSON metadata

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

Vibe persists every session to disk so the developer can resume,
rewind, and audit it. A session has two kinds of data: long-lived
metadata (start/end times, git commit, model alias, agent profile,
title, scheduled loops) and an append-only stream of messages.

Source: `vibe/core/session/session_logger.py:30-66`,
`vibe/core/session/session_loader.py::_is_valid_session`.

## Decision

Store each session as a directory `session_{timestamp}_{short_id}/`
containing:

- `meta.json` — a single JSON object validated by `SessionMetadata`.
- `messages.jsonl` — one `LLMMessage` per line, append-only.

Format-migration code lives in `vibe/core/session/session_migration.py`,
implying the team anticipates evolution.

## Status notes

**[OPEN — Q3.9.1]** — alternatives (SQLite, a single JSON document,
SQLite + `.jsonl`, append-only event log) and the rationale for two
files rather than one are unrecorded.

**[OPEN — Q5.6]** — the migration policy itself (forward-only?
versioned? supported window?) is unconfirmed.

## Consequences

Positive:

- Append-only `messages.jsonl` is crash-resilient: a partially written
  last line is the only loss.
- Both files are human-readable; `cat` and `jq` work without tooling.
- Metadata can be updated independently (e.g. `/rename`) without
  rewriting the whole transcript.

Negative:

- Concurrent writers (two Vibe processes resuming the same session) are
  not coordinated; the validation predicate excludes only fully empty
  logs.
- Large transcripts mean linear-time loads; no indexing.
- A schema change in `meta.json` or `LLMMessage` requires a migration
  step.

## Alternatives and Pugh Matrix

| Criterion | JSON + JSONL (chosen) | SQLite | Single JSON doc | Append-only event log |
|---|---|---|---|---|
| Crash resilience | +1 | 0 | -1 | +1 |
| Human-readable on disk | +1 | -1 | +1 | +1 |
| Concurrent writes safe | -1 | +1 | -1 | -1 |
| Schema migration cost | -1 | 0 | -1 | -1 |
| Load time on large transcripts | -1 | +1 | -1 | -1 |
| Total | ? | ? | ? | ? |
