import 'package:flutter/material.dart';
import '../../../backend/database/schemas/word.dart';
import '../../../backend/database/schemas/translation_word.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import '../../../providers/ui/main_hub_providers.dart';
import '../../styles/additional_window_theme.dart';
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

class VocabularyFeedItem extends StatelessWidget {
  final StyledVocabularyItem item;

  const VocabularyFeedItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final style = item.style;
    final wordColor = style?.color ?? AppColors.slate900;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.slate100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Multiple Words & Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: item.words.map((w) {
                    final otherVersions = w.versions
                        .where((v) => v.text != w.mainText && v.text != null && v.text!.isNotEmpty)
                        .map((v) => v.text!)
                        .join('  ');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: wordColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              if (otherVersions.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    otherVersions,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.slate400,
                                      fontWeight: FontWeight.w600,
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
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildPosBadge(item.words.first),
                  const SizedBox(height: 8),
                  _buildStatusBadge(style),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Technical Analysis Table
          _buildInfoTable(item.words),
          
          if (item.variations.isNotEmpty || item.translationVariations.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildVariationsSection(item.variations, item.translationVariations),
          ],
          
          const SizedBox(height: 20),
          
          // Analysis Box
          _buildAnalysisBox(item.words, item.translationWords),
          
          const SizedBox(height: 20),
          
          // Translation Header
          const Text(
            'TRANSLATION OF BLOCK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.slate400,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Translation Tokens
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: item.translationWords.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: t.isInferred ? AppColors.slate50 : AppColors.brandBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: t.isInferred ? AppColors.slate200 : AppColors.brandBlue.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                t.text ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: t.isInferred ? AppColors.slate500 : AppColors.brandBlue,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(SpecificWordStyle? style) {
    final color = style?.color ?? AppColors.brandBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        style?.name ?? 'Standard',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPosBadge(Word word) {
    String short = _posNames[word.pos]?.substring(0, 1).toUpperCase() ?? '?';
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
  }

  Widget _buildInfoTable(List<Word> words) {
    final first = words.first;
    final posLabel = _posNames[first.pos] ?? 'Other';
    final gfLabel = _gfNames[first.grammarFunction] ?? 'None';
    final wordsInBlock = words.map((w) => '${w.mainText} (#${w.wordPosition})').join(' + ');

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.3),
        1: FlexColumnWidth(1),
      },
      children: [
        _buildMetaRow('PART OF SPEECH', posLabel),
        _buildMetaRow('GRAMMAR ROLE', gfLabel),
        _buildMetaRow('WORDS IN BLOCK', wordsInBlock),
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

  Widget _buildVariationsSection(List<Word> variations, List<TranslationWord> trVariations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OTHER FORMS IN LIBRARY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.slate400,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...variations.map((v) => _buildVariationChip(v.mainText, isTranslation: false)),
            ...trVariations.map((v) => _buildVariationChip(v.text ?? '', isTranslation: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildVariationChip(String text, {required bool isTranslation}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isTranslation ? AppColors.brandBlue50 : AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isTranslation ? AppColors.brandBlue100 : AppColors.slate100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isTranslation ? AppColors.brandBlue : AppColors.slate600,
        ),
      ),
    );
  }

  Widget _buildAnalysisBox(List<Word> words, List<TranslationWord> trWords) {
    String explanation = '';
    final first = words.first;

    if (words.length > 1 && trWords.length > 1) {
      explanation = 'Complex mapping. Multiple source words are translated using a combined multi-word expression to preserve nuanced meaning.';
    } else if (words.length > 1) {
      explanation = 'Compound source concept. Multiple original words are merged into a single logical unit in the translation.';
    } else if (trWords.length > 1) {
      explanation = 'Extended translation. A single original word required multiple target-language tokens for a natural and accurate rendering.';
    } else if (first.grammarFunction != GrammarFunction.none) {
      explanation = 'Special grammar role determined by sentence context. This term serves a specific functional purpose in this phrase.';
    } else if (first.pos == WordPos.p) {
      explanation = 'Grammar particle. Defines relationships between words and establishes sentence structure.';
    } else {
      explanation = 'This word has been prioritized in your library. Its status helps the system highlight it in future content.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate50,
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
  }
}
