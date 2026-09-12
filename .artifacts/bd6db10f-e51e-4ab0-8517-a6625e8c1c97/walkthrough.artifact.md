# Walkthrough - UI Refresh & Navigation Improvements

I have updated the AppBar design, refactored the "How to Use" guide, and moved the full library view to a dedicated screen.

## Changes Made

### 1. AppBar Refresh
- **Logo Style**: Updated the `logoStyle` in `AppAppBarTheme` to use `AppColors.brandBlue` for better brand consistency.
- **Icons**: Changed the settings navigation icon from a hamburger menu to a gear icon (`Icons.settings_rounded`) in `AppAppBar`.
- **Progress Refactoring**: Created `TranslationProgressBar` in the `animations/` folder and updated `AppAppBar` to use it, replacing the old banner.

### 2. Main Screen & Guide
- **Repositioning**: The "How to Use" guide was moved from the bottom of the `MainScreen` to a primary position directly below the "Add Video" button.
- **English Localization**: Updated the manual steps to English, describing the video upload process:
    1. Tap the "Add Video" button.
    2. Add your video file.
    3. Select source (Local or Jimaku).
    4. Choose metadata provider (Shikimori, AniList, etc.).
    5. Enter the video title.
    6. Select the language to finish.

### 3. Library Navigation
- **Dedicated Screen**: Created `LibraryScreen` to display the full grid of videos.
- **Navigation**: Updated the "See All" button in the Library section of `MainScreen` to navigate to `/library` instead of opening a bottom sheet.

## Bug Fixes
- **LibraryScreen**: Fixed a compilation error caused by a missing import for `allVideosProvider`. Added `import 'package:eiga/providers/ui/main_hub_providers.dart';` to the file.

## Verification

- **AppBar**: Verified the new logo color and gear icon.
- **Guide**: Confirmed the "How to Use" section is visible under the "Add Video" button with the new English text.
- **Navigation**: Verified that clicking "See All" correctly opens the new full-screen library view.
