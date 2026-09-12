import 'package:shared_preferences/shared_preferences.dart';
import '../backend/database/schemas/translation_pipeline_step.dart';

class AppConfig {
  final SharedPreferences _prefs;

  AppConfig(this._prefs);

  // --- API Constants ---
  static const String aniListEndpoint = 'https://graphql.anilist.co';
  static const String jimakuBaseUrl = 'https://jimaku.cc/api';
  static const String wyzieBaseUrl = 'https://api.wyzie.xyz/v1';
  static const String tvMazeEndpoint = 'https://api.tvmaze.com';
  static const String shikimoriBaseUrl = 'https://shikimori.one/api';
  static const Duration defaultTimeout = Duration(seconds: 15);

  // --- Default Values ---
  static const int defaultPhrasesPerRequest = 40;
  static const int defaultSecondsAhead = 100;
  static const int defaultMaxConcurrentProcesses = 2;
  static const int defaultSyncSkipMinutes = 5;
  static const int defaultSyncPointDurationMinutes = 2;
  
  static const Map<TranslationPipelineStep, String> defaultModels = {
    TranslationPipelineStep.research: 'gemini-3.5-flash-lite',
    TranslationPipelineStep.translate: 'gemini-3.8-flash',
    TranslationPipelineStep.tokenize: 'gemini-3.5-flash-lite',
    TranslationPipelineStep.morphemes: 'gemini-3.5-flash',
  };

  // --- Storage Keys ---
  static const _keySecondsAhead = 'seconds_before_send';
  static const _keyNumberOfPhrases = 'number_of_phrases';
  static const _keyIsAutomaticModelSwitch = 'is_automatic_model_switch';
  static const _keyLastResetDate = 'last_reset_date_utc';
  static const _keyMaxConcurrentProcesses = 'max_concurrent_processes';
  
  static const _keyBatchSizeTranslate = 'batch_size_translate';
  static const _keyBatchSizeTokenize = 'batch_size_tokenize';
  static const _keyBatchSizeMorphemes = 'batch_size_morphemes';
  static const _keySyncSkipMinutes = 'sync_skip_minutes';
  static const _keySyncPointDurationMinutes = 'sync_point_duration_minutes';
  
  static String _modelKey(TranslationPipelineStep step) => 'active_model_${step.name}';

  // --- Getters & Setters ---

  Future<void> setSecondsAhead(int value) async {
    await _prefs.setInt(_keySecondsAhead, value);
  }

  Future<void> setNumberOfPhrases(int value) async {
    await _prefs.setInt(_keyNumberOfPhrases, value);
  }

  Future<void> setMaxConcurrentProcesses(int value) async {
    await _prefs.setInt(_keyMaxConcurrentProcesses, value);
  }

  Future<void> setBatchSizeTranslate(int value) async {
    await _prefs.setInt(_keyBatchSizeTranslate, value);
  }

  Future<void> setBatchSizeTokenize(int value) async {
    await _prefs.setInt(_keyBatchSizeTokenize, value);
  }

  Future<void> setBatchSizeMorphemes(int value) async {
    await _prefs.setInt(_keyBatchSizeMorphemes, value);
  }

  Future<void> setSyncSkipMinutes(int value) async {
    await _prefs.setInt(_keySyncSkipMinutes, value);
  }

  Future<void> setSyncPointDurationMinutes(int value) async {
    await _prefs.setInt(_keySyncPointDurationMinutes, value);
  }

  Future<void> setIsAutomaticModelSwitch(bool value) async {
    await _prefs.setBool(_keyIsAutomaticModelSwitch, value);
  }

  Future<void> setActiveModelForStep(TranslationPipelineStep step, String modelName) async {
    await _prefs.setString(_modelKey(step), modelName);
  }

  int get getSecondsAhead => _prefs.getInt(_keySecondsAhead) ?? defaultSecondsAhead;

  int get getNumberOfPhrases => _prefs.getInt(_keyNumberOfPhrases) ?? defaultPhrasesPerRequest;

  int get getMaxConcurrentProcesses => _prefs.getInt(_keyMaxConcurrentProcesses) ?? defaultMaxConcurrentProcesses;

  int get getBatchSizeTranslate => _prefs.getInt(_keyBatchSizeTranslate) ?? 40;
  int get getBatchSizeTokenize => _prefs.getInt(_keyBatchSizeTokenize) ?? 40;
  int get getBatchSizeMorphemes => _prefs.getInt(_keyBatchSizeMorphemes) ?? 40;

  int get getSyncSkipMinutes => _prefs.getInt(_keySyncSkipMinutes) ?? defaultSyncSkipMinutes;
  int get getSyncPointDurationMinutes => _prefs.getInt(_keySyncPointDurationMinutes) ?? defaultSyncPointDurationMinutes;

  bool get getIsAutomaticModelSwitch => _prefs.getBool(_keyIsAutomaticModelSwitch) ?? true;

  String? get getLastResetDate => _prefs.getString(_keyLastResetDate);

  Future<void> setLastResetDate(String dateStr) async {
    await _prefs.setString(_keyLastResetDate, dateStr);
  }

  String getActiveModelForStep(TranslationPipelineStep step) {
    return _prefs.getString(_modelKey(step)) ?? defaultModels[step]!;
  }

  String? getActiveModelForStepRaw(TranslationPipelineStep step) {
    return _prefs.getString(_modelKey(step));
  }

  Future<void> resetToDefault() async {
    await _prefs.remove(_keySecondsAhead);
    await _prefs.remove(_keyNumberOfPhrases);
    for (final step in TranslationPipelineStep.values) {
      await _prefs.remove(_modelKey(step));
    }
  }
}
