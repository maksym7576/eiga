import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/block.dart';
import '../../../backend/database/schemas/word.dart';
import '../../../backend/database/schemas/language.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
import 'ruby_text.dart';
import 'shimmer_text.dart';

class PhraseItemWidget extends HookConsumerWidget {
  final Phrase phrase;
  final bool isActive;
  final Language? language;

  const PhraseItemWidget({
    super.key,
    required this.phrase,
    this.isActive = false,
    this.language,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider);
    final currentTime = ref.watch(playerTimeProvider);

    final startBase = DateTime(1970, 1, 1);
    final phraseEnd = phrase.endTime?.difference(startBase) ?? Duration.zero;
    final isPast = currentTime > phraseEnd;
    final isPastUntranslated = isPast && !phrase.isTranslated;

    Widget content;
    // Phrases in the past look like "translated" (finalized) regardless of original state
    if (phrase.isTranslating && !isPast) {
      content = _buildTranslatingContent(context);
    } else if (phrase.isTranslated || isPast) {
      content = _buildTranslatedContent(context, ref);
    } else {
      content = _buildQueuedContent(context);
    }

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
          ref.read(isAutoScrollEnabledProvider.notifier).state = true;
        }
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
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: !isAutoScrollEnabled
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildTimeColumn(phrase, isActive),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(child: content),
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
                      color: const Color(0xFF3B66F5).withOpacity(0.4),
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
    if (phrase.startTime == null) return const SizedBox(width: 28);

    final duration = phrase.startTime!.difference(DateTime(1970, 1, 1));
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

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

  Widget _buildTranslatingContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerText(
          child: Text(
            phrase.originalPhrase ?? '',
            style: const TextStyle(
              fontFamily: 'Noto Serif JP',
              fontSize: 17.5,
              height: 1.8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 12,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildQueuedContent(BuildContext context) {
    return Text(
      phrase.originalPhrase ?? '',
      style: const TextStyle(
        fontFamily: 'Noto Serif JP',
        fontSize: 17.5,
        color: Color(0xFF0F172A),
        height: 1.8,
      ),
    );
  }

  Widget _buildTranslatedContent(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PhraseOriginalContent(phraseId: phrase.id, language: language, fallbackText: phrase.originalPhrase),
        if (phrase.translatedPhrase != null) ...[
          const SizedBox(height: 6),
          Text(
            phrase.translatedPhrase!,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.normal,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _PhraseOriginalContent extends HookConsumerWidget {
  final int phraseId;
  final Language? language;
  final String? fallbackText;

  const _PhraseOriginalContent({required this.phraseId, this.language, this.fallbackText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(phraseBlocksProvider(phraseId));

    return blocksAsync.when(
      data: (blocks) {
        if (blocks.isEmpty) return Text(fallbackText ?? '', style: const TextStyle(fontSize: 17.5));
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 0, // Words should be close
          runSpacing: 4,
          children: blocks.map((block) => _BlockWords(block: block, language: language)).toList(),
        );
      },
      loading: () => Text(fallbackText ?? '', style: const TextStyle(fontSize: 17.5)),
      error: (_, __) => Text(fallbackText ?? '', style: const TextStyle(color: Colors.red)),
    );
  }
}

class _BlockWords extends HookConsumerWidget {
  final Block block;
  final Language? language;

  const _BlockWords({required this.block, this.language});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(blockWordsProvider(block.id));

    return wordsAsync.when(
      data: (words) => Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: words
            .map((word) => RubyText(
                  word: word,
                  language: language,
                  baseStyle: const TextStyle(
                    fontFamily: 'Noto Serif JP',
                    fontSize: 17.5,
                    color: Color(0xFF0F172A),
                    height: 1.8,
                  ),
                  annotationStyle: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 9.5,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.normal,
                    height: 1.0,
                  ),
                ))
            .toList(),
      ),
      loading: () => const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1)),
      error: (_, __) => const Icon(Icons.error, size: 12),
    );
  }
}
