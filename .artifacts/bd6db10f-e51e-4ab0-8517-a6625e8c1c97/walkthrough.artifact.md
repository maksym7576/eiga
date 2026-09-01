# Walkthrough - Phased AI Model Integration (Foundation)

I have implemented the foundational components for AI model management, including database schema updates, seeding, CRUD services, and the initial AppBar UI.

## Changes Made

### 1. Database & Models
- **[AiModel Schema](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/database/schemas/ai_model.dart)**: Added fields for tracking usage (`used`, `dailyUsed`), customizable limits (`currentMaxLimit`, `currentDailyMaxLimit`), and streaming toggles.
- **[AiModel Seeds](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/database/seeds/ai_model_seeds.dart)**: Updated seed data to initialize these new fields and define supported translation steps for each model.
- **[AiModelService](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/database/services/ai_model_service.dart)**: Created a service to handle CRUD operations, usage incrementing, and resetting to defaults.

### 2. Configs & State
- **[TranslationPipelineStep Enum](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/config/models_url/TranslationPipelineStep.dart)**: Defined the steps: `research`, `translate`, `morphemes`, and `fullTranslate`.
- **[AppConfigs](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/config/AppConfigs.dart)**: Added a SharedPreferences wrapper to store user preferences like the translation method (1-step vs 3-step).
- **Direct Database Usage**: Removed DTOs in favor of using the `AiModel` Isar schema directly in the UI to ensure data consistency.

### 3. UI Components
- **[AppAppBar](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/appBarWidgets/app_app_bar.dart)**: Implemented the new AppBar with a cycling animation that shows the current translation step and active model. (Renamed from `AppBarWidget` for consistency).
- **[EigaLogoAnimation](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/animations/eiga_logo_animation.dart)**: Added the "Accent Box" animation to the logo. The letter 'a' inside a blue box periodically scales down, swaps to 'あ', pauses, and swaps back to 'a'. I also increased the font size of the letters within the box for better visibility.
- **[MainScreen Integration](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/screens/main_screen.dart)**: Replaced the default `AppBar` with the custom `AppAppBar` in the main library screen.
- **[ModelPreviewWidget](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/appBarWidgets/modelsPreviewWidget.dart)**: Created a placeholder bottom sheet content that will be expanded in future phases.
- **[AppAppBarTheme](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/styles/AppAppBarTheme.dart)**: Defined the visual styles for the new AppBar components.

## Verification Results

### Database Seeding
- The `standardAiModels()` function now correctly initializes all new fields.
- `IsarService` will automatically populate the database with these enhanced models on the first run.

### AppBar UI
- The `AppBarWidget` includes a timer that cycles through translation steps every 3 seconds with a slide animation.
- Tapping the selector opens the `AppBottomSheet` with the `ModelPreviewWidget`.

### 9. Data Management & Reset
- **[SettingsScreen](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/screens/settings_screen.dart)**: Added a "Danger Zone" section with a **Clear All Data** button. This button:
  - Wipes the Isar database.
  - Resets all `SharedPreferences` to factory defaults.
  - Invalidates providers to force a fresh UI reload.
- **[AppConfigs](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/backend/services/app_configs.dart)**: Fixed an issue where default model names were set to 'none'. They now correctly point to standard Gemini models defined in seeds.
