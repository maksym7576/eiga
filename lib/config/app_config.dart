import 'package:shared_preferences/shared_preferences.dart';
import '../backend/database/schemas/translation_pipeline_step.dart';

class AppConfig {
  final SharedPreferences _prefs;

  AppConfig(this._prefs);

  // --- API Constants ---
  static const String aniListEndpoint = 'https://graphql.anilist.co';
  static const String jimakuBaseUrl = 'https://jimaku.cc/api';
  static const Duration defaultTimeout = Duration(seconds: 15);

  // --- Default Values ---
  static const int defaultPhrasesPerRequest = 40;
  static const int defaultSecondsAhead = 100;
  
  static const Map<TranslationPipelineStep, String> defaultModels = {
    TranslationPipelineStep.research: 'gemini-2.5-flash-lite',
    TranslationPipelineStep.translate: 'gemini-3.5-flash',
    TranslationPipelineStep.morphemes: 'gemini-2.5-flash',
    TranslationPipelineStep.fullTranslate: 'gemini-3.5-flash',
  };

  // --- Storage Keys ---
  static const _keySecondsAhead = 'seconds_before_send';
  static const _keyNumberOfPhrases = 'number_of_phrases';
  static const _keyIsThreeStepMethod = 'is_three_step_method';
  static const _keyLastResetDate = 'last_reset_date_utc';
  
  static String _modelKey(TranslationPipelineStep step) => 'active_model_${step.name}';

  // --- Getters & Setters ---

  Future<void> setSecondsAhead(int value) async {
    await _prefs.setInt(_keySecondsAhead, value);
  }

  Future<void> setNumberOfPhrases(int value) async {
    await _prefs.setInt(_keyNumberOfPhrases, value);
  }

  Future<void> setIsThreeStepMethod(bool value) async {
    await _prefs.setBool(_keyIsThreeStepMethod, value);
  }

  Future<void> setActiveModelForStep(TranslationPipelineStep step, String modelName) async {
    await _prefs.setString(_modelKey(step), modelName);
  }

  int get getSecondsAhead => _prefs.getInt(_keySecondsAhead) ?? defaultSecondsAhead;

  int get getNumberOfPhrases => _prefs.getInt(_keyNumberOfPhrases) ?? defaultPhrasesPerRequest;

  bool get getIsThreeStepMethod => _prefs.getBool(_keyIsThreeStepMethod) ?? true;

  String? get getLastResetDate => _prefs.getString(_keyLastResetDate);

  Future<void> setLastResetDate(String dateStr) async {
    await _prefs.setString(_keyLastResetDate, dateStr);
  }

  String getActiveModelForStep(TranslationPipelineStep step) {
    return _prefs.getString(_modelKey(step)) ?? defaultModels[step]!;
  }

  Future<void> resetToDefault() async {
    await _prefs.remove(_keySecondsAhead);
    await _prefs.remove(_keyNumberOfPhrases);
    await _prefs.remove(_keyIsThreeStepMethod);
    for (final step in TranslationPipelineStep.values) {
      await _prefs.remove(_modelKey(step));
    }
  }
}
