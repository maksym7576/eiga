import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import 'package:eiga/providers/ui/grammar_labels_provider.dart';
import 'package:eiga/providers/services/external_api_providers.dart';
import '../../styles/app_colors.dart';

class WordDetailsPopover extends ConsumerWidget {
  const WordDetailsPopover({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightedWordIds = ref.watch(highlightedWordIdsProvider);
    final highlightedTranslationIds = ref.watch(highlightedTranslationIdsProvider);

    if (highlightedWordIds.isEmpty && highlightedTranslationIds.isEmpty) {
      return const SizedBox.shrink();
    }

    final phraseId = ref.watch(selectedPhraseIdProvider);
    if (phraseId == null) return const SizedBox.shrink();

    final phraseAsync = ref.watch(phrasesStreamProvider);
    final phrase = phraseAsync.value?.where((p) => p.id == phraseId).firstOrNull;
    if (phrase == null) return const SizedBox.shrink();

    final index = PhraseLinkIndex(phrase.originalTokens ?? [], phrase.translatedWords ?? [], phrase.linkGroups);
    final stylesAsync = ref.watch(specificWordStylesStreamProvider);
    final clickedPosition = ref.watch(clickedWordPositionProvider);
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));
    
    final labelsAsync = ref.watch(grammarLabelsProvider);

    // Geometry calculations
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    const popoverWidth = 320.0;
    const margin = 16.0;

    double? left, top, bottom;

    if (clickedPosition == null) {
      if (isFullscreen) {
        left = (screenWidth - popoverWidth) / 2;
        bottom = 120;
      } else {
        return const SizedBox.shrink();
      }
    } else {
      // Find the parent stack to calculate local coordinates
      // In Desktop view, WordDetailsPopover is inside a root Stack.
      final RenderBox? stackBox = context.findAncestorRenderObjectOfType<RenderStack>() as RenderBox?;
      final localPosition = stackBox != null ? stackBox.globalToLocal(clickedPosition) : clickedPosition;

      left = (localPosition.dx - popoverWidth / 2).clamp(margin, screenWidth - popoverWidth - margin);
      final bool showAbove = localPosition.dy > screenHeight * 0.45;
      
      if (showAbove) {
        final stackHeight = stackBox?.size.height ?? screenHeight;
        bottom = (stackHeight - localPosition.dy + 12).clamp(margin, stackHeight - margin);
      } else {
        top = (localPosition.dy + 36).clamp(margin, screenHeight - margin);
      }
    }

