import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';

class PhrasesPreviewSection extends ConsumerWidget {
  const PhrasesPreviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);

    if (state.activeSelection == null) {
      return const SizedBox.shrink();
    }

    return _buildOptimizationControls(theme, state, notifier);
  }

  Widget _buildOptimizationControls(AdditionalWindowTheme theme, UploadState state, UploadNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 10),
              const Text(
                'ANIMATION OPTIMIZATION',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A), letterSpacing: 0.5),
              ),
              const Spacer(),
              if (state.appliedPaddingMs > 0 || state.appliedFillGaps)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                  ),
                  child: const Text(
                    'ADJUSTED',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _OptionChip(
                  label: 'Original',
                  isSelected: state.appliedPaddingMs == 0 && !state.appliedFillGaps,
                  onSelected: () => notifier.optimizeTimings(0, fillGaps: false),
                  showCheck: true,
                ),
                _OptionChip(
                  label: '+100ms',
                  isSelected: state.appliedPaddingMs == 100,
                  onSelected: () => notifier.optimizeTimings(100, fillGaps: state.appliedFillGaps),
                ),
                _OptionChip(
                  label: '+200ms',
                  isSelected: state.appliedPaddingMs == 200,
                  onSelected: () => notifier.optimizeTimings(200, fillGaps: state.appliedFillGaps),
                ),
                _OptionChip(
                  label: '+500ms',
                  isSelected: state.appliedPaddingMs == 500,
                  onSelected: () => notifier.optimizeTimings(500, fillGaps: state.appliedFillGaps),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 24, color: const Color(0xFFE2E8F0)),
                const SizedBox(width: 8),
                _OptionChip(
                  label: 'Fill Gaps',
                  isSelected: state.appliedFillGaps,
                  onSelected: () => notifier.optimizeTimings(state.appliedPaddingMs, fillGaps: !state.appliedFillGaps),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final bool showCheck;

  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.showCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: isSelected ? const Color(0xFFDBEAFE).withValues(alpha: 0.7) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected && showCheck) ...[
                  const Icon(Icons.check_rounded, size: 14, color: Color(0xFF1D4ED8)),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
