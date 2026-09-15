import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../../../styles/additional_window_theme.dart';
import '../selectors/sync_version_selector.dart';

class SubtitleVersionSection extends HookConsumerWidget {
  const SubtitleVersionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = useState(false);

    if (state.analyzedVersions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SyncVersionSelector(
        isExpanded: isExpanded,
        showTechDetails: true,
      ),
    );
  }
}
