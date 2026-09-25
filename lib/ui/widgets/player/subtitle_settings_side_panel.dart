import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import '../../styles/app_colors.dart';

class SubtitleSettingsSidePanel extends HookConsumerWidget {
  final String playerScope;
  const SubtitleSettingsSidePanel({super.key, this.playerScope = 'main'});

  static Future<void> show(BuildContext context, {String playerScope = 'main'}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SubtitleSettingsSidePanel',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: SubtitleSettingsSidePanel(playerScope: playerScope),
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
      Future.microtask(() => ref.read(playerProvider(playerScope).notifier).setSettingsOpen(true));
      return () => Future.microtask(() => ref.read(playerProvider(playerScope).notifier).setSettingsOpen(false));
    }, [playerScope]);

    final settings = ref.watch(subtitleSettingsProvider);
    final safePadding = MediaQuery.of(context).padding;
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      Future.microtask(() {
        if (context.mounted) Navigator.of(context).maybePop();
      });
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bgDark.withValues(alpha: 0.85),
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 25,
              offset: const Offset(-8, 0),
            ),
          ],
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
                  const Row(
                    children: [
                      Icon(Icons.tune_rounded, color: AppColors.brandBlue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Subtitle Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECTION 1: SIZING & POSITION ---
                    _buildGroupHeader('Layout & Size'),
                    const SizedBox(height: 10),
                    _buildCard([
                      _buildSection(
                        title: 'Font Size',
                        value: '${settings.fullscreen.fontSize.toInt()}px',
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.fontSize.clamp(4.0, 60.0),
                            min: 4.0,
                            max: 60.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontSizeFullscreen(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Vertical Position',
                        value: settings.verticalOffset.toStringAsFixed(2),
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
                    ]),

                    const SizedBox(height: 24),

                    // --- SECTION 2: GAPS & SPACING ---
                    _buildGroupHeader('Spacing & Gaps'),
                    const SizedBox(height: 10),
                    _buildCard([
                      _buildSection(
                        title: 'Original - Translation Gap',
                        value: settings.fullscreen.originalToTranslationSpacing.toStringAsFixed(2),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.originalToTranslationSpacing.clamp(0.0, 3.0),
                            min: 0.0,
                            max: 3.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalToTranslationSpacingFs(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Original - Furigana Gap',
                        value: settings.fullscreen.originalToAdditionalSpacing.toStringAsFixed(2),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.originalToAdditionalSpacing.clamp(0.0, 3.0),
                            min: 0.0,
                            max: 3.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalToAdditionalSpacingFs(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Original Letter Spacing',
                        value: settings.fullscreen.originalLetterSpacing.toStringAsFixed(1),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.originalLetterSpacing.clamp(0.0, 10.0),
                            min: 0.0,
                            max: 10.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalLetterSpacingFs(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Translation Letter Spacing',
                        value: settings.fullscreen.translationLetterSpacing.toStringAsFixed(1),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.translationLetterSpacing.clamp(0.0, 10.0),
                            min: 0.0,
                            max: 10.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setTranslationLetterSpacingFs(val),
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // --- SECTION 3: STYLING & OUTLINE ---
                    _buildGroupHeader('Styling & Strokes'),
                    const SizedBox(height: 10),
                    _buildCard([
                      _buildSection(
                        title: 'Word Thickness',
                        value: settings.fullscreen.fontWeight.toStringAsFixed(2),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.fontWeight.clamp(0.0, 1.0),
                            min: 0.0,
                            max: 1.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setFontWeightFs(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Global Outline Width (All Subtitles)',
                        value: settings.fullscreen.globalOutlineWidth.toStringAsFixed(1),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.globalOutlineWidth.clamp(0.0, 3.0),
                            min: 0.0,
                            max: 3.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setGlobalOutlineWidthFs(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Original Outline Width',
                        value: settings.fullscreen.originalOutlineWidth.toStringAsFixed(1),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.originalOutlineWidth.clamp(0.5, 4.0),
                            min: 0.5,
                            max: 4.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalOutlineWidthFs(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Translation Outline Width',
                        value: settings.fullscreen.translationOutlineWidth.toStringAsFixed(1),
                        child: SliderTheme(
                          data: _sliderTheme(context),
                          child: Slider(
                            value: settings.fullscreen.translationOutlineWidth.clamp(0.5, 4.0),
                            min: 0.5,
                            max: 4.0,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setTranslationOutlineWidthFs(val),
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // --- SECTION 4: BACKGROUND / BACKDROP ---
                    _buildGroupHeader('Background Backdrop'),
                    const SizedBox(height: 10),
                    _buildCard([
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Show Backdrop',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Switch.adaptive(
                            value: settings.showBackdrop,
                            onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setShowBackdrop(val),
                            activeColor: AppColors.brandBlue,
                          ),
                        ],
                      ),
                      if (settings.showBackdrop) ...[
                        const SizedBox(height: 16),
                        _buildSection(
                          title: 'Opacity',
                          value: settings.backdropOpacity.toStringAsFixed(2),
                          child: SliderTheme(
                            data: _sliderTheme(context),
                            child: Slider(
                              value: settings.backdropOpacity.clamp(0.0, 1.0),
                              min: 0.0,
                              max: 1.0,
                              onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setBackdropOpacity(val),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          title: 'Padding',
                          value: '${settings.backdropPadding.toInt()}px',
                          child: SliderTheme(
                            data: _sliderTheme(context),
                            child: Slider(
                              value: settings.backdropPadding.clamp(0.0, 40.0),
                              min: 0.0,
                              max: 40.0,
                              onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setBackdropPadding(val),
                            ),
                          ),
                        ),
                      ],
                    ]),

                    const SizedBox(height: 24),

                    // --- SECTION 5: ADVANCED SCALING (Collapsible) ---
                    _buildAdvancedScalingSection(context, ref, settings),

                    const SizedBox(height: 32),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => ref.read(subtitleSettingsProvider.notifier).reset(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.cardDark.withValues(alpha: 0.6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Reset to Defaults', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
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

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.brandBlue,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.65), // Використання кольору cardDark з app_colors.dart
        borderRadius: BorderRadius.circular(20), // Округлені форми у стилі білих карток
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildAdvancedScalingSection(BuildContext context, WidgetRef ref, SubtitleSettings settings) {
    final isExpanded = useState(false);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.65), // Використання кольору cardDark з app_colors.dart
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => isExpanded.value = !isExpanded.value,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.aspect_ratio_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Advanced Scaling',
                        style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded.value ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded.value) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(color: Colors.white12, height: 16),
                  _buildSection(
                    title: 'Original Text Scale (includes Furigana)',
                    value: '${(settings.fullscreen.originalScale * 100).toInt()}%',
                    child: SliderTheme(
                      data: _sliderTheme(context),
                      child: Slider(
                        value: settings.fullscreen.originalScale.clamp(0.5, 2.5),
                        min: 0.5,
                        max: 2.5,
                        onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setOriginalScaleFs(val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Furigana Scale',
                    value: '${(settings.fullscreen.additionalScale * 100).toInt()}%',
                    child: SliderTheme(
                      data: _sliderTheme(context),
                      child: Slider(
                        value: settings.fullscreen.additionalScale.clamp(0.5, 2.5),
                        min: 0.5,
                        max: 2.5,
                        onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setAdditionalScaleFs(val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Translation Scale',
                    value: '${(settings.fullscreen.translationScale * 100).toInt()}%',
                    child: SliderTheme(
                      data: _sliderTheme(context),
                      child: Slider(
                        value: settings.fullscreen.translationScale.clamp(0.5, 2.5),
                        min: 0.5,
                        max: 2.5,
                        onChanged: (val) => ref.read(subtitleSettingsProvider.notifier).setTranslationScaleFs(val),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(color: AppColors.brandBlue, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  SliderThemeData _sliderTheme(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: AppColors.brandBlue,
      inactiveTrackColor: Colors.white24,
      thumbColor: Colors.white,
      trackHeight: 4.0,
      overlayColor: AppColors.brandBlue.withValues(alpha: 0.2),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
    );
  }
}
