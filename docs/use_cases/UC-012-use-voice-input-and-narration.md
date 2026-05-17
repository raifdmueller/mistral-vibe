# UC-012 Use Voice Input and Narration

## Overview

- **ID**: UC-012
- **Name**: Use Voice Input and Narration
- **Primary Actor**: Developer
- **Goal**: Speak prompts instead of typing, and have the assistant's replies read aloud.
- **Status**: Implemented

## Preconditions

- Voice mode is enabled in configuration.
- The system has access to an audio input and output device.

## Main Success Scenario

1. The developer enables voice mode and starts speaking.
2. The system records the audio and sends it to the transcription service.
3. The transcription service returns text.
4. The system treats the transcribed text as the developer's prompt and proceeds as in UC-001.
5. When narration is enabled, the system sends the assistant's reply to the text-to-speech service.
6. The system plays the spoken reply through the audio output device.

## Alternative Flows

- **A1 — Narration disabled** (step 5): narration is off; the assistant's reply is shown as text only.
- **A2 — Transcription fails** (step 3): the transcription service returns an error; the system reports it and falls back to typed input.
- **A3 — Voice settings changed** (step 1): the developer opens the voice settings; the system lets the developer adjust transcription and narration options.

## Postconditions

- **Success**: The spoken prompt was processed and, when enabled, the reply was read aloud.
- **Failure**: The system falls back to text input or output and reports the audio failure.

## Business Rules

- **BR-020**: Voice input and narration use the configured transcription and text-to-speech models.
