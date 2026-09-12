import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../styles/additional_window_theme.dart';
import '../../styles/painters/dashed_border_painter.dart';

class UploadDropBox extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? subtitle;
  final String? filePath;
  final IconData icon;

  const UploadDropBox({
    super.key,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.filePath,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final bool hasPath = filePath != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.cardBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.primaryAccent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.1)),
              ),
              child: Icon(
                icon,
                size: 20,
                color: theme.primaryAccent,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hasPath ? p.basename(filePath!) : title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: theme.normalText,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              hasPath ? 'Local file ready for processing' : (subtitle ?? 'Select a file to begin'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: theme.mutedText,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
