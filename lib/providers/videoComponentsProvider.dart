import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../backend/database/schemas/language.dart';
import 'services/database_services_providers.dart';

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

final allLanguagesProvider = FutureProvider<List<Language>>((ref) async {
  final service = ref.watch(languageServiceProvider);
  return await service.getAllLanguages();
});

final languageCodesProvider = FutureProvider<Map<String, String>>((ref) async {
  final languages = await ref.watch(allLanguagesProvider.future);
  return {
    for (var l in languages)
      if (l.name != null && l.code != null) l.name!: l.code!,
  };
});
