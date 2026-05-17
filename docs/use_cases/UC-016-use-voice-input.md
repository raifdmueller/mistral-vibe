# UC-016 Use Voice Input

## Overview

- **ID:** UC-016
- **Name:** Use Voice Input
- **Primary Actor:** Developer
- **Secondary Actor:** Mistral Platform
- **Goal:** Dictate a prompt with the microphone instead of typing it.
- **Status:** Implemented

## Preconditions

- An interactive session is running (UC-001).
- A transcription provider and model are configured.
- A microphone is available.

## Main Success Scenario

1. The developer toggles voice mode on with the `/voice` command.
2. The developer starts recording with the recording shortcut.
3. The system captures audio from the microphone and streams it to the transcription service.
4. The transcription service returns recognized text as it processes the audio.
5. The system places the transcribed text in the input field.
6. The developer reviews the text and submits it as a normal turn (UC-002).

## Alternative Flows

- **A1 — Voice mode disabled (from step 1):** Toggling `/voice` again turns voice mode off and recording shortcuts become inactive.
- **A2 — Transcription failure (from step 4):** The system reports the transcription error and the developer can retry or type instead.

## Postconditions

- **Success:** The dictated text is in the input field, ready to submit.
- **Failure:** No text is captured; the developer can type the prompt.

## Business Rules

- **BR-041:** Voice mode is experimental and off by default; the developer enables it explicitly.
- **BR-042:** Audio is captured at the transcription model's configured sample rate and encoding and streamed to the transcription service.
