import 'package:flutter/material.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';

class CloudGroupTile extends StatelessWidget {
  final JimakuGroup group;
  final VoidCallback onTap;

  const CloudGroupTile({
    super.key,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = group.isExpanded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isExpanded
                ? theme.selectionAccentColor.withValues(alpha: 0.08)
                : theme.cardBackground,
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : BorderRadius.circular(12),
            border: Border.all(
              color: isExpanded ? theme.selectionAccentColor.withValues(alpha: 0.3) : theme.cardBorder, 
              width: 0.5
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: isExpanded ? 0.0 : 0.0, 
                child: Icon(
                  isExpanded ? Icons.folder_open_rounded : Icons.folder_rounded,
                  color: theme.selectionAccentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.normalText,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color:
                      isExpanded ? theme.selectionAccentColor : theme.mutedText,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
