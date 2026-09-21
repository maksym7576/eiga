import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import '../../../providers/services/translation_provider.dart';
import '../subtitles/windowed_subtitle.dart';
import '../subtitles/components/shimmer_text.dart';

class PlayerPhraseItem extends HookConsumerWidget {
  final Phrase phrase;
  final bool isActive;
  final bool isPast;
  final bool isFuture;
  final String playerScope;

  const PlayerPhraseItem({
    super.key,
    required this.phrase,
    this.isActive = false,
    this.isPast = false,
    this.isFuture = false,
    this.playerScope = 'main',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider(playerScope));
    // Removed playerTimeProvider watch to prevent high-frequency rebuilds

    final startBase = DateTime(1970, 1, 1);

    // Transparency logic for both text and time
    double itemOpacity = 1.0;
    if (isActive) {
      itemOpacity = 1.0;
    } else if (isPast) {
      itemOpacity = 0.5; // Increased from 0.35 to ensure processing animations are visible
    } else if (isFuture) {
      itemOpacity = 0.7; // Slightly increased for better overall balance
    }

    // A card is only considered "translating" if its current stage is actually in 'processing' state.
    // Cards in 'pending' or 'completed' should not show background animations.
    final bool isTranslating = phrase.uiStatus.isProcessing;

    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (phrase.startTime != null) {
            final position = phrase.startTime!.difference(startBase);
            ref.read(playerProvider(playerScope).notifier).seekTo(position);
            ref.read(playerProvider(playerScope).notifier).setAutoScroll(true);
            
            // If not translated, trigger a focused translation request for this part of video
            if (!phrase.isTranslated && !phrase.isTranslating) {
              ref.read(translationProvider.notifier).checkAndTranslateRealtime(position);
            }
          }
          // Clear word selection when tapping background
          ref.read(playerProvider(playerScope).notifier).clearSelection();
          ref.read(playerProvider(playerScope).notifier).setPlaying(true);
        },
        child: _buildMainContent(context, ref, isAutoScrollEnabled, isTranslating, itemOpacity),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref, bool isAutoScrollEnabled, bool isTranslating, double itemOpacity) {
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
                  Color(0xB2EEF2FF), // EEF2FF @ 70%
                  Color(0x4DEEF2FF), // EEF2FF @ 30%
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
                    isPast: isPast,
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

    // Use DateTime components directly - much faster than duration difference math
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
