import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/backend/database/schemas/language.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'languagePreviewWidget.dart';

class LanguageWidget extends ConsumerWidget {
  final Language language;
  final LanguageType type;

  const LanguageWidget({
    super.key,
    required this.language,
    required this.type,
  });

  void _setLanguage(WidgetRef ref, String languageName) {
    if (type == LanguageType.original) {
      ref.read(languageProvider.notifier).setOriginal(languageName);
    } else {
      ref.read(languageProvider.notifier).setTarget(languageName);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateLan = ref.watch(languageProvider);
    final original = stateLan.original;
    final translation = stateLan.target;
    final theme = AdditionalWindowTheme.of(context);

    final String languageName = language.name ?? '';
    final bool isSelected = (type == LanguageType.original && languageName == original) ||
        (type == LanguageType.translation && languageName == translation);

    final bool isOccupied = (type == LanguageType.original && languageName == translation) ||
        (type == LanguageType.translation && languageName == original);

    return InkWell(
      onTap: isOccupied ? null : () => _setLanguage(ref, languageName),
      child: Opacity(
        opacity: isOccupied ? 0.4 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          color: isSelected ? theme.primaryAccent.withValues(alpha: 0.05) : Colors.transparent,
          child: Row(
            children: [
              // Language Icon/Code Box
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? theme.primaryAccent.withValues(alpha: 0.1) : AppColors.slate100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    language.iconLabel ?? (languageName.length >= 2 ? languageName.substring(0, 2).toUpperCase() : '??'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? theme.primaryAccent : AppColors.slate600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              
              // Name and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? theme.primaryAccent : theme.normalText,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (language.subtitle != null)
                      Text(
                        language.subtitle!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? theme.primaryAccent.withValues(alpha: 0.6) : AppColors.slate400,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),

              // Radio Indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? theme.primaryAccent : AppColors.slate300,
                    width: isSelected ? 6 : 2,
                  ),
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
                child: isSelected 
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
