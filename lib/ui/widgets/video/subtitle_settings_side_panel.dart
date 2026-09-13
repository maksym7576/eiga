import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/subtitle_settings_provider.dart';
import '../../styles/app_colors.dart';

class SubtitleSettingsSidePanel extends ConsumerWidget {
  const SubtitleSettingsSidePanel({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SubtitleSettingsSidePanel',
      barrierColor: Colors.transparent, // Transparent barrier to see the video
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const Align(
          alignment: Alignment.centerRight,
          child: SubtitleSettingsSidePanel(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(subtitleSettingsProvider);
    final safePadding = MediaQuery.of(context).padding;
    final orientation = MediaQuery.of(context).orientation;

    // Auto-close when rotating back to portrait
    if (orientation == Orientation.portrait) {
      Future.microtask(() {
        if (context.mounted) Navigator.of(context).maybePop();
      });
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 280,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          border: const Border(
            left: BorderSide(color: Colors.white12, width: 1),
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(
                top: safePadding.top + 16,
                left: 20,
                right: 12,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtitle Styles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text Size
                    _buildSection(
                      title: 'Text Size',
                      value: '${settings.baseFontSize.toInt()}',
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.baseFontSize,
                          min: 16,
                          max: 48,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontSize(val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Outline
                    _buildSection(
                      title: 'Outline Thickness',
                      value: settings.outlineWidth.toStringAsFixed(1),
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.outlineWidth,
                          min: 0.5,
                          max: 4.0,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOutlineWidth(val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Backdrop
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Background',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Switch.adaptive(
                          value: settings.showBackdrop,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setShowBackdrop(val),
                          activeColor: AppColors.brandBlue,
                        ),
                      ],
                    ),

                    if (settings.showBackdrop) ...[
                      const SizedBox(height: 8),
                      _buildSection(
                        title: 'Opacity',
                        value: '${(settings.backdropOpacity * 100).toInt()}%',
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.backdropOpacity,
                            min: 0,
                            max: 1,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setBackdropOpacity(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Padding (Size)',
                        value: '${settings.backdropPadding.toInt()}',
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.backdropPadding,
                            min: 0,
                            max: 40,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setBackdropPadding(val),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Position
                    _buildSection(
                      title: 'Vertical Position',
                      value: '${settings.verticalOffset.toInt()}',
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.verticalOffset,
                          min: 0,
                          max: 300,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setVerticalOffset(val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => ref.read(subtitleSettingsProvider.notifier).reset(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Reset to Defaults', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String value, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(color: AppColors.brandBlue, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  SliderThemeData _sliderTheme(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      trackHeight: 3,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      activeTrackColor: AppColors.brandBlue,
      inactiveTrackColor: Colors.white12,
      thumbColor: Colors.white,
    );
  }
}
