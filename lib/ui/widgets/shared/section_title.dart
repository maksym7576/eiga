import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double bottomPadding;

  const SectionTitle({
    super.key,
    required this.title,
    this.bottomPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: theme.mutedText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
