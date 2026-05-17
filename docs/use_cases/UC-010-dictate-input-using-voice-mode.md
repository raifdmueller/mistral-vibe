# UC-010: Dictate Input Using Voice Mode

## Overview

- **ID:** UC-010
- **Name:** Dictate Input Using Voice Mode
- **Primary Actor:** Developer
- **Goal:** Speak a request instead of typing it, having Vibe transcribe the speech into the input box.
- **Status:** Implemented

## Preconditions

- An interactive session is in progress (see UC-003).
- A working microphone is available.

## Main Success Scenario

1. The developer enables voice mode.
2. The developer starts recording.
3. The system captures audio from the microphone and streams it to the transcription service.
4. The developer stops recording.
5. The system transcribes the speech and places the resulting text in the input box.
6. The developer reviews the transcribed text and submits it as a request.

## Alternative Flows

- **A1 — Recording cancelled.** Trigger: the developer cancels while recording. The system discards the audio and leaves the input box unchanged.
- **A2 — Voice mode disabled.** Trigger: the developer turns voice mode off. The system stops accepting voice recording for the session.
- **A3 — Transcription unavailable.** Trigger: the transcription service cannot be reached. The system reports the problem and the developer falls back to typing.

## Postconditions

- **Success:** The spoken request is transcribed into text the developer can review and submit.
- **Failure:** No transcribed text is produced and the input box is unchanged.

## Business Rules

- **BR-024:** Transcription model aliases in the configuration must be unique.
