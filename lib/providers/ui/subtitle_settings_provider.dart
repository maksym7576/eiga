import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/app_configs_provider.dart';

class ModeSubtitleSettings {
  final double fontSize;
  final double letterSpacing;
  final double originalScale;
  final double translationScale;
  final double additionalScale;

  const ModeSubtitleSettings({
    required this.fontSize,
    this.letterSpacing = 2.0,
    this.originalScale = 1.0,
    this.translationScale = 1.0,
    this.additionalScale = 1.0,
  });

  ModeSubtitleSettings copyWith({
    double? fontSize,
    double? letterSpacing,
    double? originalScale,
    double? translationScale,
    double? additionalScale,
  }) {
    return ModeSubtitleSettings(
      fontSize: fontSize ?? this.fontSize,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      originalScale: originalScale ?? this.originalScale,
      translationScale: translationScale ?? this.translationScale,
      additionalScale: additionalScale ?? this.additionalScale,
    );
  }
}

class SubtitleSettings {
  final ModeSubtitleSettings fullscreen;
  final ModeSubtitleSettings windowed;
  
  // Shared Visual Properties (usually same for both or FS only)
  final double outlineWidth;
  final double backdropOpacity;
  final double backdropPadding;
  final bool showBackdrop;
  final double verticalOffset;

  SubtitleSettings({
    required this.fullscreen,
    required this.windowed,
    this.outlineWidth = 1.0,
    this.backdropOpacity = 0.6,
    this.backdropPadding = 8.0,
    this.showBackdrop = true,
    this.verticalOffset = 0.0,
  });

  SubtitleSettings copyWith({
    ModeSubtitleSettings? fullscreen,
    ModeSubtitleSettings? windowed,
    double? outlineWidth,
    double? backdropOpacity,
    double? backdropPadding,
    bool? showBackdrop,
    double? verticalOffset,
  }) {
    return SubtitleSettings(
      fullscreen: fullscreen ?? this.fullscreen,
      windowed: windowed ?? this.windowed,
      outlineWidth: outlineWidth ?? this.outlineWidth,
      backdropOpacity: backdropOpacity ?? this.backdropOpacity,
      backdropPadding: backdropPadding ?? this.backdropPadding,
      showBackdrop: showBackdrop ?? this.showBackdrop,
      verticalOffset: verticalOffset ?? this.verticalOffset,
    );
  }
}

class SubtitleSettingsNotifier extends Notifier<SubtitleSettings> {
  @override
  SubtitleSettings build() {
    final config = ref.watch(appConfigsServiceProvider);
    return SubtitleSettings(
      fullscreen: ModeSubtitleSettings(
        fontSize: config.getSubFontSize,
        letterSpacing: config.getSubLetterSpacingFs,
        originalScale: config.getSubOriginalScaleFs,
        translationScale: config.getSubTranslationScaleFs,
        additionalScale: config.getSubAdditionalScaleFs,
      ),
      windowed: ModeSubtitleSettings(
        fontSize: config.getSubWindowedFontSize,
        letterSpacing: config.getSubLetterSpacingWin,
        originalScale: config.getSubOriginalScaleWin,
        translationScale: config.getSubTranslationScaleWin,
        additionalScale: config.getSubAdditionalScaleWin,
      ),
      outlineWidth: config.getSubOutlineWidth,
      backdropOpacity: config.getSubBackdropOpacity,
      backdropPadding: config.getSubBackdropPadding,
      showBackdrop: config.getSubShowBackdrop,
      verticalOffset: config.getSubVerticalOffset,
    );
  }

