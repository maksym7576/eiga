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
  static const int defaultPhrasesPerRequest = 70;
  static const int defaultSecondsAhead = 100;
  static const int defaultMaxConcurrentProcesses = 2;
  static const int defaultSyncSkipMinutes = 5;
  static const int defaultSyncPointDurationMinutes = 2;
  
  static const Map<TranslationPipelineStep, String> defaultModels = {
    TranslationPipelineStep.research: 'gemini-3.5-flash-lite',
    TranslationPipelineStep.translate: 'gemini-3.8-flash',
    TranslationPipelineStep.tokenize: 'gemini-3.5-flash-lite',
    TranslationPipelineStep.morphemes: 'gemini-3.5-flash',
    TranslationPipelineStep.grammarRole: 'gemini-3.5-flash',
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
  static const _keySubFontWeightFs = 'sub_font_weight_fs';
  static const _keySubFontWeightWin = 'sub_font_weight_win';
  
  // Advanced Typography - Fullscreen
  static const _keySubLetterSpacingFs = 'sub_letter_spacing_fs'; // Keep for legacy or rename?
  static const _keySubTranslationLetterSpacingFs = 'sub_translation_letter_spacing_fs';
  static const _keySubOriginalScaleFs = 'sub_original_scale_fs';
  static const _keySubTranslationScaleFs = 'sub_translation_scale_fs';
  static const _keySubAdditionalScaleFs = 'sub_additional_scale_fs';
  static const _keySubOriginalOutlineWidthFs = 'sub_original_outline_width_fs';
  static const _keySubTranslationOutlineWidthFs = 'sub_translation_outline_width_fs';

  // Advanced Typography - Windowed
  static const _keySubLetterSpacingWin = 'sub_letter_spacing_win';
  static const _keySubTranslationLetterSpacingWin = 'sub_translation_letter_spacing_win';
  static const _keySubOriginalScaleWin = 'sub_original_scale_win';
  static const _keySubTranslationScaleWin = 'sub_translation_scale_win';
  static const _keySubAdditionalScaleWin = 'sub_additional_scale_win';

  static const _keyVideoCachingEnabled = 'video_caching_enabled';
  
  static const _keyBatchSizeTranslate = 'batch_size_translate';
  static const _keyBatchSizeTokenize = 'batch_size_tokenize';
  static const _keyBatchSizeMorphemes = 'batch_size_morphemes';
  static const _keyBatchSizeGrammarRole = 'batch_size_grammar_role';
  static const _keySyncSkipMinutes = 'sync_skip_minutes';
  static const _keySyncPointDurationMinutes = 'sync_point_duration_minutes';
  static const _keyHideParenthesesContent = 'hide_parentheses_content';
  static const _keyFullscreenAutoShrink = 'fs_auto_shrink';

  static const _keyAnkiConnectUrl = 'anki_connect_url';
  static const _keyAnkiDeckName = 'anki_deck_name';
  static const _keyAnkiNoteType = 'anki_note_type';
  
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

  Future<void> setBatchSizeGrammarRole(int value) async {
    await _prefs.setInt(_keyBatchSizeGrammarRole, value);
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

  Future<void> setHideParenthesesContent(bool value) async {
    await _prefs.setBool(_keyHideParenthesesContent, value);
  }

  Future<void> setFullscreenAutoShrink(bool value) async {
    await _prefs.setBool(_keyFullscreenAutoShrink, value);
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

  Future<void> setSubFontWeightFs(double value) async {
    await _prefs.setDouble(_keySubFontWeightFs, value);
  }

  Future<void> setSubFontWeightWin(double value) async {
    await _prefs.setDouble(_keySubFontWeightWin, value);
  }

  // Setters - FS
  Future<void> setSubLetterSpacingFs(double value) async {
    await _prefs.setDouble(_keySubLetterSpacingFs, value);
  }
  Future<void> setSubTranslationLetterSpacingFs(double value) async {
    await _prefs.setDouble(_keySubTranslationLetterSpacingFs, value);
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
  Future<void> setSubOriginalOutlineWidthFs(double value) async {
    await _prefs.setDouble(_keySubOriginalOutlineWidthFs, value);
  }
  Future<void> setSubTranslationOutlineWidthFs(double value) async {
    await _prefs.setDouble(_keySubTranslationOutlineWidthFs, value);
  }

  // Setters - Windowed
  Future<void> setSubLetterSpacingWin(double value) async {
    await _prefs.setDouble(_keySubLetterSpacingWin, value);
  }
  Future<void> setSubTranslationLetterSpacingWin(double value) async {
    await _prefs.setDouble(_keySubTranslationLetterSpacingWin, value);
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

  int get getNumberOfPhrases => _prefs.getInt(_keyNumberOfPhrases) ?? defaultPhrasesPerRequest;

  int get getMaxConcurrentProcesses => _prefs.getInt(_keyMaxConcurrentProcesses) ?? defaultMaxConcurrentProcesses;

  int get getBatchSizeTranslate => _prefs.getInt(_keyBatchSizeTranslate) ?? 70;
  int get getBatchSizeTokenize => _prefs.getInt(_keyBatchSizeTokenize) ?? 70;
  int get getBatchSizeMorphemes => _prefs.getInt(_keyBatchSizeMorphemes) ?? 70;
  int get getBatchSizeGrammarRole => _prefs.getInt(_keyBatchSizeGrammarRole) ?? 70;

  int get getSyncSkipMinutes => _prefs.getInt(_keySyncSkipMinutes) ?? defaultSyncSkipMinutes;
  int get getSyncPointDurationMinutes => _prefs.getInt(_keySyncPointDurationMinutes) ?? defaultSyncPointDurationMinutes;

  bool get getIsAutomaticModelSwitch => _prefs.getBool(_keyIsAutomaticModelSwitch) ?? true;

  bool get getIsAutoLockEnabled => _prefs.getBool(_keyIsAutoLockEnabled) ?? true;

  bool get getHideParenthesesContent => _prefs.getBool(_keyHideParenthesesContent) ?? false;

  bool get getFullscreenAutoShrink => _prefs.getBool(_keyFullscreenAutoShrink) ?? false;

  double get getSubFontSize => _prefs.getDouble(_keySubFontSize) ?? 28.0;
  double get getSubWindowedFontSize => _prefs.getDouble(_keySubWindowedFontSize) ?? 18.0;
  double get getSubOutlineWidth => _prefs.getDouble(_keySubOutlineWidth) ?? 1.0;
  double get getSubBackdropOpacity => _prefs.getDouble(_keySubBackdropOpacity) ?? 0.6;
  double get getSubBackdropPadding => _prefs.getDouble(_keySubBackdropPadding) ?? 8.0;
  bool get getSubShowBackdrop => _prefs.getBool(_keySubShowBackdrop) ?? true;
  double get getSubVerticalOffset => _prefs.getDouble(_keySubVerticalOffset) ?? 0.0;
  double get getSubFontWeightFs => _prefs.getDouble(_keySubFontWeightFs) ?? 0.5; // 0.0 to 1.0
  double get getSubFontWeightWin => _prefs.getDouble(_keySubFontWeightWin) ?? 0.0;

  // Getters - FS
  double get getSubLetterSpacingFs => _prefs.getDouble(_keySubLetterSpacingFs) ?? 0.0;
  double get getSubTranslationLetterSpacingFs => _prefs.getDouble(_keySubTranslationLetterSpacingFs) ?? 0.0;
  double get getSubOriginalScaleFs => _prefs.getDouble(_keySubOriginalScaleFs) ?? 1.0;
  double get getSubTranslationScaleFs => _prefs.getDouble(_keySubTranslationScaleFs) ?? 1.0;
  double get getSubAdditionalScaleFs => _prefs.getDouble(_keySubAdditionalScaleFs) ?? 1.0;
  double get getSubOriginalOutlineWidthFs => _prefs.getDouble(_keySubOriginalOutlineWidthFs) ?? 1.0;
  double get getSubTranslationOutlineWidthFs => _prefs.getDouble(_keySubTranslationOutlineWidthFs) ?? 1.0;

  // Getters - Windowed
  double get getSubLetterSpacingWin => _prefs.getDouble(_keySubLetterSpacingWin) ?? 0.0;
  double get getSubTranslationLetterSpacingWin => _prefs.getDouble(_keySubTranslationLetterSpacingWin) ?? 0.0;
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
    await _prefs.remove(_keySubFontSize);
    await _prefs.remove(_keySubWindowedFontSize);
    await _prefs.remove(_keySubOutlineWidth);
    await _prefs.remove(_keySubBackdropOpacity);
    await _prefs.remove(_keySubBackdropPadding);
    await _prefs.remove(_keySubShowBackdrop);
    await _prefs.remove(_keySubVerticalOffset);
    await _prefs.remove(_keySubFontWeightFs);
    await _prefs.remove(_keySubFontWeightWin);
    await _prefs.remove(_keySubLetterSpacingFs);
    await _prefs.remove(_keySubOriginalScaleFs);
    await _prefs.remove(_keySubTranslationScaleFs);
    await _prefs.remove(_keySubAdditionalScaleFs);
    await _prefs.remove(_keySubLetterSpacingWin);
    await _prefs.remove(_keySubOriginalScaleWin);
    await _prefs.remove(_keySubTranslationScaleWin);
    await _prefs.remove(_keySubAdditionalScaleWin);
    
    for (final step in TranslationPipelineStep.values) {
      await _prefs.remove(_modelKey(step));
    }
  }

  String get getAnkiConnectUrl => _prefs.getString(_keyAnkiConnectUrl) ?? 'http://localhost:8765';
  Future<void> setAnkiConnectUrl(String value) async => await _prefs.setString(_keyAnkiConnectUrl, value);

  String get getAnkiDeckName => _prefs.getString(_keyAnkiDeckName) ?? 'Eiga';
  Future<void> setAnkiDeckName(String value) async => await _prefs.setString(_keyAnkiDeckName, value);

  String get getAnkiNoteType => _prefs.getString(_keyAnkiNoteType) ?? 'Basic';
  Future<void> setAnkiNoteType(String value) async => await _prefs.setString(_keyAnkiNoteType, value);

  Future<void> resetBatchSettings() async {
    await _prefs.remove(_keyNumberOfPhrases);
    await _prefs.remove(_keyBatchSizeTranslate);
    await _prefs.remove(_keyBatchSizeTokenize);
    await _prefs.remove(_keyBatchSizeMorphemes);
    await _prefs.remove(_keyBatchSizeGrammarRole);
  }
}
