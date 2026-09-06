import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/services/reading_type_provider.dart';
import '../../styles/app_colors.dart';

class ReadingTypeSelectorWidget extends ConsumerWidget {
  final VoidCallback? onBack;

  const ReadingTypeSelectorWidget({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(readingTypeNotifierProvider);

    return stateAsync.when(
      data: (state) => _buildContent(context, ref, state),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  String _getDisplayLabel(String opt, String languageName) {
    if (languageName.toLowerCase() == 'japanese') {
      switch (opt.toLowerCase()) {
        case 'original':
          return 'KANJI';
        case 'kana':
          return 'KANA';
        case 'romaji':
          return 'ROMAJI';
      }
    }
    return opt.toUpperCase();
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ReadingTypeState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (onBack != null)
                    GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.brandBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (onBack == null) const SizedBox(width: 8),
                  const Text(
                    'Subtitle Display',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              if (onBack == null)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Primary Section
          _buildSectionHeader(
            title: 'Primary Subtitle',
            subtitle: 'This will be the main original text shown.',
          ),
          const SizedBox(height: 8),
          _buildOptionGroup(
            children: state.availableOptions.map((opt) {
              return _ReadingOptionTile(
                label: _getDisplayLabel(opt, state.languageName),
                isSelected: state.mainOption == opt,
                onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateMainOption(opt),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Secondary Section
          _buildSectionHeader(
            title: 'Secondary Subtitle',
            subtitle: 'Annotation text shown above the primary.',
          ),
          const SizedBox(height: 8),
          _buildOptionGroup(
            children: [
              _ReadingOptionTile(
                label: 'NONE',
                isSelected: state.additionalOption == null,
                onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateAdditionalOption(null),
              ),
              ...state.availableOptions.map((opt) {
                return _ReadingOptionTile(
                  label: _getDisplayLabel(opt, state.languageName),
                  isSelected: state.additionalOption == opt,
                  onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateAdditionalOption(opt),
                );
              }),
            ],
          ),

          const SizedBox(height: 24),

          // Translation Section
          _buildSectionHeader(
            title: 'Translation',
            subtitle: 'Display translated text below the original subtitles.',
          ),
          const SizedBox(height: 8),
          _buildOptionGroup(
            children: [
              _ReadingOptionTile(
                label: 'OFF',
                isSelected: !state.showTranslation,
                onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateShowTranslation(false),
              ),
              _ReadingOptionTile(
                label: 'ON',
                isSelected: state.showTranslation,
                onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateShowTranslation(true),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _ReadingOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReadingOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlue.withValues(alpha: 0.05) : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AppColors.brandBlue : const Color(0xFF334155),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.brandBlue, size: 20)
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
