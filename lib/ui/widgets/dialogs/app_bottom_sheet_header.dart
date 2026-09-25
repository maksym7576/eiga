import 'package:flutter/material.dart';
import '../../styles/app_bottom_sheet_theme.dart';

class AppBottomSheetHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsets? padding;

  const AppBottomSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppBottomSheetTheme.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(20, 8, 8, 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: theme.isDark ? Colors.white : Colors.black87, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: theme.isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            trailing!,
            const SizedBox(width: 8),
          ],
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(
              Icons.close_rounded,
              color: theme.isDark ? Colors.white38 : Colors.black26,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
