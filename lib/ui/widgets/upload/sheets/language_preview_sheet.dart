import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/language_provider.dart';
import 'package:eiga/config/languages/language_hub.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';
import '../../cards/language_widget.dart';

class LanguagePreviewWidget extends ConsumerStatefulWidget {
  final LanguageType? initialType;

  const LanguagePreviewWidget({super.key, this.initialType});

  @override
  ConsumerState<LanguagePreviewWidget> createState() => _LanguagePreviewWidgetState();
}

class _LanguagePreviewWidgetState extends ConsumerState<LanguagePreviewWidget> {
  late LanguageType _activeTypeNow;

  @override
  void initState() {
    super.initState();
    _activeTypeNow = widget.initialType ?? LanguageType.original;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final languagesAsync = ref.watch(allLanguagesProvider);

    final sorted = languagesAsync.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    // Якщо передано конкретний тип, то це цільовий вибір для одного треку
    final bool isSingleSelectionMode = widget.initialType != null;

    String subtitleText = 'Choose source or target language';
    if (isSingleSelectionMode) {
      subtitleText = widget.initialType == LanguageType.original 
          ? 'Select Original language for this track' 
          : 'Select Translation language for this track';
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Language',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.slate900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        subtitleText,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.slate100,
                      foregroundColor: AppColors.slate600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Показуємо таби ЛИШЕ якщо тип НЕ був наперед визначений (загальний режим)
            if (!isSingleSelectionMode) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildTypeTab('Source', LanguageType.original),
                      _buildTypeTab('Target', LanguageType.translation),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                itemCount: sorted.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return LanguageWidget(
                    language: sorted[index],
                    type: _activeTypeNow,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTab(String label, LanguageType type) {
    final bool isSelected = _activeTypeNow == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTypeNow = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.brandBlue : AppColors.slate500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
