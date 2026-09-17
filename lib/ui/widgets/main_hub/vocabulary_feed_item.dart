import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/ui/vocabulary_provider.dart';
import 'package:eiga/providers/ui/grammar_labels_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class VocabularyFeedItem extends ConsumerWidget {
  final StyledVocabularyItem item;

  const VocabularyFeedItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = item.style;
    final wordColor = style?.color ?? AppColors.slate900;
    
    final labelsAsync = ref.watch(grammarLabelsProvider);

    return labelsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (labels) {
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
                  if (item.words.isNotEmpty) _buildPosBadge(labels, item.words.first, item.isIdiom),
                  const SizedBox(height: 8),
                  _buildStatusBadge(style),
                ],
              ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              _buildInfoTable(labels, item.words),
              
              const SizedBox(height: 20),
              
              _buildAnalysisBox(labels, item.words, item.translationWords, item.isIdiom),
              
              const SizedBox(height: 20),
              
              Text(
                labels.getUiLabel('translation_of_block'),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate400,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              
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

  Widget _buildPosBadge(GrammarLabelsService labels, TokenEntry word, bool isIdiom) {
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

  Widget _buildInfoTable(GrammarLabelsService labels, List<TokenEntry> words) {
    if (words.isEmpty) return const SizedBox.shrink();
    final first = words.first;
    final posLabel = labels.getPosName(first.pos);
    final gfLabel = labels.getGfName(first.grammarFunction);
    final wordsInBlock = words.map((w) => '${w.mainText} (#${w.wordPosition})').join(' + ');

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.3),
        1: FlexColumnWidth(1),
      },
      children: [
        _buildMetaRow(labels.getUiLabel('part_of_speech'), posLabel),
        _buildMetaRow(labels.getUiLabel('grammar_role'), gfLabel),
        _buildMetaRow(labels.getUiLabel('words_in_block'), wordsInBlock),
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

  Widget _buildAnalysisBox(GrammarLabelsService labels, List<TokenEntry> words, List<TranslationTokenEntry> trWords, bool isIdiom) {
    if (words.isEmpty) return const SizedBox.shrink();
    String explanation = '';
    final first = words.first;

    if (isIdiom) {
      explanation = labels.getExplanation('idiom');
    } else if (words.length > 1 && trWords.length > 1) {
      explanation = labels.getExplanation('complex_mapping');
    } else if (words.length > 1) {
      explanation = labels.getExplanation('compound');
    } else if (trWords.length > 1) {
      explanation = labels.getExplanation('extended_translation');
    } else if (first.grammarFunction != GrammarFunction.none) {
      explanation = labels.getExplanation(first.grammarFunction.name);
    } else if (first.pos == WordPos.p) {
      explanation = labels.getExplanation('particle');
    } else {
      explanation = labels.getExplanation('vocabulary_default');
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
          Text(
            labels.getUiLabel('analysis_logic'),
            style: const TextStyle(
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
