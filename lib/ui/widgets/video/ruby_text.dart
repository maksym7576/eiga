import 'package:flutter/material.dart';
import '../../../backend/database/schemas/word.dart';
import '../../../backend/database/schemas/language.dart';

class RubyText extends StatelessWidget {
  final Word word;
  final Language? language;
  final TextStyle? baseStyle;
  final TextStyle? annotationStyle;

  const RubyText({
    super.key,
    required this.word,
    this.language,
    this.baseStyle,
    this.annotationStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (word.versions.isEmpty) return const SizedBox.shrink();

    String baseText = '';
    String? annotationText;

    if (language?.code == 'ja') {
      // Logic for Japanese: Original as base, Kana as annotation
      final original = word.versions.firstWhere((v) => v.key == 'original', orElse: () => word.versions.first);
      final kana = word.versions.firstWhere((v) => v.key == 'kana', orElse: () => ReadingItem());
      
      baseText = original.text ?? '';
      if (kana.text != null && kana.text != baseText) {
        annotationText = kana.text;
      }
    } else {
      // Default: First is base, others ignored for now unless specific logic added
      baseText = word.versions.first.text ?? '';
    }

    if (annotationText == null || annotationText.isEmpty) {
      return Text(baseText, style: baseStyle);
    }

    final effectiveBaseStyle = baseStyle ?? const TextStyle(fontSize: 17.5, color: Color(0xFF0F172A), fontFamily: 'Noto Serif JP');
    final effectiveAnnotationStyle = annotationStyle ?? 
        const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.normal, fontFamily: 'Plus Jakarta Sans');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            annotationText,
            style: effectiveAnnotationStyle,
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),
        Text(
          baseText,
          style: effectiveBaseStyle,
        ),
      ],
    );
  }
}
