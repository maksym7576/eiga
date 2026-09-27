# Walkthrough - Subtitle Parsing & Bracket Handling Refactoring

## Changes

### Subtitle Depacker Service
- Removed `_bracketNoise` and all automatic bracket/parentheses stripping from `_normalize(...)` in [subtitle_depacker_service.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/services/depacker_subtitles/subtitle_depacker_service.dart).
- Subtitles now parse, preview, and save to the database in their original raw form without losing parentheses or brackets.

### Smart Bracket Hiding in Subtitle Rendering
- Updated [phrase_original_content.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/subtitles/components/phrase_original_content.dart) and [translation_styled_content.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/subtitles/components/translation_styled_content.dart).
- When "Hide content in brackets" is enabled in settings:
  - Partial brackets / parenthetical notes inside sentences are hidden.
  - **Exception**: If the entire text of a phrase/line is enclosed in brackets (e.g., `（セミの鳴き声）`), it is fully preserved on screen so that sound effects or standalone parenthetical lines remain visible.

## Validation Results
- Verified with flutter analyze.
