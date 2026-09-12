import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/word.dart';
import '../../../backend/database/schemas/translation_word.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/services/database_services_providers.dart';
import '../../styles/app_colors.dart';

const Map<WordPos, String> _posNames = {
  WordPos.v: 'Verb',
  WordPos.n: 'Noun',
  WordPos.i: 'Adjective',
  WordPos.d: 'Adverb',
  WordPos.p: 'Particle',
  WordPos.x: 'Punctuation',
  WordPos.s: 'Symbol',
  WordPos.o: 'Other',
  WordPos.unknown: 'Unknown',
};

const Map<GrammarFunction, String> _gfNames = {
  GrammarFunction.top: 'Topic',
  GrammarFunction.subj: 'Subject',
  GrammarFunction.obj: 'Object',
  GrammarFunction.loc: 'Locative',
  GrammarFunction.dir: 'Directional',
  GrammarFunction.tim: 'Time',
  GrammarFunction.mns: 'Means',
  GrammarFunction.src: 'Source',
  GrammarFunction.rsn: 'Reason',
  GrammarFunction.cnd: 'Conditional',
  GrammarFunction.q: 'Question',
  GrammarFunction.quo: 'Quotation',
  GrammarFunction.emp: 'Emphasis',
  GrammarFunction.ctr: 'Contrast',
  GrammarFunction.dep: 'Dependent',
  GrammarFunction.tgt: 'Target',
  GrammarFunction.cmp: 'Complement',
  GrammarFunction.cnj: 'Conjunction',
  GrammarFunction.oth: 'Other',
  GrammarFunction.none: 'None',
};

const Map<GrammarFunction, String> _grammarExplanations = {
  GrammarFunction.top: 'Topic marker. Indicates what the sentence is about.',
  GrammarFunction.subj: 'Subject marker. Indicates who or what performs the action.',
  GrammarFunction.obj: 'Object marker. Indicates the direct recipient of the action.',
  GrammarFunction.loc: 'Locative marker. Indicates location or where something is.',
  GrammarFunction.dir: 'Directional marker. Indicates the direction of movement.',
  GrammarFunction.tim: 'Time marker. Indicates when an event takes place.',
  GrammarFunction.mns: 'Means marker. Indicates the tool or method used.',
  GrammarFunction.src: 'Source marker. Indicates the origin or cause.',
  GrammarFunction.rsn: 'Reason marker. Explains the "why" behind an action.',
  GrammarFunction.cnd: 'Conditional marker. Sets a "if... then" condition.',
  GrammarFunction.q: 'Question marker. Turns a statement into a query.',
  GrammarFunction.quo: 'Quotation marker. Marks thoughts or direct speech.',
  GrammarFunction.emp: 'Emphasis marker. Adds stress to a specific component.',
  GrammarFunction.ctr: 'Contrast marker. Highlights differences or oppositions.',
  GrammarFunction.dep: 'Dependent marker. Links components or creates descriptors.',
  GrammarFunction.tgt: 'Target marker. Indicates the goal or target of an action.',
  GrammarFunction.cmp: 'Complement marker. Adds necessary details to the predicate.',
  GrammarFunction.cnj: 'Conjunction. Joins words or parts of a sentence.',
  GrammarFunction.oth: 'Special grammar role for this specific context.',
};

