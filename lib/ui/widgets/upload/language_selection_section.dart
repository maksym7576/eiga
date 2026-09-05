import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/videoComponentsProvider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import 'languagePreviewWidget.dart';

class LanguageSelectionSection extends ConsumerWidget {
  const LanguageSelectionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final languageState = ref.watch(languageProvider);
    
    final hasOriginal = languageState.original != null;
    final hasTarget = languageState.target != null;

    return GestureDetector(
      onTap: () => _showLanguagePicker(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.brandBlue50.withValues(alpha: 0.6),
              AppColors.brandBlue50.withValues(alpha: 0.8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.brandBlue200.withValues(alpha: 0.7),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'ORIGINAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: theme.mutedText,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    languageState.original ?? 'Not Selected',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: hasOriginal 
                          ? theme.normalText 
                          : theme.mutedText,
                    ),
                  ),
                  Text(
                    'Audio / OCR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: theme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.primaryAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryAccent.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'TARGET',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: theme.primaryAccent,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    languageState.target ?? 'Not Selected',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: hasTarget 
                          ? theme.normalText 
                          : theme.mutedText,
                    ),
                  ),
                  Text(
                    'Smart AI Translation',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LanguagePreviewWidget(),
    );
  }
}
