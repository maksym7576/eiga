import 'package:flutter/material.dart';

class EqualToggleButtons<T> extends StatelessWidget {
  final List<T> items;
  final T activeItem;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  final IconData? Function(T)? iconBuilder;

  const EqualToggleButtons({
    super.key,
    required this.items,
    required this.activeItem,
    required this.onChanged,
    required this.labelBuilder,
    this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9), // Slate 100
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: items.map((item) {
          final isActive = item == activeItem;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(item),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive 
                      ? (isDark ? const Color(0xFF2C2C2E) : Colors.white) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive ? (isDark ? Colors.white10 : const Color(0xFFE2E8F0)) : Colors.transparent,
                    width: 1,
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ] : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconBuilder != null && iconBuilder!(item) != null) ...[
                      Icon(
                        iconBuilder!(item),
                        size: 14,
                        color: isActive 
                            ? (item.toString().contains('youtube') ? Colors.red : const Color(0xFF3B66F5))
                            : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      labelBuilder(item),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive 
                            ? (isDark ? Colors.white : const Color(0xFF3B66F5))
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
