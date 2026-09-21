import 'package:eiga/providers/ui/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/ui/styles/app_colors.dart';

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
          const _SectionHeader(title: 'Audio Tracks'),
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
          const _SectionHeader(title: 'Embedded Subtitles'),
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
                  if (isOriginal) {
                    notifier.selectOriginalSubtitle(null);
                  } else {
                    // Try auto-select first, if fails, show picker
                    await notifier.selectOriginalSubtitle(track);
                    if (ref.read(languageProvider).original == null) {
                      final lang = await _showLanguagePicker(context, ref, 'Select Original Language', track.language);
                      if (lang != null) {
                        notifier.selectOriginalSubtitle(track, language: lang);
                      }
                    }
                  }
                },
                onTranslationTap: () async {
                  if (isTranslation) {
                    notifier.selectTranslationSubtitle(null);
                  } else {
                    // Try auto-select first
                    await notifier.selectTranslationSubtitle(track);
                    if (ref.read(languageProvider).target == null) {
                      final lang = await _showLanguagePicker(context, ref, 'Select Translation Language', track.language);
                      if (lang != null) {
                        notifier.selectTranslationSubtitle(track, language: lang);
                      }
                    }
                  }
                },
              );
            },
          ),
        ],
      ],
    );
  }

  Future<String?> _showLanguagePicker(BuildContext context, WidgetRef ref, String title, String? initialHint) async {
    final languages = ref.read(allLanguagesProvider);
    String? selected;

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              return ListTile(
                title: Text(lang.name),
                subtitle: Text(lang.subtitle),
                onTap: () => Navigator.pop(context, lang.name),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: AppColors.slate900,
        letterSpacing: -0.2,
      ),
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlue.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.brandBlue : AppColors.slate200,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.brandBlue : AppColors.slate700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppColors.brandBlue.withValues(alpha: 0.7) : AppColors.slate500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.brandBlue : AppColors.slate300,
              size: 22,
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

  const _SubtitleTrackTile({
    required this.track,
    required this.isOriginal,
    required this.isTranslation,
    required this.onOriginalTap,
    required this.onTranslationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool anySelected = isOriginal || isTranslation;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: anySelected ? AppColors.brandBlue.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: anySelected ? AppColors.brandBlue : AppColors.slate200,
          width: anySelected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title ?? 'Subtitle Track ${track.index}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: anySelected ? FontWeight.w800 : FontWeight.w600,
                    color: anySelected ? AppColors.brandBlue : AppColors.slate700,
                  ),
                ),
                if (track.language != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    track.language!,
                    style: TextStyle(
                      fontSize: 12,
                      color: anySelected ? AppColors.brandBlue.withValues(alpha: 0.7) : AppColors.slate500,
                    ),
                  ),
                ],
                if (anySelected && ((isOriginal && ref.watch(languageProvider).original == null) || (isTranslation && ref.watch(languageProvider).target == null))) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: isOriginal ? onOriginalTap : onTranslationTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warningAmberBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 10, color: AppColors.warningAmberText),
                          SizedBox(width: 4),
                          Text(
                            'SELECT LANGUAGE',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.warningAmberText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brandBlue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.brandBlue : AppColors.slate300,
            width: 1.2,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.brandBlue.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: isActive ? Colors.white : AppColors.slate600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
