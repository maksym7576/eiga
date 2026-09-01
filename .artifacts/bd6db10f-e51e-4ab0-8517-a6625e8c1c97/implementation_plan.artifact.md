# Implementation Plan - AI Model Selection UI

The goal is to implement a fully functional model selection bottom sheet based on the provided design. This includes method selection (1-step vs 3-step), step selection for the advanced method, and model configuration (active model selection and streaming toggle).

## User Review Required

> [!IMPORTANT]
> - **Streaming Logic**: The streaming toggle will only be visible when the active step is `morphemes` or `fullTranslate`.
> - **Persistence**: Toggling the translation method or changing an active model will immediately update `SharedPreferences`. Toggling streaming will update the Isar database.
> - **Visuals**: I will use custom widgets to match the Material 3 / Tailwind look from the mockup, including the segmented controls and model cards.

## Proposed Changes

### 1. State Management

#### [MODIFY] [ai_models_state_provider.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/providers/ui/ai_models_state_provider.dart)
- Implement `modelsForStepProvider` to fetch actual models from `AiModelService`.
- Ensure `AiModelsNotifier` correctly triggers UI updates when the active model changes.

### 2. UI Implementation

#### [MODIFY] [modelsPreviewWidget.dart](file:///C:/Users/fcjhx/StudioProjects/eiga/lib/ui/widgets/appBarWidgets/modelsPreviewWidget.dart)
- Implement the header with the "Models" title and close button.
- **Method Selector**: A segmented control to switch between "Advanced (3-step)" and "Standard (1-step)".
- **Step Selector**: Visible only in Advanced mode, allows switching between "Research", "Translation", and "Morphemes".
- **Model List**: Renders model cards for the currently selected step.
- **Model Card**:
  - Displays model name, provider icon, and description.
  - Shows "Active" indicator (check mark and border).
  - Includes a "Streaming" toggle (conditionally visible).
  - Displays usage counters (`used/dailyMaxLimit`).

### 3. Service Integration
- Use `AppConfigs` to manage `isThreeStepMethod` and active model names.
- Use `AiModelService` to update `AiModel` objects in Isar when settings like streaming are changed.

## Verification Plan

### Manual Verification
- Open the bottom sheet and toggle between "Advanced" and "Standard".
- Switch between steps in "Advanced" mode and verify the model list updates.
- Select a different model and verify the AppBar updates.
- Toggle "Streaming" and verify it persists after reopening the sheet.
- Check that the streaming toggle is hidden for "Research" and "Translation" steps.
