import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/search_provider.dart';
import '../../../providers/anilist_status_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class MetadataProviderSelector extends ConsumerWidget {
  const MetadataProviderSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = ref.watch(isMetadataSelectorExpandedProvider);
    final selected = ref.watch(selectedMetadataProvider);

    // Track offline providers for warning banners
    final offlineProviders = MetadataProviderType.values.where((type) {
      final status = ref.watch(metadataStatusProvider(type));
      return status == ServiceStatus.down || status == ServiceStatus.maintenance;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Metadata:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: theme.normalText,
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: () => ref.read(isMetadataSelectorExpandedProvider.notifier).state = !isExpanded,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isExpanded ? theme.primaryAccent.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      isExpanded ? 'Show less' : 'Change',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isExpanded ? theme.primaryAccent : theme.mutedText,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: isExpanded ? theme.primaryAccent : theme.mutedText,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: child,
              ),
            );
          },
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
                  ),
                  const SizedBox(height: 8),
                  _ProviderTile(
                    type: MetadataProviderType.jikan,
                    title: 'MyAnimeList(Jikan)',
                    subtitle: 'Anime',
                    icon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 8),
                  _ProviderTile(
                    type: MetadataProviderType.tvmaze,
                    title: 'TVmaze',
                    subtitle: 'Anime & Series',
                    icon: Icons.tv_rounded,
                  ),
                  const SizedBox(height: 8),
                  _ProviderTile(
                    type: MetadataProviderType.manual,
                    title: 'Manual',
                    subtitle: '',
                    icon: Icons.edit_outlined,
                  ),
                ],
              )
            : _ProviderTile(
                key: const ValueKey('collapsed'),
                type: selected,
                title: _getProviderTitle(selected),
                subtitle: _getProviderSubtitle(selected),
                icon: _getProviderIcon(selected),
              ),
        ),
        if (offlineProviders.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...offlineProviders.map((type) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _OfflineWarningBanner(type: type),
          )),
        ],
      ],
    );
  }

  String _getProviderTitle(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist: return 'AniList';
      case MetadataProviderType.jikan: return 'MyAnimeList(Jikan)';
      case MetadataProviderType.tvmaze: return 'TVmaze';
      case MetadataProviderType.manual: return 'Manual';
    }
  }

  String _getProviderSubtitle(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist: return 'Anime';
      case MetadataProviderType.jikan: return 'Anime';
      case MetadataProviderType.tvmaze: return 'Anime & Series';
      case MetadataProviderType.manual: return '';
    }
  }

  IconData _getProviderIcon(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist: return Icons.terrain_rounded;
      case MetadataProviderType.jikan: return Icons.notes_rounded;
      case MetadataProviderType.tvmaze: return Icons.tv_rounded;
      case MetadataProviderType.manual: return Icons.edit_outlined;
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
        customMessage = ref.watch(aniListStatusMessageProvider);
        break;
      case MetadataProviderType.jikan: providerName = 'MyAnimeList'; break;
      case MetadataProviderType.tvmaze: providerName = 'TVmaze'; break;
      case MetadataProviderType.manual: providerName = 'Manual'; break;
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
          const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFD97706)),
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

  const _ProviderTile({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isSelected = ref.watch(selectedMetadataProvider) == type;
    final status = ref.watch(metadataStatusProvider(type));
    final isOffline = status == ServiceStatus.down || status == ServiceStatus.maintenance;

    final bgColor = isSelected
        ? Colors.white
        : (theme.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white);

    return IntrinsicWidth(
      child: IgnorePointer(
        ignoring: isOffline,
        child: GestureDetector(
          onTap: () {
            ref.read(selectedMetadataProvider.notifier).setProvider(type);
            // Auto-collapse on selection if expanded
            if (ref.read(isMetadataSelectorExpandedProvider)) {
              ref.read(isMetadataSelectorExpandedProvider.notifier).state = false;
            }
          },
          child: Opacity(
            opacity: isOffline ? 0.6 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? theme.primaryAccent : theme.cardBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Compact Icon Container
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? theme.primaryAccent : AppColors.slate200.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 13,
                      color: isSelected ? Colors.white : AppColors.slate500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 11,
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
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? theme.primaryAccent.withValues(alpha: 0.7) : theme.mutedText,
                            height: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          softWrap: false,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
