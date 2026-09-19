import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../config/languages/language_hub.dart';

class LanguageState {
  final String? original;
  final String? target;

  LanguageState({this.original, this.target});

  LanguageState copyWith({String? original, String? target}) {
    return LanguageState(
      original: original ?? this.original,
      target: target ?? this.target,
    );
  }
}

class LanguageNotifier extends Notifier<LanguageState> {
  @override
  LanguageState build() {
    return LanguageState();
  }

  void setOriginal(String? language) {
    state = state.copyWith(original: language);
  }

  void setTarget(String? language) {
    state = state.copyWith(target: language);
  }

  void reset() {
    state = LanguageState();
  }
}

final languageProvider = NotifierProvider.autoDispose<LanguageNotifier, LanguageState>(
  LanguageNotifier.new,
);

final allLanguagesProvider = Provider<List<LanguageConfig>>((ref) {
  return LanguageHub.all;
});

final languageCodesProvider = Provider<Map<String, String>>((ref) {
  final languages = ref.watch(allLanguagesProvider);
  return {
    for (var l in languages) l.name: l.code,
  };
});
