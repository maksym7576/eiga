import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final int? step;
  final Widget? trailing;
  final double bottomPadding;

  const SectionTitle({
    super.key,
    required this.title,
    this.step,
    this.trailing,
    this.bottomPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, left: 4),
      child: Row(
        children: [
          if (step != null) ...[
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: theme.primaryAccent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: theme.mutedText,
                letterSpacing: 1.0,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
