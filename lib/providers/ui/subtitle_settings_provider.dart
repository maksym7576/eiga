import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/app_configs_provider.dart';

class SubtitleSettings {
  final double baseFontSize;
  final double outlineWidth; // 0.5 to 4.0
  final double backdropOpacity; // 0.0 to 1.0
  final double backdropPadding; // 0.0 to 40.0
  final bool showBackdrop;
  final double verticalOffset; // Padding from bottom

  SubtitleSettings({
    this.baseFontSize = 22.0,
    this.outlineWidth = 1.0,
    this.backdropOpacity = 0.6,
    this.backdropPadding = 8.0,
    this.showBackdrop = true,
    this.verticalOffset = 0.0,
  });

  SubtitleSettings copyWith({
    double? baseFontSize,
    double? outlineWidth,
    double? backdropOpacity,
    double? backdropPadding,
    bool? showBackdrop,
    double? verticalOffset,
  }) {
    return SubtitleSettings(
      baseFontSize: baseFontSize ?? this.baseFontSize,
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
      baseFontSize: config.getSubFontSize,
      outlineWidth: config.getSubOutlineWidth,
      backdropOpacity: config.getSubBackdropOpacity,
      backdropPadding: config.getSubBackdropPadding,
      showBackdrop: config.getSubShowBackdrop,
      verticalOffset: config.getSubVerticalOffset,
    );
  }

  void setFontSize(double size) {
    state = state.copyWith(baseFontSize: size);
    ref.read(appConfigsServiceProvider).setSubFontSize(size);
  }

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
    state = SubtitleSettings();
    final config = ref.read(appConfigsServiceProvider);
    config.setSubFontSize(22.0);
    config.setSubOutlineWidth(1.0);
    config.setSubBackdropOpacity(0.6);
    config.setSubBackdropPadding(8.0);
    config.setSubShowBackdrop(true);
    config.setSubVerticalOffset(0.0);
  }
}

final subtitleSettingsProvider = NotifierProvider<SubtitleSettingsNotifier, SubtitleSettings>(
  SubtitleSettingsNotifier.new,
);
