import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';
import 'sync_version_selector.dart';

class SubtitleVersionSection extends HookConsumerWidget {
  const SubtitleVersionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = useState(false);

    if (state.analyzedVersions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        buildVersionSelectorCard(
          context,
          state,
          theme,
          notifier,
          isExpanded: isExpanded,
          showTechDetails: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
