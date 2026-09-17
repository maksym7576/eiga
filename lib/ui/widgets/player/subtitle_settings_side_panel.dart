import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import '../../styles/app_colors.dart';

class SubtitleSettingsSidePanel extends HookConsumerWidget {
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
    useEffect(() {
      Future.microtask(() => ref.read(playerProvider.notifier).setSettingsOpen(true));
      return () => Future.microtask(() => ref.read(playerProvider.notifier).setSettingsOpen(false));
    }, []);

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
                    // FS Text Size
                    _buildSection(
                      title: 'Full Screen Size',
                      value: '${settings.fullscreen.fontSize.toInt()}',
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: () {
                          const minVal = 4.0;
                          const maxVal = 60.0;
                          return Slider(
                            value: settings.fullscreen.fontSize.clamp(minVal, maxVal),
                            min: minVal,
                            max: maxVal,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontSizeFullscreen(val),
                          );
                        }(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Letter Spacing (Split)
                    _buildSection(
                      title: 'Original Spacing',
                      value: settings.fullscreen.originalLetterSpacing.toStringAsFixed(1),
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.fullscreen.originalLetterSpacing,
                          min: 0.0,
                          max: 10.0,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalLetterSpacingFs(val),
                        ),
                      ),
                    ),

                    _buildSection(
                      title: 'Translation Spacing',
                      value: settings.fullscreen.translationLetterSpacing.toStringAsFixed(1),
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.fullscreen.translationLetterSpacing,
                          min: 0.0,
                          max: 10.0,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setTranslationLetterSpacingFs(val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Font Weight
                    _buildSection(
                      title: 'Word Thickness',
                      value: '${(settings.fullscreen.fontWeight * 100).toInt()}%',
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.fullscreen.fontWeight,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontWeightFs(val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Outline (Split)
                    _buildSection(
                      title: 'Original Outline',
                      value: settings.fullscreen.originalOutlineWidth.toStringAsFixed(1),
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.fullscreen.originalOutlineWidth,
                          min: 0.5,
                          max: 4.0,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalOutlineWidthFs(val),
                        ),
                      ),
                    ),

                    _buildSection(
                      title: 'Translation Outline',
                      value: settings.fullscreen.translationOutlineWidth.toStringAsFixed(1),
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.fullscreen.translationOutlineWidth,
                          min: 0.5,
                          max: 4.0,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setTranslationOutlineWidthFs(val),
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
                          activeTrackColor: AppColors.brandBlue,
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
                      value: '${(settings.verticalOffset * 100).toInt()}%',
                      child: SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: settings.verticalOffset.clamp(0.0, 1.0),
                          min: 0.0,
                          max: 1.0,
                          onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setVerticalOffset(val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 12),

                    // Expandable Advanced Options
                    (() {
                      final isExpanded = useState(false);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => isExpanded.value = !isExpanded.value,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Advanced Scaling',
                                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w900),
                                  ),
                                  Icon(
                                    isExpanded.value ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded.value) ...[
                            const SizedBox(height: 16),
                            // Original Scale Factor
                            _buildSection(
                              title: 'Original Text Scale',
                              value: '${(settings.fullscreen.originalScale * 100).toInt()}%',
                              child: SliderTheme(
                                data: _sliderTheme(context),
                                child: Slider(
                                  value: settings.fullscreen.originalScale,
                                  min: 0.5,
                                  max: 2.5,
                                  onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalScaleFs(val),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Translation Scale Factor
                            _buildSection(
                              title: 'Translation Scale',
                              value: '${(settings.fullscreen.translationScale * 100).toInt()}%',
                              child: SliderTheme(
                                data: _sliderTheme(context),
                                child: Slider(
                                  value: settings.fullscreen.translationScale,
                                  min: 0.5,
                                  max: 2.5,
                                  onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setTranslationScaleFs(val),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Additional Scale Factor
                            _buildSection(
                              title: 'Additional (Furigana) Scale',
                              value: '${(settings.fullscreen.additionalScale * 100).toInt()}%',
                              child: SliderTheme(
                                data: _sliderTheme(context),
                                child: Slider(
                                  value: settings.fullscreen.additionalScale,
                                  min: 0.5,
                                  max: 2.5,
                                  onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setAdditionalScaleFs(val),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    })(),

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
