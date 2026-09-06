import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/services/database_services_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';

class ReadingTypeNotifier extends AsyncNotifier<ReadingTypeState> {
  String _getMainKey(String lang) => 'reading_main_${lang.toLowerCase()}';
  String _getAdditionalKey(String lang) => 'reading_additional_${lang.toLowerCase()}';
  String _getTranslationToggleKey(String lang) => 'show_translation_${lang.toLowerCase()}';

  @override
  Future<ReadingTypeState> build() async {
    final videoId = ref.watch(playerIdProvider);
    if (videoId == null) throw Exception('No video selected');

    final videoService = ref.read(videoServiceProvider);
    final video = await videoService.getVideoById(videoId);
    
    if (video == null || video.originalLanguage == null) {
      throw Exception('Video or language not found');
    }

    final langName = video.originalLanguage!;
    final languageService = ref.read(languageServiceProvider);
    final languageData = await languageService.getLanguageByName(langName);

    final List<String> options = languageData?.readingOptions ?? ['original'];
    final List<String> labels = languageData?.readingLabels ?? ['ORIGINAL'];
    
    final prefs = ref.read(sharedPreferencesProvider);
    final savedMain = prefs.getString(_getMainKey(langName)) ?? 'original';
    final savedAdditional = prefs.getString(_getAdditionalKey(langName));
    final showTranslation = prefs.getBool(_getTranslationToggleKey(langName)) ?? true;

    return ReadingTypeState(
      languageName: langName,
      availableOptions: options.toSet().toList(),
      optionLabels: labels,
      mainOption: options.contains(savedMain) ? savedMain : (options.isNotEmpty ? options.first : 'original'),
      additionalOption: savedAdditional != null && options.contains(savedAdditional) ? savedAdditional : null,
      showTranslation: showTranslation,
    );
  }

  Future<void> updateMainOption(String option) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_getMainKey(currentState.languageName), option);

    state = AsyncData(currentState.copyWith(mainOption: option));
  }

  Future<void> updateAdditionalOption(String? option) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    final key = _getAdditionalKey(currentState.languageName);

    if (option == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, option);
    }

    state = AsyncData(currentState.copyWith(additionalOption: () => option));
  }

  Future<void> updateShowTranslation(bool value) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_getTranslationToggleKey(currentState.languageName), value);

    state = AsyncData(currentState.copyWith(showTranslation: value));
  }
}

class ReadingTypeState {
  final String languageName;
  final List<String> availableOptions;
  final List<String> optionLabels;
  final String mainOption;
  final String? additionalOption;
  final bool showTranslation;

  ReadingTypeState({
    required this.languageName,
    required this.availableOptions,
    this.optionLabels = const [],
    this.mainOption = 'original',
    this.additionalOption,
    this.showTranslation = true,
  });

  String getLabel(String option) {
    if (option == 'NONE') return 'NONE';
    final index = availableOptions.indexOf(option);
    if (index != -1 && index < optionLabels.length) {
      return optionLabels[index];
    }
    return option.toUpperCase();
  }

  ReadingTypeState copyWith({
    String? mainOption,
    String? Function()? additionalOption,
    bool? showTranslation,
  }) {
    return ReadingTypeState(
      languageName: languageName,
      availableOptions: availableOptions,
      optionLabels: optionLabels,
      mainOption: mainOption ?? this.mainOption,
      additionalOption: additionalOption != null ? additionalOption() : this.additionalOption,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }
}

final readingTypeNotifierProvider = AsyncNotifierProvider.autoDispose<ReadingTypeNotifier, ReadingTypeState>(
  ReadingTypeNotifier.new,
);

class GlobalReadingTypeNotifier extends AsyncNotifier<ReadingTypeState> {
  final String languageName;
  GlobalReadingTypeNotifier(this.languageName);

  String _getMainKey(String lang) => 'reading_main_${lang.toLowerCase()}';
  String _getAdditionalKey(String lang) => 'reading_additional_${lang.toLowerCase()}';
  String _getTranslationToggleKey(String lang) => 'show_translation_${lang.toLowerCase()}';

  @override
  Future<ReadingTypeState> build() async {
    final languageService = ref.read(languageServiceProvider);
    final languageData = await languageService.getLanguageByName(languageName);

    final List<String> options = languageData?.readingOptions ?? ['original'];
    final List<String> labels = languageData?.readingLabels ?? ['ORIGINAL'];
    
    final prefs = ref.read(sharedPreferencesProvider);
    final savedMain = prefs.getString(_getMainKey(languageName)) ?? 'original';
    final savedAdditional = prefs.getString(_getAdditionalKey(languageName));
    final showTranslation = prefs.getBool(_getTranslationToggleKey(languageName)) ?? true;

    return ReadingTypeState(
      languageName: languageName,
      availableOptions: options.toSet().toList(),
      optionLabels: labels,
      mainOption: options.contains(savedMain) ? savedMain : (options.isNotEmpty ? options.first : 'original'),
      additionalOption: savedAdditional != null && options.contains(savedAdditional) ? savedAdditional : null,
      showTranslation: showTranslation,
    );
  }

  Future<void> updateMainOption(String option) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_getMainKey(currentState.languageName), option);

    state = AsyncData(currentState.copyWith(mainOption: option));
  }

  Future<void> updateAdditionalOption(String? option) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    final key = _getAdditionalKey(currentState.languageName);

    if (option == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, option);
    }

    state = AsyncData(currentState.copyWith(additionalOption: () => option));
  }

  Future<void> updateShowTranslation(bool value) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_getTranslationToggleKey(currentState.languageName), value);

    state = AsyncData(currentState.copyWith(showTranslation: value));
  }
}

final globalReadingTypeProvider = AsyncNotifierProvider.family<GlobalReadingTypeNotifier, ReadingTypeState, String>(
  GlobalReadingTypeNotifier.new,
);
