import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/videoComponentsProvider.dart';
import '../../styles/additional_window_theme.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.primaryAccent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.primaryAccent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'ORIGINAL',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: theme.primaryAccent,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    languageState.original ?? 'Not Selected',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: hasOriginal 
                          ? theme.normalText 
                          : theme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.primaryAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'TARGET',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: theme.primaryAccent,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    languageState.target ?? 'Not Selected',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: hasTarget 
                          ? theme.normalText 
                          : theme.mutedText,
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
