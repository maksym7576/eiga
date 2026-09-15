import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import '../subtitles/windowed_subtitle.dart';

class PlayerPhraseItem extends HookConsumerWidget {
  final Phrase phrase;
  final bool isActive;

  const PlayerPhraseItem({
    super.key,
    required this.phrase,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider);
    final currentTime = ref.watch(playerTimeProvider);

    final startBase = DateTime(1970, 1, 1);
    final phraseEnd = phrase.endTime?.difference(startBase) ?? Duration.zero;
    final isPast = currentTime > phraseEnd;

    final isFuture = currentTime < (phrase.startTime?.difference(startBase) ?? Duration.zero);

    // Transparency logic for both text and time
    double itemOpacity = 1.0;
    if (isActive) {
      itemOpacity = 1.0;
    } else if (isPast) {
      itemOpacity = 0.35; // Past is now the most transparent
    } else if (isFuture) {
      itemOpacity = 0.65; // Future is dimmed but clearer than past
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (phrase.startTime != null) {
          final position = phrase.startTime!.difference(startBase);
          ref.read(playerProvider.notifier).seekTo(position);
          ref.read(playerProvider.notifier).setAutoScroll(true);
        }
        // Clear word selection when tapping background
        ref.read(playerProvider.notifier).clearSelection();
        ref.read(playerProvider.notifier).setPlaying(true);
      },
      child: Container(
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
            left: isActive ? const BorderSide(color: Color(0xFF3B66F5), width: 4) : BorderSide.none,
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
