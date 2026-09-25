# Walkthrough - Subtitle Settings & Spacing Refinement

Implemented all requested enhancements for subtitle settings:

1. **Windowed Subtitle Default Font Size:**
   - Increased default font size from `12.0` to `16.0` in [app_config.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/config/app_config.dart) for improved readability.

2. **Proportional Spacing Between Original and Translation (Fullscreen):**
   - Added `originalToTranslationSpacing` property to `ModeSubtitleSettings` and preference persistence in [app_config.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/config/app_config.dart).
   - Added a slider in [subtitle_settings_side_panel.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/player/subtitle_settings_side_panel.dart) to adjust it, allowing it to go down to `0.0` ("в притик").

3. **Proportional Spacing Between Original and Additional (Fullscreen):**
   - Added `originalToAdditionalSpacing` property with corresponding persistence, state management, and side panel slider controls.
   - Applied proportional gap scaling in [subtitle_text_content.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/subtitles/subtitle_text_content.dart).
