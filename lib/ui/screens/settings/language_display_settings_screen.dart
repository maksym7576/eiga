import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/services/reading_type_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import '../../widgets/settings/reading_option_selector.dart';

class LanguageDisplaySettingsScreen extends ConsumerWidget {
  final String languageName;

  const LanguageDisplaySettingsScreen({
    super.key,
    required this.languageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final stateAsync = ref.watch(globalReadingTypeProvider(languageName));

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(languageName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.dividerColor, height: 1),
        ),
      ),
      body: stateAsync.when(
        data: (state) {
          final notifier = ref.read(globalReadingTypeProvider(languageName).notifier);
          final actions = _GlobalReadingActions(notifier);
          return ReadingOptionSelector(
            state: state,
            actions: actions,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _GlobalReadingActions implements ReadingTypeActions {
  final GlobalReadingTypeNotifier notifier;
  _GlobalReadingActions(this.notifier);

  @override
  void updateMainOption(String option) => notifier.updateMainOption(option);
  @override
  void updateAdditionalOption(String? option) => notifier.updateAdditionalOption(option);
  @override
  void updateShowTranslation(bool value) => notifier.updateShowTranslation(value);
}
