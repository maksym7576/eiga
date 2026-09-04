import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';

enum AppStatusType {
  success,
  info,
  warning,
}

class AppStatusBadge extends StatelessWidget {
  final String text;
  final AppStatusType type;
  final bool showCheckmark;

  const AppStatusBadge({
    super.key,
    required this.text,
    this.type = AppStatusType.success,
    this.showCheckmark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    
    Color bgColor;
    Color borderColor;
    Color textColor;

    switch (type) {
      case AppStatusType.success:
        bgColor = const Color(0xFFECFDF5);
        borderColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        break;
      case AppStatusType.info:
        bgColor = theme.brandBlue50;
        borderColor = theme.brandBlue100;
        textColor = theme.primaryAccent;
        break;
      case AppStatusType.warning:
        bgColor = const Color(0xFFFFF7ED);
        borderColor = const Color(0xFFFFEDD5);
        textColor = const Color(0xFFD97706);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCheckmark) ...[
            Icon(Icons.check, size: 10, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
