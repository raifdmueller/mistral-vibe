# ADR-006: Telemetry routed through the primary Mistral provider

- **Status:** Accepted (inferred)
- **Date:** unknown
- **Deciders:** **[OPEN — Q3.9.1]**

## Context

Vibe supports multiple LLM providers (Mistral, OpenAI, Anthropic, Vertex,
llama.cpp). It also collects telemetry events to improve the product.
The telemetry transport must work regardless of the active model.

Source: `vibe/core/telemetry/send.py:50-156`. The endpoint is constructed
as `{primary_mistral_provider.api_base}/v1/datalake/events` (line 30).
The comment at lines 50-60 reads "to avoid leaking third-party
credentials to the telemetry endpoint".

## Decision

Always send telemetry events to the *primary Mistral provider* derived
from the user's config, regardless of which provider is serving chat
completions. Never include third-party headers, API keys, or response
bodies in the telemetry payload. Send fire-and-forget; swallow all
exceptions (line 156).

## Status notes

**[OPEN — Q3.9.1]** — whether this is also intended as a privacy
guarantee for end users (vs. just a credential-leakage prevention) is
unconfirmed.

## Consequences

Positive:

- Third-party provider credentials never reach the telemetry endpoint.
- A single endpoint to monitor and rate-limit at Mistral's side.
- Fire-and-forget means telemetry latency never blocks the user.

Negative:

- Users on non-Mistral providers may not realise telemetry still goes to
  Mistral.
- Telemetry on by default (`enable_telemetry: True` at
  `vibe/core/config/_settings.py:511`) may conflict with enterprise
  compliance regimes — see **[OPEN — Q5.5.a]**.

## Alternatives and Pugh Matrix

| Criterion | Mistral provider (chosen) | Dedicated telemetry endpoint | OTel collector only | No telemetry |
|---|---|---|---|---|
| Avoids cross-provider credential leakage | +1 | +1 | +1 | +1 |
| Operability for Mistral | +1 | 0 | -1 | -1 |
| User-perceived privacy | ? | +1 | +1 | +1 |
| Implementation cost | +1 | 0 | -1 | +1 |
| Compatibility with `enable_telemetry=false` | +1 | +1 | +1 | n/a |
| Total | ? | ? | ? | ? |
