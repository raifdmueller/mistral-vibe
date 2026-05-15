# UC-014: Dictate Input by Voice

## Overview

| Field | Value |
|---|---|
| **ID** | UC-014 |
| **Name** | Dictate Input by Voice |
| **Primary Actor** | Developer |
| **Goal** | Speak the next prompt instead of typing it, with the transcription appearing in the chat input. |
| **Status** | Implemented (experimental) |

## Preconditions

- The developer has a working microphone exposed to the host process.
- The transcription provider is configured with valid credentials.
- An interactive session is in progress.

## Main Success Scenario

1. The developer enables voice mode with the `/voice` slash command.
2. The system confirms voice mode is active.
3. The developer presses the record shortcut.
4. The system captures audio from the default input device using the configured sample rate and encoding.
5. The developer presses any key to stop recording.
6. The system streams the audio to the transcription provider.
7. The transcription provider returns text within the target streaming delay.
8. The system inserts the text into the chat input.
9. The developer reviews and submits the prompt, continuing per UC-003.

## Alternative Flows

### A1 — Developer cancels recording

Trigger: At step 5, the developer presses Escape or Ctrl+C.

1. The system discards the captured audio.

### A2 — Microphone is unavailable

Trigger: At step 4, no audio input device can be opened.

1. The system reports the failure and turns voice mode off.

### A3 — Transcription error

Trigger: At step 7, the provider returns an error or the connection drops.

1. The system reports the failure to the developer.
2. The captured audio is discarded; the chat input is unchanged.

### A4 — Narrator (text-to-speech) playback for the assistant

Trigger: At step 9, the `narrator_enabled` configuration flag is true.

1. After the assistant replies, the system synthesises the reply via the TTS provider and plays it back through the default output device.

## Postconditions

- **Success**: A transcription of the developer's speech appears in the chat input; if the narrator is enabled, the assistant's next reply is also spoken.
- **Failure**: The chat input is unchanged; voice mode may be auto-disabled if the device is unavailable.

## Business Rules

- **BR-054**: Voice mode is off by default and must be enabled per session via the slash command or persisted via `voice_mode_enabled = true`.
- **BR-055**: The transcription model declares its sample rate (default 16 000 Hz), encoding (`pcm_s16le`), language (default `en`), and target streaming delay (default 500 ms).
- **BR-056**: The TTS model declares its voice (default `gb_jane_neutral`) and response format (default `wav`).
- **BR-057**: The transcription and TTS providers are configured independently from the chat model's provider.
