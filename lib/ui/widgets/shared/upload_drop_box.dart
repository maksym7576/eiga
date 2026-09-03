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
      child: CustomPaint(
        painter: hasPath ? null : DashedBorderPainter(
          color: theme.cardBorder.withOpacity(0.8),
          strokeWidth: 2.0,
          gap: 5,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: hasPath 
                ? theme.primaryAccent.withOpacity(0.08) 
                : theme.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: hasPath 
                ? Border.all(color: theme.primaryAccent, width: 2.0) 
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.primaryAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: theme.primaryAccent,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      hasPath ? p.basename(filePath!) : title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.normalText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!hasPath && subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.subtitleColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
