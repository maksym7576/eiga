import 'package:hooks_riverpod/hooks_riverpod.dart';

class OpenJimakuDialogNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  set state(bool value) => super.state = value;
}

final openJimakuDialogProvider = NotifierProvider<OpenJimakuDialogNotifier, bool>(
  OpenJimakuDialogNotifier.new,
);

class OpenGeminiDialogNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  set state(bool value) => super.state = value;
}

final openGeminiDialogProvider = NotifierProvider<OpenGeminiDialogNotifier, bool>(
  OpenGeminiDialogNotifier.new,
);

class OpenGroqDialogNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  set state(bool value) => super.state = value;
}

final openGroqDialogProvider = NotifierProvider<OpenGroqDialogNotifier, bool>(
  OpenGroqDialogNotifier.new,
);

class UseAlternativeLogoNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  set state(bool value) => super.state = value;
}

final useAlternativeLogoProvider = NotifierProvider<UseAlternativeLogoNotifier, bool>(
  UseAlternativeLogoNotifier.new,
);
