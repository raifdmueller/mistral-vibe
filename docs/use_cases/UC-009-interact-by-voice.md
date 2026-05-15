# UC-009: Interact by Voice

## Overview

- **ID**: UC-009
- **Name**: Interact by Voice
- **Primary Actor**: Developer
- **Goal**: Dictate prompts by voice instead of typing, and (optionally) have the assistant's replies read back through text-to-speech.
- **Status**: Implemented

## Preconditions

- The developer's machine has a working microphone (and speakers, if narration is enabled).
- `voice_mode_enabled` is set to true in `config.toml`, or the developer has enabled it via `/voice`.
- A Transcribe model (default `voxtral-realtime`) and a TTS model (default `voxtral-tts`) are registered with the Mistral provider.

## Main Success Scenario

1. Developer presses `Ctrl+R` at the prompt.
2. System opens a microphone stream, shows a recording indicator, and begins capturing audio.
3. System streams audio chunks to the Transcribe model and renders partial transcripts in the input box in near real time.
4. Developer stops recording by pressing any key (or cancels with Escape).
5. System submits the final transcript as the next user message (UC-002 takes over from here).
6. When narration is enabled, system streams the assistant's reply to the TTS model and plays the audio while the text is displayed.

## Alternative Flows

- **A1**: Trigger at step 4 — Developer cancels with Escape. System closes the microphone stream and discards the in-progress transcript without sending anything.
- **A2**: Trigger at step 3 — The transcription stream returns an error or disconnects. System stops the recording, surfaces the error, and returns the developer to a text prompt.
- **A3**: Trigger at step 1 — Voice mode is disabled. System ignores `Ctrl+R` and informs the developer that voice must be enabled via `/voice` first.
- **A4**: Trigger at step 6 — Narration playback is interrupted (next prompt submitted, Escape pressed). System stops the TTS stream and returns to the prompt.

## Postconditions

- **Success**: The transcribed text has been submitted as a user turn; if narration is enabled, the assistant's reply has been read aloud.
- **Failure**: No user message is submitted; the recording is discarded; the conversation is unchanged.

## Business Rules

- **BR-040**: Voice capture uses 16 kHz, signed-16-bit-PCM little-endian audio, streamed to the Transcribe model with a 500 ms target streaming delay.
- **BR-041**: Voice mode and narration are independent toggles — voice input can be used without TTS, and TTS can be used without voice input.
- **BR-042**: Both voice and narration require an active Mistral provider with a valid API key; they are unavailable when only third-party providers are configured.
