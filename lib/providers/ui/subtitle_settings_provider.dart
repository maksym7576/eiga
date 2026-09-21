import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/app_configs_provider.dart';
import '../../config/languages/language_hub.dart';
import 'video_data_providers.dart';

class ModeSubtitleSettings {
  final double fontSize;
  final double originalLetterSpacing;
  final double translationLetterSpacing;
  final double originalScale;
  final double translationScale;
  final double additionalScale;
  final double originalOutlineWidth;
  final double translationOutlineWidth;
  final double fontWeight; // 0.0 to 1.0 (Normal to Black)

  const ModeSubtitleSettings({
    required this.fontSize,
    this.originalLetterSpacing = 0.0,
    this.translationLetterSpacing = 0.0,
    this.originalScale = 1.0,
    this.translationScale = 1.0,
    this.additionalScale = 1.0,
    this.originalOutlineWidth = 1.0,
    this.translationOutlineWidth = 1.0,
    this.fontWeight = 0.5,
  });

  ModeSubtitleSettings copyWith({
    double? fontSize,
    double? originalLetterSpacing,
    double? translationLetterSpacing,
    double? originalScale,
    double? translationScale,
    double? additionalScale,
    double? originalOutlineWidth,
    double? translationOutlineWidth,
    double? fontWeight,
  }) {
    return ModeSubtitleSettings(
      fontSize: fontSize ?? this.fontSize,
      originalLetterSpacing: originalLetterSpacing ?? this.originalLetterSpacing,
      translationLetterSpacing: translationLetterSpacing ?? this.translationLetterSpacing,
      originalScale: originalScale ?? this.originalScale,
      translationScale: translationScale ?? this.translationScale,
      additionalScale: additionalScale ?? this.additionalScale,
      originalOutlineWidth: originalOutlineWidth ?? this.originalOutlineWidth,
      translationOutlineWidth: translationOutlineWidth ?? this.translationOutlineWidth,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}

class SubtitleSettings {
  final ModeSubtitleSettings fullscreen;
  final ModeSubtitleSettings windowed;
  
  // Shared Visual Properties (usually same for both or FS only)
  final double backdropOpacity;
  final double backdropPadding;
  final bool showBackdrop;
  final double verticalOffset;

  SubtitleSettings({
    required this.fullscreen,
    required this.windowed,
    this.backdropOpacity = 0.6,
    this.backdropPadding = 8.0,
    this.showBackdrop = true,
    this.verticalOffset = 0.0,
  });

  SubtitleSettings copyWith({
    ModeSubtitleSettings? fullscreen,
    ModeSubtitleSettings? windowed,
    double? backdropOpacity,
    double? backdropPadding,
    bool? showBackdrop,
    double? verticalOffset,
  }) {
    return SubtitleSettings(
      fullscreen: fullscreen ?? this.fullscreen,
      windowed: windowed ?? this.windowed,
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
    final video = ref.watch(currentVideoProvider).value;
    final languageName = video?.originalLanguage ?? 'Japanese';
    final language = LanguageHub.getByName(languageName);

    double defaultOriginalSpacing = 0.0;
    if (language?.code == 'ja' || language?.name?.toLowerCase().contains('japanese') == true) {
      defaultOriginalSpacing = 2.0;
    }

    return SubtitleSettings(
      fullscreen: ModeSubtitleSettings(
        fontSize: config.getSubFontSize,
        originalLetterSpacing: config.getSubLetterSpacingFs != 0.0 ? config.getSubLetterSpacingFs : defaultOriginalSpacing,
        translationLetterSpacing: config.getSubTranslationLetterSpacingFs,
        originalScale: config.getSubOriginalScaleFs,
        translationScale: config.getSubTranslationScaleFs,
        additionalScale: config.getSubAdditionalScaleFs,
        originalOutlineWidth: config.getSubOriginalOutlineWidthFs,
        translationOutlineWidth: config.getSubTranslationOutlineWidthFs,
        fontWeight: config.getSubFontWeightFs,
      ),
      windowed: ModeSubtitleSettings(
        fontSize: config.getSubWindowedFontSize,
        originalLetterSpacing: 0, // Forced to 0 for windowed
        translationLetterSpacing: 0,
        originalScale: config.getSubOriginalScaleWin,
        translationScale: config.getSubTranslationScaleWin,
        additionalScale: config.getSubAdditionalScaleWin,
        originalOutlineWidth: 0, // Forced to 0 for windowed
        translationOutlineWidth: 0,
        fontWeight: config.getSubFontWeightWin,
      ),
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
  void setOriginalLetterSpacingFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(originalLetterSpacing: val));
    ref.read(appConfigsServiceProvider).setSubLetterSpacingFs(val);
  }
  void setTranslationLetterSpacingFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(translationLetterSpacing: val));
    ref.read(appConfigsServiceProvider).setSubTranslationLetterSpacingFs(val);
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
  void setOriginalOutlineWidthFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(originalOutlineWidth: val));
    ref.read(appConfigsServiceProvider).setSubOriginalOutlineWidthFs(val);
  }
  void setTranslationOutlineWidthFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(translationOutlineWidth: val));
    ref.read(appConfigsServiceProvider).setSubTranslationOutlineWidthFs(val);
  }

  void setFontWeightFs(double val) {
    state = state.copyWith(fullscreen: state.fullscreen.copyWith(fontWeight: val));
    ref.read(appConfigsServiceProvider).setSubFontWeightFs(val);
  }

  // --- Windowed Setters ---
  void setFontSizeWindowed(double size) {
    state = state.copyWith(windowed: state.windowed.copyWith(fontSize: size));
    ref.read(appConfigsServiceProvider).setSubWindowedFontSize(size);
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

  void setFontWeightWin(double val) {
    state = state.copyWith(windowed: state.windowed.copyWith(fontWeight: val));
    ref.read(appConfigsServiceProvider).setSubFontWeightWin(val);
  }

  // --- Shared Setters ---
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
    config.setSubLetterSpacingFs(0.0); 
    config.setSubTranslationLetterSpacingFs(0.0);
    config.setSubOriginalScaleFs(1.0);
    config.setSubTranslationScaleFs(1.0);
    config.setSubAdditionalScaleFs(1.0);
    config.setSubOriginalOutlineWidthFs(1.0);
    config.setSubTranslationOutlineWidthFs(1.0);
    config.setSubFontWeightFs(0.5);

    // Reset Win
    config.setSubWindowedFontSize(12.0);
    config.setSubOriginalScaleWin(1.0);
    config.setSubTranslationScaleWin(1.0);
    config.setSubAdditionalScaleWin(1.0);
    config.setSubFontWeightWin(0.0);

    // Shared
    config.setSubBackdropOpacity(0.6);
    config.setSubBackdropPadding(8.0);
    config.setSubShowBackdrop(true);
    config.setSubVerticalOffset(0.0);

    ref.invalidateSelf();
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
