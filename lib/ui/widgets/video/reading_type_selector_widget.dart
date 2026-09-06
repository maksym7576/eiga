import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/services/reading_type_provider.dart';
import '../../styles/app_colors.dart';
import '../settings/reading_option_selector.dart';

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

  Widget _buildContent(BuildContext context, WidgetRef ref, ReadingTypeState state) {
    final notifier = ref.read(readingTypeNotifierProvider.notifier);
    final actions = _ReadingNotifierActions(notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
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
        ),
        Flexible(
          child: ReadingOptionSelector(
            state: state,
            actions: actions,
          ),
        ),
      ],
    );
  }
}

class _ReadingNotifierActions implements ReadingTypeActions {
  final ReadingTypeNotifier notifier;
  _ReadingNotifierActions(this.notifier);

  @override
  void updateMainOption(String option) => notifier.updateMainOption(option);
  @override
  void updateAdditionalOption(String? option) => notifier.updateAdditionalOption(option);
  @override
  void updateShowTranslation(bool value) => notifier.updateShowTranslation(value);
}
