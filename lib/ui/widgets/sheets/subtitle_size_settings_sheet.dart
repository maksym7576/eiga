import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import '../../styles/app_colors.dart';
import '../dialogs/app_bottom_sheet.dart';

class SubtitleSizeSettingsSheet extends HookConsumerWidget {
  const SubtitleSizeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(subtitleSettingsProvider);
    final isAdvancedExpanded = useState(false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppBottomSheetHeader(
          title: 'Subtitle Styles',
          subtitle: 'Configure windowed mode typography',
          icon: Icons.text_fields_rounded,
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              children: [
                // Windowed Size
                _buildSliderSection(
                  ref: ref,
                  title: 'Base Font Size',
                  subtitle: 'Main text scale in list view',
                  value: settings.windowed.fontSize,
                  min: 4,
                  max: 60,
                  onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontSizeWindowed(val),
                ),
                
                const SizedBox(height: 24),
                
                // Letter Spacing (Always visible)
                _buildSliderSection(
                  ref: ref,
                  title: 'Letter Spacing',
                  subtitle: 'Space between characters',
                  value: settings.windowed.letterSpacing,
                  min: 0,
                  max: 10,
                  label: settings.windowed.letterSpacing.toStringAsFixed(1),
                  onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setLetterSpacingWin(val),
                ),

                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),

                // Advanced Windowed Scaling
                InkWell(
                  onTap: () => isAdvancedExpanded.value = !isAdvancedExpanded.value,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Advanced Scaling Overrides',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF475569),
                          ),
                        ),
                        Icon(
                          isAdvancedExpanded.value ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                          color: const Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),

                if (isAdvancedExpanded.value) ...[
                  const SizedBox(height: 16),
                  _buildSliderSection(
                    ref: ref,
                    title: 'Original Text Scale',
                    subtitle: 'Relative size for source text',
                    value: settings.windowed.originalScale,
                    min: 0.5,
                    max: 2.5,
                    label: '${(settings.windowed.originalScale * 100).toInt()}%',
                    onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalScaleWin(val),
                  ),
                  const SizedBox(height: 20),
                  _buildSliderSection(
                    ref: ref,
                    title: 'Translation Scale',
                    subtitle: 'Relative size for translation',
                    value: settings.windowed.translationScale,
                    min: 0.5,
                    max: 2.5,
                    label: '${(settings.windowed.translationScale * 100).toInt()}%',
                    onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setTranslationScaleWin(val),
                  ),
                  const SizedBox(height: 20),
                  _buildSliderSection(
                    ref: ref,
                    title: 'Additional Scale',
                    subtitle: 'Relative size for furigana',
                    value: settings.windowed.additionalScale,
                    min: 0.5,
                    max: 2.5,
                    label: '${(settings.windowed.additionalScale * 100).toInt()}%',
                    onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setAdditionalScaleWin(val),
                  ),
                ],

                const SizedBox(height: 32),
                
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => ref.read(subtitleSettingsProvider.notifier).reset(),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF64748B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Reset Defaults', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderSection({
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    String? label,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.brandBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label ?? '${value.toInt()}px',
                style: const TextStyle(
                  color: AppColors.brandBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8, elevation: 2),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppColors.brandBlue,
            inactiveTrackColor: const Color(0xFFF1F5F9),
            thumbColor: Colors.white,
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
