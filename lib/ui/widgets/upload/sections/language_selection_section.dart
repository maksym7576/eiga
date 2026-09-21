import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/config/languages/language_hub.dart';
import '../../../../providers/ui/language_provider.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';
import '../../cards/language_widget.dart';
import '../sheets/language_preview_sheet.dart';

class LanguageSelectionSection extends ConsumerStatefulWidget {
  const LanguageSelectionSection({super.key});

  @override
  ConsumerState<LanguageSelectionSection> createState() => _LanguageSelectionSectionState();
}

class _LanguageSelectionSectionState extends ConsumerState<LanguageSelectionSection> {
  LanguageType _selectedTabType = LanguageType.original;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageState = ref.read(languageProvider);
      final uploadState = ref.read(uploadProvider);
      
      // Автовизначення мови (якщо ще не встановлена), шукаємо в назві файлу або субтитрів
      if (languageState.original == null) {
        final sampleText = '${uploadState.fileName ?? ''} ${uploadState.subtitleFileName ?? ''}';
        for (var lang in LanguageHub.all) {
          if (sampleText.toLowerCase().contains(lang.name.toLowerCase()) || sampleText.toLowerCase().contains(lang.code.toLowerCase())) {
            ref.read(languageProvider.notifier).setOriginal(lang.name);
            break;
          }
        }
      }

      // Якщо мову не вдалося задетектувати автоматично, відкриваємо нижній діалог вибору (BottomSheet)
      if (ref.read(languageProvider).original == null) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const LanguagePreviewWidget(),
        );
      }
    });
  }

  Widget _buildInlineTabTrigger({
    required String label,
    required String? currentValue,
    required LanguageType type,
    required AdditionalWindowTheme theme,
  }) {
    final bool isSelected = _selectedTabType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryAccent.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? theme.primaryAccent : AppColors.slate200,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? theme.primaryAccent : AppColors.slate400,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentValue ?? (type == LanguageType.original ? 'Select' : 'Select'),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: currentValue != null ? theme.normalText : AppColors.slate400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final languageState = ref.watch(languageProvider);
    final languagesAsync = ref.watch(allLanguagesProvider);

    final sorted = languagesAsync.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Горизонтальні перемикачі мов у вигляді карток на весь екран
        Row(
          children: [
            _buildInlineTabTrigger(
              label: 'Original',
              currentValue: languageState.original,
              type: LanguageType.original,
              theme: theme,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.slate100, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.slate500),
            ),
            const SizedBox(width: 8),
            _buildInlineTabTrigger(
              label: 'Translation',
              currentValue: languageState.target,
              type: LanguageType.translation,
              theme: theme,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (sorted.isEmpty) 
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No languages available', style: TextStyle(fontSize: 12, color: AppColors.slate400)),
            ),
          )
        else 
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), 
            padding: EdgeInsets.zero,
            itemCount: sorted.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.slate100),
            itemBuilder: (context, index) {
              return LanguageWidget(
                language: sorted[index],
                type: _selectedTabType,
              );
            },
          ),
      ],
    );
  }
}
