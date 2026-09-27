# Subtitle Parsing & Bracket Handling Refactoring

## User Review Required

> [!IMPORTANT]
> This plan addresses subtitle parsing (`SrtParser`, `AssParser`, `SubtitleDepackerService`), upload preview and database saving, and adds a dedicated configuration option in Player & Subtitle Settings for "Hide content in brackets" vs preserving bracketed text.

- **Parsing Preservation**: During subtitle upload and preview parsing, we will **NOT** strip parentheses/brackets anymore (`_normalize` or `_bracketNoise` removal will be removed from the raw parser/upload stage). Subtitles will be parsed as they are in the source file.
- **New Setting**: Add a setting in [player_settings_screen.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/screens/settings/player_settings_screen.dart) and [app_config.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/config/app_config.dart): `Hide content in brackets` (enabled by default or toggleable).
- **Smart Exception Rule**: If the text inside brackets occupies the entire line/phrase (or represents a standalone parenthetical line like `（セミの鳴き声）` where the whole content is enclosed in brackets), we preserve it even when "Hide content in brackets" is enabled!
- **Upload Preview Toggle**: In the upload screen / preview, users can toggle this setting to instantly see how subtitles look with or without brackets.

## Proposed Changes

### Configuration & Settings
#### [MODIFY] [app_config.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/config/app_config.dart)
- Ensure clean getter/setter for `_keyHideParenthesesContent`.

#### [MODIFY] [player_settings_screen.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/screens/settings/player_settings_screen.dart)
- Verify/enhance the switch for hiding parentheses content.

### Subtitle Parsers & Depacking
#### [MODIFY] [subtitle_depacker_service.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/services/depacker_subtitles/subtitle_depacker_service.dart)
- Remove `_bracketNoise` stripping from `_normalize` and `parseMultiStreamPreview` so that raw subtitles keep brackets during upload, preview, and database persistence.
- Refine `mergePhraseCues` and text cleanup so speaker names/parenthetical notes are not erroneously malformed or split.

#### [MODIFY] [srt_parser_service.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/services/depacker_subtitles/srt_parser_service.dart) & [ass_parser_service.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/services/depacker_subtitles/ass_parser_service.dart)
- Ensure clean parsing without stripping brackets.

### Subtitle Rendering & Helper Utilities
#### [MODIFY] [phrase_original_content.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/subtitles/components/phrase_original_content.dart)
- Implement the smart bracket-hiding rule:
  - If `hideBrackets` is true, remove bracketed text **unless** the entire string/phrase is enclosed in brackets (e.g. `（セミの鳴き声）`).

## Verification Plan

### Automated Tests
- Build and analyze project.

### Manual Verification
- Test uploading `.srt` / `.ass` subtitles with brackets (e.g., character names, SFX).
- Verify preview retains brackets in the Upload screen.
- Toggle "Hide content in brackets" in settings and verify partial brackets are hidden while full-bracket lines (like `（セミの鳴き声）`) remain visible.
