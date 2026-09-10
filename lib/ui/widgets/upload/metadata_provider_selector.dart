import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/search_provider.dart';
import '../../../providers/service_status_providers.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class MetadataProviderSelector extends ConsumerWidget {
  const MetadataProviderSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = ref.watch(isMetadataSelectorExpandedProvider);
    final selected = ref.watch(selectedMetadataProvider);

    // Trigger health check for the selected provider
    ref.watch(checkServiceProviderStatus(selected));

    // Get status for the selected provider
    final status = ref.watch(providerStatusProvider(selected));
    final isOffline = status == ProviderStatus.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Metadata:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: theme.normalText,
              letterSpacing: -0.2,
            ),
          ),
        ),
        
        // Simple Expand/Collapse Animation
        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Column(
                  key: const ValueKey('expanded'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProviderTile(
                      type: MetadataProviderType.anilist,
                      title: 'AniList',
                      subtitle: 'Anime',
                      icon: Icons.terrain_rounded,
                      showToggle: selected == MetadataProviderType.anilist,
                    ),
                    const SizedBox(height: 10),
                    _ProviderTile(
                      type: MetadataProviderType.shikimori,
                      title: 'Shikimori',
                      subtitle: 'Anime',
                      icon: Icons.library_books_rounded,
                      showToggle: selected == MetadataProviderType.shikimori,
                    ),
                    const SizedBox(height: 10),
                    _ProviderTile(
                      type: MetadataProviderType.tvmaze,
                      title: 'TVmaze',
                      subtitle: 'Anime & Series',
                      icon: Icons.tv_rounded,
                      showToggle: selected == MetadataProviderType.tvmaze,
                    ),
                    const SizedBox(height: 10),
                    _ProviderTile(
                      type: MetadataProviderType.manual,
                      title: 'Manual',
                      subtitle: '',
                      icon: Icons.edit_outlined,
                      showToggle: selected == MetadataProviderType.manual,
                    ),
                  ],
                )
              : _ProviderTile(
                  key: const ValueKey('collapsed'),
                  type: selected,
                  title: _getProviderTitle(selected),
                  subtitle: _getProviderSubtitle(selected),
                  icon: _getProviderIcon(selected),
                  showToggle: true,
                ),
        ),
        
        if (isOffline) ...[
          const SizedBox(height: 12),
          _OfflineWarningBanner(type: selected),
        ],
      ],
    );
  }

  String _getProviderTitle(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist:
        return 'AniList';
      case MetadataProviderType.shikimori:
        return 'Shikimori';
      case MetadataProviderType.tvmaze:
        return 'TVmaze';
      case MetadataProviderType.manual:
        return 'Manual';
    }
  }

  String _getProviderSubtitle(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist:
        return 'Anime';
      case MetadataProviderType.shikimori:
        return 'Anime';
      case MetadataProviderType.tvmaze:
        return 'Anime & Series';
      case MetadataProviderType.manual:
        return '';
    }
  }

  IconData _getProviderIcon(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist:
        return Icons.terrain_rounded;
      case MetadataProviderType.shikimori:
        return Icons.library_books_rounded;
      case MetadataProviderType.tvmaze:
        return Icons.tv_rounded;
      case MetadataProviderType.manual:
        return Icons.edit_outlined;
    }
  }
}

class _OfflineWarningBanner extends ConsumerWidget {
  final MetadataProviderType type;

  const _OfflineWarningBanner({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String providerName;
    String? customMessage;

    switch (type) {
      case MetadataProviderType.anilist:
        providerName = 'AniList';
        customMessage = ref.watch(providerStatusMessageProvider(type));
        break;
      case MetadataProviderType.shikimori:
        providerName = 'Shikimori';
        customMessage = ref.watch(providerStatusMessageProvider(type));
        break;
      case MetadataProviderType.tvmaze:
        providerName = 'TVmaze';
        customMessage = ref.watch(providerStatusMessageProvider(type));
        break;
      case MetadataProviderType.manual:
        providerName = 'Manual';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7), // Amber 100
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)), // Amber 200
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 14, color: Color(0xFFD97706)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              customMessage ?? '$providerName service is currently unavailable',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF92400E), // Amber 800
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderTile extends ConsumerWidget {
  final MetadataProviderType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool showToggle;

  const _ProviderTile({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.showToggle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = ref.watch(isMetadataSelectorExpandedProvider);
    final isSelected = ref.watch(selectedMetadataProvider) == type;

    final bgColor = isSelected
        ? Colors.white
        : (theme.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white);

    return GestureDetector(
      onTap: () {
        if (!isExpanded) {
          // Expand if collapsed
          ref.read(isMetadataSelectorExpandedProvider.notifier).state = true;
        } else {
          // Select and collapse if expanded
          ref.read(selectedMetadataProvider.notifier).setProvider(type);
          ref.read(isMetadataSelectorExpandedProvider.notifier).state = false;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primaryAccent : theme.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Compact Icon Container
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.primaryAccent
                    : AppColors.slate200.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.slate500,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? theme.primaryAccent : theme.normalText,
                      letterSpacing: -0.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.primaryAccent.withValues(alpha: 0.7)
                            : theme.mutedText,
                        height: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    ),
                  ],
                ],
              ),
            ),
            if (showToggle) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? theme.primaryAccent.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpanded ? 'Show less' : 'Change',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isExpanded ? theme.primaryAccent : theme.mutedText,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: isExpanded ? theme.primaryAccent : theme.mutedText,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