  // --- Fullscreen Setters ---
  void setFontSizeFullscreen(double size) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(fontSize: size));
    ref.read(appConfigsServiceProvider).setSubFontSize(size);
  }
  void setLetterSpacingFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(letterSpacing: val));
    ref.read(appConfigsServiceProvider).setSubLetterSpacingFs(val);
  }
  void setOriginalScaleFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(originalScale: val));
    ref.read(appConfigsServiceProvider).setSubOriginalScaleFs(val);
  }
  void setTranslationScaleFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(translationScale: val));
    ref.read(appConfigsServiceProvider).setSubTranslationScaleFs(val);
  }
  void setAdditionalScaleFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(additionalScale: val));
    ref.read(appConfigsServiceProvider).setSubAdditionalScaleFs(val);
  }

  // --- Windowed Setters ---
  void setFontSizeWindowed(double size) {
    state = state.copyWith(windowed: state.windowed.copyWith(fontSize: size));
    ref.read(appConfigsServiceProvider).setSubWindowedFontSize(size);
  }
  void setLetterSpacingWin(double val) {
    state = state.copyWith(windowed: state.windowed.copyWith(letterSpacing: val));
    ref.read(appConfigsServiceProvider).setSubLetterSpacingWin(val);
  }
  void setOriginalScaleWin(double val) {
    state = state.copyWith(windowed: state.windowed.copyWith(originalScale: val));
    ref.read(appConfigsServiceProvider).setSubOriginalScaleWin(val);
  }
  void setTranslationScaleWin(double val) {
    state = state.copyWith(windowed: state.windowed.copyWith(translationScale: val));
    ref.read(appConfigsServiceProvider).setSubTranslationScaleWin(val);
  }
  void setAdditionalScaleWin(double val) {
    state = state.copyWith(windowed: state.windowed.copyWith(additionalScale: val));
    ref.read(appConfigsServiceProvider).setSubAdditionalScaleWin(val);
  }

  // --- Shared Setters ---
  void setOutlineWidth(double width) {
    state = state.copyWith(outlineWidth: width);
    ref.read(appConfigsServiceProvider).setSubOutlineWidth(width);
  }
  void setBackdropOpacity(double opacity) {
    state = state.copyWith(backdropOpacity: opacity);
    ref.read(appConfigsServiceProvider).setSubBackdropOpacity(opacity);
  }
  void setBackdropPadding(double padding) {
    state = state.copyWith(backdropPadding: padding);
    ref.read(appConfigsServiceProvider).setSubBackdropPadding(padding);
  }
  void setShowBackdrop(bool show) {
    state = state.copyWith(showBackdrop: show);
    ref.read(appConfigsServiceProvider).setSubShowBackdrop(show);
  }
  void setVerticalOffset(double offset) {
    state = state.copyWith(verticalOffset: offset);
    ref.read(appConfigsServiceProvider).setSubVerticalOffset(offset);
  }
  
  void reset() {
    final config = ref.read(appConfigsServiceProvider);
    
    // Reset FS
    config.setSubFontSize(12.0);
    config.setSubLetterSpacingFs(2.0);
    config.setSubOriginalScaleFs(1.0);
    config.setSubTranslationScaleFs(1.0);
    config.setSubAdditionalScaleFs(1.0);

    // Reset Win
    config.setSubWindowedFontSize(18.0);
    config.setSubLetterSpacingWin(2.0);
    config.setSubOriginalScaleWin(1.0);
    config.setSubTranslationScaleWin(1.0);
    config.setSubAdditionalScaleWin(1.0);

    // Shared
    config.setSubOutlineWidth(1.0);
    config.setSubBackdropOpacity(0.6);
    config.setSubBackdropPadding(8.0);
    config.setSubShowBackdrop(true);
    config.setSubVerticalOffset(0.0);

    state = SubtitleSettings(
      fullscreen: const ModeSubtitleSettings(fontSize: 12.0),
      windowed: const ModeSubtitleSettings(fontSize: 18.0),
    );
  }
}

final subtitleSettingsProvider = NotifierProvider<SubtitleSettingsNotifier, SubtitleSettings>(
  SubtitleSettingsNotifier.new,
);

final fullscreenSubtitleFontSizeProvider = Provider<double>((ref) {
  final settings = ref.watch(subtitleSettingsProvider);
  return settings.fullscreen.fontSize;
});

final windowedSubtitleFontSizeProvider = Provider<double>((ref) {
  final settings = ref.watch(subtitleSettingsProvider);
  return settings.windowed.fontSize;
});

final sidebarSubtitleFontSizeProvider = Provider<double>((ref) {
  final settings = ref.watch(subtitleSettingsProvider);
  return settings.windowed.fontSize;
});
