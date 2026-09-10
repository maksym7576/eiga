import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/ui/main_hub_providers.dart';
import '../widgets/main_hub/vocabulary_feed_item.dart';
import '../styles/additional_window_theme.dart';
import '../styles/app_colors.dart';

class FullVocabularyScreen extends ConsumerWidget {
  const FullVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTheme = AdditionalWindowTheme.of(context);
    final stylesAsync = ref.watch(allVocabularyStylesProvider);
    final filteredWordsAsync = ref.watch(filteredVocabularyProvider);
    final selectedStyleId = ref.watch(selectedVocabularyStyleIdProvider);

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: customTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: customTheme.titleColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Vocabulary',
          style: TextStyle(
            color: customTheme.titleColor,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: stylesAsync.when(
              data: (styles) => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: selectedStyleId == null,
                    onTap: () => ref.read(selectedVocabularyStyleIdProvider.notifier).state = null,
                  ),
                  ...styles.map((style) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _FilterChip(
                      label: style.name ?? '',
                      isSelected: selectedStyleId == style.id,
                      color: style.color,
                      onTap: () => ref.read(selectedVocabularyStyleIdProvider.notifier).state = style.id,
                    ),
                  )),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          
          const SizedBox(height: 8),

          // List
          Expanded(
            child: filteredWordsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_stories_outlined, size: 64, color: AppColors.slate300),
                        const SizedBox(height: 16),
                        Text(
                          'No words found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: VocabularyFeedItem(item: item),
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
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? effectiveColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? effectiveColor : AppColors.slate200,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: effectiveColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isSelected ? Colors.white : AppColors.slate600,
            ),
          ),
        ),
      ),
    );
  }
}
