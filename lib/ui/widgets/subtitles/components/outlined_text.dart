import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double outlineWidth;
  final Color outlineColor;
  final bool useOutline;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const OutlinedText({
    super.key,
    required this.text,
    required this.style,
    this.outlineWidth = 1.5,
    this.outlineColor = Colors.black,
    this.useOutline = false,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    if (!useOutline || outlineWidth <= 0) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // High performance stacked rendering for flawless vector stroke borders without GPU overhead
    return Stack(
      alignment: _getStackAlignment(textAlign),
      children: [
        // Background layer: Vector stroke outline
        Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..color = outlineColor,
            shadows: null, // Clear shadows on background stroke
          ),
        ),
        // Foreground layer: Core inner text fill
        Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: style.copyWith(shadows: null),
        ),
      ],
    );
  }

  AlignmentGeometry _getStackAlignment(TextAlign alignment) {
    switch (alignment) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}