class WordPopover extends ConsumerWidget {
  const WordPopover({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clickedWordAsync = ref.watch(clickedWordProvider);
    final clickedTranslationWordAsync = ref.watch(clickedTranslationWordProvider);
    final highlightedWordIds = ref.watch(highlightedWordIdsProvider);
    final highlightedTranslationIds = ref.watch(highlightedTranslationIdsProvider);

    if (highlightedWordIds.isEmpty && highlightedTranslationIds.isEmpty) {
      return const SizedBox.shrink();
    }

    final stylesAsync = ref.watch(specificWordStylesStreamProvider);
    final link = ref.watch(blockLayerLinkProvider);
    final clickedPosition = ref.watch(clickedWordPositionProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    const popoverWidth = 320.0;
    const horizontalMargin = 16.0;

    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      targetAnchor: Alignment.topCenter,
      followerAnchor: Alignment.bottomCenter,
      offset: const Offset(0, -16),
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
                onTapOutside: (event) => _hidePopover(ref),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: popoverWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMainContent(context, ref, highlightedWordIds, highlightedTranslationIds),
                            _buildBottomStyles(ref, stylesAsync, highlightedWordIds),
                          ],
                        ),
                      ),
                      // Arrow
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref, Set<int> wordIds, Set<int> tIds) {
    final clickedWordAsync = ref.watch(clickedWordProvider);
    final clickedTWordAsync = ref.watch(clickedTranslationWordProvider);
    
    final phraseId = clickedWordAsync.value?.phraseId ?? clickedTWordAsync.value?.phraseId ?? 0;
    if (phraseId == 0) return const SizedBox.shrink();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWordsHeader(ref, wordIds, phraseId, isCompact: true),
              const SizedBox(height: 12),
              _buildMinimalTranslation(ref, tIds, phraseId),
              const SizedBox(height: 16),
              _buildDetailsButton(context, ref, wordIds, tIds, phraseId),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: _buildPosBadge(ref, wordIds, phraseId),
        ),
      ],
    );
  }

  Widget _buildMinimalTranslation(WidgetRef ref, Set<int> tIds, int phraseId) {
    final tokensAsync = ref.watch(phraseTranslationTokensProvider(phraseId));
    return tokensAsync.maybeWhen(
      data: (tokens) {
        final text = tokens.where((ts) => tIds.contains(ts.token.id)).map((ts) => ts.token.text).join(' ');
        if (text.isEmpty) return const SizedBox.shrink();
        return Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.slate600, // Changed from brandBlue to slate
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildDetailsButton(BuildContext context, WidgetRef ref, Set<int> wordIds, Set<int> tIds, int phraseId) {
    return GestureDetector(
      onTap: () => _showDetailDialog(context, ref, wordIds, tIds, phraseId),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'See more details',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.brandBlue, // Changed to brand blue
              letterSpacing: 0.2,
              decoration: TextDecoration.underline, // Added underline for clear clickability
              decorationColor: AppColors.brandBlue.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.brandBlue),
        ],
      ),
    );
  }

  Widget _buildPosBadge(WidgetRef ref, Set<int> wordIds, int phraseId) {
    return Consumer(builder: (context, ref, _) {
      final wordsAsync = ref.watch(phraseWordsProvider(phraseId));
      return wordsAsync.maybeWhen(
        data: (allWords) {
          final word = allWords.where((ws) => wordIds.contains(ws.word.id)).firstOrNull?.word;
          if (word == null) return const SizedBox.shrink();
          
          String short = _posNames[word.pos]?.substring(0, 1).toUpperCase() ?? '?';
          // Specific Japanese handling if needed (like 名 for noun)
          if (word.pos == WordPos.n) short = '名'; 
          else if (word.pos == WordPos.v) short = '動';
          else if (word.pos == WordPos.i) short = '形';

          return Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.brandBlue.withValues(alpha: 0.3), width: 1),
              boxShadow: [
                BoxShadow(color: AppColors.brandBlue.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Text(
              short,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.brandBlue,
              ),
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      );
    });
  }

  Widget _buildWordsHeader(WidgetRef ref, Set<int> wordIds, int phraseId, {bool isCompact = false}) {
    return Consumer(builder: (context, ref, _) {
      final wordsAsync = ref.watch(phraseWordsProvider(phraseId));
      return wordsAsync.when(
        data: (allWords) {
          final words = allWords.where((ws) => wordIds.contains(ws.word.id)).map((ws) => ws.word).toList();
          if (words.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: words.map((w) {
              final otherVersions = w.versions
                  .where((v) => v.text != w.mainText && v.text != null && v.text!.isNotEmpty)
                  .map((v) => v.text!)
                  .join('  ');

              return Padding(
                padding: EdgeInsets.only(bottom: isCompact ? 4 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          w.mainText,
                          style: TextStyle(
                            fontSize: isCompact ? 20 : 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.slate900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (otherVersions.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              otherVersions,
                              style: TextStyle(
                                fontSize: isCompact ? 13 : 14,
                                color: AppColors.slate500,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => const SizedBox.shrink(),
      );
    });
  }

  Widget _buildMetadataTable(WidgetRef ref, Set<int> wordIds, Set<int> tIds, int phraseId) {
    return Consumer(builder: (context, ref, _) {
      final wordsAsync = ref.watch(phraseWordsProvider(phraseId));
      return wordsAsync.when(
        data: (allWords) {
          final words = allWords.where((ws) => wordIds.contains(ws.word.id)).map((ws) => ws.word).toList();
          if (words.isEmpty) return const SizedBox.shrink();

          final first = words.first;
          final posLabel = _posNames[first.pos] ?? 'Other';
          final gfLabel = _gfNames[first.grammarFunction] ?? 'None';
          final wordsInBlock = words.map((w) => '${w.mainText} (#${w.wordPosition})').join(' + ');
          final connection = '${words.length} source → ${tIds.length} translation';

          return Table(
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1),
            },
            children: [
              _buildMetaRow('PART OF SPEECH', posLabel),
              _buildMetaRow('GRAMMAR ROLE', gfLabel),
              _buildMetaRow('WORDS IN BLOCK', wordsInBlock),
              _buildMetaRow('CONNECTION', connection),
            ],
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      );
    });
  }

  TableRow _buildMetaRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.slate400,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.slate700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationBox(WidgetRef ref, Set<int> wordIds, Set<int> tIds, int phraseId) {
    return Consumer(builder: (context, ref, _) {
      final wordsAsync = ref.watch(phraseWordsProvider(phraseId));
      return wordsAsync.when(
        data: (allWords) {
          final words = allWords.where((ws) => wordIds.contains(ws.word.id)).map((ws) => ws.word).toList();
          if (words.isEmpty) return const SizedBox.shrink();

          String explanation = '';
          final first = words.first;

          if (words.length > 1) {
            explanation = 'Compound concept. Multiple source words are merged into a single logical unit in the translation.';
          } else if (first.grammarFunction != GrammarFunction.none) {
            explanation = _grammarExplanations[first.grammarFunction] ?? 'Special grammar role determined by sentence context.';
          } else if (first.pos == WordPos.p) {
            explanation = 'Grammar particle. Defines relationships between words and establishes sentence structure.';
          } else if (first.pos == WordPos.n) {
            explanation = 'Standard noun. Represents a person, place, thing, or idea in this phrase.';
          } else if (first.pos == WordPos.v) {
            explanation = 'Action or state. Describes the activity or condition mentioned in the subtitle.';
          } else {
            explanation = 'Vocabulary entry. Contributes to the core meaning of this specific segment.';
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                left: BorderSide(color: AppColors.brandBlue, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis & Logic',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brandBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate600,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      );
    });
  }

  Widget _buildTranslationFooter(WidgetRef ref, Set<int> tIds, int phraseId) {
    final tokensAsync = ref.watch(phraseTranslationTokensProvider(phraseId));
    return tokensAsync.when(
      data: (tokens) {
        final selected = tokens.where((ts) => tIds.contains(ts.token.id)).map((ts) => ts.token.text).join(' ');
        if (selected.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TRANSLATION OF BLOCK',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.slate400,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              selected,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.slate700, // Changed from brandBlue to slate
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildBottomStyles(WidgetRef ref, AsyncValue<List<SpecificWordStyle>> stylesAsync, Set<int> highlightedIds) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: stylesAsync.when(
        data: (styles) => Row(
          children: [
            _KnowledgeBtn(label: 'Standard', color: AppColors.slate500, onTap: () => _updateStyle(ref, null)),
            const SizedBox(width: 12),
            for (final s in styles) ...[
              _KnowledgeBtn(
                label: s.name ?? '',
                color: s.color,
                onTap: () => _updateStyle(ref, s.id),
              ),
              if (s != styles.last) const SizedBox(width: 12),
            ],
          ],
        ),
        loading: () => const SizedBox(height: 44, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  void _hidePopover(WidgetRef ref) {
    ref.read(selectedBlockIdProvider.notifier).state = null;
    ref.read(clickedWordIdProvider.notifier).state = null;
    ref.read(clickedTranslationWordIdProvider.notifier).state = null;
    ref.read(clickedWordPositionProvider.notifier).state = null;
    ref.read(selectionAnchorTypeProvider.notifier).state = null;
    ref.read(highlightedWordIdsProvider.notifier).state = {};
    ref.read(highlightedTranslationIdsProvider.notifier).state = {};
    ref.read(playerProvider.notifier).resumeFromInteraction();
  }

  Future<void> _updateStyle(WidgetRef ref, int? styleId) async {
    final statusService = ref.read(knownWordStatusServiceProvider);
    final highlightedIds = ref.read(highlightedWordIdsProvider);
    final clickedWordAsync = ref.read(clickedWordProvider);
    final clickedTWordAsync = ref.read(clickedTranslationWordProvider);
    
    final phraseId = clickedWordAsync.value?.phraseId ?? clickedTWordAsync.value?.phraseId ?? 0;
    if (phraseId == 0) return;

    final wordService = ref.read(wordServiceProvider);
    final allWordsInPhrase = await wordService.getWordsByPhraseId(phraseId);
    
    // We update the expression base (all highlighted words in order)
    final highlightedWords = allWordsInPhrase.where((w) => highlightedIds.contains(w.id)).toList();
    highlightedWords.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));
    
    final expressionBase = highlightedWords.map((w) => w.lemma ?? '').join(' ').trim();

    // 1. Update the block expression itself
    if (expressionBase.isNotEmpty) {
      await statusService.setStyleForBase(expressionBase, styleId: styleId);
    }

    // 2. Also update each individual lemma in the expression for full coverage
    for (final wId in highlightedIds) {
      final w = allWordsInPhrase.where((e) => e.id == wId).firstOrNull;
      if (w != null && w.lemma != null && w.lemma!.isNotEmpty && w.lemma != expressionBase) {
        await statusService.setStyleForBase(w.lemma!, styleId: styleId);
      }
    }
    
    // 3. Clear all highlighting states BEFORE closing
    ref.read(highlightedWordIdsProvider.notifier).state = {};
    ref.read(highlightedTranslationIdsProvider.notifier).state = {};
    
    _hidePopover(ref);
  }

  void _showDetailDialog(BuildContext context, WidgetRef ref, Set<int> wordIds, Set<int> tIds, int phraseId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Linguistic Analysis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.slate900,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: AppColors.slate400),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildWordsHeader(ref, wordIds, phraseId),
                const SizedBox(height: 24),
                _buildMetadataTable(ref, wordIds, tIds, phraseId),
                const SizedBox(height: 24),
                _buildExplanationBox(ref, wordIds, tIds, phraseId),
                const SizedBox(height: 24),
                _buildTranslationFooter(ref, tIds, phraseId),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KnowledgeBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _KnowledgeBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.w900, 
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
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
    double xShift = 0;
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