    // CRITICAL: Positioned MUST be the outermost widget returned to the Stack.
    return Positioned(
      left: left,
      top: top,
      bottom: bottom,
      width: popoverWidth,
      child: labelsAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
        data: (labels) => Material(
          color: Colors.transparent,
          child: TapRegion(
            groupId: 'word_selection_group',
            onTapOutside: (event) => ref.read(playerProvider.notifier).clearSelection(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isFullscreen ? 0.25 : 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.6,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMainContent(context, ref, labels, phrase, index, highlightedWordIds, highlightedTranslationIds),
                          _buildBottomStyles(ref, labels, stylesAsync, highlightedWordIds),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref, GrammarLabelsService labels, Phrase phrase, PhraseLinkIndex index, Set<int> wordIds, Set<int> tIds) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWordsHeader(phrase, wordIds, isCompact: true),
              const SizedBox(height: 12),
              _buildMinimalTranslation(phrase, index, tIds),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailsButton(context, ref, labels, phrase, index, wordIds, tIds),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      final words = phrase.originalTokens?.where((t) => wordIds.contains(t.wordPosition)).toList() ?? [];
                      final frontText = words.map((w) => w.mainText).join(', ');
                      final tokens = phrase.translatedWords ?? [];
                      final backText = tokens.where((t) => tIds.contains(t.translatedWordPosition)).map((t) => t.text).join(' ');
                      
                      final success = await ref.read(ankiServiceProvider).addNote(front: frontText, back: backText, tags: ['eiga']);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? 'Added to Anki!' : 'Failed to add to Anki'),
                            backgroundColor: success ? Colors.green : Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded, size: 14, color: Colors.blue.shade700),
                          const SizedBox(width: 4),
                          const Text(
                            'Anki',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: _buildPosBadge(labels, phrase, wordIds),
        ),
      ],
    );
  }

  Widget _buildMinimalTranslation(Phrase phrase, PhraseLinkIndex index, Set<int> tIds) {
    final tokens = phrase.translatedWords ?? [];
    final text = tokens.where((t) => tIds.contains(t.translatedWordPosition)).map((t) => t.text).join(' ');
    if (text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.slate600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDetailsButton(BuildContext context, WidgetRef ref, GrammarLabelsService labels, Phrase phrase, PhraseLinkIndex index, Set<int> wordIds, Set<int> tIds) {
    return GestureDetector(
      onTap: () => _showDetailDialog(context, ref, labels, phrase, index, wordIds, tIds),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labels.getUiLabel('see_more'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.brandBlue,
              letterSpacing: 0.2,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.brandBlue.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.brandBlue),
        ],
      ),
    );
  }

  Widget _buildPosBadge(GrammarLabelsService labels, Phrase phrase, Set<int> wordIds) {
    final originalTokens = phrase.originalTokens ?? [];
    final word = originalTokens.where((t) => wordIds.contains(t.wordPosition)).firstOrNull;
    if (word == null) return const SizedBox.shrink();
    
    // Check if any selected word belongs to an idiom group
    final bool isIdiom = phrase.linkGroups?.any((lg) => lg.isIdiom && lg.sourcePositions.any((sp) => wordIds.contains(sp))) ?? false;

    String short = labels.getPosName(word.pos).substring(0, 1).toUpperCase();
    if (word.pos == WordPos.n) {
      short = '名';
    } else if (word.pos == WordPos.v) {
      short = '動';
    } else if (word.pos == WordPos.i) {
      short = '形';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isIdiom) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3), width: 1),
            ),
            child: const Text(
              'IDIOM',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFF059669),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
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
        ),
      ],
    );
  }

  Widget _buildWordsHeader(Phrase phrase, Set<int> wordIds, {bool isCompact = false}) {
    final originalTokens = phrase.originalTokens ?? [];
    final words = originalTokens.where((t) => wordIds.contains(t.wordPosition)).toList();
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
  }

  Widget _buildMetadataTable(GrammarLabelsService labels, Phrase phrase, PhraseLinkIndex index, Set<int> wordIds, Set<int> tIds) {
    final originalTokens = phrase.originalTokens ?? [];
    final words = originalTokens.where((t) => wordIds.contains(t.wordPosition)).toList();
    if (words.isEmpty) return const SizedBox.shrink();

    final first = words.first;
    final posLabel = labels.getPosName(first.pos);
    final gfLabel = labels.getGfName(first.grammarFunction);
    final wordsInBlock = words.map((w) => '${w.mainText} (#${w.wordPosition})').join(' + ');
    final connection = '${words.length} source → ${tIds.length} translation';

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1),
      },
      children: [
        _buildMetaRow(labels.getUiLabel('part_of_speech'), posLabel),
        _buildMetaRow(labels.getUiLabel('grammar_role'), gfLabel),
        _buildMetaRow(labels.getUiLabel('words_in_block'), wordsInBlock),
        _buildMetaRow(labels.getUiLabel('connection'), connection),
      ],
    );
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

  Widget _buildSentenceMap(GrammarLabelsService labels, Phrase phrase, Set<int> wordIds) {
    final tokens = phrase.originalTokens ?? [];
    if (tokens.isEmpty) return const SizedBox.shrink();

    // Map POS to colors
    Color getPosColor(WordPos pos) {
      switch (pos) {
        case WordPos.v: return const Color(0xFF3B82F6); // Verb - Blue
        case WordPos.n: return const Color(0xFFF59E0B); // Noun - Amber
        case WordPos.p: return const Color(0xFF6366F1); // Particle - Indigo
        case WordPos.x: return const Color(0xFF14B8A6); // Auxiliary - Teal
        case WordPos.i:
        case WordPos.d: return const Color(0xFFEC4899); // Adjective/Adverb - Pink
        default: return const Color(0xFF94A3B8); // Other - Slate
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labels.getUiLabel('sentence_diagram'),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.slate400,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: tokens.map<Widget>((t) {
              final bool isPunctuation = t.pos == WordPos.s;
              final isFocus = !isPunctuation && wordIds.contains(t.wordPosition);
              final isHeadWord = !isPunctuation && tokens.any((focusTok) => wordIds.contains(focusTok.wordPosition) && focusTok.headPosition == t.wordPosition);
              final isDimmed = !isPunctuation && !isFocus && !isHeadWord;
              
              final posColor = getPosColor(t.pos);
              
              final kana = t.versions.where((v) => v.key == 'kana').firstOrNull?.text;
              final romaji = t.versions.where((v) => v.key == 'romaji').firstOrNull?.text;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (romaji != null)
                    Text(
                      romaji,
                      style: TextStyle(
                        fontSize: 9,
                        color: isDimmed ? Colors.transparent : AppColors.slate400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (kana != null && kana != t.mainText)
                    Text(
                      kana,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDimmed ? Colors.transparent : posColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isFocus 
                          ? posColor.withValues(alpha: 0.15)
                          : (isHeadWord ? posColor.withValues(alpha: 0.08) : Colors.white),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isFocus 
                            ? posColor 
                            : (isHeadWord ? posColor.withValues(alpha: 0.4) : (isPunctuation ? Colors.transparent : Colors.transparent)),
                        width: isFocus ? 2 : 1,
                      ),
                      boxShadow: isFocus ? [
                        BoxShadow(color: posColor.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))
                      ] : null,
                    ),
                    child: Text(
                      t.mainText,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Noto Serif JP',
                        fontWeight: (isFocus || isHeadWord) ? FontWeight.w900 : (isPunctuation ? FontWeight.normal : FontWeight.w600),
                        color: (isDimmed || isPunctuation) ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B),
                        decoration: isHeadWord ? TextDecoration.underline : TextDecoration.none,
                        decorationColor: posColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isFocus)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: posColor, borderRadius: BorderRadius.circular(4)),
                      child: const Text('FOCUS', style: TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.w900)),
                    )
                  else if (isHeadWord)
                    Text('HEAD', style: TextStyle(fontSize: 8, color: posColor, fontWeight: FontWeight.w900))
                  else
                    Text(
                      isPunctuation ? '' : (labels.getPosName(t.pos).toUpperCase().substring(0, 3)),
                      style: TextStyle(fontSize: 8, color: isDimmed ? AppColors.slate300 : AppColors.slate400, fontWeight: FontWeight.bold),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationBox(GrammarLabelsService labels, Phrase phrase, Set<int> wordIds) {
    final originalTokens = phrase.originalTokens ?? [];
    final words = originalTokens.where((t) => wordIds.contains(t.wordPosition)).toList();
    if (words.isEmpty) return const SizedBox.shrink();

    final first = words.first;
    final code = first.grammarCode;

    return FutureBuilder<String>(
      future: code != null ? rootBundle.loadString('assets/grammar/grammar_ja.json').catchError((_) => '{}') : Future.value('{}'),
      builder: (context, snapshot) {
        String title = labels.getUiLabel('analysis_logic');
        String description = '';

        if (snapshot.hasData && snapshot.data != '{}' && code != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(snapshot.data!);
            if (data.containsKey(code)) {
              final rule = data[code];
              title = rule['title'] ?? title;
              description = rule['description'] ?? '';
            }
          } catch (_) {}
        }

        if (description.isEmpty) {
          final bool isIdiom = phrase.linkGroups?.any((lg) => lg.isIdiom && lg.sourcePositions.any((sp) => wordIds.contains(sp))) ?? false;

          if (isIdiom) {
            description = labels.getExplanation('idiom');
          } else if (words.length > 1) {
            description = labels.getExplanation('compound');
          } else if (first.grammarFunction != GrammarFunction.none) {
            description = labels.getExplanation(first.grammarFunction.name);
          } else if (first.pos == WordPos.p) {
            description = labels.getExplanation('particle');
          } else if (first.pos == WordPos.n) {
            description = labels.getExplanation('standard_noun');
          } else if (first.pos == WordPos.v) {
            description = labels.getExplanation('action_state');
          } else {
            description = labels.getExplanation('oth');
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brandBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSentenceMap(labels, phrase, wordIds),
          ],
        );
      },
    );
  }

  Widget _buildTranslationFooter(GrammarLabelsService labels, Phrase phrase, PhraseLinkIndex index, Set<int> tIds) {
    final tokens = phrase.translatedWords ?? [];
    final selected = tokens.where((t) => tIds.contains(t.translatedWordPosition)).map((t) => t.text).join(' ');
    if (selected.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labels.getUiLabel('translation_of_block'),
          style: const TextStyle(
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
            color: AppColors.slate700,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomStyles(WidgetRef ref, GrammarLabelsService labels, AsyncValue<List<SpecificWordStyle>> stylesAsync, Set<int> highlightedIds) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: stylesAsync.when(
        data: (styles) => Row(
          children: [
            _KnowledgeBtn(label: labels.getUiLabel('standard'), color: AppColors.slate500, onTap: () => _updateStyle(ref, null)),
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

  Future<void> _updateStyle(WidgetRef ref, int? styleId) async {
    final statusService = ref.read(knownWordStatusServiceProvider);
    final phraseService = ref.read(phraseServiceProvider);
    final highlightedIds = ref.read(highlightedWordIdsProvider);
    
    final phraseId = ref.read(selectedPhraseIdProvider);
    if (phraseId == null) return;

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null || phrase.originalTokens == null) return;
    
    final allWordsInPhrase = phrase.originalTokens!;
    final highlightedWords = allWordsInPhrase.where((w) => highlightedIds.contains(w.wordPosition)).toList();
    highlightedWords.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));
    
    final expressionBase = highlightedWords.map((w) => w.lemma ?? '').join(' ').trim();

    if (expressionBase.isNotEmpty) {
      await statusService.setStyleForBase(expressionBase, styleId: styleId);
    }

    for (final wId in highlightedIds) {
      final w = allWordsInPhrase.where((e) => e.wordPosition == wId).firstOrNull;
      if (w != null && w.lemma != null && w.lemma!.isNotEmpty && w.lemma != expressionBase) {
        await statusService.setStyleForBase(w.lemma!, styleId: styleId);
      }
    }
    
    ref.read(playerProvider.notifier).clearSelection();
  }

  void _showDetailDialog(BuildContext context, WidgetRef ref, GrammarLabelsService labels, Phrase phrase, PhraseLinkIndex index, Set<int> wordIds, Set<int> tIds) {
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
                    Text(
                      labels.getUiLabel('linguistic_analysis'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.slate900,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded, color: AppColors.slate400),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildWordsHeader(phrase, wordIds),
                const SizedBox(height: 24),
                _buildMetadataTable(labels, phrase, index, wordIds, tIds),
                const SizedBox(height: 24),
                _buildExplanationBox(labels, phrase, wordIds),
                const SizedBox(height: 24),
                _buildTranslationFooter(labels, phrase, index, tIds),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      ref.read(playerProvider.notifier).resumeFromInteraction();
    });
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
