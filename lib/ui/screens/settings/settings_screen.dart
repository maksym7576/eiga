import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/utils/responsive_helper.dart';
import 'package:eiga/providers/database/isar_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/ui/redirect_providers.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/settings/control_button_widget.dart';
import 'package:eiga/backend/services/cache_service.dart';

import 'package:eiga/providers/services/isar_services_providers.dart';
import 'mobile/settings_mobile_view.dart';
import 'desktop/settings_desktop_view.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(openGeminiDialogProvider)) {
        ref.read(openGeminiDialogProvider.notifier).state = false;
        ControlButtonWidget.openGeminiKeyDialog(context);
      }
      if (ref.read(openJimakuDialogProvider)) {
        ref.read(openJimakuDialogProvider.notifier).state = false;
        ControlButtonWidget.openJimakuKeyDialog(context);
      }
    });
  }

  Future<void> _handleFullReset(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const _SelectiveClearDataDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktopOrTablet(context)) {
          return SettingsDesktopView(onFullReset: _handleFullReset);
        } else {
          return SettingsMobileView(onFullReset: _handleFullReset);
        }
      },
    );
  }
}

class _SelectiveClearDataDialog extends ConsumerStatefulWidget {
  const _SelectiveClearDataDialog();

  @override
  ConsumerState<_SelectiveClearDataDialog> createState() => _SelectiveClearDataDialogState();
}

class _SelectiveClearDataDialogState extends ConsumerState<_SelectiveClearDataDialog> {
  final CacheService _cacheService = CacheService();

  bool _clearJimaku = true;
  bool _clearPhoto = true;
  bool _clearVideo = true;
  bool _clearMetadata = true;
  bool _clearIsar = true;

  int _jimakuSize = 0;
  int _photoSize = 0;
  int _videoSize = 0;
  int _metadataSize = 0;
  bool _isLoadingSizes = true;

  @override
  void initState() {
    super.initState();
    _loadCacheSizes();
  }

  Future<void> _loadCacheSizes() async {
    try {
      final sizes = await Future.wait([
        _cacheService.getCacheSize(CacheType.jimaku),
        _cacheService.getCacheSize(CacheType.photo),
        _cacheService.getCacheSize(CacheType.video),
        _cacheService.getCacheSize(CacheType.metadata),
      ]);

      if (mounted) {
        setState(() {
          _jimakuSize = sizes[0];
          _photoSize = sizes[1];
          _videoSize = sizes[2];
          _metadataSize = sizes[3];
          _isLoadingSizes = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingSizes = false);
      }
    }
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return '0.00 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return AlertDialog(
      backgroundColor: theme.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Clear Data & Cache',
        style: TextStyle(color: theme.titleColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select what data you want to delete. By default, all options are selected.',
                style: TextStyle(color: theme.mutedText, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _buildCheckboxTile(
                title: 'Subtitles Cache (Jimaku)',
                subtitle: _isLoadingSizes ? 'Calculating...' : _formatSize(_jimakuSize),
                value: _clearJimaku,
                onChanged: (val) => setState(() => _clearJimaku = val ?? false),
                theme: theme,
              ),
              _buildCheckboxTile(
                title: 'Images & Posters',
                subtitle: _isLoadingSizes ? 'Calculating...' : _formatSize(_photoSize),
                value: _clearPhoto,
                onChanged: (val) => setState(() => _clearPhoto = val ?? false),
                theme: theme,
              ),
              _buildCheckboxTile(
                title: 'Videos Cache',
                subtitle: _isLoadingSizes ? 'Calculating...' : _formatSize(_videoSize),
                value: _clearVideo,
                onChanged: (val) => setState(() => _clearVideo = val ?? false),
                theme: theme,
              ),
              _buildCheckboxTile(
                title: 'Search & Meta Cache',
                subtitle: _isLoadingSizes ? 'Calculating...' : _formatSize(_metadataSize),
                value: _clearMetadata,
                onChanged: (val) => setState(() => _clearMetadata = val ?? false),
                theme: theme,
              ),
              const Divider(height: 24),
              _buildCheckboxTile(
                title: 'Isar Database',
                subtitle: 'Videos, history & words',
                value: _clearIsar,
                onChanged: (val) => setState(() => _clearIsar = val ?? false),
                theme: theme,
                isCritical: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: theme.mutedText)),
        ),
        FilledButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: (_clearIsar || _clearVideo) ? Colors.redAccent : theme.primaryAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          onPressed: () async {
            if (_clearJimaku) await _cacheService.clearCache(CacheType.jimaku);
            if (_clearPhoto) await _cacheService.clearCache(CacheType.photo);
            if (_clearVideo) await _cacheService.clearCache(CacheType.video);
            if (_clearMetadata) await _cacheService.clearCache(CacheType.metadata);
            
            if (_clearIsar) {
              await ref.read(isarServiceProvider).clearAllData();
              await ref.read(appConfigsServiceProvider).resetToDefault();
            }

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selected data cleared successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Clear Selected'),
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required AdditionalWindowTheme theme,
    bool isCritical = false,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isCritical ? Colors.redAccent : theme.titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: theme.mutedText),
      ),
      activeColor: isCritical ? Colors.redAccent : theme.primaryAccent,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
