import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import '../../../providers/services/translation_provider.dart';
import '../subtitles/windowed_subtitle.dart';

class PlayerPhraseItem extends HookConsumerWidget {
  final Phrase phrase;
  final String playerScope;

  const PlayerPhraseItem({
    super.key,
    required this.phrase,
    this.playerScope = 'main',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(
      stickyActivePhraseIdProvider(playerScope).select((activePhraseId) => activePhraseId == phrase.id),
    );
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider(playerScope));

    final startBase = DateTime(1970, 1, 1);

    double itemOpacity = isActive ? 1.0 : 0.7;
    final bool isTranslating = phrase.isTranslating;

    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (phrase.startTime != null) {
            final position = phrase.startTime!.difference(startBase);
            ref.read(playerProvider(playerScope).notifier).seekTo(position);
            ref.read(playerProvider(playerScope).notifier).setAutoScroll(true);
            
            if (!phrase.isTranslated && !phrase.isTranslating) {
              ref.read(translationProvider.notifier).checkAndTranslateRealtime(position);
            }
          }
          ref.read(playerProvider(playerScope).notifier).clearSelection();
          ref.read(playerProvider(playerScope).notifier).setPlaying(true);
        },
        child: _buildMainContent(context, ref, isAutoScrollEnabled, isTranslating, itemOpacity, isActive),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref, bool isAutoScrollEnabled, bool isTranslating, double itemOpacity, bool isActive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: isActive ? 8 : (isAutoScrollEnabled ? 16 : 8),
        right: 16,
        top: 14,
        bottom: 14,
      ),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [
                  Color(0xB2EEF2FF),
                  Color(0x4DEEF2FF),
                  Colors.transparent,
                ],
                stops: [0.0, 0.5, 1.0],
              )
            : null,
        color: isActive ? null : Colors.white,
        border: Border(
          bottom: const BorderSide(color: Color(0xFFF1F5F9)),
          left: isActive 
              ? const BorderSide(color: Color(0xFF3B66F5), width: 4) 
              : BorderSide.none,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Opacity(
            opacity: itemOpacity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isAutoScrollEnabled)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildTimeColumn(phrase, isActive),
                  ),
                Expanded(
                  child: WindowedSubtitle(
                    phrase: phrase,
                    isPast: false,
                    playerScope: playerScope,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            Positioned(
              right: -14,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 2,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B66F5).withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(Phrase phrase, bool isActive) {
    final startTime = phrase.startTime;
    if (startTime == null) return const SizedBox(width: 28);

    final minutes = startTime.minute.toString().padLeft(2, '0');
    final seconds = startTime.second.toString().padLeft(2, '0');
    final hours = startTime.hour;

    final timeColor = isActive ? const Color(0xFF4338CA) : const Color(0xFF4F46E5);
    final subColor = isActive ? const Color(0xFF6366F1) : const Color(0xFF818CF8);

    return SizedBox(
      width: 28,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hours > 0)
            Text(
              '${hours.toString().padLeft(2, '0')}h',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: timeColor,
                height: 1.0,
              ),
            ),
          Text(
            '${minutes}m',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: timeColor,
              height: 1.1,
            ),
          ),
          Text(
            '${seconds}s',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              color: subColor,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
