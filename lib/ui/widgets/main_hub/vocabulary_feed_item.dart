import 'package:flutter/material.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import '../../styles/additional_window_theme.dart';

class VocabularyFeedItem extends StatelessWidget {
  final String word;
  final String reading;
  final String translation;
  final bool isKnown;
  final SpecificWordStyle? style;

  const VocabularyFeedItem({
    super.key,
    required this.word,
    required this.reading,
    required this.translation,
    required this.isKnown,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = AdditionalWindowTheme.of(context);

    final wordColor = style?.color ?? customTheme.normalText;
    final wordWeight = style?.fontWeight ?? FontWeight.w700;
    final borderColor = style?.borderColor;
    final borderSize = style?.borderSize ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: customTheme.cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WORD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: customTheme.primaryAccent.withValues(alpha: 0.7),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: borderSize > 0 ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1) : EdgeInsets.zero,
                          decoration: borderSize > 0 ? BoxDecoration(
                            border: Border.all(color: borderColor ?? wordColor, width: borderSize.toDouble()),
                            borderRadius: BorderRadius.circular(4),
                          ) : null,
                          child: Text(
                            word,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: wordWeight,
                              color: wordColor,
                            ),
                          ),
                        ),
                        if (reading.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            '($reading)',
                            style: TextStyle(
                              fontSize: 14,
                              color: customTheme.mutedText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'STATUS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: customTheme.mutedText,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isKnown ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 16,
                        color: isKnown ? Colors.green : customTheme.mutedText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isKnown ? 'Know' : 'Learning',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isKnown ? Colors.green : customTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: customTheme.dividerColor),
          const SizedBox(height: 8),
          Text(
            'TRANSLATION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: customTheme.mutedText,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            translation,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: customTheme.normalText,
            ),
          ),
        ],
      ),
    );
  }
}
