import 'package:flutter/material.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<Color> iconBackground;
  final String? badgeText;
  final Color? badgeColor;
  final String? actionLabel;
  final bool isDestructive;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.badgeText,
    this.badgeColor,
    this.actionLabel,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isDestructive ? 20 : 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: iconBackground.length > 1 
                      ? LinearGradient(colors: iconBackground, begin: Alignment.bottomLeft, end: Alignment.topRight)
                      : null,
                  color: iconBackground.length == 1 ? iconBackground.first : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDestructive ? Colors.redAccent : theme.titleColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: badgeColor?.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: badgeColor?.withValues(alpha: 0.2) ?? Colors.transparent),
                            ),
                            child: Text(
                              badgeText!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: theme.mutedText),
                    ),
                  ],
                ),
              ),
              if (actionLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                )
              else
                Icon(Icons.chevron_right_rounded, color: theme.mutedText.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
