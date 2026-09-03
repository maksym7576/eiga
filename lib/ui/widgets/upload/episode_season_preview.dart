import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';

class EpisodeSeasonPreview extends ConsumerWidget {
  const EpisodeSeasonPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final theme = AdditionalWindowTheme.of(context);

    if (state.episode == null && state.season == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (state.season != null)
            _buildBadge(context, 'Season ${state.season}', theme),
          if (state.season != null && state.episode != null)
            const SizedBox(width: 8),
          if (state.episode != null)
            _buildBadge(context, 'Episode ${state.episode}', theme),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, AdditionalWindowTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.cardBorder),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.normalText,
        ),
      ),
    );
  }
}
