import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/videoComponentsProvider.dart';
import '../../../backend/database/schemas/language.dart';
import '../../styles/app_colors.dart';
import 'languageWidget.dart';

enum LanguageType { original, translation }

class LanguagePreviewWidget extends ConsumerStatefulWidget {
  const LanguagePreviewWidget({super.key});

  @override
  ConsumerState<LanguagePreviewWidget> createState() => _LanguagePreviewWidgetState();
}

class _LanguagePreviewWidgetState extends ConsumerState<LanguagePreviewWidget> {
  LanguageType _activeTypeNow = LanguageType.original;

  @override
  void initState() {
    super.initState();
    _activeTypeNow = LanguageType.original;
  }

  Widget _buildSelectorTrigger({
    required String label,
    required String? selectedValue,
    required LanguageType type,
    required AdditionalWindowTheme theme,
  }) {
    final isActive = _activeTypeNow == type;
    final displayValue = selectedValue ?? 'Select';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? theme.primaryAccent : theme.mutedText,
                letterSpacing: 0.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _activeTypeNow = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isActive ? theme.primaryAccent.withValues(alpha: 0.05) : theme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? theme.primaryAccent : theme.cardBorder,
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: theme.primaryAccent.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ] : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? theme.primaryAccent : theme.mutedText.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      displayValue,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? theme.primaryAccent : theme.normalText,
                      ),
                    ),
                  ),
                  Icon(
                    isActive ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isActive ? theme.primaryAccent : theme.mutedText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final languageState = ref.watch(languageProvider);
    final languagesAsync = ref.watch(allLanguagesProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, -10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.slate300,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Languages',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 24),
                  color: AppColors.slate400,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose the context for the video content.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.slate500,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildSelectorTrigger(
                  label: 'ORIGINAL',
                  selectedValue: languageState.original,
                  type: LanguageType.original,
                  theme: theme,
                ),
                const SizedBox(width: 12),
                _buildSelectorTrigger(
                  label: 'TRANSLATION',
                  selectedValue: languageState.target,
                  type: LanguageType.translation,
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.slate200.withValues(alpha: 0.9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: AppColors.slate50.withValues(alpha: 0.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Select ${_activeTypeNow == LanguageType.original ? 'source' : 'target'}:',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.primaryAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Select',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.brandBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.slate100),
                    Expanded(
                      child: languagesAsync.when(
                        data: (languages) {
                          final sorted = languages.where((l) => l.name != null).toList()
                            ..sort((a, b) => a.name!.compareTo(b.name!));
                          
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: sorted.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.slate100),
                            itemBuilder: (context, index) {
                              return LanguageWidget(
                                language: sorted[index],
                                type: _activeTypeNow,
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Error: $err')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryAccent,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: theme.primaryAccent.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
