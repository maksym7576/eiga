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
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasPath ? theme.primaryAccent.withValues(alpha: 0.4) : theme.cardBorder, 
            width: hasPath ? 2.0 : 1.5
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
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
                color: theme.brandBlue50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 20,
                color: theme.primaryAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              hasPath ? p.basename(filePath!) : title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: theme.normalText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              hasPath ? 'Local video file ready for translation' : (subtitle ?? 'Select a file to begin'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: theme.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
