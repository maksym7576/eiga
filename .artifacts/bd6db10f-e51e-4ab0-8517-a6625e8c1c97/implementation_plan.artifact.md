# Implementation Plan - Smart Jimaku Text Cleaning

This plan improves synchronization accuracy by strictly filtering out non-speech elements like music markers, sound effect notes, and technical brackets common in Japanese Jimaku.

## User Review Required

> [!IMPORTANT]
> - **Music Filtering**: Symbols like `♪`, `～`, and `〜` will be completely stripped. If a phrase contains *only* these symbols, it will be treated as silence (0.0 weight).
> - **Bracket Refinement**:
>     - Content inside `( )` and `（ ）` (standard/full-width parentheses) is usually a speaker name or sound effect and will be **deleted**.
>     - Brackets like `《 》`, `「 」`, and `『 』` are markers for thoughts or quotes. We will **keep the text inside** but remove the brackets themselves to get an accurate character count.
> - **Soft Signals**: Short interjections and breath sounds (e.g., `あっ`, `んっ`, `すぅ`) will be assigned a slightly lower weight (0.8) to prioritize full sentences during correlation.

## Proposed Changes

### Backend Services
#### [MODIFY] [audio_sync_service.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/services/sync/audio_sync_service.dart)
- Update `_generateSubtitleActivityMap`:
    - Implement a multi-stage cleaning logic:
        1. Remove music/technical symbols.
        2. Strip content in `()` brackets.
        3. Strip *only the symbols* for `《》`, `「」`, `『』`.
        4. Handle stray `((` and `))` memory markers.
    - Detect "low-value" speech (breaths/sighs) and apply a weight multiplier.
    - If the final cleaned string is empty or purely non-alphanumeric, set activity to 0.0.

## Verification Plan

### Automated Verification
- I will run a logic check on the provided test phrases (e.g., Line 30 `♪～` and Line 43 `(ｷｰﾌﾘｰ)んっ｡`) to ensure they yield the expected weights.

### Manual Verification
1. **Music Check**: Test with an opening theme. Verify that segments with only `♪～` no longer contribute to the correlation peak.
2. **Monologue Check**: Verify that internal monologues `《...》` are still correctly synced as speech.
3. **Accuracy**: Observe the confidence score; it should increase as "noisy" text is removed from the timing map.
