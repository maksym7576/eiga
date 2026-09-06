import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/block.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/services/database_services_providers.dart';
import '../../styles/app_colors.dart';

class WordPopover extends ConsumerWidget {
  const WordPopover({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBlockId = ref.watch(selectedBlockIdProvider);
    if (selectedBlockId == null) return const SizedBox.shrink();

    final wordsAsync = ref.watch(blockWordsProvider(selectedBlockId));
    final stylesAsync = ref.watch(specificWordStylesStreamProvider);
    final link = ref.watch(blockLayerLinkProvider);
    final languageAsync = ref.watch(videoLanguageProvider);
    final clickedPosition = ref.watch(clickedWordPositionProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    const popoverWidth = 280.0;
    const horizontalMargin = 20.0; // Increased margin from screen edges

    return wordsAsync.when(
      data: (words) {
        if (words.isEmpty) return const SizedBox.shrink();
        final word = words.first;
        final languageName = languageAsync.value?.name?.toLowerCase() ?? '';

        String getLabel(String key) {
          if (languageName == 'japanese') {
            switch (key.toLowerCase()) {
              case 'original': return 'KANJI';
              case 'kana': return 'KANA';
              case 'romaji': return 'ROMAJI';
            }
          }
          return key.toUpperCase();
        }

        return CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
          followerAnchor: Alignment.bottomCenter,
          offset: const Offset(0, -20),
          child: Material(
            color: Colors.transparent,
            child: _SmartClampedContent(
              width: popoverWidth,
              screenWidth: screenWidth,
              margin: horizontalMargin,
              targetPosition: clickedPosition,
              builder: (context, xOffset, arrowX) {
                return Transform.translate(
                  offset: Offset(xOffset, 0),
                  child: TapRegion(
                    groupId: 'word_selection_group',
                    onTapOutside: (event) {
                      print('UI: Tap outside popover detected');
                      ref.read(selectedBlockIdProvider.notifier).state = null;
                      ref.read(clickedWordIdProvider.notifier).state = null;
                      ref.read(clickedWordPositionProvider.notifier).state = null;
                      ref.read(playerProvider.notifier).setPlaying(true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Buffer zone around the popover
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {}, // Blocks taps from reaching words behind
                        child: Stack(
                          clipBehavior: Clip.none,
                        children: [
                          // Popover Card
                          Container(
                            width: popoverWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header / Readings for all words in the block
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: () {
                                          // Group versions by key across all words in the block
                                          final Map<String, List<String>> groupedVersions = {};
                                          final List<String> orderedKeys = [];

                                          for (var word in words) {
                                            // Handle mainText (original)
                                            const mainKey = 'original';
                                            if (!orderedKeys.contains(mainKey)) orderedKeys.add(mainKey);
                                            groupedVersions.putIfAbsent(mainKey, () => []).add(word.mainText);

                                            // Handle other versions
                                            for (var v in word.versions) {
                                              final key = v.key ?? 'OTHER';
                                              if (key == mainKey) continue;
                                              if (!orderedKeys.contains(key)) orderedKeys.add(key);
                                              groupedVersions.putIfAbsent(key, () => []).add(v.text ?? '');
                                            }
                                          }

                                          return orderedKeys.map((key) {
                                            final isMain = key == 'original';
                                            final label = getLabel(key);
                                            final combinedText = groupedVersions[key]!.join(', ');
                                            final color = isMain ? const Color(0xFF0F172A) : const Color(0xFF64748B);
                                            
                                            return _buildReadingItem(context, label, combinedText, color, isMain);
                                          }).toList();
                                        }(),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Action Buttons (Knowledge Styles)
                                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                stylesAsync.when(
                                  data: (styles) => Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: _KnowledgeButton(
                                              label: 'Standard',
                                              color: const Color(0xFF64748B), // Slate 500
                                              onTap: () => _updateStyle(ref, selectedBlockId, null),
                                            ),
                                          ),
                                        ),
                                        ...styles.map((style) => Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: _KnowledgeButton(
                                              label: style.name ?? '',
                                              color: style.color,
                                              onTap: () => _updateStyle(ref, selectedBlockId, style.id),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  loading: () => const SizedBox(height: 60),
                                  error: (_, __) => const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          // Triangle pointer
                          Positioned(
                            bottom: -6,
                            left: arrowX - 6,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  right: BorderSide(color: Color(0xFFF1F5F9)),
                                  bottom: BorderSide(color: Color(0xFFF1F5F9)),
                                ),
                              ),
                              transform: Matrix4.rotationZ(0.785398),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildReadingItem(BuildContext context, String type, String text, Color color, bool isMain) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isMain ? AppColors.brandBlue.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 9, 
                fontWeight: FontWeight.w800, 
                color: isMain ? AppColors.brandBlue : const Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isMain ? 18 : 14, 
                fontWeight: isMain ? FontWeight.bold : FontWeight.w600, 
                color: color,
                fontFamily: 'Noto Serif JP',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStyle(WidgetRef ref, int blockId, int? styleId) async {
    print('UI: Requesting style update for Block $blockId to Style $styleId');
    final service = ref.read(blockServiceProvider);
    await service.updateBlockStyle(blockId, styleId);
    
    // Resume playback after selection
    ref.read(playerProvider.notifier).setPlaying(true);

    // Clear selection state
    ref.read(selectedBlockIdProvider.notifier).state = null;
    ref.read(clickedWordIdProvider.notifier).state = null;

    print('UI: Style update requested and selection cleared');
    // REMOVED: ref.invalidate(phraseBlocksWithStylesProvider);
    // REMOVED: ref.invalidate(phraseWordsProvider);
  }
}

class _SmartClampedContent extends StatelessWidget {
  final double width;
  final double screenWidth;
  final double margin;
  final Offset? targetPosition;
  final Widget Function(BuildContext context, double xOffset, double arrowX) builder;

  const _SmartClampedContent({
    required this.width,
    required this.screenWidth,
    required this.margin,
    this.targetPosition,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    double xShift = 0; // Followers are centered on target by default
    double arrowX = width / 2;

    if (targetPosition != null) {
      final centerX = targetPosition!.dx;
      
      final leftEdge = centerX - (width / 2);
      final rightEdge = centerX + (width / 2);

      if (leftEdge < margin) {
        final correction = margin - leftEdge;
        xShift += correction;
        arrowX -= correction;
      } else if (rightEdge > screenWidth - margin) {
        final correction = rightEdge - (screenWidth - margin);
        xShift -= correction;
        arrowX += correction;
      }
    }

    return builder(context, xShift, arrowX);
  }
}

class _KnowledgeButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _KnowledgeButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w800, 
              color: color,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}
