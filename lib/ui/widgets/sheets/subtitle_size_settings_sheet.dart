import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import '../../styles/app_colors.dart';
import '../../styles/additional_window_theme.dart';

class SubtitleSizeSettingsSheet extends HookConsumerWidget {
  final VoidCallback? onBack;

  const SubtitleSizeSettingsSheet({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(subtitleSettingsProvider);
    final isAdvancedExpanded = useState(false);
    final theme = AdditionalWindowTheme.of(context);

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
                        decoration: BoxDecoration(
                          color: theme.isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: theme.titleColor,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.primaryAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (onBack == null) const SizedBox(width: 8),
                  Text(
                    'Subtitle Styles',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: theme.titleColor,
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
                    decoration: BoxDecoration(
                      color: theme.isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: theme.closeIconColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader(
                  theme: theme,
                  title: 'Typography & Size',
                  subtitle: 'Adjust base font size and word thickness.',
                ),
                const SizedBox(height: 8),
                _buildOptionGroup(
                  theme: theme,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildSliderRow(
                            theme: theme,
                            ref: ref,
                            title: 'Base Font Size',
                            subtitle: 'Main text scale in list view',
                            value: settings.windowed.fontSize,
                            min: 4,
                            max: 60,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontSizeWindowed(val),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(height: 1, color: theme.dividerColor),
                          ),
                          _buildSliderRow(
                            theme: theme,
                            ref: ref,
                            title: 'Word Thickness',
                            subtitle: 'Adjust font boldness',
                            value: settings.windowed.fontWeight,
                            min: 0,
                            max: 1,
                            label: '${(settings.windowed.fontWeight * 100).toInt()}%',
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontWeightWin(val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Advanced Windowed Scaling Card
                _buildSectionHeader(
                  theme: theme,
                  title: 'Advanced Scaling Overrides',
                  subtitle: 'Fine-tune relative text scales.',
                ),
                const SizedBox(height: 8),
                _buildOptionGroup(
                  theme: theme,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: ExpansionTile(
                        initiallyExpanded: isAdvancedExpanded.value,
                        onExpansionChanged: (expanded) => isAdvancedExpanded.value = expanded,
                        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        iconColor: theme.titleColor,
                        collapsedIconColor: theme.subtitleColor,
                        title: Text(
                          'Scaling Multipliers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.titleColor,
                          ),
                        ),
                        subtitle: Text(
                          'Source, translation & furigana scales',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: theme.subtitleColor,
                          ),
                        ),
                        children: [
                          Divider(height: 1, color: theme.dividerColor),
                          const SizedBox(height: 16),
                          _buildSliderRow(
                            theme: theme,
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
                          _buildSliderRow(
                            theme: theme,
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
                          _buildSliderRow(
                            theme: theme,
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => ref.read(subtitleSettingsProvider.notifier).reset(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.titleColor,
                      side: BorderSide(color: theme.cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Reset Defaults', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required AdditionalWindowTheme theme, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.titleColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: theme.subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionGroup({required AdditionalWindowTheme theme, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required AdditionalWindowTheme theme,
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: theme.subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.primaryAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label ?? '${value.toInt()}px',
                style: TextStyle(
                  color: theme.primaryAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9, elevation: 2),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            activeTrackColor: theme.primaryAccent,
            inactiveTrackColor: theme.dividerColor,
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
