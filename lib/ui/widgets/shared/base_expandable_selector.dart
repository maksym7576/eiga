import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class BaseExpandableSelector<T> extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final T selectedValue;
  final List<T> options;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final IconData Function(T) getIcon;
  final void Function(bool) onExpandedChanged;
  final void Function(T) onSelected;

  const BaseExpandableSelector({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.selectedValue,
    required this.options,
    required this.getTitle,
    required this.getSubtitle,
    required this.getIcon,
    required this.onExpandedChanged,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.slate900),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => onExpandedChanged(!isExpanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isExpanded ? theme.primaryAccent : theme.primaryAccent.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.primaryAccent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryAccent.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(getIcon(selectedValue), color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTitle(selectedValue),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryAccent.withValues(alpha: 0.9),
                        ),
                      ),
                      Text(
                        getSubtitle(selectedValue),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.primaryAccent.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isExpanded ? 0.5 : 0,
                      child: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: theme.primaryAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: options.map((option) {
                  final isSelected = option == selectedValue;
                  return Material(
                    color: isSelected ? theme.primaryAccent.withValues(alpha: 0.05) : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        onSelected(option);
                        onExpandedChanged(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              getIcon(option),
                              size: 18,
                              color: isSelected ? theme.primaryAccent : AppColors.slate500,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTitle(option),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? theme.primaryAccent : AppColors.slate900,
                                    ),
                                  ),
                                  Text(
                                    getSubtitle(option),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected ? theme.primaryAccent.withValues(alpha: 0.7) : AppColors.slate500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_rounded, size: 18, color: theme.primaryAccent),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
