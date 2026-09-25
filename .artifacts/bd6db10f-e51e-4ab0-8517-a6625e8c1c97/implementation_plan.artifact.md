# Implementation Plan - Subtitle Settings & Spacing Refinement

Improve windowed subtitle default font size, and add proportional spacing controls between original/translation and original/additional subtitles in fullscreen mode.

## User Review Required

> [!IMPORTANT]
> - Windowed default font size will be increased (e.g. from `12.0` to `16.0`).
> - New proportional spacing settings will be added for fullscreen mode: `originalToTranslationSpacing` and `originalToAdditionalSpacing`, configurable via sliders with a proportional range where maximum closeness means touching ("в притик", 0.0).

## Proposed Changes

### Configuration & Persistence

#### [MODIFY] [app_config.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/config/app_config.dart)
- Update default windowed subtitle font size getter from `12.0` to `16.0`.
- Add storage keys and getters/setters for fullscreen spacing proportions:
  - `sub_original_to_translation_spacing_fs` (default `1.0`)
  - `sub_original_to_additional_spacing_fs` (default `1.0`)

### State & Providers

#### [MODIFY] [subtitle_settings_provider.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/providers/ui/subtitle_settings_provider.dart)
- Update `ModeSubtitleSettings` to include spacing fields (`originalToTranslationSpacing`, `originalToAdditionalSpacing`).
- Update `SubtitleSettingsNotifier.build()` and reset logic.
- Add modifier methods for the new spacing parameters.

### UI Widgets & Layouts

#### [MODIFY] [subtitle_text_content.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/subtitles/subtitle_text_content.dart)
- Use the configurable proportional spacing between original, translation, and additional content instead of hardcoded `6.0`.

#### [MODIFY] [subtitle_settings_side_panel.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/player/subtitle_settings_side_panel.dart)
- Add UI controls (sliders) for adjusting the new spacing parameters in fullscreen mode.

## Verification Plan

### Automated Tests
- Run project build or analyzer to verify no syntax errors.

### Manual Verification
- Test windowed subtitle readability with the new default font size (`16.0`).
- Test fullscreen spacing sliders and verify proportional behavior up to overlapping ("в притик", 0.0).
