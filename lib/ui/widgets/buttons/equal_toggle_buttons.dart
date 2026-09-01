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
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: items.map((item) {
          final isActive = item == activeItem;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2), // Spacing between buttons
              child: GestureDetector(
                onTap: () => onChanged(item),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? theme.colorScheme.surfaceContainerLowest 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? theme.colorScheme.outlineVariant.withOpacity(0.2) : Colors.transparent,
                      width: 1,
                    ),
                    boxShadow: isActive ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
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
                          size: 16,
                          color: isActive 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        labelBuilder(item),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                          color: isActive 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
