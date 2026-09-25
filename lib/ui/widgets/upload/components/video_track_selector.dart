import 'package:eiga/providers/ui/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/config/languages/language_hub.dart';
import '../sheets/language_preview_sheet.dart';

class VideoTrackSelector extends ConsumerWidget {
  const VideoTrackSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);

    if (state.audioTracks.isEmpty && state.subtitleTracks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.audioTracks.isNotEmpty) ...[
          const _SectionHeader(title: 'Audio Tracks', icon: Icons.audiotrack_rounded),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.audioTracks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final track = state.audioTracks[index];
              final isSelected = state.selectedAudioTrack?.id == track.id;

              return _TrackTile(
                title: track.title ?? 'Audio Track ${track.index}',
                subtitle: track.language,
                isSelected: isSelected,
                onTap: () => notifier.selectAudioTrack(track),
              );
            },
          ),
          const SizedBox(height: 24),
        ],

        if (state.subtitleTracks.isNotEmpty) ...[
          const _SectionHeader(title: 'Embedded Subtitles', icon: Icons.subtitles_rounded),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.subtitleTracks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final track = state.subtitleTracks[index];
              final isOriginal = state.selectedOriginalSubtitle?.id == track.id;
              final isTranslation = state.selectedTranslationSubtitle?.id == track.id;

              return _SubtitleTrackTile(
                track: track,
                isOriginal: isOriginal,
                isTranslation: isTranslation,
                onOriginalTap: () async {
                  await notifier.selectOriginalSubtitle(track);
                  if (context.mounted) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const LanguagePreviewWidget(
                        initialType: LanguageType.original,
                      ),
                    );
                  }
                },
                onTranslationTap: () async {
                  await notifier.selectTranslationSubtitle(track);
                  if (context.mounted) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const LanguagePreviewWidget(
                        initialType: LanguageType.translation,
                      ),
                    );
                  }
                },
                onClear: () {
                  if (isOriginal) notifier.selectOriginalSubtitle(null);
                  if (isTranslation) notifier.selectTranslationSubtitle(null);
                },
                onConfigureLanguage: (type) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => LanguagePreviewWidget(
                      initialType: type,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.slate800),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.slate900,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _TrackTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _TrackTile({
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlue.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.brandBlue : AppColors.slate200,
            width: isSelected ? 1.6 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandBlue.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brandBlue.withValues(alpha: 0.1) : AppColors.slate100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.volume_up_rounded,
                size: 16,
                color: isSelected ? AppColors.brandBlue : AppColors.slate600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.brandBlue : AppColors.slate800,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: isSelected ? AppColors.brandBlue.withValues(alpha: 0.6) : AppColors.slate400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.brandBlue : AppColors.slate300,
                  width: isSelected ? 6 : 2,
                ),
                color: isSelected ? Colors.white : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubtitleTrackTile extends ConsumerWidget {
  final MediaTrackInfo track;
  final bool isOriginal;
  final bool isTranslation;
  final VoidCallback onOriginalTap;
  final VoidCallback onTranslationTap;
  final VoidCallback onClear;
  final Function(LanguageType) onConfigureLanguage;

  const _SubtitleTrackTile({
    required this.track,
    required this.isOriginal,
    required this.isTranslation,
    required this.onOriginalTap,
    required this.onTranslationTap,
    required this.onClear,
    required this.onConfigureLanguage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool anySelected = isOriginal || isTranslation;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: anySelected ? AppColors.brandBlue.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: anySelected ? AppColors.brandBlue : AppColors.slate200,
          width: anySelected ? 1.6 : 1.0,
        ),
        boxShadow: anySelected
            ? [
                BoxShadow(
                  color: AppColors.brandBlue.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: anySelected ? AppColors.brandBlue.withValues(alpha: 0.1) : AppColors.slate100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.subtitles_outlined,
              size: 16,
              color: anySelected ? AppColors.brandBlue : AppColors.slate600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: isOriginal 
                        ? () => onConfigureLanguage(LanguageType.original)
                        : isTranslation 
                            ? () => onConfigureLanguage(LanguageType.translation)
                            : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title ?? 'Subtitle Track ${track.index}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: anySelected ? FontWeight.w800 : FontWeight.w600,
                            color: anySelected ? AppColors.brandBlue : AppColors.slate800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (track.language != null && track.language!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            track.language!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: anySelected ? AppColors.brandBlue.withValues(alpha: 0.6) : AppColors.slate400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (anySelected) ...[
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClear,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.slate100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 16, color: AppColors.slate500),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          _StatusPill(
            label: 'Original',
            isActive: isOriginal,
            onTap: onOriginalTap,
          ),
          const SizedBox(width: 6),
          _StatusPill(
            label: 'Translation',
            isActive: isTranslation,
            onTap: onTranslationTap,
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brandBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.brandBlue : AppColors.slate300,
            width: 1.2,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.brandBlue.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.white : AppColors.slate600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
