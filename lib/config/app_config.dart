import 'dart:io';
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
  static const _keyIsAutoLockEnabled = 'is_auto_lock_enabled';
  static const _keyLastResetDate = 'last_reset_date_utc';
  static const _keyMaxConcurrentProcesses = 'max_concurrent_processes';
  
  // Subtitle Settings Keys
  static const _keySubFontSize = 'sub_font_size';
  static const _keySubWindowedFontSize = 'sub_windowed_font_size';
  static const _keySubOutlineWidth = 'sub_outline_width';
  static const _keySubBackdropOpacity = 'sub_backdrop_opacity';
  static const _keySubBackdropPadding = 'sub_backdrop_padding';
  static const _keySubShowBackdrop = 'sub_show_backdrop';
  static const _keySubVerticalOffset = 'sub_vertical_offset';
  
  // Advanced Typography - Fullscreen
  static const _keySubLetterSpacingFs = 'sub_letter_spacing_fs';
  static const _keySubOriginalScaleFs = 'sub_original_scale_fs';
  static const _keySubTranslationScaleFs = 'sub_translation_scale_fs';
  static const _keySubAdditionalScaleFs = 'sub_additional_scale_fs';

  // Advanced Typography - Windowed
  static const _keySubLetterSpacingWin = 'sub_letter_spacing_win';
  static const _keySubOriginalScaleWin = 'sub_original_scale_win';
  static const _keySubTranslationScaleWin = 'sub_translation_scale_win';
  static const _keySubAdditionalScaleWin = 'sub_additional_scale_win';

  static const _keyVideoCachingEnabled = 'video_caching_enabled';
  
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

  Future<void> setIsAutoLockEnabled(bool value) async {
    await _prefs.setBool(_keyIsAutoLockEnabled, value);
  }

  Future<void> setSubFontSize(double value) async {
    await _prefs.setDouble(_keySubFontSize, value);
  }

  Future<void> setSubWindowedFontSize(double value) async {
    await _prefs.setDouble(_keySubWindowedFontSize, value);
  }

  Future<void> setSubOutlineWidth(double value) async {
    await _prefs.setDouble(_keySubOutlineWidth, value);
  }

  Future<void> setSubBackdropOpacity(double value) async {
    await _prefs.setDouble(_keySubBackdropOpacity, value);
  }

  Future<void> setSubBackdropPadding(double value) async {
    await _prefs.setDouble(_keySubBackdropPadding, value);
  }

  Future<void> setSubShowBackdrop(bool value) async {
    await _prefs.setBool(_keySubShowBackdrop, value);
  }

  Future<void> setSubVerticalOffset(double value) async {
    await _prefs.setDouble(_keySubVerticalOffset, value);
  }

  // Setters - FS
  Future<void> setSubLetterSpacingFs(double value) async {
    await _prefs.setDouble(_keySubLetterSpacingFs, value);
  }
  Future<void> setSubOriginalScaleFs(double value) async {
    await _prefs.setDouble(_keySubOriginalScaleFs, value);
  }
  Future<void> setSubTranslationScaleFs(double value) async {
    await _prefs.setDouble(_keySubTranslationScaleFs, value);
  }
  Future<void> setSubAdditionalScaleFs(double value) async {
    await _prefs.setDouble(_keySubAdditionalScaleFs, value);
  }

  // Setters - Windowed
  Future<void> setSubLetterSpacingWin(double value) async {
    await _prefs.setDouble(_keySubLetterSpacingWin, value);
  }
  Future<void> setSubOriginalScaleWin(double value) async {
    await _prefs.setDouble(_keySubOriginalScaleWin, value);
  }
  Future<void> setSubTranslationScaleWin(double value) async {
    await _prefs.setDouble(_keySubTranslationScaleWin, value);
  }
  Future<void> setSubAdditionalScaleWin(double value) async {
    await _prefs.setDouble(_keySubAdditionalScaleWin, value);
  }

  Future<void> setVideoCachingEnabled(bool value) async {
    await _prefs.setBool(_keyVideoCachingEnabled, value);
  }

  Future<void> setActiveModelForStep(TranslationPipelineStep step, String modelName) async {
    await _prefs.setString(_modelKey(step), modelName);
  }

  int get getSecondsAhead => _prefs.getInt(_keySecondsAhead) ?? defaultSecondsAhead;

  int get getNumberOfPhrases => _prefs.getInt(_keySecondsAhead) ?? defaultPhrasesPerRequest;

  int get getMaxConcurrentProcesses => _prefs.getInt(_keyMaxConcurrentProcesses) ?? defaultMaxConcurrentProcesses;

  int get getBatchSizeTranslate => _prefs.getInt(_keyBatchSizeTranslate) ?? 40;
  int get getBatchSizeTokenize => _prefs.getInt(_keyBatchSizeTokenize) ?? 40;
  int get getBatchSizeMorphemes => _prefs.getInt(_keyBatchSizeMorphemes) ?? 40;

  int get getSyncSkipMinutes => _prefs.getInt(_keySyncSkipMinutes) ?? defaultSyncSkipMinutes;
  int get getSyncPointDurationMinutes => _prefs.getInt(_keySyncPointDurationMinutes) ?? defaultSyncPointDurationMinutes;

  bool get getIsAutomaticModelSwitch => _prefs.getBool(_keyIsAutomaticModelSwitch) ?? true;

  bool get getIsAutoLockEnabled => _prefs.getBool(_keyIsAutoLockEnabled) ?? true;

  double get getSubFontSize => _prefs.getDouble(_keySubFontSize) ?? 28.0;
  double get getSubWindowedFontSize => _prefs.getDouble(_keySubWindowedFontSize) ?? 18.0;
  double get getSubOutlineWidth => _prefs.getDouble(_keySubOutlineWidth) ?? 1.0;
  double get getSubBackdropOpacity => _prefs.getDouble(_keySubBackdropOpacity) ?? 0.6;
  double get getSubBackdropPadding => _prefs.getDouble(_keySubBackdropPadding) ?? 8.0;
  bool get getSubShowBackdrop => _prefs.getBool(_keySubShowBackdrop) ?? true;
  double get getSubVerticalOffset => _prefs.getDouble(_keySubVerticalOffset) ?? 0.0;

  // Getters - FS
  double get getSubLetterSpacingFs => _prefs.getDouble(_keySubLetterSpacingFs) ?? 2.0;
  double get getSubOriginalScaleFs => _prefs.getDouble(_keySubOriginalScaleFs) ?? 1.0;
  double get getSubTranslationScaleFs => _prefs.getDouble(_keySubTranslationScaleFs) ?? 1.0;
  double get getSubAdditionalScaleFs => _prefs.getDouble(_keySubAdditionalScaleFs) ?? 1.0;

  // Getters - Windowed
  double get getSubLetterSpacingWin => _prefs.getDouble(_keySubLetterSpacingWin) ?? 2.0;
  double get getSubOriginalScaleWin => _prefs.getDouble(_keySubOriginalScaleWin) ?? 1.0;
  double get getSubTranslationScaleWin => _prefs.getDouble(_keySubTranslationScaleWin) ?? 1.0;
  double get getSubAdditionalScaleWin => _prefs.getDouble(_keySubAdditionalScaleWin) ?? 1.0;

  bool get getVideoCachingEnabled {
    final def = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return _prefs.getBool(_keyVideoCachingEnabled) ?? def;
  }

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
