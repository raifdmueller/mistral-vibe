# UC-012 Use Voice Input and Spoken Narration

## Overview

- **ID:** UC-012
- **Name:** Use Voice Input and Spoken Narration
- **Primary Actor:** Developer
- **Goal:** Speak prompts to the agent and have its replies read aloud.
- **Status:** Implemented

## Preconditions

- An interactive session is running.
- A working microphone and audio output are available.
- A Mistral provider for transcription and text-to-speech is configured.

## Main Success Scenario

1. The Developer opens voice settings and enables voice input and spoken narration.
2. The Developer speaks a prompt.
3. The system records the audio and streams it for transcription.
4. The system shows the transcribed text and submits it as the prompt (UC-003).
5. The agent produces a reply.
6. The system reads the reply aloud using the configured voice.

## Alternative Flows

- **A1 — Voice input only (diverges at step 1):** The Developer enables voice input but not narration; replies are shown as text only.
- **A2 — Narration only (diverges at step 2):** Voice input is off; the Developer types the prompt and the reply is read aloud.
- **A3 — Transcription unavailable (diverges at step 3):** No transcription provider is configured or it cannot be reached; the system reports the problem and falls back to typed input.
- **A4 — No audio device (diverges at step 2):** No microphone or speaker is available; the system reports it and keeps voice features off.

## Postconditions

- **Success:** The spoken prompt was transcribed and answered, and the reply was read aloud where narration is enabled.
- **Failure:** Voice features are off or unavailable; the Developer can still type.

## Business Rules

- **BR-029:** Voice input and spoken narration are disabled by default and must be enabled by the Developer.
- **BR-030:** Transcription and text-to-speech require a configured Mistral provider.
